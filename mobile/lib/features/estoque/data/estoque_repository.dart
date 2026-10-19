import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stowise_api/stowise_api.dart';

import '../../../core/api/cliente_api.dart';
import '../../../core/api/erros.dart';
import '../domain/estoque.dart';

final _rotulosEmbalagem = {
  TipoEmbalagem.unidade: 'Unidade',
  TipoEmbalagem.caixa: 'Caixa',
  TipoEmbalagem.palete: 'Palete',
};

/// Estoque pela API: leitura de produto e endereço pelo código e as movimentações do operador.
class EstoqueRepository {
  EstoqueRepository(this._api);

  final StowiseApi _api;

  Future<List<Armazem>> listarArmazens() => _chamar(() async {
    final resposta = await _api.getEstruturaFsicaApi().listarArmazens();
    return [for (final a in resposta.data!) Armazem(id: a.id, codigo: a.codigo, nome: a.nome)];
  });

  /// Produto pelo SKU ou pelo GTIN de qualquer embalagem.
  Future<ProdutoLido> buscarProduto(String codigo) => _chamar(() async {
    final resposta = await _api.getCatlogoApi().obterProdutoPorCodigo(codigo: codigo);
    final lido = resposta.data!;
    final produto = lido.produto;
    final embalagem = produto.embalagens.firstWhere((e) => e.id == lido.embalagemId);
    return ProdutoLido(
      id: produto.id,
      sku: produto.sku,
      descricao: produto.descricao,
      unidadeBase: produto.unidadeBase,
      controlaLote: produto.controlaLote,
      controlaValidade: produto.controlaValidade,
      embalagemId: embalagem.id,
      embalagem: _rotulosEmbalagem[embalagem.tipo] ?? embalagem.tipo.name,
      fator: embalagem.fatorConversao,
    );
  });

  Future<EnderecoLido> buscarEndereco(String armazemId, String codigo) => _chamar(() async {
    final resposta = await _api.getEstruturaFsicaApi().obterEnderecoPorCodigo(id: armazemId, codigo: codigo);
    final endereco = resposta.data!;
    return EnderecoLido(
      id: endereco.id,
      codigo: endereco.codigo,
      bloqueado: endereco.status == StatusEndereco.bloqueado,
    );
  });

  Future<MovimentoRegistrado> registrar(Movimento movimento) => _chamar(() async {
    final estoque = _api.getEstoqueApi();
    final agora = DateTime.now().toUtc();
    final lote = movimento.loteNumero;
    final Response<MovimentacaoDetalhe> resposta = switch (movimento.tipo) {
      TipoMovimento.entrada => await estoque.registrarEntrada(
        registrarEntrada: RegistrarEntrada(
          (b) => b
            ..produtoId = movimento.produto.id
            ..embalagemId = movimento.produto.embalagemId
            ..enderecoId = movimento.destino!.id
            ..quantidade = movimento.quantidade
            ..lote = lote == null
                ? null
                : (LoteInformadoBuilder()
                    ..numero = lote
                    ..validade = _data(movimento.loteValidade))
            ..documentoReferencia = movimento.documento
            ..dispositivoId = movimento.dispositivoId
            ..ocorridoEm = agora
            ..idempotencyKey = movimento.chave,
        ),
      ),
      TipoMovimento.saida => await estoque.registrarSaida(
        registrarSaida: RegistrarSaida(
          (b) => b
            ..produtoId = movimento.produto.id
            ..embalagemId = movimento.produto.embalagemId
            ..enderecoId = movimento.origem!.id
            ..quantidade = movimento.quantidade
            ..lote = lote
            ..documentoReferencia = movimento.documento
            ..dispositivoId = movimento.dispositivoId
            ..ocorridoEm = agora
            ..idempotencyKey = movimento.chave,
        ),
      ),
      TipoMovimento.transferencia => await estoque.registrarTransferencia(
        registrarTransferencia: RegistrarTransferencia(
          (b) => b
            ..produtoId = movimento.produto.id
            ..embalagemId = movimento.produto.embalagemId
            ..enderecoOrigemId = movimento.origem!.id
            ..enderecoDestinoId = movimento.destino!.id
            ..quantidade = movimento.quantidade
            ..lote = lote
            ..documentoReferencia = movimento.documento
            ..dispositivoId = movimento.dispositivoId
            ..ocorridoEm = agora
            ..idempotencyKey = movimento.chave,
        ),
      ),
    };
    final detalhe = resposta.data!;
    return MovimentoRegistrado(
      id: detalhe.id,
      quantidadeBase: detalhe.quantidade,
      repetido: resposta.headers.value('Idempotent-Replayed') == 'true',
    );
  });

  Future<ResumoProduto> resumoDoProduto(String produtoId) => _chamar(() async {
    final resumo = (await _api.getEstoqueApi().obterResumoSaldoProduto(produtoId: produtoId)).data!;
    return ResumoProduto(
      sku: resumo.sku,
      descricao: resumo.descricao,
      unidade: resumo.unidadeBase,
      quantidade: resumo.quantidade,
      reservada: resumo.quantidadeReservada,
      disponivel: resumo.quantidadeDisponivel,
      enderecos: resumo.enderecos,
      lotes: [
        for (final lote in resumo.lotes)
          LoteResumo(numero: lote.numero, validade: _dataHora(lote.validade), quantidade: lote.quantidade),
      ],
    );
  });

  /// Saldos por produto ou por endereço (até 100 linhas: o suficiente para uma consulta no corredor).
  Future<List<SaldoLinha>> saldos({String? produtoId, String? enderecoId}) => _chamar(() async {
    final pagina = await _api.getEstoqueApi().listarSaldos(
      produtoId: produtoId,
      enderecoId: enderecoId,
      tamanhoPagina: 100,
    );
    return [
      for (final saldo in pagina.data!.itens)
        SaldoLinha(
          enderecoCodigo: saldo.enderecoCodigo,
          sku: saldo.sku,
          descricao: saldo.descricao,
          unidade: saldo.unidadeBase,
          lote: saldo.loteNumero,
          validade: _dataHora(saldo.validade),
          quantidade: saldo.quantidade,
          reservada: saldo.quantidadeReservada,
          disponivel: saldo.quantidadeDisponivel,
        ),
    ];
  });

  DateTime? _dataHora(Date? data) => data == null ? null : DateTime(data.year, data.month, data.day);

  Date? _data(DateTime? data) => data == null ? null : Date(data.year, data.month, data.day);

  /// Converte as falhas do Dio na falha do estoque, com a mensagem e os erros por campo da API.
  Future<T> _chamar<T>(Future<T> Function() chamada) async {
    try {
      return await chamada();
    } on DioException catch (erro) {
      throw FalhaEstoque(
        mensagemDoErro(erro),
        campos: _campos(erro),
        semConexao: ehFalhaDeConexao(erro),
        naoEncontrado: erro.response?.statusCode == 404,
      );
    }
  }

  Map<String, String> _campos(DioException erro) {
    final dados = erro.response?.data;
    final erros = dados is Map ? dados['errors'] : null;
    if (erros is! Map) {
      return const {};
    }

    return {
      for (final MapEntry(:key, :value) in erros.entries)
        if (value is List && value.isNotEmpty) '$key': '${value.first}',
    };
  }
}

final estoqueRepositoryProvider = Provider<EstoqueRepository>(
  (ref) => EstoqueRepository(ref.watch(stowiseApiProvider)),
);
