// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_endereco.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusEndereco _$livre = const StatusEndereco._('livre');
const StatusEndereco _$ocupado = const StatusEndereco._('ocupado');
const StatusEndereco _$bloqueado = const StatusEndereco._('bloqueado');

StatusEndereco _$valueOf(String name) {
  switch (name) {
    case 'livre':
      return _$livre;
    case 'ocupado':
      return _$ocupado;
    case 'bloqueado':
      return _$bloqueado;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusEndereco> _$values = BuiltSet<StatusEndereco>(const <StatusEndereco>[
  _$livre,
  _$ocupado,
  _$bloqueado,
]);

class _$StatusEnderecoMeta {
  const _$StatusEnderecoMeta();
  StatusEndereco get livre => _$livre;
  StatusEndereco get ocupado => _$ocupado;
  StatusEndereco get bloqueado => _$bloqueado;
  StatusEndereco valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusEndereco> get values => _$values;
}

abstract class _$StatusEnderecoMixin {
  // ignore: non_constant_identifier_names
  _$StatusEnderecoMeta get StatusEndereco => const _$StatusEnderecoMeta();
}

Serializer<StatusEndereco> _$statusEnderecoSerializer = _$StatusEnderecoSerializer();

class _$StatusEnderecoSerializer implements PrimitiveSerializer<StatusEndereco> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'livre': 'Livre',
    'ocupado': 'Ocupado',
    'bloqueado': 'Bloqueado',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Livre': 'livre',
    'Ocupado': 'ocupado',
    'Bloqueado': 'bloqueado',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusEndereco];
  @override
  final String wireName = 'StatusEndereco';

  @override
  Object serialize(Serializers serializers, StatusEndereco object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusEndereco deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusEndereco.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
