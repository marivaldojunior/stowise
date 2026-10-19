// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_importacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusImportacao _$recebido = const StatusImportacao._('recebido');
const StatusImportacao _$mapeando = const StatusImportacao._('mapeando');
const StatusImportacao _$aguardandoConfirmacao = const StatusImportacao._('aguardandoConfirmacao');
const StatusImportacao _$validando = const StatusImportacao._('validando');
const StatusImportacao _$aguardandoRevisao = const StatusImportacao._('aguardandoRevisao');
const StatusImportacao _$efetivando = const StatusImportacao._('efetivando');
const StatusImportacao _$concluido = const StatusImportacao._('concluido');
const StatusImportacao _$falhou = const StatusImportacao._('falhou');

StatusImportacao _$valueOf(String name) {
  switch (name) {
    case 'recebido':
      return _$recebido;
    case 'mapeando':
      return _$mapeando;
    case 'aguardandoConfirmacao':
      return _$aguardandoConfirmacao;
    case 'validando':
      return _$validando;
    case 'aguardandoRevisao':
      return _$aguardandoRevisao;
    case 'efetivando':
      return _$efetivando;
    case 'concluido':
      return _$concluido;
    case 'falhou':
      return _$falhou;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StatusImportacao> _$values = BuiltSet<StatusImportacao>(const <StatusImportacao>[
  _$recebido,
  _$mapeando,
  _$aguardandoConfirmacao,
  _$validando,
  _$aguardandoRevisao,
  _$efetivando,
  _$concluido,
  _$falhou,
]);

class _$StatusImportacaoMeta {
  const _$StatusImportacaoMeta();
  StatusImportacao get recebido => _$recebido;
  StatusImportacao get mapeando => _$mapeando;
  StatusImportacao get aguardandoConfirmacao => _$aguardandoConfirmacao;
  StatusImportacao get validando => _$validando;
  StatusImportacao get aguardandoRevisao => _$aguardandoRevisao;
  StatusImportacao get efetivando => _$efetivando;
  StatusImportacao get concluido => _$concluido;
  StatusImportacao get falhou => _$falhou;
  StatusImportacao valueOf(String name) => _$valueOf(name);
  BuiltSet<StatusImportacao> get values => _$values;
}

abstract class _$StatusImportacaoMixin {
  // ignore: non_constant_identifier_names
  _$StatusImportacaoMeta get StatusImportacao => const _$StatusImportacaoMeta();
}

Serializer<StatusImportacao> _$statusImportacaoSerializer = _$StatusImportacaoSerializer();

class _$StatusImportacaoSerializer implements PrimitiveSerializer<StatusImportacao> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'recebido': 'Recebido',
    'mapeando': 'Mapeando',
    'aguardandoConfirmacao': 'AguardandoConfirmacao',
    'validando': 'Validando',
    'aguardandoRevisao': 'AguardandoRevisao',
    'efetivando': 'Efetivando',
    'concluido': 'Concluido',
    'falhou': 'Falhou',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Recebido': 'recebido',
    'Mapeando': 'mapeando',
    'AguardandoConfirmacao': 'aguardandoConfirmacao',
    'Validando': 'validando',
    'AguardandoRevisao': 'aguardandoRevisao',
    'Efetivando': 'efetivando',
    'Concluido': 'concluido',
    'Falhou': 'falhou',
  };

  @override
  final Iterable<Type> types = const <Type>[StatusImportacao];
  @override
  final String wireName = 'StatusImportacao';

  @override
  Object serialize(Serializers serializers, StatusImportacao object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StatusImportacao deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusImportacao.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
