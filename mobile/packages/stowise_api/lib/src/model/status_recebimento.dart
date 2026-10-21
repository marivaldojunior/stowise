//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_recebimento.g.dart';

class StatusRecebimento extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AguardandoConferencia')
  static const StatusRecebimento aguardandoConferencia = _$aguardandoConferencia;
  @BuiltValueEnumConst(wireName: r'EmConferencia')
  static const StatusRecebimento emConferencia = _$emConferencia;
  @BuiltValueEnumConst(wireName: r'Conferido')
  static const StatusRecebimento conferido = _$conferido;

  static Serializer<StatusRecebimento> get serializer => _$statusRecebimentoSerializer;

  const StatusRecebimento._(String name) : super(name);

  static BuiltSet<StatusRecebimento> get values => _$values;
  static StatusRecebimento valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusRecebimentoMixin = Object with _$StatusRecebimentoMixin;
