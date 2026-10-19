import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stowise_api/stowise_api.dart';

import '../config/ambiente.dart';

/// Tempo máximo de cada etapa da chamada. A rede do armazém pode ser lenta, mas o operador não pode esperar demais.
const _timeoutConexao = Duration(seconds: 10);
const _timeoutResposta = Duration(seconds: 20);

/// Dio do app: URL do ambiente e timeouts. Os interceptors (token e renovação) são acrescentados pela autenticação.
final dioProvider = Provider<Dio>((ref) {
  final ambiente = ref.watch(ambienteProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ambiente.apiUrl,
      connectTimeout: _timeoutConexao,
      receiveTimeout: _timeoutResposta,
      headers: {'Accept': 'application/json'},
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Cliente gerado do contrato. Sem os interceptors de autenticação do gerador: o app trata o token no próprio Dio.
final stowiseApiProvider = Provider<StowiseApi>(
  (ref) => StowiseApi(dio: ref.watch(dioProvider), interceptors: const []),
);
