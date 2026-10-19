//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tipo_embalagem.g.dart';

class TipoEmbalagem extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Unidade')
  static const TipoEmbalagem unidade = _$unidade;
  @BuiltValueEnumConst(wireName: r'Caixa')
  static const TipoEmbalagem caixa = _$caixa;
  @BuiltValueEnumConst(wireName: r'Palete')
  static const TipoEmbalagem palete = _$palete;

  static Serializer<TipoEmbalagem> get serializer => _$tipoEmbalagemSerializer;

  const TipoEmbalagem._(String name) : super(name);

  static BuiltSet<TipoEmbalagem> get values => _$values;
  static TipoEmbalagem valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TipoEmbalagemMixin = Object with _$TipoEmbalagemMixin;
