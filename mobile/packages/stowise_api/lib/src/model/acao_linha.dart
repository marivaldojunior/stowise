//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'acao_linha.g.dart';

class AcaoLinha extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Criar')
  static const AcaoLinha criar = _$criar;
  @BuiltValueEnumConst(wireName: r'Atualizar')
  static const AcaoLinha atualizar = _$atualizar;
  @BuiltValueEnumConst(wireName: r'Ignorar')
  static const AcaoLinha ignorar = _$ignorar;

  static Serializer<AcaoLinha> get serializer => _$acaoLinhaSerializer;

  const AcaoLinha._(String name) : super(name);

  static BuiltSet<AcaoLinha> get values => _$values;
  static AcaoLinha valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AcaoLinhaMixin = Object with _$AcaoLinhaMixin;
