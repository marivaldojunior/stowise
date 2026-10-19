import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/ajudantes.dart';
import '../test/api_falsa.dart';
import '../test/features/estoque/api_estoque.dart';

/// API em memória com estado: o login abre a sessão, a entrada soma no saldo e a consulta devolve o saldo atual.
ApiFalsa apiDoArmazem() {
  var saldo = 0.0;
  final catalogo = apiDeEstoque();
  return ApiFalsa((r) {
    switch (r.caminho) {
      case '/api/v1/auth/refresh':
        return problema(401, 'Sessão inválida');
      case '/api/v1/auth/login':
        return json(sessaoJson());
      case '/api/v1/auth/logout':
        return semConteudo();
      case '/api/v1/movimentacoes/entradas':
        saldo += ((r.corpo! as Map<String, dynamic>)['quantidade'] as num).toDouble();
        return json(movimentacao('Entrada', saldo), status: 201);
      case '/api/v1/saldos/produtos/p-arroz':
        return json({
          'produtoId': 'p-arroz',
          'sku': 'ARZ-T1-5',
          'descricao': 'Arroz tipo 1 5kg',
          'unidadeBase': 'UN',
          'quantidade': saldo,
          'quantidadeReservada': 0,
          'quantidadeDisponivel': saldo,
          'enderecos': saldo > 0 ? 1 : 0,
          'lotes': <Object>[],
        });
      case '/api/v1/saldos':
        return json({'itens': <Object>[], 'pagina': 1, 'tamanhoPagina': 100, 'total': 0});
      default:
        return catalogo.responder(r);
    }
  });
}

Future<void> digitarCodigo(WidgetTester tester, String rotulo, String codigo) async {
  await tester.enterText(find.widgetWithText(TextField, rotulo), codigo);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('operador entra, registra uma entrada, consulta o saldo e sai', (tester) async {
    await montarApp(tester, api: apiDoArmazem(), cofre: CofreFalso(), tela: const Size(400, 1000));

    // Login
    expect(find.text('Entrar no Stowise'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), 'carla@stowise.dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), 'segredo');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Olá, Carla'), findsOneWidget);

    // Entrada de 3 unidades
    await tester.tap(find.text('Movimentar estoque'));
    await tester.pumpAndSettle();
    await digitarCodigo(tester, 'Produto (SKU ou código de barras)', 'ARZ-T1-5');
    await digitarCodigo(tester, 'Endereço', 'A-01-1-1');
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '3');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Registrar entrada'));
    await tester.tap(find.widgetWithText(FilledButton, 'Registrar entrada'));
    await tester.pumpAndSettle();
    expect(find.text('Entrada registrada: 3 UN de ARZ-T1-5 em A-01-1-1.'), findsOneWidget);

    // Saldo do produto
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Consultar saldo'));
    await tester.pumpAndSettle();
    await digitarCodigo(tester, 'Produto (SKU ou código de barras)', 'ARZ-T1-5');
    expect(find.text('3 UN'), findsNWidgets(2), reason: 'em estoque e disponível');

    // Sair
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu do usuário'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.text('Entrar no Stowise'), findsOneWidget);
  });
}
