import 'package:flutter/material.dart';

/// Cor da marca, a mesma do painel web (primary, verde-azulado).
const corMarca = Color(0xFF00777A);

/// Cores com sentido fixo, como no painel: sucesso, aviso e informação. O erro usa `colorScheme.error`.
@immutable
class CoresStowise extends ThemeExtension<CoresStowise> {
  const CoresStowise({required this.sucesso, required this.aviso, required this.info});

  static const claro = CoresStowise(sucesso: Color(0xFF1B7F4B), aviso: Color(0xFFB45309), info: Color(0xFF2563C9));

  static const escuro = CoresStowise(sucesso: Color(0xFF5BD18B), aviso: Color(0xFFF2B85B), info: Color(0xFF7FB0FF));

  final Color sucesso;
  final Color aviso;
  final Color info;

  @override
  CoresStowise copyWith({Color? sucesso, Color? aviso, Color? info}) =>
      CoresStowise(sucesso: sucesso ?? this.sucesso, aviso: aviso ?? this.aviso, info: info ?? this.info);

  @override
  CoresStowise lerp(CoresStowise? other, double t) {
    if (other == null) {
      return this;
    }

    return CoresStowise(
      sucesso: Color.lerp(sucesso, other.sucesso, t)!,
      aviso: Color.lerp(aviso, other.aviso, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

ThemeData _tema(Brightness brilho) {
  final cores = ColorScheme.fromSeed(seedColor: corMarca, brightness: brilho);
  return ThemeData(
    colorScheme: cores,
    extensions: [if (brilho == Brightness.light) CoresStowise.claro else CoresStowise.escuro],
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    // Alvos de toque grandes: o app é usado em pé, com luva ou com o coletor na outra mão.
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52))),
  );
}

final temaClaro = _tema(Brightness.light);
final temaEscuro = _tema(Brightness.dark);

extension CoresDoTema on BuildContext {
  CoresStowise get cores => Theme.of(this).extension<CoresStowise>()!;
}
