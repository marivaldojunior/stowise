// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_cadastro.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusCadastro _$incompleto = const StatusCadastro._('incompleto');
const StatusCadastro _$completo = const StatusCadastro._('completo');

StatusCadastro _$valueOf(String name) {
  switch (name) {
    case 'incompleto':
      return _$incompleto;
    case 'completo':
      return _$completo;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusCadastro> _$values = BuiltSet<StatusCadastro>(const <StatusCadastro>[
  _$incompleto,
  _$completo,
]);

class _$StatusCadastroMeta {
  const _$StatusCadastroMeta();
  StatusCadastro get incompleto => _$incompleto;
  StatusCadastro get completo => _$completo;
  StatusCadastro valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusCadastro> get values => _$values;
}

abstract class _$StatusCadastroMixin {
  // ignore: non_constant_identifier_names
  _$StatusCadastroMeta get StatusCadastro => const _$StatusCadastroMeta();
}

Serializer<StatusCadastro> _$statusCadastroSerializer = _$StatusCadastroSerializer();

class _$StatusCadastroSerializer implements PrimitiveSerializer<StatusCadastro> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'incompleto': 'Incompleto',
    'completo': 'Completo',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Incompleto': 'incompleto',
    'Completo': 'completo',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusCadastro];
  @override
  final String wireName = 'StatusCadastro';

  @override
  Object serialize(Serializers serializers, StatusCadastro object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusCadastro deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusCadastro.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
