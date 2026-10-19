import 'package:flutter/material.dart';

/// Cor da marca, a mesma do painel web: o verde-azulado da operação.
const corMarca = Color(0xFF00777A);

/// Identidade do Stowise, tirada do armazém (igual ao painel web):
/// - marca → marca2: verde-azulado da operação, em degradê para o ciano;
/// - tinta: azul-petróleo escuro dos cabeçalhos;
/// - sinal: âmbar da fita de segurança e da etiqueta de palete;
/// - ia → ia2: violeta → magenta, só nos recursos de IA;
/// - sucesso, aviso e info: o sentido das situações (o erro usa `colorScheme.error`).
@immutable
class CoresStowise extends ThemeExtension<CoresStowise> {
  const CoresStowise({
    required this.sucesso,
    required this.aviso,
    required this.info,
    required this.marca2,
    required this.tinta,
    required this.tinta2,
    required this.sinal,
    required this.ia,
    required this.ia2,
    required this.sombra,
  });

  static const claro = CoresStowise(
    sucesso: Color(0xFF1B7F4B),
    aviso: Color(0xFFB45309),
    info: Color(0xFF2563C9),
    marca2: Color(0xFF22A6B8),
    tinta: Color(0xFF0F2E3A),
    tinta2: Color(0xFF13233F),
    sinal: Color(0xFFF2A93B),
    ia: Color(0xFF7A4DE0),
    ia2: Color(0xFFD0479B),
    sombra: Color(0x330F2E3A),
  );

  static const escuro = CoresStowise(
    sucesso: Color(0xFF5BD18B),
    aviso: Color(0xFFF2B85B),
    info: Color(0xFF7FB0FF),
    marca2: Color(0xFF5CC8D6),
    tinta: Color(0xFF0A1C24),
    tinta2: Color(0xFF0D1730),
    sinal: Color(0xFFF5B54D),
    ia: Color(0xFFA588F2),
    ia2: Color(0xFFE47BB8),
    sombra: Color(0x66000000),
  );

  final Color sucesso;
  final Color aviso;
  final Color info;
  final Color marca2;
  final Color tinta;
  final Color tinta2;
  final Color sinal;
  final Color ia;
  final Color ia2;

  /// Cor das sombras: um pouco da tinta no claro, preto no escuro.
  final Color sombra;

  LinearGradient gradienteMarca(Color marca) =>
      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [marca, marca2]);

  LinearGradient get gradienteTinta =>
      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [tinta, tinta2]);

  LinearGradient get gradienteSinal =>
      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [sinal, const Color(0xFFE07B28)]);

  LinearGradient get gradienteIa =>
      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ia, ia2]);

  /// Faixa de assinatura: operação, sinal e IA, como uma fita de armazém.
  LinearGradient faixa(Color marca) => LinearGradient(colors: [marca, marca2, sinal, ia, ia2]);

  /// Sombra em camadas dos cartões: a profundidade lembra prateleiras e paletes.
  List<BoxShadow> get sombraCartao => [
    BoxShadow(
      color: sombra.withValues(alpha: sombra.a * 0.4),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(color: sombra, blurRadius: 18, spreadRadius: -6, offset: const Offset(0, 8)),
  ];

  /// Brilho colorido embaixo de um elemento em destaque (botão principal, ícone de ação).
  List<BoxShadow> brilho(Color cor) => [
    BoxShadow(color: cor.withValues(alpha: 0.45), blurRadius: 18, spreadRadius: -6, offset: const Offset(0, 8)),
  ];

  @override
  CoresStowise copyWith({
    Color? sucesso,
    Color? aviso,
    Color? info,
    Color? marca2,
    Color? tinta,
    Color? tinta2,
    Color? sinal,
    Color? ia,
    Color? ia2,
    Color? sombra,
  }) => CoresStowise(
    sucesso: sucesso ?? this.sucesso,
    aviso: aviso ?? this.aviso,
    info: info ?? this.info,
    marca2: marca2 ?? this.marca2,
    tinta: tinta ?? this.tinta,
    tinta2: tinta2 ?? this.tinta2,
    sinal: sinal ?? this.sinal,
    ia: ia ?? this.ia,
    ia2: ia2 ?? this.ia2,
    sombra: sombra ?? this.sombra,
  );

  @override
  CoresStowise lerp(CoresStowise? other, double t) {
    if (other == null) {
      return this;
    }

    Color misturar(Color a, Color b) => Color.lerp(a, b, t)!;
    return CoresStowise(
      sucesso: misturar(sucesso, other.sucesso),
      aviso: misturar(aviso, other.aviso),
      info: misturar(info, other.info),
      marca2: misturar(marca2, other.marca2),
      tinta: misturar(tinta, other.tinta),
      tinta2: misturar(tinta2, other.tinta2),
      sinal: misturar(sinal, other.sinal),
      ia: misturar(ia, other.ia),
      ia2: misturar(ia2, other.ia2),
      sombra: misturar(sombra, other.sombra),
    );
  }
}

ThemeData _tema(Brightness brilho) {
  final escuro = brilho == Brightness.dark;
  final cores = ColorScheme.fromSeed(
    seedColor: corMarca,
    brightness: brilho,
    surface: escuro ? const Color(0xFF101C22) : const Color(0xFFF4F8F9),
  );
  final extras = escuro ? CoresStowise.escuro : CoresStowise.claro;
  final cantos = BorderRadius.circular(14);
  // Estilos derivados do texto do tema, para manter a família de fonte da plataforma.
  final texto = ThemeData(colorScheme: cores).textTheme;
  return ThemeData(
    colorScheme: cores,
    scaffoldBackgroundColor: cores.surface,
    extensions: [extras],
    appBarTheme: AppBarTheme(
      backgroundColor: extras.tinta,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: texto.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: escuro ? const Color(0xFF16262E) : Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cores.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: escuro ? const Color(0xFF16262E) : Colors.white,
      border: OutlineInputBorder(borderRadius: cantos),
      enabledBorder: OutlineInputBorder(
        borderRadius: cantos,
        borderSide: BorderSide(color: cores.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: cantos,
        borderSide: BorderSide(color: cores.primary, width: 2),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: cores.primary,
        selectedForegroundColor: cores.onPrimary,
        backgroundColor: escuro ? const Color(0xFF16262E) : Colors.white,
      ),
    ),
    // Alvos de toque grandes: o app é usado em pé, com luva ou com o coletor na outra mão.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: cantos),
        textStyle: texto.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

final temaClaro = _tema(Brightness.light);
final temaEscuro = _tema(Brightness.dark);

extension CoresDoTema on BuildContext {
  CoresStowise get cores => Theme.of(this).extension<CoresStowise>()!;
}
