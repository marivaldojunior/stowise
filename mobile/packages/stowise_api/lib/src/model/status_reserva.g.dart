// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_reserva.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusReserva _$ativa = const StatusReserva._('ativa');
const StatusReserva _$cancelada = const StatusReserva._('cancelada');
const StatusReserva _$consumida = const StatusReserva._('consumida');

StatusReserva _$valueOf(String name) {
  switch (name) {
    case 'ativa':
      return _$ativa;
    case 'cancelada':
      return _$cancelada;
    case 'consumida':
      return _$consumida;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusReserva> _$values = BuiltSet<StatusReserva>(const <StatusReserva>[
  _$ativa,
  _$cancelada,
  _$consumida,
]);

class _$StatusReservaMeta {
  const _$StatusReservaMeta();
  StatusReserva get ativa => _$ativa;
  StatusReserva get cancelada => _$cancelada;
  StatusReserva get consumida => _$consumida;
  StatusReserva valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusReserva> get values => _$values;
}

abstract class _$StatusReservaMixin {
  // ignore: non_constant_identifier_names
  _$StatusReservaMeta get StatusReserva => const _$StatusReservaMeta();
}

Serializer<StatusReserva> _$statusReservaSerializer = _$StatusReservaSerializer();

class _$StatusReservaSerializer implements PrimitiveSerializer<StatusReserva> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ativa': 'Ativa',
    'cancelada': 'Cancelada',
    'consumida': 'Consumida',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Ativa': 'ativa',
    'Cancelada': 'cancelada',
    'Consumida': 'consumida',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusReserva];
  @override
  final String wireName = 'StatusReserva';

  @override
  Object serialize(Serializers serializers, StatusReserva object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusReserva deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusReserva.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
