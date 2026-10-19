// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_importacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TipoImportacao _$produtos = const TipoImportacao._('produtos');
const TipoImportacao _$notaFiscal = const TipoImportacao._('notaFiscal');
const TipoImportacao _$bensPatrimoniais = const TipoImportacao._('bensPatrimoniais');

TipoImportacao _$valueOf(String name) {
  switch (name) {
    case 'produtos':
      return _$produtos;
    case 'notaFiscal':
      return _$notaFiscal;
    case 'bensPatrimoniais':
      return _$bensPatrimoniais;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TipoImportacao> _$values = BuiltSet<TipoImportacao>(const <TipoImportacao>[
  _$produtos,
  _$notaFiscal,
  _$bensPatrimoniais,
]);

class _$TipoImportacaoMeta {
  const _$TipoImportacaoMeta();
  TipoImportacao get produtos => _$produtos;
  TipoImportacao get notaFiscal => _$notaFiscal;
  TipoImportacao get bensPatrimoniais => _$bensPatrimoniais;
  TipoImportacao valueOf(String name) => _$valueOf(name);
  BuiltSet<TipoImportacao> get values => _$values;
}

abstract class _$TipoImportacaoMixin {
  // ignore: non_constant_identifier_names
  _$TipoImportacaoMeta get TipoImportacao => const _$TipoImportacaoMeta();
}

Serializer<TipoImportacao> _$tipoImportacaoSerializer = _$TipoImportacaoSerializer();

class _$TipoImportacaoSerializer implements PrimitiveSerializer<TipoImportacao> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'produtos': 'Produtos',
    'notaFiscal': 'NotaFiscal',
    'bensPatrimoniais': 'BensPatrimoniais',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Produtos': 'produtos',
    'NotaFiscal': 'notaFiscal',
    'BensPatrimoniais': 'bensPatrimoniais',
  };

  @override
  final Iterable<Type> types = const <Type>[TipoImportacao];
  @override
  final String wireName = 'TipoImportacao';

  @override
  Object serialize(Serializers serializers, TipoImportacao object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TipoImportacao deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TipoImportacao.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
