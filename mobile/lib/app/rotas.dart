import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/estado_sessao_pages.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/sessao_controller.dart';
import '../features/inicio/presentation/inicio_page.dart';

abstract final class Rotas {
  static const inicio = '/';
  static const login = '/login';
  static const carregando = '/carregando';
  static const semConexao = '/sem-conexao';
}

/// Para onde a sessão manda: sem sessão, só o login; com sessão, nada de login ou de telas de abertura.
@visibleForTesting
String? destinoPelaSessao(EstadoSessao estado, String atual) {
  final destino = switch (estado) {
    Verificando() => Rotas.carregando,
    SemConexao() => Rotas.semConexao,
    Anonimo() => Rotas.login,
    Autenticado() => const [Rotas.login, Rotas.carregando, Rotas.semConexao].contains(atual) ? Rotas.inicio : null,
  };
  return destino == atual ? null : destino;
}

/// Rotas do app (go_router), protegidas pela sessão: o `redirect` roda de novo a cada mudança da sessão.
final rotasProvider = Provider<GoRouter>((ref) {
  final mudancas = ValueNotifier<EstadoSessao>(ref.read(sessaoProvider));
  ref.listen(sessaoProvider, (_, estado) => mudancas.value = estado);

  final rotas = GoRouter(
    initialLocation: Rotas.carregando,
    refreshListenable: mudancas,
    redirect: (context, state) => destinoPelaSessao(ref.read(sessaoProvider), state.matchedLocation),
    routes: [
      GoRoute(path: Rotas.inicio, builder: (context, state) => const InicioPage()),
      GoRoute(path: Rotas.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: Rotas.carregando, builder: (context, state) => const CarregandoPage()),
      GoRoute(path: Rotas.semConexao, builder: (context, state) => const SemConexaoPage()),
    ],
  );
  ref.onDispose(() {
    rotas.dispose();
    mudancas.dispose();
  });
  return rotas;
});
