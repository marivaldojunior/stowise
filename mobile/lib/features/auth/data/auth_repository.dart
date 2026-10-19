import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stowise_api/stowise_api.dart';

import '../../../core/api/cliente_api.dart';
import '../../../core/api/erros.dart';
import '../../../core/armazenamento/cofre.dart';
import '../domain/sessao.dart';

/// Login, renovação e saída pela API (ADR-0005). O app pede o refresh token no corpo (`useCookie: false`) e o guarda
/// no cofre. A API gira o refresh token a cada uso: toda renovação grava o novo no lugar do antigo.
class AuthRepository {
  AuthRepository(this._api, this._cofre);

  final AutenticaoApi _api;
  final Cofre _cofre;

  Future<Sessao> entrar(String email, String senha) async {
    try {
      final resposta = await _api.login(
        loginRequest: LoginRequest(
          (b) => b
            ..email = email.trim()
            ..senha = senha
            ..useCookie = false,
        ),
      );
      return _abrir(resposta.data!);
    } on DioException catch (erro) {
      throw _falha(erro, padrao: 'Não foi possível entrar.');
    }
  }

  /// Renova a sessão com o refresh token guardado. Sem token guardado, a sessão é recusada.
  Future<Sessao> renovar() async {
    final refreshToken = await _cofre.lerRefreshToken();
    if (refreshToken == null) {
      throw const FalhaAuth('Entre com o seu e-mail e a sua senha.', recusada: true);
    }

    try {
      final resposta = await _api.renovarSessao(
        refreshRequest: RefreshRequest(
          (b) => b
            ..refreshToken = refreshToken
            ..useCookie = false,
        ),
      );
      return _abrir(resposta.data!);
    } on DioException catch (erro) {
      final falha = _falha(erro, padrao: 'Sua sessão terminou. Entre novamente.');
      if (falha.recusada) {
        await _cofre.apagar();
      }

      throw falha;
    }
  }

  /// Encerra a sessão na API (revoga o refresh token) e no aparelho. Sem rede, a sessão local termina mesmo assim.
  Future<void> sair() async {
    final refreshToken = await _cofre.lerRefreshToken();
    await _cofre.apagar();
    if (refreshToken == null) {
      return;
    }

    try {
      await _api.logout(
        refreshRequest: RefreshRequest(
          (b) => b
            ..refreshToken = refreshToken
            ..useCookie = false,
        ),
      );
    } on DioException {
      // O refresh token expira sozinho; o aparelho já não o tem.
    }
  }

  Future<Sessao> _abrir(AuthResponse resposta) async {
    final refreshToken = resposta.refreshToken;
    if (refreshToken != null) {
      await _cofre.gravarRefreshToken(refreshToken);
    }

    final usuario = resposta.usuario;
    return Sessao(
      accessToken: resposta.accessToken,
      expiraEm: resposta.accessTokenExpiresAt,
      usuario: Usuario(id: usuario.id, nome: usuario.nome, email: usuario.email, perfis: usuario.perfis.toList()),
    );
  }

  FalhaAuth _falha(DioException erro, {required String padrao}) {
    if (ehFalhaDeConexao(erro)) {
      return const FalhaAuth(mensagemSemConexao, semConexao: true);
    }

    return FalhaAuth(mensagemDoErro(erro, padrao: padrao), recusada: true);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(stowiseApiProvider).getAutenticaoApi(), ref.watch(cofreProvider)),
);
