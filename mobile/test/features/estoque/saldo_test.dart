import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ajudantes.dart';
import '../../api_falsa.dart';
import 'api_estoque.dart';
import 'fluxo.dart';

Future<ApiFalsa> abrirSaldo(WidgetTester tester) async {
  final api = apiDeEstoque();
  await montarApp(tester, api: api, tela: const Size(400, 1000));
  await tester.tap(find.text('Consultar saldo'));
  await tester.pumpAndSettle();
  return api;
}

void main() {
  testWidgets('por produto: totais, lotes e endereços', (tester) async {
    final api = await abrirSaldo(tester);

    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'QUEIJO');

    expect(find.text('Queijo muçarela'), findsOneWidget);
    expect(find.text('QUE-MUS-KG · 2 endereço(s)'), findsOneWidget);
    expect(find.text('48 KG'), findsOneWidget);
    expect(find.text('6 KG'), findsOneWidget);
    expect(find.text('42 KG'), findsOneWidget);
    expect(find.text('L26100 · 30 · val. 20/11/2026'), findsOneWidget);
    expect(find.text('F-01-1-1'), findsOneWidget);
    expect(find.text('F-02-1-1'), findsOneWidget);
    expect(find.text('24 KG'), findsOneWidget, reason: 'disponível no F-01-1-1: 30 menos 6 reservados');
    final consulta = api.requisicoes.where((r) => r.caminho == '/api/v1/saldos').single;
    expect(consulta.query['produtoId'], 'p-queijo');
  });

  testWidgets('por endereço: o que está nele', (tester) async {
    final api = await abrirSaldo(tester);
    await tester.tap(find.text('Por endereço'));
    await tester.pumpAndSettle();

    await lerCodigo(tester, 'Endereço', 'F-01-1-1');

    expect(find.text('Endereço F-01-1-1'), findsOneWidget);
    expect(find.text('Queijo muçarela'), findsOneWidget);
    expect(find.textContaining('Lote L26100'), findsOneWidget);
    final consulta = api.requisicoes.where((r) => r.caminho == '/api/v1/saldos').single;
    expect(consulta.query['enderecoId'], 'end-F-01-1-1');
  });

  testWidgets('endereço vazio e endereço bloqueado', (tester) async {
    await abrirSaldo(tester);
    await tester.tap(find.text('Por endereço'));
    await tester.pumpAndSettle();

    await lerCodigo(tester, 'Endereço', 'VAZIO');
    expect(find.text('Nenhum saldo encontrado.'), findsOneWidget);

    await lerCodigo(tester, 'Endereço', 'B-01-1-1');
    expect(find.text('Este endereço está bloqueado.'), findsOneWidget);
  });

  testWidgets('produto não encontrado', (tester) async {
    await abrirSaldo(tester);

    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'NADA');

    expect(find.text('Nenhum produto com o SKU ou GTIN NADA.'), findsOneWidget);
  });

  testWidgets('golden: saldo por produto', (tester) async {
    await abrirSaldo(tester);
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'QUEIJO');

    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../../goldens/saldo_produto.png'));
  });
}
