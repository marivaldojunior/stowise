// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acao_item_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AcaoItemNota _$confirmar = const AcaoItemNota._('confirmar');
const AcaoItemNota _$vincular = const AcaoItemNota._('vincular');
const AcaoItemNota _$criarProduto = const AcaoItemNota._('criarProduto');

AcaoItemNota _$valueOf(String name) {
  switch (name) {
    case 'confirmar':
      return _$confirmar;
    case 'vincular':
      return _$vincular;
    case 'criarProduto':
      return _$criarProduto;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AcaoItemNota> _$values = BuiltSet<AcaoItemNota>(const <AcaoItemNota>[
  _$confirmar,
  _$vincular,
  _$criarProduto,
]);

class _$AcaoItemNotaMeta {
  const _$AcaoItemNotaMeta();
  AcaoItemNota get confirmar => _$confirmar;
  AcaoItemNota get vincular => _$vincular;
  AcaoItemNota get criarProduto => _$criarProduto;
  AcaoItemNota valueOf(String name) => _$valueOf(name);
  BuiltSet<AcaoItemNota> get values => _$values;
}

abstract class _$AcaoItemNotaMixin {
  // ignore: non_constant_identifier_names
  _$AcaoItemNotaMeta get AcaoItemNota => const _$AcaoItemNotaMeta();
}

Serializer<AcaoItemNota> _$acaoItemNotaSerializer = _$AcaoItemNotaSerializer();

class _$AcaoItemNotaSerializer implements PrimitiveSerializer<AcaoItemNota> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'confirmar': 'Confirmar',
    'vincular': 'Vincular',
    'criarProduto': 'CriarProduto',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Confirmar': 'confirmar',
    'Vincular': 'vincular',
    'CriarProduto': 'criarProduto',
  };

  @override
  final Iterable<Type> types = const <Type>[AcaoItemNota];
  @override
  final String wireName = 'AcaoItemNota';

  @override
  Object serialize(Serializers serializers, AcaoItemNota object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AcaoItemNota deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AcaoItemNota.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
