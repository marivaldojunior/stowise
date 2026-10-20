import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stowise_api/stowise_api.dart';

import '../../../core/api/cliente_api.dart';
import '../../../core/api/erros.dart';
import '../domain/rfid.dart';

/// A API resolve até este número de EPCs por chamada (LimitesRfid.LeiturasPorLote).
const leiturasPorLote = 1000;

const _rotulosEmbalagem = {
  TipoEmbalagem.unidade: 'Unidade',
  TipoEmbalagem.caixa: 'Caixa',
  TipoEmbalagem.palete: 'Palete',
};

/// RFID pela API (ADR-0010): resolve EPCs lidos em quantidades e pede EPCs novos para gravar.
class RfidRepository {
  RfidRepository(this._api);

  final StowiseApi _api;

  /// Resolve os EPCs em lotes de [leiturasPorLote] e soma as contagens por embalagem.
  Future<ResultadoLeituraRfid> resolver(Iterable<String> epcs) => _chamar(() async {
    final distintos = epcs.toSet().toList();
    final porEmbalagem = <String, ContagemPorEmbalagem>{};
    var naoReconhecidas = 0;
    for (var inicio = 0; inicio < distintos.length; inicio += leiturasPorLote) {
      final lote = distintos.sublist(inicio, (inicio + leiturasPorLote).clamp(0, distintos.length));
      final resposta = await _api.getRFIDApi().resolverLeiturasRfid(
        resolverLeiturasRfid: ResolverLeiturasRfid((b) => b..epcs = ListBuilder(lote)),
      );
      final resolvidas = resposta.data!;
      naoReconhecidas += resolvidas.naoReconhecidas;
      for (final c in resolvidas.produtos) {
        final anterior = porEmbalagem[c.embalagemId];
        porEmbalagem[c.embalagemId] = ContagemPorEmbalagem(
          produtoId: c.produtoId,
          sku: c.sku,
          descricao: c.descricao,
          embalagemId: c.embalagemId,
          embalagem: _rotulosEmbalagem[c.tipo] ?? c.tipo.name,
          unidadeBase: c.unidadeBase,
          etiquetas: (anterior?.etiquetas ?? 0) + c.etiquetas,
          quantidadeBase: (anterior?.quantidadeBase ?? 0) + c.quantidadeBase,
        );
      }
    }

    return ResultadoLeituraRfid(contagens: porEmbalagem.values.toList(), naoReconhecidas: naoReconhecidas);
  });

  /// EPCs novos, com séries únicas, para gravar nas etiquetas da embalagem.
  Future<List<EtiquetaParaGravar>> gerarEtiquetas(String embalagemId, int quantidade) => _chamar(() async {
    final resposta = await _api.getRFIDApi().gerarEtiquetasRfid(
      gerarEtiquetasRfid: GerarEtiquetasRfid(
        (b) => b
          ..embalagemId = embalagemId
          ..quantidade = quantidade,
      ),
    );
    return [for (final e in resposta.data!.etiquetas) EtiquetaParaGravar(epc: e.epc, epcUri: e.epcUri, serie: e.serie)];
  });

  Future<T> _chamar<T>(Future<T> Function() chamada) async {
    try {
      return await chamada();
    } on DioException catch (erro) {
      throw FalhaRfid(mensagemDoErro(erro), campos: _campos(erro), semConexao: ehFalhaDeConexao(erro));
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

final rfidRepositoryProvider = Provider<RfidRepository>((ref) => RfidRepository(ref.watch(stowiseApiProvider)));

/// Leitor do aparelho. Um plugin de fabricante substitui este provider na inicialização do app.
final leitorRfidProvider = Provider<LeitorRfid>((ref) => const LeitorRfidIndisponivel());
