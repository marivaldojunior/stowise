// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origem_fator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrigemFator _$nota = const OrigemFator._('nota');
const OrigemFator _$dePara = const OrigemFator._('dePara');
const OrigemFator _$embalagem = const OrigemFator._('embalagem');
const OrigemFator _$desconhecido = const OrigemFator._('desconhecido');

OrigemFator _$valueOf(String name) {
  switch (name) {
    case 'nota':
      return _$nota;
    case 'dePara':
      return _$dePara;
    case 'embalagem':
      return _$embalagem;
    case 'desconhecido':
      return _$desconhecido;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrigemFator> _$values = BuiltSet<OrigemFator>(const <OrigemFator>[
  _$nota,
  _$dePara,
  _$embalagem,
  _$desconhecido,
]);

class _$OrigemFatorMeta {
  const _$OrigemFatorMeta();
  OrigemFator get nota => _$nota;
  OrigemFator get dePara => _$dePara;
  OrigemFator get embalagem => _$embalagem;
  OrigemFator get desconhecido => _$desconhecido;
  OrigemFator valueOf(String name) => _$valueOf(name);
  BuiltSet<OrigemFator> get values => _$values;
}

abstract class _$OrigemFatorMixin {
  // ignore: non_constant_identifier_names
  _$OrigemFatorMeta get OrigemFator => const _$OrigemFatorMeta();
}

Serializer<OrigemFator> _$origemFatorSerializer = _$OrigemFatorSerializer();

class _$OrigemFatorSerializer implements PrimitiveSerializer<OrigemFator> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nota': 'Nota',
    'dePara': 'DePara',
    'embalagem': 'Embalagem',
    'desconhecido': 'Desconhecido',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Nota': 'nota',
    'DePara': 'dePara',
    'Embalagem': 'embalagem',
    'Desconhecido': 'desconhecido',
  };

  @override
  final Iterable<Type> types = const <Type>[OrigemFator];
  @override
  final String wireName = 'OrigemFator';

  @override
  Object serialize(Serializers serializers, OrigemFator object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrigemFator deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrigemFator.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
