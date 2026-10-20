// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metodo_similaridade.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MetodoSimilaridade _$semantica = const MetodoSimilaridade._('semantica');
const MetodoSimilaridade _$trigramas = const MetodoSimilaridade._('trigramas');

MetodoSimilaridade _$valueOf(String name) {
  switch (name) {
    case 'semantica':
      return _$semantica;
    case 'trigramas':
      return _$trigramas;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MetodoSimilaridade> _$values = BuiltSet<MetodoSimilaridade>(const <MetodoSimilaridade>[
  _$semantica,
  _$trigramas,
]);

class _$MetodoSimilaridadeMeta {
  const _$MetodoSimilaridadeMeta();
  MetodoSimilaridade get semantica => _$semantica;
  MetodoSimilaridade get trigramas => _$trigramas;
  MetodoSimilaridade valueOf(String name) => _$valueOf(name);
  BuiltSet<MetodoSimilaridade> get values => _$values;
}

abstract class _$MetodoSimilaridadeMixin {
  // ignore: non_constant_identifier_names
  _$MetodoSimilaridadeMeta get MetodoSimilaridade => const _$MetodoSimilaridadeMeta();
}

Serializer<MetodoSimilaridade> _$metodoSimilaridadeSerializer = _$MetodoSimilaridadeSerializer();

class _$MetodoSimilaridadeSerializer implements PrimitiveSerializer<MetodoSimilaridade> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'semantica': 'Semantica',
    'trigramas': 'Trigramas',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Semantica': 'semantica',
    'Trigramas': 'trigramas',
  };

  @override
  final Iterable<Type> types = const <Type>[MetodoSimilaridade];
  @override
  final String wireName = 'MetodoSimilaridade';

  @override
  Object serialize(Serializers serializers, MetodoSimilaridade object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MetodoSimilaridade deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MetodoSimilaridade.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
