/// Perfis de acesso, com os mesmos nomes da API (ADR-0005).
abstract final class Perfis {
  static const admin = 'Admin';
  static const gestor = 'Gestor';
  static const operador = 'Operador';

  /// Política "Gestao" da API: ajustes de estoque e cadastros.
  static const gestao = [admin, gestor];
}

class Usuario {
  const Usuario({required this.id, required this.nome, required this.email, required this.perfis});

  final String id;
  final String nome;
  final String email;
  final List<String> perfis;

  bool temPerfil(Iterable<String> aceitos) => aceitos.any(perfis.contains);

  String get primeiroNome => nome.trim().split(RegExp(r'\s+')).first;
}

/// Sessão aberta: o token de acesso (só em memória) e quem entrou.
class Sessao {
  const Sessao({required this.accessToken, required this.expiraEm, required this.usuario});

  final String accessToken;
  final DateTime expiraEm;
  final Usuario usuario;
}

/// Falha de autenticação para a tela: a mensagem já vem pronta para o usuário.
class FalhaAuth implements Exception {
  const FalhaAuth(this.mensagem, {this.semConexao = false, this.recusada = false});

  final String mensagem;

  /// A API não respondeu (rede, timeout, 5xx): a sessão guardada continua valendo.
  final bool semConexao;

  /// A API recusou (4xx): credenciais erradas ou sessão inválida.
  final bool recusada;

  @override
  String toString() => mensagem;
}
