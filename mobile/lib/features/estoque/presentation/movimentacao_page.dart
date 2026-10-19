import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/tema.dart';
import '../../../app/widgets/aviso.dart';
import '../../../app/widgets/identidade.dart';
import '../../../core/armazenamento/preferencias.dart';
import '../../leitura/presentation/campo_codigo.dart';
import '../data/estoque_repository.dart';
import '../domain/estoque.dart';
import 'armazem_controller.dart';

enum _Lado { origem, destino }

/// Entrada, saída e transferência: o operador lê o produto e o endereço, informa a quantidade (e o lote, se o
/// produto controla lote) e registra. A chave de idempotência vale para a mesma operação até ela dar certo ou mudar.
class MovimentacaoPage extends ConsumerStatefulWidget {
  const MovimentacaoPage({this.tipoInicial = TipoMovimento.entrada, super.key});

  final TipoMovimento tipoInicial;

  @override
  ConsumerState<MovimentacaoPage> createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends ConsumerState<MovimentacaoPage> {
  late TipoMovimento _tipo = widget.tipoInicial;
  final _quantidade = TextEditingController(text: '1');
  final _lote = TextEditingController();
  final _documento = TextEditingController();
  DateTime? _validade;

  ProdutoLido? _produto;
  bool _buscandoProduto = false;
  String? _erroProduto;

  final _enderecos = <_Lado, EnderecoLido?>{};
  final _buscandoEndereco = <_Lado, bool>{};
  final _erroEndereco = <_Lado, String?>{};

  /// Chave de idempotência da operação atual (gerada no primeiro envio).
  String? _chave;
  bool _enviando = false;
  String? _erro;
  Map<String, String> _errosCampos = const {};
  String? _sucesso;

  /// Muda a cada operação concluída, para os campos de código começarem vazios.
  int _rodada = 0;

  @override
  void initState() {
    super.initState();
    for (final campo in [_quantidade, _lote, _documento]) {
      campo.addListener(_operacaoMudou);
    }
  }

  @override
  void dispose() {
    for (final campo in [_quantidade, _lote, _documento]) {
      campo.dispose();
    }

    super.dispose();
  }

  List<_Lado> get _lados => switch (_tipo) {
    TipoMovimento.entrada => const [_Lado.destino],
    TipoMovimento.saida => const [_Lado.origem],
    TipoMovimento.transferencia => const [_Lado.origem, _Lado.destino],
  };

  String _rotuloEndereco(_Lado lado) => switch ((_tipo, lado)) {
    (TipoMovimento.transferencia, _Lado.origem) => 'Endereço de origem',
    (TipoMovimento.transferencia, _Lado.destino) => 'Endereço de destino',
    _ => 'Endereço',
  };

  /// Qualquer mudança é outra operação: a próxima tentativa usa uma chave nova.
  void _operacaoMudou() {
    _chave = null;
  }

  Future<void> _lerProduto(String codigo) async {
    setState(() {
      _buscandoProduto = true;
      _erroProduto = null;
      _sucesso = null;
      _operacaoMudou();
    });
    try {
      final produto = await ref.read(estoqueRepositoryProvider).buscarProduto(codigo);
      setState(() => _produto = produto);
    } on FalhaEstoque catch (falha) {
      setState(() {
        _produto = null;
        _erroProduto = falha.mensagem;
      });
    } finally {
      setState(() => _buscandoProduto = false);
    }
  }

  Future<void> _lerEndereco(_Lado lado, String codigo) async {
    final armazem = ref.read(armazemProvider).value?.atual;
    if (armazem == null) {
      setState(() => _erroEndereco[lado] = 'Escolha o armazém antes de ler o endereço.');
      return;
    }

    setState(() {
      _buscandoEndereco[lado] = true;
      _erroEndereco[lado] = null;
      _sucesso = null;
      _operacaoMudou();
    });
    try {
      final endereco = await ref.read(estoqueRepositoryProvider).buscarEndereco(armazem.id, codigo);
      setState(() => _enderecos[lado] = endereco);
    } on FalhaEstoque catch (falha) {
      setState(() {
        _enderecos[lado] = null;
        _erroEndereco[lado] = falha.mensagem;
      });
    } finally {
      setState(() => _buscandoEndereco[lado] = false);
    }
  }

  double? get _quantidadeInformada => double.tryParse(_quantidade.text.trim().replaceAll(',', '.'));

  void _somar(double passo) {
    final atual = _quantidadeInformada ?? 0;
    final novo = (atual + passo).clamp(1, double.infinity).toDouble();
    _quantidade.text = formatarQuantidade(novo);
  }

  String? _validar() {
    if (_produto == null) {
      return 'Leia o produto.';
    }

    for (final lado in _lados) {
      if (_enderecos[lado] == null) {
        return 'Leia o ${_rotuloEndereco(lado).toLowerCase()}.';
      }
    }

    final quantidade = _quantidadeInformada;
    if (quantidade == null || quantidade <= 0) {
      return 'Informe uma quantidade maior que zero.';
    }

    if (_produto!.controlaLote && _lote.text.trim().isEmpty) {
      return 'Este produto controla lote: informe o lote.';
    }

    if (_tipo == TipoMovimento.entrada && _produto!.controlaValidade && _validade == null) {
      return 'Este produto controla validade: informe a validade do lote.';
    }

    return null;
  }

  Future<void> _registrar() async {
    final invalido = _validar();
    if (invalido != null) {
      setState(() => _erro = invalido);
      return;
    }

    final produto = _produto!;
    final quantidade = _quantidadeInformada!;
    _chave ??= const Uuid().v7();
    setState(() {
      _enviando = true;
      _erro = null;
      _errosCampos = const {};
    });
    try {
      final dispositivoId = await ref.read(dispositivoIdProvider.future);
      final registrado = await ref
          .read(estoqueRepositoryProvider)
          .registrar(
            Movimento(
              tipo: _tipo,
              produto: produto,
              quantidade: quantidade,
              chave: _chave!,
              dispositivoId: dispositivoId,
              origem: _enderecos[_Lado.origem],
              destino: _enderecos[_Lado.destino],
              loteNumero: produto.controlaLote ? _lote.text.trim() : null,
              loteValidade: _tipo == TipoMovimento.entrada ? _validade : null,
              documento: _documento.text.trim().isEmpty ? null : _documento.text.trim(),
            ),
          );
      unawaited(HapticFeedback.mediumImpact());
      setState(() {
        _sucesso = _resumo(produto, quantidade, registrado);
        _limpar();
      });
    } on FalhaEstoque catch (falha) {
      setState(() {
        _erro = falha.semConexao
            ? '${falha.mensagem} Ao tentar de novo, a operação não é gravada duas vezes.'
            : falha.mensagem;
        _errosCampos = falha.campos;
      });
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  String _resumo(ProdutoLido produto, double quantidade, MovimentoRegistrado registrado) {
    final enderecos = _lados.map((lado) => _enderecos[lado]!.codigo).join(' → ');
    final base = produto.embalagemBase
        ? ''
        : ' (${formatarQuantidade(registrado.quantidadeBase)} ${produto.unidadeBase})';
    final quantidadeTexto =
        '${formatarQuantidade(quantidade)} ${produto.embalagemBase ? produto.unidadeBase : produto.embalagem}';
    final repetido = registrado.repetido ? ' A API já tinha esta operação; nada foi gravado de novo.' : '';
    return '${_tipo.rotulo} registrada: $quantidadeTexto$base de ${produto.sku} em $enderecos.$repetido';
  }

  /// Prepara a próxima operação do mesmo tipo.
  void _limpar() {
    _produto = null;
    _enderecos.clear();
    _validade = null;
    _quantidade.text = '1';
    _lote.clear();
    _documento.clear();
    _chave = null;
    _rodada += 1;
  }

  Future<void> _escolherValidade() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _validade ?? hoje,
      firstDate: hoje.subtract(const Duration(days: 365 * 5)),
      lastDate: hoje.add(const Duration(days: 365 * 10)),
      helpText: 'Validade do lote',
    );
    if (data != null) {
      setState(() {
        _validade = data;
        _operacaoMudou();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final produto = _produto;

    return Scaffold(
      appBar: const BarraStowise(titulo: 'Movimentar estoque'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TipoMovimento>(
              segments: [for (final tipo in TipoMovimento.values) ButtonSegment(value: tipo, label: Text(tipo.rotulo))],
              selected: {_tipo},
              onSelectionChanged: (selecao) => setState(() {
                _tipo = selecao.single;
                _enderecos.clear();
                _sucesso = null;
                _erro = null;
                _operacaoMudou();
              }),
            ),
            const SizedBox(height: 16),
            if (_sucesso != null) ...[Aviso(texto: _sucesso!, tom: TomAviso.sucesso), const SizedBox(height: 16)],
            const SeletorArmazem(),
            const SizedBox(height: 16),
            CampoCodigo(
              key: ValueKey('produto-$_rodada'),
              rotulo: 'Produto (SKU ou código de barras)',
              tituloLeitura: 'Ler o produto',
              onCodigo: _lerProduto,
              carregando: _buscandoProduto,
              erro: _erroProduto ?? _errosCampos['produtoId'],
            ),
            if (produto != null) _CartaoProduto(produto: produto),
            for (final lado in _lados) ...[
              const SizedBox(height: 16),
              CampoCodigo(
                key: ValueKey('${lado.name}-$_tipo-$_rodada'),
                rotulo: _rotuloEndereco(lado),
                tituloLeitura: 'Ler o ${_rotuloEndereco(lado).toLowerCase()}',
                onCodigo: (codigo) => _lerEndereco(lado, codigo),
                carregando: _buscandoEndereco[lado] ?? false,
                erro:
                    _erroEndereco[lado] ??
                    _errosCampos[lado == _Lado.origem
                        ? (_tipo == TipoMovimento.saida ? 'enderecoId' : 'enderecoOrigemId')
                        : (_tipo == TipoMovimento.entrada ? 'enderecoId' : 'enderecoDestinoId')],
              ),
              if (_enderecos[lado] case final endereco?)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        endereco.bloqueado ? Icons.block : Icons.place_outlined,
                        size: 18,
                        color: endereco.bloqueado ? tema.colorScheme.error : context.cores.sucesso,
                      ),
                      const SizedBox(width: 8),
                      Etiqueta(endereco.codigo, grande: true),
                      if (endereco.bloqueado) ...[
                        const SizedBox(width: 8),
                        Text('bloqueado', style: TextStyle(color: tema.colorScheme.error)),
                      ],
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Diminuir',
                  onPressed: () => _somar(-1),
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _quantidade,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      helperText: produto?.unidadeDaQuantidade,
                      errorText: _errosCampos['quantidade'],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(tooltip: 'Aumentar', onPressed: () => _somar(1), icon: const Icon(Icons.add)),
              ],
            ),
            if (produto?.controlaLote ?? false) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _lote,
                decoration: InputDecoration(
                  labelText: 'Lote',
                  errorText: _errosCampos['lote.numero'] ?? _errosCampos['lote'],
                ),
              ),
              if (_tipo == TipoMovimento.entrada && produto!.controlaValidade) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _escolherValidade,
                  icon: const Icon(Icons.event),
                  label: Text(
                    _validade == null
                        ? 'Validade do lote'
                        : 'Validade: ${MaterialLocalizations.of(context).formatCompactDate(_validade!)}',
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _documento,
              decoration: InputDecoration(
                labelText: 'Documento de referência (opcional)',
                hintText: 'NF, pedido, ordem',
                errorText: _errosCampos['documentoReferencia'],
              ),
            ),
            if (_erro != null) ...[const SizedBox(height: 16), Aviso(texto: _erro!, tom: TomAviso.erro)],
            const SizedBox(height: 24),
            BotaoGradiente(
              onPressed: _enviando ? null : _registrar,
              child: _enviando
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_tipo.acao),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartaoProduto extends StatelessWidget {
  const _CartaoProduto({required this.produto});

  final ProdutoLido produto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final detalhes = [
      produto.sku,
      if (!produto.embalagemBase) produto.unidadeDaQuantidade,
      if (produto.controlaLote) 'controla lote',
    ];
    final cores = context.cores;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: tema.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: cores.sombraCartao,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Borda âmbar da etiqueta de palete.
            Container(width: 5, color: cores.sinal),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: cores.gradienteMarca(tema.colorScheme.primary),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: cores.brilho(tema.colorScheme.primary),
                      ),
                      child: Icon(
                        produto.embalagemBase ? Icons.inventory_2_outlined : Icons.all_inbox_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto.descricao,
                            style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(detalhes.join(' · '), style: tema.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ExcludeSemantics(
                      child: CodigoDeBarras(cor: tema.colorScheme.onSurfaceVariant, largura: 40, altura: 28),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
