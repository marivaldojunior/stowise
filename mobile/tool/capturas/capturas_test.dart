// Capturas das telas do app para o README (docs/media/app-*.png), com as fontes reais (Roboto e Material Icons do
// SDK do Flutter) no lugar da fonte de teste. Fica fora de test/: não roda no CI.
//
// Uso (em mobile/): flutter test tool/capturas
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test/ajudantes.dart';
import '../../test/api_falsa.dart';
import '../../test/features/estoque/api_estoque.dart';
import '../../test/features/estoque/fluxo.dart';

final _destino = Directory('../docs/media');

Future<void> _carregarFonte(String familia, List<String> arquivos) async {
  final pasta = '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  final carregador = FontLoader(familia);
  for (final arquivo in arquivos) {
    final bytes = File('$pasta/$arquivo').readAsBytesSync();
    carregador.addFont(Future.value(ByteData.sublistView(bytes)));
  }

  await carregador.load();
}

Future<void> _capturar(WidgetTester tester, String nome) async {
  await tester.pumpAndSettle();
  final limite = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
  await tester.runAsync(() async {
    final imagem = await limite.toImage(pixelRatio: 2);
    final bytes = await imagem.toByteData(format: ui.ImageByteFormat.png);
    _destino.createSync(recursive: true);
    File('${_destino.path}/$nome.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

ApiFalsa _apiDeLogin() {
  final estoque = apiDeEstoque();
  return ApiFalsa((r) => r.caminho == '/api/v1/auth/refresh' ? problema(401, 'Sessão inválida') : estoque.responder(r));
}

/// Captura com as sombras reais: o ambiente de teste troca as sombras por um contorno preto. O valor volta ao padrão
/// no fim do próprio teste, porque o Flutter confere as variáveis de pintura antes do tearDown.
void _testeDeCaptura(String descricao, Future<void> Function(WidgetTester tester) corpo) {
  testWidgets(descricao, (tester) async {
    debugDisableShadows = false;
    try {
      await corpo(tester);
    } finally {
      debugDisableShadows = true;
    }
  });
}

void main() {
  setUpAll(() async {
    await _carregarFonte('Roboto', ['roboto-regular.ttf', 'roboto-medium.ttf', 'roboto-bold.ttf']);
    await _carregarFonte('MaterialIcons', ['materialicons-regular.otf']);
  });

  _testeDeCaptura('1. login', (tester) async {
    await montarApp(tester, api: _apiDeLogin(), cofre: CofreFalso());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), 'operador@demo.stowise.dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), 'senha-demo');
    FocusManager.instance.primaryFocus?.unfocus();
    await _capturar(tester, 'app-1-login');
  });

  _testeDeCaptura('2. início', (tester) async {
    await montarApp(tester, api: apiDeEstoque());
    await _capturar(tester, 'app-2-inicio');
  });

  _testeDeCaptura('3 e 4. entrada de uma caixa', (tester) async {
    await montarApp(tester, api: apiDeEstoque());
    await tester.tap(find.text('Movimentar estoque'));
    await tester.pumpAndSettle();
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', '17891000000014');
    await lerCodigo(tester, 'Endereço', 'A-01-1-1');
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '2');
    FocusManager.instance.primaryFocus?.unfocus();
    await _capturar(tester, 'app-3-movimentacao');

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Registrar entrada'));
    await tester.tap(find.widgetWithText(FilledButton, 'Registrar entrada'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 2000));
    await _capturar(tester, 'app-4-registrada');
  });

  _testeDeCaptura('5. saldo por produto', (tester) async {
    await montarApp(tester, api: apiDeEstoque());
    await tester.tap(find.text('Consultar saldo'));
    await tester.pumpAndSettle();
    await lerCodigo(tester, 'Produto (SKU ou código de barras)', 'QUEIJO');
    FocusManager.instance.primaryFocus?.unfocus();
    await _capturar(tester, 'app-5-saldo');
  });
}
