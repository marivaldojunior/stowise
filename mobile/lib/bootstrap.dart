import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/api/credenciais.dart';
import 'core/config/ambiente.dart';
import 'features/auth/presentation/sessao_controller.dart';

/// Ligações entre camadas (composição): a rede usa a sessão como credenciais.
final ligacoes = [credenciaisProvider.overrideWith((ref) => ref.watch(sessaoProvider.notifier))];

/// Ponto de partida comum aos flavors: injeta o ambiente e abre o app.
void bootstrap(Ambiente ambiente) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(overrides: [ambienteProvider.overrideWithValue(ambiente), ...ligacoes], child: const StowiseApp()),
  );
}
