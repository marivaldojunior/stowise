import 'package:dio/dio.dart';

/// Rotas de autenticação: não levam o token nem disparam a renovação (evita laço de 401).
const _rotasDeAutenticacao = '/api/v1/auth/';

/// Marca de uma requisição que já foi repetida depois da renovação: um segundo 401 não renova de novo.
const _jaRepetida = 'stowise.repetida';

/// Põe o token de acesso em cada chamada e, depois de um 401, renova a sessão e repete a chamada uma vez.
class AutenticacaoInterceptor extends Interceptor {
  AutenticacaoInterceptor({required this.token, required this.renovar, required this.repetir});

  /// Token atual (em memória), ou null sem sessão.
  final String? Function() token;

  /// Renova a sessão (em voo único). Verdadeiro se há um token novo.
  final Future<bool> Function() renovar;

  /// Executa de novo a requisição (o próprio Dio, para passar pelos interceptors outra vez).
  final Future<Response<dynamic>> Function(RequestOptions opcoes) repetir;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final atual = token();
    if (atual != null && !options.path.startsWith(_rotasDeAutenticacao)) {
      options.headers['Authorization'] = 'Bearer $atual';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final opcoes = err.requestOptions;
    final podeRenovar =
        err.response?.statusCode == 401 &&
        !opcoes.path.startsWith(_rotasDeAutenticacao) &&
        opcoes.extra[_jaRepetida] != true;
    if (!podeRenovar || !await renovar()) {
      handler.next(err);
      return;
    }

    try {
      opcoes.extra[_jaRepetida] = true;
      handler.resolve(await repetir(opcoes));
    } on DioException catch (erro) {
      handler.next(erro);
    }
  }
}
