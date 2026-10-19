import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stowise_api/stowise_api.dart';
import 'package:stowise_mobile/core/api/cliente_api.dart';
import 'package:stowise_mobile/core/config/ambiente.dart';

import '../api_falsa.dart';

void main() {
  late ApiFalsa api;
  late ProviderContainer container;

  setUp(() {
    api = ApiFalsa((_) => json(sessaoJson()));
    container = ProviderContainer.test(
      overrides: [ambienteProvider.overrideWithValue(const Ambiente(nome: 'dev', apiUrl: 'http://api.teste'))],
    );
    container.read(dioProvider).httpClientAdapter = api;
  });

  test('o Dio usa a URL e os timeouts do ambiente', () {
    final dio = container.read(dioProvider);

    expect(dio.options.baseUrl, 'http://api.teste');
    expect(dio.options.connectTimeout, const Duration(seconds: 10));
    expect(dio.options.receiveTimeout, const Duration(seconds: 20));
  });

  test('o cliente gerado serializa o pedido e lê a resposta do contrato', () async {
    final autenticacao = container.read(stowiseApiProvider).getAutenticaoApi();

    final resposta = await autenticacao.login(
      loginRequest: LoginRequest(
        (b) => b
          ..email = 'carla@stowise.dev'
          ..senha = 'segredo'
          ..useCookie = false,
      ),
    );

    expect(api.requisicoes.single.metodo, 'POST');
    expect(api.requisicoes.single.caminho, '/api/v1/auth/login');
    expect(api.requisicoes.single.corpo, {'email': 'carla@stowise.dev', 'senha': 'segredo', 'useCookie': false});
    expect(resposta.data!.accessToken, 'token-1');
    expect(resposta.data!.refreshToken, 'refresh-1');
    expect(resposta.data!.usuario.perfis.toList(), ['Operador']);
  });
}
