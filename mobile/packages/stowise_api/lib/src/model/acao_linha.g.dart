// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acao_linha.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AcaoLinha _$criar = const AcaoLinha._('criar');
const AcaoLinha _$atualizar = const AcaoLinha._('atualizar');
const AcaoLinha _$ignorar = const AcaoLinha._('ignorar');

AcaoLinha _$valueOf(String name) {
  switch (name) {
    case 'criar':
      return _$criar;
    case 'atualizar':
      return _$atualizar;
    case 'ignorar':
      return _$ignorar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AcaoLinha> _$values = BuiltSet<AcaoLinha>(const <AcaoLinha>[
  _$criar,
  _$atualizar,
  _$ignorar,
]);

class _$AcaoLinhaMeta {
  const _$AcaoLinhaMeta();
  AcaoLinha get criar => _$criar;
  AcaoLinha get atualizar => _$atualizar;
  AcaoLinha get ignorar => _$ignorar;
  AcaoLinha valueOf(String name) => _$valueOf(name);
  BuiltSet<AcaoLinha> get values => _$values;
}

abstract class _$AcaoLinhaMixin {
  // ignore: non_constant_identifier_names
  _$AcaoLinhaMeta get AcaoLinha => const _$AcaoLinhaMeta();
}

Serializer<AcaoLinha> _$acaoLinhaSerializer = _$AcaoLinhaSerializer();

class _$AcaoLinhaSerializer implements PrimitiveSerializer<AcaoLinha> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'criar': 'Criar',
    'atualizar': 'Atualizar',
    'ignorar': 'Ignorar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Criar': 'criar',
    'Atualizar': 'atualizar',
    'Ignorar': 'ignorar',
  };

  @override
  final Iterable<Type> types = const <Type>[AcaoLinha];
  @override
  final String wireName = 'AcaoLinha';

  @override
  Object serialize(Serializers serializers, AcaoLinha object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AcaoLinha deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) =>
      AcaoLinha.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
