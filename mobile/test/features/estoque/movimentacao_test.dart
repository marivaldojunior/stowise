import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ajudantes.dart';
import '../../api_falsa.dart';
import 'api_estoque.dart';

Future<({ApiFalsa api, CofreFalso cofre})> abrirMovimentacao(WidgetTester tester, ApiFalsa api) async {
  final ambiente = await montarApp(tester, api: api, tela: const Size(400, 1200));
  await tester.tap(find.text('Movimentar estoque'));
  await tester.pumpAndSettle();
  return ambiente;
}

/// Digita o código e envia Enter, como faz o leitor físico do coletor.
Future<void> lerCodigo(WidgetTester tester, String rotulo, String codigo) async {
  await tester.enterText(find.widgetWithText(TextField, rotulo), codigo);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

Future<void> registrar(WidgetTester tester, String acao) async {
  await tester.ensureVisible(find.widgetWithText(FilledButton, acao));
  await tester.tap(find.widgetWithText(FilledButton, acao));
  await tester.pumpAndSettle();
}

List<Map<String, dynamic>> envios(ApiFalsa api) => [
  for (final r in api.requisicoes)
    if (r.caminho.startsWith('/api/v1/movimentacoes/')) r.corpo! as Map<String, dynamic>,
];

void main() {
  testWidgets('entrada lendo o GTIN da caixa: envia em caixas e mostra a conversão', (tester) async {
    final api = apiDeEstoque();
    await abrirMovimentacao(tester, api);

    await lerCodigo(tester, 'Produto (SKU ou código de barras)', '17891000000014');
    expect(find.text('Arroz tipo 1 5kg'), findsOneWidget);
    expect(find.text('Caixa (12 UN)'), findsWidgets);
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '2');
    await registrar(tester, 'Registrar entrada');

    expect(find.text('Entrada registrada: 2 Caixa (24 UN) de ARZ-T1-5 em A-01-1-1.'), findsOneWidget);
    final corpo = envios(api).single;
    expect(api.requisicoes.last.caminho, '/api/v1/movimentacoes/entradas');
    expect(corpo, containsPair('produtoId', 'p-arroz'));
    expect(corpo, containsPair('embalagemId', 'emb-cx'));
    expect(corpo, containsPair('enderecoId', 'end-A-01-1-1'));
    expect(corpo, containsPair('quantidade', 2.0));
    expect(corpo['idempotencyKey'], isA<String>());
    expect(corpo['dispositivoId'], isA<String>());
    // O formulário fica pronto para a próxima entrada.
    expect(find.text('Arroz tipo 1 5kg'), findsNothing);
  });

  testWidgets('produto não encontrado aparece no campo', (tester) async {
    await abrirMovimentacao(tester, apiDeEstoque());

    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'NAO-EXISTE');

    expect(find.text('Nenhum produto com o SKU ou GTIN NAO-EXISTE.'), findsOneWidget);
  });

  testWidgets('sem rede, tentar de novo reenvia com a mesma chave; mudar a operação gera outra', (tester) async {
    var online = false;
    final api = apiDeEstoque(
      movimentar: (r) => online ? json(movimentacao('Saida', 1), status: 201) : throw semRede(r),
    );
    await abrirMovimentacao(tester, api);
    await tester.tap(find.text('Saída'));
    await tester.pumpAndSettle();
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'ARZ-T1-5');
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');

    await registrar(tester, 'Registrar saída');
    expect(find.textContaining('Ao tentar de novo, a operação não é gravada duas vezes.'), findsOneWidget);
    await registrar(tester, 'Registrar saída');
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '3');
    await registrar(tester, 'Registrar saída');

    online = true;
    await registrar(tester, 'Registrar saída');

    final chaves = envios(api).map((c) => c['idempotencyKey']).toList();
    expect(chaves, hasLength(4));
    expect(chaves[1], chaves[0], reason: 'nova tentativa da mesma operação');
    expect(chaves[2], isNot(chaves[1]), reason: 'a quantidade mudou: outra operação');
    expect(chaves[3], chaves[2]);
    expect(find.textContaining('Saída registrada'), findsOneWidget);
  });

  testWidgets('regra da API (422) aparece como erro', (tester) async {
    final api = apiDeEstoque(movimentar: (_) => problema(422, 'Saldo insuficiente no endereço A-01-1-1.'));
    await abrirMovimentacao(tester, api);
    await tester.tap(find.text('Saída'));
    await tester.pumpAndSettle();
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'ARZ-T1-5');
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');

    await registrar(tester, 'Registrar saída');

    expect(find.text('Saldo insuficiente no endereço A-01-1-1.'), findsOneWidget);
  });

  testWidgets('produto com lote e validade: exige os dois e envia o lote na entrada', (tester) async {
    final api = apiDeEstoque();
    await abrirMovimentacao(tester, api);
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'QUEIJO');
    await lerCodigo(tester, 'Endereço', 'F-01-1-1');

    await registrar(tester, 'Registrar entrada');
    expect(find.text('Este produto controla lote: informe o lote.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Lote'), 'L26100');
    await registrar(tester, 'Registrar entrada');
    expect(find.text('Este produto controla validade: informe a validade do lote.'), findsOneWidget);

    await tester.ensureVisible(find.text('Validade do lote'));
    await tester.tap(find.text('Validade do lote'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await registrar(tester, 'Registrar entrada');

    final lote = envios(api).single['lote'] as Map<String, dynamic>;
    expect(lote['numero'], 'L26100');
    expect(lote['validade'], isA<String>());
  });

  testWidgets('transferência lê origem e destino', (tester) async {
    final api = apiDeEstoque();
    await abrirMovimentacao(tester, api);
    await tester.tap(find.text('Transferência'));
    await tester.pumpAndSettle();

    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'ARZ-T1-5');
    await lerCodigo(tester, 'Endereço de origem', 'A-01-1-1');
    await lerCodigo(tester, 'Endereço de destino', 'A-02-1-1');
    await registrar(tester, 'Registrar transferência');

    expect(api.requisicoes.last.caminho, '/api/v1/movimentacoes/transferencias');
    expect(envios(api).single, containsPair('enderecoOrigemId', 'end-A-01-1-1'));
    expect(envios(api).single, containsPair('enderecoDestinoId', 'end-A-02-1-1'));
  });

  testWidgets('endereço bloqueado e não encontrado ficam visíveis', (tester) async {
    await abrirMovimentacao(tester, apiDeEstoque());

    await lerCodigo(tester, 'Endereço', 'B-01-1-1');
    expect(find.text('bloqueado'), findsOneWidget);
    await lerCodigo(tester, 'Endereço', 'X-99');
    expect(find.text('Endereço X-99 não encontrado.'), findsOneWidget);
  });

  testWidgets('com mais de um armazém, pede para escolher antes de ler o endereço', (tester) async {
    final api = apiDeEstoque(
      armazens: const [
        {'id': 'arm-1', 'codigo': 'CD1', 'nome': 'Centro', 'zonas': 1, 'enderecos': 10},
        {'id': 'arm-2', 'codigo': 'CD2', 'nome': 'Norte', 'zonas': 1, 'enderecos': 10},
      ],
    );
    await abrirMovimentacao(tester, api);

    await lerCodigo(tester, 'Endereço', 'A-01-1-1');
    expect(find.text('Escolha o armazém antes de ler o endereço.'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CD1 · Centro').last);
    await tester.pumpAndSettle();
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');

    expect(find.text('A-01-1-1'), findsWidgets);
    expect(find.text('Escolha o armazém antes de ler o endereço.'), findsNothing);
  });

  testWidgets('golden: entrada com produto lido', (tester) async {
    await abrirMovimentacao(tester, apiDeEstoque());
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', '17891000000014');
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');

    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../../goldens/movimentacao_entrada.png'));
  });
}
