import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ajudantes.dart';
import '../../api_falsa.dart';

/// API sem sessão guardada: o login devolve o que [login] responder; o logout responde 204.
ApiFalsa apiDeLogin(Responder login) => ApiFalsa(
  (r) => switch (r.caminho) {
    '/api/v1/auth/login' => login(r),
    '/api/v1/auth/logout' => semConteudo(),
    _ => problema(401, 'Sessão inválida'),
  },
);

Future<void> preencherLogin(WidgetTester tester, String email, String senha) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
  await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), senha);
  await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sem sessão guardada, abre no login', (tester) async {
    await montarApp(tester, api: apiDeLogin((_) => json(sessaoJson())), cofre: CofreFalso());

    expect(find.text('Entrar no Stowise'), findsOneWidget);
  });

  testWidgets('entra e vai para o início com o nome do usuário', (tester) async {
    final ambiente = await montarApp(tester, api: apiDeLogin((_) => json(sessaoJson())), cofre: CofreFalso());

    await preencherLogin(tester, 'carla@stowise.dev', 'segredo');

    expect(find.text('Olá, Carla'), findsOneWidget);
    expect(ambiente.cofre.refreshToken, 'refresh-1');
  });

  testWidgets('pede e-mail e senha antes de chamar a API', (tester) async {
    final ambiente = await montarApp(tester, api: apiDeLogin((_) => json(sessaoJson())), cofre: CofreFalso());

    await preencherLogin(tester, '', '');

    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);
    expect(ambiente.api.requisicoes.where((r) => r.caminho == '/api/v1/auth/login'), isEmpty);
  });

  testWidgets('mostra o motivo da recusa', (tester) async {
    await montarApp(
      tester,
      api: apiDeLogin(
        (_) => problema(401, 'Credenciais inválidas', detalhe: 'E-mail ou senha incorretos, ou usuário bloqueado.'),
      ),
      cofre: CofreFalso(),
    );

    await preencherLogin(tester, 'carla@stowise.dev', 'errada');

    expect(find.text('E-mail ou senha incorretos, ou usuário bloqueado.'), findsOneWidget);
    expect(find.text('Entrar no Stowise'), findsOneWidget);
  });

  testWidgets('avisa quando a API não responde', (tester) async {
    await montarApp(
      tester,
      api: apiDeLogin((r) => throw DioException.connectionError(requestOptions: RequestOptions(), reason: 'x')),
      cofre: CofreFalso(),
    );

    await preencherLogin(tester, 'carla@stowise.dev', 'segredo');

    expect(find.text('A API não respondeu. Confira a rede e tente de novo.'), findsOneWidget);
  });

  testWidgets('sai pelo menu do usuário e volta ao login', (tester) async {
    final ambiente = await montarApp(tester);
    expect(find.text('Olá, Carla'), findsOneWidget);

    await tester.tap(find.byTooltip('Menu do usuário'));
    await tester.pumpAndSettle();
    expect(find.text('carla@stowise.dev'), findsOneWidget);
    expect(find.text('Operador'), findsOneWidget);
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(find.text('Entrar no Stowise'), findsOneWidget);
    expect(ambiente.cofre.refreshToken, isNull);
  });

  testWidgets('sem conexão ao abrir: tenta de novo e entra', (tester) async {
    var online = false;
    await montarApp(
      tester,
      api: ApiFalsa((_) => online ? json(sessaoJson()) : problema(503, 'Service Unavailable')),
      cofre: CofreFalso('refresh-1'),
    );
    expect(find.text('Sem conexão'), findsOneWidget);

    online = true;
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();

    expect(find.text('Olá, Carla'), findsOneWidget);
  });

  testWidgets('golden: login', (tester) async {
    await montarApp(tester, api: apiDeLogin((_) => json(sessaoJson())), cofre: CofreFalso());

    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../../goldens/login_claro.png'));
  });
}
