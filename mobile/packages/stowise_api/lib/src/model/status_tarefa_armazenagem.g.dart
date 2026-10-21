// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_tarefa_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusTarefaArmazenagem _$pendente = const StatusTarefaArmazenagem._('pendente');
const StatusTarefaArmazenagem _$concluida = const StatusTarefaArmazenagem._('concluida');
const StatusTarefaArmazenagem _$divergente = const StatusTarefaArmazenagem._('divergente');

StatusTarefaArmazenagem _$valueOf(String name) {
  switch (name) {
    case 'pendente':
      return _$pendente;
    case 'concluida':
      return _$concluida;
    case 'divergente':
      return _$divergente;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusTarefaArmazenagem> _$values = BuiltSet<StatusTarefaArmazenagem>(const <StatusTarefaArmazenagem>[
  _$pendente,
  _$concluida,
  _$divergente,
]);

class _$StatusTarefaArmazenagemMeta {
  const _$StatusTarefaArmazenagemMeta();
  StatusTarefaArmazenagem get pendente => _$pendente;
  StatusTarefaArmazenagem get concluida => _$concluida;
  StatusTarefaArmazenagem get divergente => _$divergente;
  StatusTarefaArmazenagem valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusTarefaArmazenagem> get values => _$values;
}

abstract class _$StatusTarefaArmazenagemMixin {
  // ignore: non_constant_identifier_names
  _$StatusTarefaArmazenagemMeta get StatusTarefaArmazenagem => const _$StatusTarefaArmazenagemMeta();
}

Serializer<StatusTarefaArmazenagem> _$statusTarefaArmazenagemSerializer = _$StatusTarefaArmazenagemSerializer();

class _$StatusTarefaArmazenagemSerializer implements PrimitiveSerializer<StatusTarefaArmazenagem> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pendente': 'Pendente',
    'concluida': 'Concluida',
    'divergente': 'Divergente',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Pendente': 'pendente',
    'Concluida': 'concluida',
    'Divergente': 'divergente',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusTarefaArmazenagem];
  @override
  final String wireName = 'StatusTarefaArmazenagem';

  @override
  Object serialize(Serializers serializers, StatusTarefaArmazenagem object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusTarefaArmazenagem deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusTarefaArmazenagem.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
