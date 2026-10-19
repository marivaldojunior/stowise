//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_linha.g.dart';

class StatusLinha extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Valida')
  static const StatusLinha valida = _$valida;
  @BuiltValueEnumConst(wireName: r'Erro')
  static const StatusLinha erro = _$erro;
  @BuiltValueEnumConst(wireName: r'PossivelDuplicata')
  static const StatusLinha possivelDuplicata = _$possivelDuplicata;
  @BuiltValueEnumConst(wireName: r'Ignorada')
  static const StatusLinha ignorada = _$ignorada;

  static Serializer<StatusLinha> get serializer => _$statusLinhaSerializer;

  const StatusLinha._(String name) : super(name);

  static BuiltSet<StatusLinha> get values => _$values;
  static StatusLinha valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusLinhaMixin = Object with _$StatusLinhaMixin;
