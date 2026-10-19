// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_embalagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TipoEmbalagem _$unidade = const TipoEmbalagem._('unidade');
const TipoEmbalagem _$caixa = const TipoEmbalagem._('caixa');
const TipoEmbalagem _$palete = const TipoEmbalagem._('palete');

TipoEmbalagem _$valueOf(String name) {
  switch (name) {
    case 'unidade':
      return _$unidade;
    case 'caixa':
      return _$caixa;
    case 'palete':
      return _$palete;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TipoEmbalagem> _$values = BuiltSet<TipoEmbalagem>(const <TipoEmbalagem>[
  _$unidade,
  _$caixa,
  _$palete,
]);

class _$TipoEmbalagemMeta {
  const _$TipoEmbalagemMeta();
  TipoEmbalagem get unidade => _$unidade;
  TipoEmbalagem get caixa => _$caixa;
  TipoEmbalagem get palete => _$palete;
  TipoEmbalagem valueOf(String name) => _$valueOf(name);
  BuiltSet<TipoEmbalagem> get values => _$values;
}

abstract class _$TipoEmbalagemMixin {
  // ignore: non_constant_identifier_names
  _$TipoEmbalagemMeta get TipoEmbalagem => const _$TipoEmbalagemMeta();
}

Serializer<TipoEmbalagem> _$tipoEmbalagemSerializer = _$TipoEmbalagemSerializer();

class _$TipoEmbalagemSerializer implements PrimitiveSerializer<TipoEmbalagem> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unidade': 'Unidade',
    'caixa': 'Caixa',
    'palete': 'Palete',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Unidade': 'unidade',
    'Caixa': 'caixa',
    'Palete': 'palete',
  };

  @override
  final Iterable<Type> types = const <Type>[TipoEmbalagem];
  @override
  final String wireName = 'TipoEmbalagem';

  @override
  Object serialize(Serializers serializers, TipoEmbalagem object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TipoEmbalagem deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TipoEmbalagem.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
