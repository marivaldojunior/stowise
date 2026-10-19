import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/app/app.dart';
import 'package:stowise_mobile/bootstrap.dart';
import 'package:stowise_mobile/core/api/cliente_api.dart';
import 'package:stowise_mobile/core/armazenamento/cofre.dart';
import 'package:stowise_mobile/core/armazenamento/preferencias.dart';
import 'package:stowise_mobile/core/config/ambiente.dart';

import 'api_falsa.dart';

const ambienteDeTeste = Ambiente(nome: 'dev', apiUrl: 'http://api.teste');

/// Cofre em memória (no lugar do Keystore).
class CofreFalso implements Cofre {
  CofreFalso([this.refreshToken]);

  String? refreshToken;

  @override
  Future<String?> lerRefreshToken() async => refreshToken;

  @override
  Future<void> gravarRefreshToken(String token) async => refreshToken = token;

  @override
  Future<void> apagar() async => refreshToken = null;
}

/// Preferências em memória (no lugar do SharedPreferences).
class PreferenciasFalsas implements Preferencias {
  PreferenciasFalsas([Map<String, String>? iniciais]) : valores = {...?iniciais};

  final Map<String, String> valores;

  @override
  Future<String?> ler(String chave) async => valores[chave];

  @override
  Future<void> gravar(String chave, String valor) async => valores[chave] = valor;
}

/// API que aceita o refresh token guardado e devolve uma sessão de Operador; o resto responde 404.
ApiFalsa apiComSessao({List<String> perfis = const ['Operador']}) => ApiFalsa(
  (requisicao) => requisicao.caminho == '/api/v1/auth/refresh'
      ? json(sessaoJson(perfis: perfis, refreshToken: 'refresh-2'))
      : problema(404, 'Não encontrado'),
);

/// Container com o ambiente de teste, o cofre e a API falsos e as mesmas ligações do app. Sem [comSessao], a rede
/// não usa a sessão (para testar o repositório sozinho).
ProviderContainer criarContainer({
  required ApiFalsa api,
  required CofreFalso cofre,
  List<dynamic> overrides = const [],
  bool comSessao = true,
}) {
  final container = ProviderContainer.test(
    overrides: [
      ambienteProvider.overrideWithValue(ambienteDeTeste),
      cofreProvider.overrideWithValue(cofre),
      preferenciasProvider.overrideWithValue(PreferenciasFalsas()),
      if (comSessao) ...ligacoes,
      ...overrides.cast(),
    ],
  );
  container.read(dioProvider).httpClientAdapter = api;
  return container;
}

/// Monta o app inteiro numa tela de celular. Sem [cofre], há uma sessão guardada (refresh token) que a API aceita.
Future<({ApiFalsa api, CofreFalso cofre})> montarApp(
  WidgetTester tester, {
  ApiFalsa? api,
  CofreFalso? cofre,
  PreferenciasFalsas? preferencias,
  ThemeMode tema = ThemeMode.light,
  Size tela = const Size(400, 800),
}) async {
  // Tela de celular (400 x 800) com densidade 1: goldens pequenos e iguais em qualquer máquina.
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = tela;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.platformBrightnessTestValue = tema == ThemeMode.dark ? Brightness.dark : Brightness.light;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  final apiDoTeste = api ?? apiComSessao();
  final cofreDoTeste = cofre ?? CofreFalso('refresh-1');
  // ProviderScope (e não um container solto): ao desmontar a árvore no fim do teste, os providers são descartados e
  // o timer de renovação da sessão é cancelado.
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ambienteProvider.overrideWithValue(ambienteDeTeste),
        cofreProvider.overrideWithValue(cofreDoTeste),
        preferenciasProvider.overrideWithValue(preferencias ?? PreferenciasFalsas()),
        ...ligacoes,
      ],
      child: _ComAdaptador(api: apiDoTeste, child: const StowiseApp()),
    ),
  );
  await tester.pumpAndSettle();
  return (api: apiDoTeste, cofre: cofreDoTeste);
}

/// Troca o adaptador HTTP do Dio do app pela API falsa antes da primeira chamada.
class _ComAdaptador extends ConsumerWidget {
  const _ComAdaptador({required this.api, required this.child});

  final ApiFalsa api;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(dioProvider).httpClientAdapter = api;
    return child;
  }
}
