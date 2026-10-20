import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/core/api/cliente_api.dart';
import 'package:stowise_mobile/core/config/ambiente.dart';
import 'package:stowise_mobile/features/rfid/data/rfid_repository.dart';
import 'package:stowise_mobile/features/rfid/domain/rfid.dart';

import '../../api_falsa.dart';

const _epcCaixa1 = '3054257BF7194E4000000001';
const _epcCaixa2 = '3054257BF7194E4000000002';

/// Leitor controlado pelo teste: entrega EPCs quando o teste manda e guarda o que foi gravado.
class LeitorRfidFalso implements LeitorRfid {
  final _leituras = StreamController<String>.broadcast();
  final gravados = <String>[];
  var lendo = false;

  void ler(String epc) => _leituras.add(epc);

  @override
  bool get disponivel => true;

  @override
  Stream<String> get leituras => _leituras.stream;

  @override
  Future<void> iniciarLeitura() async => lendo = true;

  @override
  Future<void> pararLeitura() async => lendo = false;

  @override
  Future<void> gravar(String epc) async => gravados.add(epc);
}

Map<String, Object?> _contagem({required int etiquetas, required double quantidade}) => {
  'produtoId': 'prod-1',
  'sku': 'COLA-2L',
  'descricao': 'Refrigerante Cola 2L',
  'unidadeBase': 'UN',
  'embalagemId': 'emb-cx',
  'tipo': 'Caixa',
  'fatorConversao': 6,
  'etiquetas': etiquetas,
  'quantidadeBase': quantidade,
};

void main() {
  group('EPC', () {
    test('normaliza o hexadecimal e recusa o que não tem 96 bits', () {
      expect(normalizarEpc(' 3054257bf7194e4000000001 '), _epcCaixa1);
      expect(normalizarEpc('7891000315507'), isNull);
      expect(normalizarEpc('3054257BF7194E400000000G'), isNull);
    });
  });

  group('leitor indisponível', () {
    test('é o padrão do app e recusa ler e gravar com uma mensagem clara', () async {
      final container = ProviderContainer.test();
      final leitor = container.read(leitorRfidProvider);

      expect(leitor.disponivel, isFalse);
      await expectLater(leitor.gravar(_epcCaixa1), throwsA(isA<FalhaRfid>()));
      await expectLater(ColetaRfid(leitor).iniciar(), throwsA(isA<FalhaRfid>()));
    });
  });

  group('coleta', () {
    test('junta os EPCs distintos e para de ouvir ao parar', () async {
      final leitor = LeitorRfidFalso();
      final coleta = ColetaRfid(leitor);

      await coleta.iniciar();
      leitor
        ..ler(_epcCaixa1)
        ..ler(_epcCaixa1.toLowerCase())
        ..ler('lixo do leitor')
        ..ler(_epcCaixa2);
      await Future<void>.delayed(Duration.zero);
      expect(leitor.lendo, isTrue);
      expect(coleta.epcs, [_epcCaixa1, _epcCaixa2]);

      await coleta.parar();
      leitor.ler('3054257BF7194E4000000003');
      await Future<void>.delayed(Duration.zero);
      expect(leitor.lendo, isFalse);
      expect(coleta.lendo, isFalse);
      expect(coleta.epcs, hasLength(2));
    });
  });

  group('repositório', () {
    late ApiFalsa api;
    late RfidRepository repositorio;

    setUp(() {
      api = ApiFalsa((_) => json({}));
      final container = ProviderContainer.test(
        overrides: [ambienteProvider.overrideWithValue(const Ambiente(nome: 'dev', apiUrl: 'http://api.teste'))],
      );
      container.read(dioProvider).httpClientAdapter = api;
      repositorio = container.read(rfidRepositoryProvider);
    });

    test('resolve em lotes de 1000 e soma as contagens da mesma embalagem', () async {
      api.responder = (r) => json({
        'leituras': <Object?>[],
        'produtos': [_contagem(etiquetas: ((r.corpo! as Map)['epcs'] as List).length, quantidade: 6)],
        'naoReconhecidas': 1,
      });
      final epcs = [for (var i = 0; i < 1500; i++) i.toRadixString(16).padLeft(24, '0')];

      final resultado = await repositorio.resolver([...epcs, epcs.first]);

      expect(api.requisicoes.map((r) => r.caminho), everyElement('/api/v1/rfid/leituras'));
      expect(api.requisicoes.map((r) => ((r.corpo! as Map)['epcs'] as List).length), [1000, 500]);
      final caixa = resultado.contagens.single;
      expect(caixa.embalagem, 'Caixa');
      expect(caixa.etiquetas, 1500);
      expect(caixa.quantidadeBase, 12);
      expect(resultado.naoReconhecidas, 2);
    });

    test('pede EPCs para gravar e devolve a série de cada um', () async {
      api.responder = (_) => json({
        'produtoId': 'prod-1',
        'embalagemId': 'emb-cx',
        'gtin': '17891000315504',
        'etiquetas': [
          {'epc': _epcCaixa1, 'epcUri': 'urn:epc:id:sgtin:7891000.131550.1', 'serie': 1},
        ],
      });

      final etiquetas = await repositorio.gerarEtiquetas('emb-cx', 1);

      // Sem tamanhoPrefixoEmpresa, a API usa Rfid:TamanhoPrefixoEmpresaPadrao.
      expect(api.requisicoes.single.corpo, {'embalagemId': 'emb-cx', 'quantidade': 1, 'tamanhoPrefixoEmpresa': null});
      expect(etiquetas.single.epc, _epcCaixa1);
      expect(etiquetas.single.serie, 1);
    });

    test('converte o erro da API numa falha com os campos', () async {
      api.responder = (_) => json({
        'status': 400,
        'title': 'One or more validation errors occurred.',
        'errors': {
          'quantidade': ['Informe de 1 a 500 etiquetas.'],
        },
      }, status: 400);

      await expectLater(
        repositorio.gerarEtiquetas('emb-cx', 501),
        throwsA(isA<FalhaRfid>().having((f) => f.campos['quantidade'], 'quantidade', 'Informe de 1 a 500 etiquetas.')),
      );
    });
  });
}
