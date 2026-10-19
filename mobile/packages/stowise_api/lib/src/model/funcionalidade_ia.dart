//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'funcionalidade_ia.g.dart';

class FuncionalidadeIa extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Mapeamento')
  static const FuncionalidadeIa mapeamento = _$mapeamento;
  @BuiltValueEnumConst(wireName: r'CasamentoItens')
  static const FuncionalidadeIa casamentoItens = _$casamentoItens;
  @BuiltValueEnumConst(wireName: r'Camera')
  static const FuncionalidadeIa camera = _$camera;
  @BuiltValueEnumConst(wireName: r'CadastroPorFoto')
  static const FuncionalidadeIa cadastroPorFoto = _$cadastroPorFoto;
  @BuiltValueEnumConst(wireName: r'Consulta')
  static const FuncionalidadeIa consulta = _$consulta;
  @BuiltValueEnumConst(wireName: r'Embeddings')
  static const FuncionalidadeIa embeddings = _$embeddings;
  @BuiltValueEnumConst(wireName: r'Documentos')
  static const FuncionalidadeIa documentos = _$documentos;
  @BuiltValueEnumConst(wireName: r'LeituraPlaqueta')
  static const FuncionalidadeIa leituraPlaqueta = _$leituraPlaqueta;
  @BuiltValueEnumConst(wireName: r'EstadoConservacao')
  static const FuncionalidadeIa estadoConservacao = _$estadoConservacao;
  @BuiltValueEnumConst(wireName: r'CasamentoBens')
  static const FuncionalidadeIa casamentoBens = _$casamentoBens;

  static Serializer<FuncionalidadeIa> get serializer => _$funcionalidadeIaSerializer;

  const FuncionalidadeIa._(String name) : super(name);

  static BuiltSet<FuncionalidadeIa> get values => _$values;
  static FuncionalidadeIa valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FuncionalidadeIaMixin = Object with _$FuncionalidadeIaMixin;
