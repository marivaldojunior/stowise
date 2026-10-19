import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_mobile/app/tema.dart';
import 'package:stowise_mobile/core/config/ambiente.dart';

import 'ajudantes.dart';

void main() {
  group('ambiente', () {
    test('dev aponta para a API local do emulador', () {
      final dev = Ambiente.dev();

      expect(dev.nome, 'dev');
      expect(dev.apiUrl, 'http://10.0.2.2:5073');
      expect(dev.dev, isTrue);
    });

    test('prod sem URL no build fica vazio', () {
      expect(Ambiente.prod().apiUrl, isEmpty);
      expect(Ambiente.prod().dev, isFalse);
    });
  });

  group('tema', () {
    test('usa a cor da marca e cores semânticas diferentes no claro e no escuro', () {
      expect(temaClaro.extension<CoresStowise>(), CoresStowise.claro);
      expect(temaEscuro.extension<CoresStowise>(), CoresStowise.escuro);
      expect(temaClaro.colorScheme.brightness, Brightness.light);
      expect(temaEscuro.colorScheme.brightness, Brightness.dark);
    });
  });

  group('início', () {
    testWidgets('mostra as ações do operador e o ambiente de desenvolvimento', (tester) async {
      await montarApp(tester);

      expect(find.text('O que você quer fazer?'), findsOneWidget);
      expect(find.text('Movimentar estoque'), findsOneWidget);
      expect(find.text('Consultar saldo'), findsOneWidget);
      expect(find.text('Ambiente dev · http://api.teste'), findsOneWidget);
    });

    testWidgets('golden: tema claro', (tester) async {
      await montarApp(tester);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/inicio_claro.png'));
    });

    testWidgets('golden: tema escuro', (tester) async {
      await montarApp(tester, tema: ThemeMode.dark);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/inicio_escuro.png'));
    });
  });
}
