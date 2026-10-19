// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClasseArmazenagem _$normal = const ClasseArmazenagem._('normal');
const ClasseArmazenagem _$refrigerado = const ClasseArmazenagem._('refrigerado');
const ClasseArmazenagem _$inflamavel = const ClasseArmazenagem._('inflamavel');
const ClasseArmazenagem _$fragil = const ClasseArmazenagem._('fragil');

ClasseArmazenagem _$valueOf(String name) {
  switch (name) {
    case 'normal':
      return _$normal;
    case 'refrigerado':
      return _$refrigerado;
    case 'inflamavel':
      return _$inflamavel;
    case 'fragil':
      return _$fragil;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClasseArmazenagem> _$values = BuiltSet<ClasseArmazenagem>(const <ClasseArmazenagem>[
  _$normal,
  _$refrigerado,
  _$inflamavel,
  _$fragil,
]);

class _$ClasseArmazenagemMeta {
  const _$ClasseArmazenagemMeta();
  ClasseArmazenagem get normal => _$normal;
  ClasseArmazenagem get refrigerado => _$refrigerado;
  ClasseArmazenagem get inflamavel => _$inflamavel;
  ClasseArmazenagem get fragil => _$fragil;
  ClasseArmazenagem valueOf(String name) => _$valueOf(name);
  BuiltSet<ClasseArmazenagem> get values => _$values;
}

abstract class _$ClasseArmazenagemMixin {
  // ignore: non_constant_identifier_names
  _$ClasseArmazenagemMeta get ClasseArmazenagem => const _$ClasseArmazenagemMeta();
}

Serializer<ClasseArmazenagem> _$classeArmazenagemSerializer = _$ClasseArmazenagemSerializer();

class _$ClasseArmazenagemSerializer implements PrimitiveSerializer<ClasseArmazenagem> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'normal': 'Normal',
    'refrigerado': 'Refrigerado',
    'inflamavel': 'Inflamavel',
    'fragil': 'Fragil',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Normal': 'normal',
    'Refrigerado': 'refrigerado',
    'Inflamavel': 'inflamavel',
    'Fragil': 'fragil',
  };

  @override
  final Iterable<Type> types = const <Type>[ClasseArmazenagem];
  @override
  final String wireName = 'ClasseArmazenagem';

  @override
  Object serialize(Serializers serializers, ClasseArmazenagem object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClasseArmazenagem deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClasseArmazenagem.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
