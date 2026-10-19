import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/inicio/presentation/inicio_page.dart';

/// Rotas do app (go_router). A proteção por sessão entra com a tarefa de autenticação.
final rotasProvider = Provider<GoRouter>((ref) {
  final rotas = GoRouter(
    routes: [GoRoute(path: '/', builder: (context, state) => const InicioPage())],
  );
  ref.onDispose(rotas.dispose);
  return rotas;
});
