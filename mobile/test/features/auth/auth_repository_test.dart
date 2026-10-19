import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/features/auth/data/auth_repository.dart';
import 'package:stowise_mobile/features/auth/domain/sessao.dart';

import '../../ajudantes.dart';
import '../../api_falsa.dart';

void main() {
  late ApiFalsa api;
  late CofreFalso cofre;
  late AuthRepository repositorio;

  void montar(Responder responder, {String? refreshGuardado}) {
    api = ApiFalsa(responder);
    cofre = CofreFalso(refreshGuardado);
    repositorio = criarContainer(api: api, cofre: cofre, comSessao: false).read(authRepositoryProvider);
  }

  group('entrar', () {
    test('pede o refresh token no corpo e o guarda no cofre', () async {
      montar((_) => json(sessaoJson(perfis: ['Gestor'])));

      final sessao = await repositorio.entrar(' carla@stowise.dev ', 'segredo');

      expect(api.requisicoes.single.caminho, '/api/v1/auth/login');
      expect(api.requisicoes.single.corpo, {'email': 'carla@stowise.dev', 'senha': 'segredo', 'useCookie': false});
      expect(sessao.accessToken, 'token-1');
      expect(sessao.usuario.perfis, ['Gestor']);
      expect(sessao.usuario.primeiroNome, 'Carla');
      expect(cofre.refreshToken, 'refresh-1');
    });

    test('credenciais recusadas trazem a mensagem da API', () async {
      montar(
        (_) => problema(401, 'Credenciais inválidas', detalhe: 'E-mail ou senha incorretos, ou usuário bloqueado.'),
      );

      await expectLater(
        repositorio.entrar('carla@stowise.dev', 'errada'),
        throwsA(
          isA<FalhaAuth>()
              .having((f) => f.mensagem, 'mensagem', 'E-mail ou senha incorretos, ou usuário bloqueado.')
              .having((f) => f.recusada, 'recusada', isTrue),
        ),
      );
      expect(cofre.refreshToken, isNull);
    });

    test('sem resposta da API, avisa da conexão', () async {
      montar(
        (r) => throw DioException.connectionError(
          requestOptions: RequestOptions(path: r.caminho),
          reason: 'x',
        ),
      );

      await expectLater(
        repositorio.entrar('carla@stowise.dev', 'segredo'),
        throwsA(isA<FalhaAuth>().having((f) => f.semConexao, 'semConexao', isTrue)),
      );
    });
  });

  group('renovar', () {
    test('usa o refresh guardado e grava o novo (a API gira o token)', () async {
      montar(
        (_) => json(sessaoJson(accessToken: 'token-2', refreshToken: 'refresh-2')),
        refreshGuardado: 'refresh-1',
      );

      final sessao = await repositorio.renovar();

      expect(api.requisicoes.single.corpo, {'refreshToken': 'refresh-1', 'useCookie': false});
      expect(sessao.accessToken, 'token-2');
      expect(cofre.refreshToken, 'refresh-2');
    });

    test('sessão recusada apaga o refresh do cofre', () async {
      montar((_) => problema(401, 'Sessão inválida'), refreshGuardado: 'refresh-1');

      await expectLater(repositorio.renovar(), throwsA(isA<FalhaAuth>().having((f) => f.recusada, 'recusada', isTrue)));
      expect(cofre.refreshToken, isNull);
    });

    test('API fora do ar mantém o refresh para tentar de novo', () async {
      montar((_) => problema(503, 'Service Unavailable'), refreshGuardado: 'refresh-1');

      await expectLater(
        repositorio.renovar(),
        throwsA(isA<FalhaAuth>().having((f) => f.semConexao, 'semConexao', isTrue)),
      );
      expect(cofre.refreshToken, 'refresh-1');
    });

    test('sem refresh guardado, nem chama a API', () async {
      montar((_) => json(sessaoJson()));

      await expectLater(repositorio.renovar(), throwsA(isA<FalhaAuth>()));
      expect(api.requisicoes, isEmpty);
    });
  });

  group('sair', () {
    test('revoga o refresh na API e apaga do cofre', () async {
      montar((_) => semConteudo(), refreshGuardado: 'refresh-1');

      await repositorio.sair();

      expect(api.requisicoes.single.caminho, '/api/v1/auth/logout');
      expect(api.requisicoes.single.corpo, {'refreshToken': 'refresh-1', 'useCookie': false});
      expect(cofre.refreshToken, isNull);
    });

    test('sem rede, a sessão local termina mesmo assim', () async {
      montar((_) => problema(503, 'Service Unavailable'), refreshGuardado: 'refresh-1');

      await repositorio.sair();

      expect(cofre.refreshToken, isNull);
    });
  });
}
