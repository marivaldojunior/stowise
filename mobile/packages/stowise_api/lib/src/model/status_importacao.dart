//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'status_importacao.g.dart';

class StatusImportacao extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Recebido')
  static const StatusImportacao recebido = _$recebido;
  @BuiltValueEnumConst(wireName: r'Mapeando')
  static const StatusImportacao mapeando = _$mapeando;
  @BuiltValueEnumConst(wireName: r'AguardandoConfirmacao')
  static const StatusImportacao aguardandoConfirmacao = _$aguardandoConfirmacao;
  @BuiltValueEnumConst(wireName: r'Validando')
  static const StatusImportacao validando = _$validando;
  @BuiltValueEnumConst(wireName: r'AguardandoRevisao')
  static const StatusImportacao aguardandoRevisao = _$aguardandoRevisao;
  @BuiltValueEnumConst(wireName: r'Efetivando')
  static const StatusImportacao efetivando = _$efetivando;
  @BuiltValueEnumConst(wireName: r'Concluido')
  static const StatusImportacao concluido = _$concluido;
  @BuiltValueEnumConst(wireName: r'Falhou')
  static const StatusImportacao falhou = _$falhou;

  static Serializer<StatusImportacao> get serializer => _$statusImportacaoSerializer;

  const StatusImportacao._(String name) : super(name);

  static BuiltSet<StatusImportacao> get values => _$values;
  static StatusImportacao valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StatusImportacaoMixin = Object with _$StatusImportacaoMixin;
