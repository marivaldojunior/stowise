import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/tema.dart';
import '../../../app/widgets/aviso.dart';
import '../../../app/widgets/identidade.dart';
import '../../leitura/presentation/campo_codigo.dart';
import '../data/estoque_repository.dart';
import '../domain/estoque.dart';
import 'armazem_controller.dart';

enum ConsultaSaldo {
  produto('Por produto'),
  endereco('Por endereço');

  const ConsultaSaldo(this.rotulo);

  final String rotulo;
}

class _Resultado {
  const _Resultado({required this.saldos, this.resumo, this.endereco});

  final ResumoProduto? resumo;
  final EnderecoLido? endereco;
  final List<SaldoLinha> saldos;
}

/// Consulta de saldo no corredor: por produto (totais, lotes e endereços) ou por endereço (o que está nele).
class SaldoPage extends ConsumerStatefulWidget {
  const SaldoPage({this.consultaInicial = ConsultaSaldo.produto, super.key});

  final ConsultaSaldo consultaInicial;

  @override
  ConsumerState<SaldoPage> createState() => _SaldoPageState();
}

class _SaldoPageState extends ConsumerState<SaldoPage> {
  late ConsultaSaldo _consulta = widget.consultaInicial;
  bool _buscando = false;
  String? _erro;
  _Resultado? _resultado;

  Future<void> _buscar(String codigo) async {
    final repositorio = ref.read(estoqueRepositoryProvider);
    setState(() {
      _buscando = true;
      _erro = null;
    });
    try {
      final resultado = switch (_consulta) {
        ConsultaSaldo.produto => await _porProduto(repositorio, codigo),
        ConsultaSaldo.endereco => await _porEndereco(repositorio, codigo),
      };
      setState(() => _resultado = resultado);
    } on FalhaEstoque catch (falha) {
      setState(() {
        _resultado = null;
        _erro = falha.mensagem;
      });
    } finally {
      setState(() => _buscando = false);
    }
  }

  Future<_Resultado> _porProduto(EstoqueRepository repositorio, String codigo) async {
    final produto = await repositorio.buscarProduto(codigo);
    final (resumo, saldos) = await (
      repositorio.resumoDoProduto(produto.id),
      repositorio.saldos(produtoId: produto.id),
    ).wait;
    return _Resultado(resumo: resumo, saldos: saldos);
  }

  Future<_Resultado> _porEndereco(EstoqueRepository repositorio, String codigo) async {
    final armazem = ref.read(armazemProvider).value?.atual;
    if (armazem == null) {
      throw const FalhaEstoque('Escolha o armazém antes de ler o endereço.');
    }

    final endereco = await repositorio.buscarEndereco(armazem.id, codigo);
    return _Resultado(
      endereco: endereco,
      saldos: await repositorio.saldos(enderecoId: endereco.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _resultado;
    return Scaffold(
      appBar: const BarraStowise(titulo: 'Consultar saldo'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<ConsultaSaldo>(
              segments: [
                for (final consulta in ConsultaSaldo.values)
                  ButtonSegment(value: consulta, label: Text(consulta.rotulo)),
              ],
              selected: {_consulta},
              onSelectionChanged: (selecao) => setState(() {
                _consulta = selecao.single;
                _resultado = null;
                _erro = null;
              }),
            ),
            const SizedBox(height: 16),
            if (_consulta == ConsultaSaldo.endereco) ...[const SeletorArmazem(), const SizedBox(height: 16)],
            CampoCodigo(
              key: ValueKey(_consulta),
              rotulo: _consulta == ConsultaSaldo.produto ? 'Produto (SKU ou código de barras)' : 'Endereço',
              tituloLeitura: _consulta == ConsultaSaldo.produto ? 'Ler o produto' : 'Ler o endereço',
              onCodigo: _buscar,
              carregando: _buscando,
            ),
            if (_erro != null) ...[const SizedBox(height: 16), Aviso(texto: _erro!, tom: TomAviso.erro)],
            if (resultado?.resumo case final resumo?) ...[const SizedBox(height: 16), _CartaoResumo(resumo: resumo)],
            if (resultado?.endereco case final endereco?) ...[
              const SizedBox(height: 16),
              Text('Endereço ${endereco.codigo}', style: Theme.of(context).textTheme.titleMedium),
              if (endereco.bloqueado) const Aviso(texto: 'Este endereço está bloqueado.', tom: TomAviso.aviso),
            ],
            if (resultado != null) ...[
              const SizedBox(height: 16),
              if (resultado.saldos.isEmpty)
                const Aviso(texto: 'Nenhum saldo encontrado.', tom: TomAviso.aviso)
              else
                for (final saldo in resultado.saldos)
                  _LinhaSaldo(saldo: saldo, porProduto: _consulta == ConsultaSaldo.produto),
            ],
          ],
        ),
      ),
    );
  }
}

String _data(BuildContext context, DateTime data) => MaterialLocalizations.of(context).formatCompactDate(data);

class _CartaoResumo extends StatelessWidget {
  const _CartaoResumo({required this.resumo});

  final ResumoProduto resumo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = context.cores;
    // Sobre a tinta, os sentidos usam os tons claros (os mesmos do tema escuro).
    Widget valor(String rotulo, double numero, {Color cor = Colors.white}) => Expanded(
      child: Column(
        children: [
          Text(
            '${formatarQuantidade(numero)} ${resumo.unidade}',
            style: tema.textTheme.titleLarge?.copyWith(color: cor, fontWeight: FontWeight.w700),
          ),
          Text(rotulo, style: tema.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: cores.gradienteTinta,
        borderRadius: BorderRadius.circular(22),
        boxShadow: cores.sombraCartao,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: PlantaPainter(cor: Colors.white.withValues(alpha: 0.05))),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(height: 3, decoration: BoxDecoration(gradient: cores.faixa(tema.colorScheme.primary))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resumo.descricao,
                  style: tema.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: cores.sinal, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${resumo.sku} · ${resumo.enderecos} endereço(s)',
                        style: tema.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      valor('Em estoque', resumo.quantidade),
                      valor('Reservado', resumo.reservada, cor: CoresStowise.escuro.sinal),
                      valor('Disponível', resumo.disponivel, cor: CoresStowise.escuro.sucesso),
                    ],
                  ),
                ),
                if (resumo.lotes.any((lote) => lote.numero != null)) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final lote in resumo.lotes)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            [
                              lote.numero ?? 'Sem lote',
                              formatarQuantidade(lote.quantidade),
                              if (lote.validade != null) 'val. ${_data(context, lote.validade!)}',
                            ].join(' · '),
                            style: tema.textTheme.labelMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinhaSaldo extends StatelessWidget {
  const _LinhaSaldo({required this.saldo, required this.porProduto});

  final SaldoLinha saldo;

  /// Na consulta por produto, o título é o endereço; por endereço, o título é o produto.
  final bool porProduto;

  @override
  Widget build(BuildContext context) {
    final detalhes = [
      if (!porProduto) saldo.sku,
      if (saldo.lote != null) 'Lote ${saldo.lote}',
      if (saldo.validade != null) 'val. ${_data(context, saldo.validade!)}',
      if (saldo.reservada > 0) 'reservado ${formatarQuantidade(saldo.reservada)}',
    ];
    final tema = Theme.of(context);
    final cores = context.cores;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: tema.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cores.sombraCartao,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 6, 16, 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: porProduto ? cores.gradienteSinal : cores.gradienteMarca(tema.colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(porProduto ? Icons.place_outlined : Icons.inventory_2_outlined, color: Colors.white, size: 22),
        ),
        title: porProduto
            ? Align(alignment: Alignment.centerLeft, child: Etiqueta(saldo.enderecoCodigo, grande: true))
            : Text(saldo.descricao),
        subtitle: detalhes.isEmpty ? null : Text(detalhes.join(' · ')),
        trailing: Text(
          '${formatarQuantidade(saldo.disponivel)} ${saldo.unidade}',
          style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: tema.colorScheme.primary),
        ),
      ),
    );
  }
}
