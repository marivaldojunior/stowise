import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Digita o código e envia Enter, como faz o leitor físico do coletor.
Future<void> lerCodigo(WidgetTester tester, String rotulo, String codigo) async {
  await tester.enterText(find.widgetWithText(TextField, rotulo), codigo);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}
