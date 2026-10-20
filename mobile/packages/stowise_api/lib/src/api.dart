//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:stowise_api/src/serializers.dart';
import 'package:stowise_api/src/auth/api_key_auth.dart';
import 'package:stowise_api/src/auth/basic_auth.dart';
import 'package:stowise_api/src/auth/bearer_auth.dart';
import 'package:stowise_api/src/auth/oauth.dart';
import 'package:stowise_api/src/api/autenticao_api.dart';
import 'package:stowise_api/src/api/catlogo_api.dart';
import 'package:stowise_api/src/api/estoque_api.dart';
import 'package:stowise_api/src/api/estrutura_fsica_api.dart';
import 'package:stowise_api/src/api/ia_api.dart';
import 'package:stowise_api/src/api/importao_api.dart';
import 'package:stowise_api/src/api/rfid_api.dart';
import 'package:stowise_api/src/api/usurios_api.dart';

class StowiseApi {
  static const String basePath = r'http://localhost';

  final Dio dio;
  final Serializers serializers;

  StowiseApi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] =
          token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] =
          BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor)
          .apiKeys[name] = apiKey;
    }
  }

  /// Get AutenticaoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AutenticaoApi getAutenticaoApi() {
    return AutenticaoApi(dio, serializers);
  }

  /// Get CatlogoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CatlogoApi getCatlogoApi() {
    return CatlogoApi(dio, serializers);
  }

  /// Get EstoqueApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EstoqueApi getEstoqueApi() {
    return EstoqueApi(dio, serializers);
  }

  /// Get EstruturaFsicaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EstruturaFsicaApi getEstruturaFsicaApi() {
    return EstruturaFsicaApi(dio, serializers);
  }

  /// Get IAApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  IAApi getIAApi() {
    return IAApi(dio, serializers);
  }

  /// Get ImportaoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ImportaoApi getImportaoApi() {
    return ImportaoApi(dio, serializers);
  }

  /// Get RFIDApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  RFIDApi getRFIDApi() {
    return RFIDApi(dio, serializers);
  }

  /// Get UsuriosApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UsuriosApi getUsuriosApi() {
    return UsuriosApi(dio, serializers);
  }
}
