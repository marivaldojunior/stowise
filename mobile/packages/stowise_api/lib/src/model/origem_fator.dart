//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'origem_fator.g.dart';

class OrigemFator extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Nota')
  static const OrigemFator nota = _$nota;
  @BuiltValueEnumConst(wireName: r'DePara')
  static const OrigemFator dePara = _$dePara;
  @BuiltValueEnumConst(wireName: r'Embalagem')
  static const OrigemFator embalagem = _$embalagem;
  @BuiltValueEnumConst(wireName: r'Desconhecido')
  static const OrigemFator desconhecido = _$desconhecido;

  static Serializer<OrigemFator> get serializer => _$origemFatorSerializer;

  const OrigemFator._(String name) : super(name);

  static BuiltSet<OrigemFator> get values => _$values;
  static OrigemFator valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OrigemFatorMixin = Object with _$OrigemFatorMixin;
