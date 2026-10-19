import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/features/leitura/presentation/campo_codigo.dart';
import 'package:stowise_mobile/features/leitura/presentation/leitura_page.dart';

Future<List<String>> montarCampo(WidgetTester tester, {String? lido}) async {
  final codigos = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [leitorProvider.overrideWithValue((context, titulo) async => lido)],
      child: MaterialApp(
        home: Scaffold(
          body: CampoCodigo(rotulo: 'Produto', onCodigo: codigos.add),
        ),
      ),
    ),
  );
  return codigos;
}

void main() {
  testWidgets('o botão da câmera usa o código lido', (tester) async {
    final codigos = await montarCampo(tester, lido: ' 7891000100103 ');

    await tester.tap(find.byTooltip('Ler com a câmera: Produto'));
    await tester.pump();

    expect(codigos, ['7891000100103']);
    expect(find.text('7891000100103'), findsOneWidget);
  });

  testWidgets('leitura cancelada não muda nada', (tester) async {
    final codigos = await montarCampo(tester);

    await tester.tap(find.byTooltip('Ler com a câmera: Produto'));
    await tester.pump();

    expect(codigos, isEmpty);
  });

  testWidgets('o leitor físico do coletor digita e envia Enter', (tester) async {
    final codigos = await montarCampo(tester);

    await tester.enterText(find.byType(TextField), 'A-01-1-1');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    expect(codigos, ['A-01-1-1']);
  });

  testWidgets('Enter com o campo vazio não envia', (tester) async {
    final codigos = await montarCampo(tester);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    expect(codigos, isEmpty);
  });

  test('lê os formatos de produto, de etiqueta e 2D', () {
    expect(formatosLidos.map((f) => f.name), containsAll(['ean13', 'code128', 'qrCode', 'dataMatrix']));
  });
}
