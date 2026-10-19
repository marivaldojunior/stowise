import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/ambiente.dart';

/// Ponto de partida comum aos flavors: injeta o ambiente e abre o app.
void bootstrap(Ambiente ambiente) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(overrides: [ambienteProvider.overrideWithValue(ambiente)], child: const StowiseApp()));
}
