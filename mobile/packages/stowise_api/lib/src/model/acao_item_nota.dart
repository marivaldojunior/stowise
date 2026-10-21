//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'acao_item_nota.g.dart';

class AcaoItemNota extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Confirmar')
  static const AcaoItemNota confirmar = _$confirmar;
  @BuiltValueEnumConst(wireName: r'Vincular')
  static const AcaoItemNota vincular = _$vincular;
  @BuiltValueEnumConst(wireName: r'CriarProduto')
  static const AcaoItemNota criarProduto = _$criarProduto;

  static Serializer<AcaoItemNota> get serializer => _$acaoItemNotaSerializer;

  const AcaoItemNota._(String name) : super(name);

  static BuiltSet<AcaoItemNota> get values => _$values;
  static AcaoItemNota valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AcaoItemNotaMixin = Object with _$AcaoItemNotaMixin;
