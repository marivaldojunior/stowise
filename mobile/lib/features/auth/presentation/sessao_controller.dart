import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/credenciais.dart';
import '../data/auth_repository.dart';
import '../domain/sessao.dart';

/// Situação da sessão no app.
sealed class EstadoSessao {
  const EstadoSessao();
}

/// O app acabou de abrir e tenta retomar a sessão guardada.
final class Verificando extends EstadoSessao {
  const Verificando();
}

final class Autenticado extends EstadoSessao {
  const Autenticado(this.sessao);

  final Sessao sessao;
}

/// Sem sessão. [aviso] explica por que (ex.: sessão expirada), quando o usuário não pediu para sair.
final class Anonimo extends EstadoSessao {
  const Anonimo({this.aviso});

  final String? aviso;
}

/// Há sessão guardada, mas a API não respondeu ao abrir: o app oferece tentar de novo.
final class SemConexao extends EstadoSessao {
  const SemConexao();
}

/// Renova o token de acesso este tempo antes de ele vencer.
const antecedenciaRenovacao = Duration(minutes: 1);

/// Espera mínima, para um relógio adiantado no aparelho não gerar renovações em sequência.
const esperaMinimaRenovacao = Duration(seconds: 5);

/// Tempo até a próxima renovação automática.
Duration esperaAteRenovar(Sessao sessao, DateTime agora) {
  final espera = sessao.expiraEm.difference(agora) - antecedenciaRenovacao;
  return espera < esperaMinimaRenovacao ? esperaMinimaRenovacao : espera;
}

/// Sessão do app: retoma pelo cofre ao abrir, renova antes de vencer e depois de um 401 (em voo único) e encerra no
/// "Sair". O token de acesso fica só neste estado, em memória.
class SessaoController extends Notifier<EstadoSessao> implements Credenciais {
  Future<bool>? _renovacao;
  Timer? _timer;

  AuthRepository get _repositorio => ref.read(authRepositoryProvider);

  @override
  EstadoSessao build() {
    ref.onDispose(() => _timer?.cancel());
    Future.microtask(_retomar);
    return const Verificando();
  }

  Sessao? get sessao => switch (state) {
    Autenticado(:final sessao) => sessao,
    _ => null,
  };

  @override
  String? get tokenAcesso => sessao?.accessToken;

  Future<void> _retomar() async {
    try {
      _abrir(await _repositorio.renovar());
    } on FalhaAuth catch (falha) {
      state = falha.semConexao ? const SemConexao() : const Anonimo();
    }
  }

  /// Nova tentativa depois de [SemConexao].
  Future<void> tentarDeNovo() async {
    state = const Verificando();
    await _retomar();
  }

  /// Entra com e-mail e senha. Lança [FalhaAuth] com a mensagem para a tela.
  Future<void> entrar(String email, String senha) async {
    _abrir(await _repositorio.entrar(email, senha));
  }

  Future<void> sair() async {
    _timer?.cancel();
    await _repositorio.sair();
    state = const Anonimo();
  }

  /// Pede um token novo. Pedidos simultâneos (vários 401 ao mesmo tempo) dividem a mesma chamada, porque a API gira o
  /// refresh token e um segundo uso derrubaria a sessão (detecção de reuso). Sessão recusada é encerrada; falha de
  /// rede mantém a sessão para a próxima tentativa.
  @override
  Future<bool> renovar() {
    return _renovacao ??= _renovarUmaVez().whenComplete(() => _renovacao = null);
  }

  Future<bool> _renovarUmaVez() async {
    try {
      _abrir(await _repositorio.renovar());
      return true;
    } on FalhaAuth catch (falha) {
      if (falha.recusada) {
        _timer?.cancel();
        state = const Anonimo(aviso: 'Sua sessão expirou. Entre novamente.');
      }

      return false;
    }
  }

  void _abrir(Sessao sessao) {
    state = Autenticado(sessao);
    _timer?.cancel();
    _timer = Timer(esperaAteRenovar(sessao, DateTime.now()), () => unawaited(renovar()));
  }
}

final sessaoProvider = NotifierProvider<SessaoController, EstadoSessao>(SessaoController.new);

/// Usuário da sessão aberta, ou null.
final usuarioProvider = Provider<Usuario?>(
  (ref) => switch (ref.watch(sessaoProvider)) {
    Autenticado(:final sessao) => sessao.usuario,
    _ => null,
  },
);
