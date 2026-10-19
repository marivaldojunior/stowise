import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/app/app.dart';
import 'package:stowise_mobile/core/config/ambiente.dart';

const ambienteDeTeste = Ambiente(nome: 'dev', apiUrl: 'http://api.teste');

/// Monta o app inteiro com o ambiente de teste e as substituições de providers do teste.
Future<ProviderContainer> montarApp(
  WidgetTester tester, {
  List<dynamic> overrides = const [],
  ThemeMode tema = ThemeMode.light,
}) async {
  // Tela de celular (400 x 800) com densidade 1: goldens pequenos e iguais em qualquer máquina.
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(400, 800);
  addTearDown(tester.view.reset);
  tester.platformDispatcher.platformBrightnessTestValue = tema == ThemeMode.dark ? Brightness.dark : Brightness.light;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  final container = ProviderContainer.test(
    overrides: [ambienteProvider.overrideWithValue(ambienteDeTeste), ...overrides.cast()],
  );
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const StowiseApp()));
  await tester.pumpAndSettle();
  return container;
}
