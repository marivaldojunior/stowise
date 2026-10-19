import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Guarda o refresh token entre aberturas do app. O access token nunca é gravado: fica só em memória (ADR-0005).
abstract interface class Cofre {
  Future<String?> lerRefreshToken();
  Future<void> gravarRefreshToken(String token);
  Future<void> apagar();
}

/// Cofre do sistema: Keystore no Android (flutter_secure_storage).
class CofreSeguro implements Cofre {
  CofreSeguro([this._armazenamento = const FlutterSecureStorage()]);

  static const _chave = 'stowise.refresh_token';
  final FlutterSecureStorage _armazenamento;

  @override
  Future<String?> lerRefreshToken() => _armazenamento.read(key: _chave);

  @override
  Future<void> gravarRefreshToken(String token) => _armazenamento.write(key: _chave, value: token);

  @override
  Future<void> apagar() => _armazenamento.delete(key: _chave);
}

final cofreProvider = Provider<Cofre>((ref) => CofreSeguro());
