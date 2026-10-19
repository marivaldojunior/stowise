import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/app/rotas.dart';
import 'package:stowise_mobile/core/api/cliente_api.dart';
import 'package:stowise_mobile/features/auth/domain/sessao.dart';
import 'package:stowise_mobile/features/auth/presentation/sessao_controller.dart';

import '../../ajudantes.dart';
import '../../api_falsa.dart';

/// Espera o controller sair de "Verificando" (a retomada roda num microtask).
Future<EstadoSessao> estadoDepoisDeAbrir(ProviderContainer container) async {
  container.read(sessaoProvider);
  for (var i = 0; i < 20 && container.read(sessaoProvider) is Verificando; i++) {
    await Future<void>.delayed(Duration.zero);
  }

  return container.read(sessaoProvider);
}

void main() {
  group('abertura do app', () {
    test('retoma a sessão pelo refresh guardado', () async {
      final container = criarContainer(api: apiComSessao(), cofre: CofreFalso('refresh-1'));

      final estado = await estadoDepoisDeAbrir(container);

      expect(estado, isA<Autenticado>());
      expect(container.read(usuarioProvider)?.nome, 'Carla Dias');
    });

    test('sem sessão guardada, vai para o login sem aviso', () async {
      final container = criarContainer(api: apiComSessao(), cofre: CofreFalso());

      final estado = await estadoDepoisDeAbrir(container);

      expect(estado, isA<Anonimo>().having((e) => e.aviso, 'aviso', isNull));
    });

    test('API fora do ar com sessão guardada: sem conexão', () async {
      final api = ApiFalsa((_) => problema(503, 'Service Unavailable'));
      final container = criarContainer(api: api, cofre: CofreFalso('refresh-1'));

      expect(await estadoDepoisDeAbrir(container), isA<SemConexao>());
    });
  });

  group('token nas chamadas', () {
    test('envia o Bearer da sessão, mas não nas rotas de autenticação', () async {
      final api = apiComSessao();
      final container = criarContainer(api: api, cofre: CofreFalso('refresh-1'));
      await estadoDepoisDeAbrir(container);

      try {
        await container.read(dioProvider).get<void>('/api/v1/produtos');
      } on DioException {
        // 404 da API falsa: aqui só interessa o cabeçalho enviado.
      }

      expect(api.requisicoes.first.cabecalhos['Authorization'], isNull);
      expect(api.requisicoes.last.cabecalhos['Authorization'], 'Bearer token-1');
    });

    test('depois de um 401, renova e repete a chamada com o token novo', () async {
      var refreshes = 0;
      final api = ApiFalsa((r) {
        if (r.caminho == '/api/v1/auth/refresh') {
          refreshes += 1;
          return json(sessaoJson(accessToken: 'token-$refreshes', refreshToken: 'refresh-$refreshes'));
        }

        return r.cabecalhos['Authorization'] == 'Bearer token-2' ? json({'ok': true}) : problema(401, 'Unauthorized');
      });
      final cofre = CofreFalso('refresh-0');
      final container = criarContainer(api: api, cofre: cofre);
      await estadoDepoisDeAbrir(container);

      final resposta = await container.read(dioProvider).get<Map<String, dynamic>>('/api/v1/produtos');

      expect(resposta.data, {'ok': true});
      final chamadas = api.requisicoes.where((r) => r.caminho == '/api/v1/produtos');
      expect(chamadas.map((r) => r.cabecalhos['Authorization']), ['Bearer token-1', 'Bearer token-2']);
      expect(cofre.refreshToken, 'refresh-2');
    });

    test('vários 401 ao mesmo tempo usam um só refresh', () async {
      var refreshes = 0;
      final api = ApiFalsa((r) {
        if (r.caminho == '/api/v1/auth/refresh') {
          refreshes += 1;
          return json(sessaoJson(accessToken: 'token-$refreshes'));
        }

        return r.cabecalhos['Authorization'] == 'Bearer token-2' ? json({'ok': true}) : problema(401, 'Unauthorized');
      });
      final container = criarContainer(api: api, cofre: CofreFalso('refresh-0'));
      await estadoDepoisDeAbrir(container);
      final dio = container.read(dioProvider);

      await Future.wait([dio.get<void>('/api/v1/a'), dio.get<void>('/api/v1/b'), dio.get<void>('/api/v1/c')]);

      expect(refreshes, 2, reason: 'um na abertura do app e um só para os três 401');
    });

    test('refresh recusado encerra a sessão com aviso', () async {
      var refreshes = 0;
      final api = ApiFalsa((r) {
        if (r.caminho == '/api/v1/auth/refresh') {
          refreshes += 1;
          return refreshes == 1 ? json(sessaoJson()) : problema(401, 'Sessão inválida');
        }

        return problema(401, 'Unauthorized');
      });
      final cofre = CofreFalso('refresh-0');
      final container = criarContainer(api: api, cofre: cofre);
      await estadoDepoisDeAbrir(container);

      await expectLater(container.read(dioProvider).get<void>('/api/v1/produtos'), throwsA(anything));

      expect(
        container.read(sessaoProvider),
        isA<Anonimo>().having((e) => e.aviso, 'aviso', 'Sua sessão expirou. Entre novamente.'),
      );
      expect(cofre.refreshToken, isNull);
    });
  });

  group('regras', () {
    final usuario = const Usuario(id: '1', nome: 'Carla Dias', email: 'c@s.dev', perfis: ['Operador']);

    test('renova um minuto antes do vencimento, com espera mínima de 5 s', () {
      final agora = DateTime.utc(2026, 10, 19, 12);
      final sessao = Sessao(accessToken: 't', expiraEm: agora.add(const Duration(minutes: 15)), usuario: usuario);

      expect(esperaAteRenovar(sessao, agora), const Duration(minutes: 14));
      final quaseVencida = Sessao(accessToken: 't', expiraEm: agora.add(const Duration(seconds: 30)), usuario: usuario);
      expect(esperaAteRenovar(quaseVencida, agora), const Duration(seconds: 5));
    });

    test('as rotas seguem a sessão', () {
      final autenticado = Autenticado(Sessao(accessToken: 't', expiraEm: DateTime.now(), usuario: usuario));

      expect(destinoPelaSessao(const Verificando(), '/'), Rotas.carregando);
      expect(destinoPelaSessao(const Anonimo(), '/'), Rotas.login);
      expect(destinoPelaSessao(const Anonimo(), Rotas.login), isNull);
      expect(destinoPelaSessao(const SemConexao(), '/'), Rotas.semConexao);
      expect(destinoPelaSessao(autenticado, Rotas.login), Rotas.inicio);
      expect(destinoPelaSessao(autenticado, '/'), isNull);
    });

    test('perfis de gestão', () {
      expect(usuario.temPerfil(Perfis.gestao), isFalse);
      expect(
        const Usuario(id: '2', nome: 'Bruno', email: 'b@s.dev', perfis: ['Gestor']).temPerfil(Perfis.gestao),
        isTrue,
      );
    });
  });
}
