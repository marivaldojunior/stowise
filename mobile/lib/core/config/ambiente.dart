import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ambiente do app, definido pelo flavor (dev ou prod) no ponto de entrada.
///
/// A URL da API pode ser trocada sem mudar o código com
/// `--dart-define=STOWISE_API_URL=https://...`.
class Ambiente {
  const Ambiente({required this.nome, required this.apiUrl});

  /// Desenvolvimento: API local. No emulador Android, 10.0.2.2 é o computador que roda a API.
  factory Ambiente.dev() => const Ambiente(
    nome: 'dev',
    apiUrl: String.fromEnvironment('STOWISE_API_URL', defaultValue: 'http://10.0.2.2:5073'),
  );

  /// Produção (APK de demonstração): a URL vem do build.
  factory Ambiente.prod() => const Ambiente(nome: 'prod', apiUrl: String.fromEnvironment('STOWISE_API_URL'));

  final String nome;
  final String apiUrl;

  bool get dev => nome == 'dev';
}

/// O ponto de entrada (main_dev.dart, main_prod.dart) sobrescreve este provider.
final ambienteProvider = Provider<Ambiente>((ref) => throw UnimplementedError('Defina o ambiente no ProviderScope.'));
