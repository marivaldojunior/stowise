import 'package:flutter_riverpod/flutter_riverpod.dart';

/// O que a camada de rede precisa da sessão: o token atual e um jeito de renová-lo.
abstract interface class Credenciais {
  /// Token de acesso atual (em memória), ou null sem sessão.
  String? get tokenAcesso;

  /// Renova a sessão. Verdadeiro se há um token novo.
  Future<bool> renovar();
}

class _SemCredenciais implements Credenciais {
  const _SemCredenciais();

  @override
  String? get tokenAcesso => null;

  @override
  Future<bool> renovar() async => false;
}

/// O ponto de entrada liga este provider à sessão (SessaoController). Sem a ligação, as chamadas vão sem token.
final credenciaisProvider = Provider<Credenciais>((ref) => const _SemCredenciais());
