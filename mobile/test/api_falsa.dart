import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Requisição recebida pela API falsa, para o teste conferir método, caminho, cabeçalhos e corpo.
class RequisicaoFalsa {
  RequisicaoFalsa(this.metodo, this.caminho, this.cabecalhos, this.corpo);

  final String metodo;
  final String caminho;
  final Map<String, dynamic> cabecalhos;
  final Object? corpo;
}

typedef Responder = ResponseBody Function(RequisicaoFalsa requisicao);

/// Adaptador HTTP do Dio que responde em memória: os testes nunca chamam a rede.
class ApiFalsa implements HttpClientAdapter {
  ApiFalsa(this.responder);

  Responder responder;
  final requisicoes = <RequisicaoFalsa>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final requisicao = RequisicaoFalsa(options.method, options.path, Map.of(options.headers), _corpo(options.data));
    requisicoes.add(requisicao);
    return responder(requisicao);
  }

  Object? _corpo(Object? dados) => dados is String ? jsonDecode(dados) : dados;

  @override
  void close({bool force = false}) {}
}

ResponseBody json(Object corpo, {int status = 200}) => ResponseBody.fromString(
  jsonEncode(corpo),
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

ResponseBody problema(int status, String titulo, {String? detalhe}) => ResponseBody.fromString(
  jsonEncode({'status': status, 'title': titulo, 'detail': ?detalhe}),
  status,
  headers: {
    Headers.contentTypeHeader: ['application/problem+json'],
  },
);

ResponseBody semConteudo() => ResponseBody.fromString('', 204);

/// Corpo de login ou refresh da API, como no contrato (AuthResponse).
Map<String, Object?> sessaoJson({
  List<String> perfis = const ['Operador'],
  String accessToken = 'token-1',
  String refreshToken = 'refresh-1',
}) {
  final agora = DateTime.now().toUtc();
  return {
    'accessToken': accessToken,
    'accessTokenExpiresAt': agora.add(const Duration(minutes: 15)).toIso8601String(),
    'refreshToken': refreshToken,
    'refreshTokenExpiresAt': agora.add(const Duration(days: 7)).toIso8601String(),
    'usuario': {
      'id': '0192f5e0-0000-7000-8000-000000000003',
      'nome': 'Carla Dias',
      'email': 'carla@stowise.dev',
      'perfis': perfis,
    },
  };
}
