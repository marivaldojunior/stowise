// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_linha.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusLinha _$valida = const StatusLinha._('valida');
const StatusLinha _$erro = const StatusLinha._('erro');
const StatusLinha _$possivelDuplicata = const StatusLinha._('possivelDuplicata');
const StatusLinha _$ignorada = const StatusLinha._('ignorada');

StatusLinha _$valueOf(String name) {
  switch (name) {
    case 'valida':
      return _$valida;
    case 'erro':
      return _$erro;
    case 'possivelDuplicata':
      return _$possivelDuplicata;
    case 'ignorada':
      return _$ignorada;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusLinha> _$values = BuiltSet<StatusLinha>(const <StatusLinha>[
  _$valida,
  _$erro,
  _$possivelDuplicata,
  _$ignorada,
]);

class _$StatusLinhaMeta {
  const _$StatusLinhaMeta();
  StatusLinha get valida => _$valida;
  StatusLinha get erro => _$erro;
  StatusLinha get possivelDuplicata => _$possivelDuplicata;
  StatusLinha get ignorada => _$ignorada;
  StatusLinha valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusLinha> get values => _$values;
}

abstract class _$StatusLinhaMixin {
  // ignore: non_constant_identifier_names
  _$StatusLinhaMeta get StatusLinha => const _$StatusLinhaMeta();
}

Serializer<StatusLinha> _$statusLinhaSerializer = _$StatusLinhaSerializer();

class _$StatusLinhaSerializer implements PrimitiveSerializer<StatusLinha> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'valida': 'Valida',
    'erro': 'Erro',
    'possivelDuplicata': 'PossivelDuplicata',
    'ignorada': 'Ignorada',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Valida': 'valida',
    'Erro': 'erro',
    'PossivelDuplicata': 'possivelDuplicata',
    'Ignorada': 'ignorada',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusLinha];
  @override
  final String wireName = 'StatusLinha';

  @override
  Object serialize(Serializers serializers, StatusLinha object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusLinha deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusLinha.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
