import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Diferença aceita nos testes golden (0,5% dos pixels): o CI roda em Linux e o desenvolvimento em Windows,
/// e o anti-aliasing muda um pouco entre os dois.
const _tolerancia = 0.005;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (goldenFileComparator is LocalFileComparator) {
    final atual = goldenFileComparator as LocalFileComparator;
    goldenFileComparator = _ComparadorComTolerancia(Uri.parse('${atual.basedir}arquivo_de_teste.dart'));
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
