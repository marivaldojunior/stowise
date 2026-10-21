//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'alerta_item_nota.g.dart';

class AlertaItemNota extends EnumClass {
  @BuiltValueEnumConst(wireName: r'FatorDivergente')
  static const AlertaItemNota fatorDivergente = _$fatorDivergente;
  @BuiltValueEnumConst(wireName: r'LotesNaoFecham')
  static const AlertaItemNota lotesNaoFecham = _$lotesNaoFecham;
  @BuiltValueEnumConst(wireName: r'LoteFaltando')
  static const AlertaItemNota loteFaltando = _$loteFaltando;
  @BuiltValueEnumConst(wireName: r'ValidadeFaltando')
  static const AlertaItemNota validadeFaltando = _$validadeFaltando;
  @BuiltValueEnumConst(wireName: r'LoteVencido')
  static const AlertaItemNota loteVencido = _$loteVencido;

  static Serializer<AlertaItemNota> get serializer => _$alertaItemNotaSerializer;

  const AlertaItemNota._(String name) : super(name);

  static BuiltSet<AlertaItemNota> get values => _$values;
  static AlertaItemNota valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AlertaItemNotaMixin = Object with _$AlertaItemNotaMixin;
