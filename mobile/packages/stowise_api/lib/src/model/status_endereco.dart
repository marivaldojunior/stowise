//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_endereco.g.dart';

class StatusEndereco extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Livre')
  static const StatusEndereco livre = _$livre;
  @BuiltValueEnumConst(wireName: r'Ocupado')
  static const StatusEndereco ocupado = _$ocupado;
  @BuiltValueEnumConst(wireName: r'Bloqueado')
  static const StatusEndereco bloqueado = _$bloqueado;

  static Serializer<StatusEndereco> get serializer => _$statusEnderecoSerializer;

  const StatusEndereco._(String name) : super(name);

  static BuiltSet<StatusEndereco> get values => _$values;
  static StatusEndereco valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusEnderecoMixin = Object with _$StatusEnderecoMixin;
