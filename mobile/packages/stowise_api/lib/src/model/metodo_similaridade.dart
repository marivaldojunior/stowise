//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'metodo_similaridade.g.dart';

class MetodoSimilaridade extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Semantica')
  static const MetodoSimilaridade semantica = _$semantica;
  @BuiltValueEnumConst(wireName: r'Trigramas')
  static const MetodoSimilaridade trigramas = _$trigramas;

  static Serializer<MetodoSimilaridade> get serializer => _$metodoSimilaridadeSerializer;

  const MetodoSimilaridade._(String name) : super(name);

  static BuiltSet<MetodoSimilaridade> get values => _$values;
  static MetodoSimilaridade valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MetodoSimilaridadeMixin = Object with _$MetodoSimilaridadeMixin;
