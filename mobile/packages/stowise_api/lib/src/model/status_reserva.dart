//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_reserva.g.dart';

class StatusReserva extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Ativa')
  static const StatusReserva ativa = _$ativa;
  @BuiltValueEnumConst(wireName: r'Cancelada')
  static const StatusReserva cancelada = _$cancelada;
  @BuiltValueEnumConst(wireName: r'Consumida')
  static const StatusReserva consumida = _$consumida;

  static Serializer<StatusReserva> get serializer => _$statusReservaSerializer;

  const StatusReserva._(String name) : super(name);

  static BuiltSet<StatusReserva> get values => _$values;
  static StatusReserva valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusReservaMixin = Object with _$StatusReservaMixin;
