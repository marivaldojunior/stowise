//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tipo_movimentacao.g.dart';

class TipoMovimentacao extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Entrada')
  static const TipoMovimentacao entrada = _$entrada;
  @BuiltValueEnumConst(wireName: r'Saida')
  static const TipoMovimentacao saida = _$saida;
  @BuiltValueEnumConst(wireName: r'Transferencia')
  static const TipoMovimentacao transferencia = _$transferencia;
  @BuiltValueEnumConst(wireName: r'Ajuste')
  static const TipoMovimentacao ajuste = _$ajuste;

  static Serializer<TipoMovimentacao> get serializer => _$tipoMovimentacaoSerializer;

  const TipoMovimentacao._(String name) : super(name);

  static BuiltSet<TipoMovimentacao> get values => _$values;
  static TipoMovimentacao valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TipoMovimentacaoMixin = Object with _$TipoMovimentacaoMixin;
