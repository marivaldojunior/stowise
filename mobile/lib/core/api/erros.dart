import 'package:dio/dio.dart';

const mensagemSemConexao = 'A API não respondeu. Confira a rede e tente de novo.';

/// A chamada não chegou a uma resposta da API (rede, timeout) ou a API está fora do ar (5xx).
bool ehFalhaDeConexao(DioException erro) {
  final status = erro.response?.statusCode;
  return status == null || status >= 500;
}

/// Mensagem para o usuário a partir do ProblemDetails da API: detail, depois title.
String mensagemDoErro(DioException erro, {String padrao = 'Erro inesperado. Tente de novo.'}) {
  if (ehFalhaDeConexao(erro)) {
    return mensagemSemConexao;
  }

  final dados = erro.response?.data;
  if (dados is Map) {
    final detalhe = dados['detail'];
    final titulo = dados['title'];
    if (detalhe is String && detalhe.isNotEmpty) {
      return detalhe;
    }

    if (titulo is String && titulo.isNotEmpty) {
      return titulo;
    }
  }

  return padrao;
}
