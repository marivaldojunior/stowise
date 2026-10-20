//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'origem_casamento.g.dart';

class OrigemCasamento extends EnumClass {
  @BuiltValueEnumConst(wireName: r'DePara')
  static const OrigemCasamento dePara = _$dePara;
  @BuiltValueEnumConst(wireName: r'Gtin')
  static const OrigemCasamento gtin = _$gtin;
  @BuiltValueEnumConst(wireName: r'Similaridade')
  static const OrigemCasamento similaridade = _$similaridade;
  @BuiltValueEnumConst(wireName: r'SemCandidato')
  static const OrigemCasamento semCandidato = _$semCandidato;

  static Serializer<OrigemCasamento> get serializer => _$origemCasamentoSerializer;

  const OrigemCasamento._(String name) : super(name);

  static BuiltSet<OrigemCasamento> get values => _$values;
  static OrigemCasamento valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OrigemCasamentoMixin = Object with _$OrigemCasamentoMixin;
