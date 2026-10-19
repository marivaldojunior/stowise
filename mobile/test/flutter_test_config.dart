import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Os goldens têm o Linux como referência (o mesmo do CI): fontes e ícones são desenhados um pouco diferente em cada
/// sistema. Fora do Linux, a comparação é pulada; os demais testes rodam normalmente. Para regravar as imagens, use o
/// job "goldens" do workflow mobile (Actions > mobile > Run workflow > atualizar_goldens) ou rode no Linux:
/// `flutter test --update-goldens`.
const _tolerancia = 0.005;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (goldenFileComparator is LocalFileComparator) {
    final atual = goldenFileComparator as LocalFileComparator;
    final base = Uri.parse('${atual.basedir}arquivo_de_teste.dart');
    goldenFileComparator = Platform.isLinux ? _ComparadorComTolerancia(base) : _SemComparacao(base);
  }

  await testMain();
}

class _ComparadorComTolerancia extends LocalFileComparator {
  _ComparadorComTolerancia(super.testFile);

  @override
  Future<bool> compare(Uint8List imagem, Uri golden) async {
    final resultado = await GoldenFileComparator.compareLists(imagem, await getGoldenBytes(golden));
    if (resultado.passed || resultado.diffPercent <= _tolerancia) {
      resultado.dispose();
      return true;
    }

    final erro = await generateFailureOutput(resultado, golden, basedir);
    resultado.dispose();
    throw FlutterError(erro);
  }
}

/// Fora do Linux: gera a imagem (o widget é desenhado, então erros de layout ainda aparecem), mas não compara.
class _SemComparacao extends LocalFileComparator {
  _SemComparacao(super.testFile);

  static bool _avisado = false;

  @override
  Future<bool> compare(Uint8List imagem, Uri golden) async {
    if (!_avisado) {
      _avisado = true;
      debugPrint('Goldens comparados só no Linux (referência do CI); aqui a comparação foi pulada.');
    }

    return true;
  }

  @override
  Future<void> update(Uri golden, Uint8List imagem) async {
    debugPrint('Goldens só são regravados no Linux: ${golden.path} não foi alterado.');
  }
}
