//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classe_armazenagem.g.dart';

class ClasseArmazenagem extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Normal')
  static const ClasseArmazenagem normal = _$normal;
  @BuiltValueEnumConst(wireName: r'Refrigerado')
  static const ClasseArmazenagem refrigerado = _$refrigerado;
  @BuiltValueEnumConst(wireName: r'Inflamavel')
  static const ClasseArmazenagem inflamavel = _$inflamavel;
  @BuiltValueEnumConst(wireName: r'Fragil')
  static const ClasseArmazenagem fragil = _$fragil;

  static Serializer<ClasseArmazenagem> get serializer => _$classeArmazenagemSerializer;

  const ClasseArmazenagem._(String name) : super(name);

  static BuiltSet<ClasseArmazenagem> get values => _$values;
  static ClasseArmazenagem valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ClasseArmazenagemMixin = Object with _$ClasseArmazenagemMixin;
