// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_recebimento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusRecebimento _$aguardandoConferencia = const StatusRecebimento._('aguardandoConferencia');
const StatusRecebimento _$emConferencia = const StatusRecebimento._('emConferencia');
const StatusRecebimento _$conferido = const StatusRecebimento._('conferido');

StatusRecebimento _$valueOf(String name) {
  switch (name) {
    case 'aguardandoConferencia':
      return _$aguardandoConferencia;
    case 'emConferencia':
      return _$emConferencia;
    case 'conferido':
      return _$conferido;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusRecebimento> _$values = BuiltSet<StatusRecebimento>(const <StatusRecebimento>[
  _$aguardandoConferencia,
  _$emConferencia,
  _$conferido,
]);

class _$StatusRecebimentoMeta {
  const _$StatusRecebimentoMeta();
  StatusRecebimento get aguardandoConferencia => _$aguardandoConferencia;
  StatusRecebimento get emConferencia => _$emConferencia;
  StatusRecebimento get conferido => _$conferido;
  StatusRecebimento valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusRecebimento> get values => _$values;
}

abstract class _$StatusRecebimentoMixin {
  // ignore: non_constant_identifier_names
  _$StatusRecebimentoMeta get StatusRecebimento => const _$StatusRecebimentoMeta();
}

Serializer<StatusRecebimento> _$statusRecebimentoSerializer = _$StatusRecebimentoSerializer();

class _$StatusRecebimentoSerializer implements PrimitiveSerializer<StatusRecebimento> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'aguardandoConferencia': 'AguardandoConferencia',
    'emConferencia': 'EmConferencia',
    'conferido': 'Conferido',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AguardandoConferencia': 'aguardandoConferencia',
    'EmConferencia': 'emConferencia',
    'Conferido': 'conferido',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusRecebimento];
  @override
  final String wireName = 'StatusRecebimento';

  @override
  Object serialize(Serializers serializers, StatusRecebimento object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusRecebimento deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusRecebimento.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
