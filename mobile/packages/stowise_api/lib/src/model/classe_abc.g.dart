// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe_abc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClasseAbc _$A = const ClasseAbc._('A');
const ClasseAbc _$B = const ClasseAbc._('B');
const ClasseAbc _$C = const ClasseAbc._('C');

ClasseAbc _$valueOf(String name) {
  switch (name) {
    case 'A':
      return _$A;
    case 'B':
      return _$B;
    case 'C':
      return _$C;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClasseAbc> _$values = BuiltSet<ClasseAbc>(const <ClasseAbc>[
  _$A,
  _$B,
  _$C,
]);

class _$ClasseAbcMeta {
  const _$ClasseAbcMeta();
  ClasseAbc get A => _$A;
  ClasseAbc get B => _$B;
  ClasseAbc get C => _$C;
  ClasseAbc valueOf(String name) => _$valueOf(name);
  BuiltSet<ClasseAbc> get values => _$values;
}

abstract class _$ClasseAbcMixin {
  // ignore: non_constant_identifier_names
  _$ClasseAbcMeta get ClasseAbc => const _$ClasseAbcMeta();
}

Serializer<ClasseAbc> _$classeAbcSerializer = _$ClasseAbcSerializer();

class _$ClasseAbcSerializer implements PrimitiveSerializer<ClasseAbc> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'A': 'A',
    'B': 'B',
    'C': 'C',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'A': 'A',
    'B': 'B',
    'C': 'C',
  };

  @override
  final Iterable<Type> types = const <Type>[ClasseAbc];
  @override
  final String wireName = 'ClasseAbc';

  @override
  Object serialize(Serializers serializers, ClasseAbc object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClasseAbc deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) =>
      ClasseAbc.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
