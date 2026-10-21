//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classe_abc.g.dart';

class ClasseAbc extends EnumClass {
  @BuiltValueEnumConst(wireName: r'A')
  static const ClasseAbc A = _$A;
  @BuiltValueEnumConst(wireName: r'B')
  static const ClasseAbc B = _$B;
  @BuiltValueEnumConst(wireName: r'C')
  static const ClasseAbc C = _$C;

  static Serializer<ClasseAbc> get serializer => _$classeAbcSerializer;

  const ClasseAbc._(String name) : super(name);

  static BuiltSet<ClasseAbc> get values => _$values;
  static ClasseAbc valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ClasseAbcMixin = Object with _$ClasseAbcMixin;
