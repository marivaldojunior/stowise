//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/unidade_de_para.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'regras_normalizacao.g.dart';

/// RegrasNormalizacao
///
/// Properties:
/// * [separadorDecimal]
/// * [unidades]
/// * [valoresVerdadeiros]
/// * [valoresFalsos]
@BuiltValue()
abstract class RegrasNormalizacao implements Built<RegrasNormalizacao, RegrasNormalizacaoBuilder> {
  @BuiltValueField(wireName: r'separadorDecimal')
  String? get separadorDecimal;

  @BuiltValueField(wireName: r'unidades')
  BuiltList<UnidadeDePara> get unidades;

  @BuiltValueField(wireName: r'valoresVerdadeiros')
  BuiltList<String> get valoresVerdadeiros;

  @BuiltValueField(wireName: r'valoresFalsos')
  BuiltList<String> get valoresFalsos;

  RegrasNormalizacao._();

  factory RegrasNormalizacao([void updates(RegrasNormalizacaoBuilder b)]) = _$RegrasNormalizacao;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegrasNormalizacaoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegrasNormalizacao> get serializer => _$RegrasNormalizacaoSerializer();
}

class _$RegrasNormalizacaoSerializer implements PrimitiveSerializer<RegrasNormalizacao> {
  @override
  final Iterable<Type> types = const [RegrasNormalizacao, _$RegrasNormalizacao];

  @override
  final String wireName = r'RegrasNormalizacao';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegrasNormalizacao object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'separadorDecimal';
    yield object.separadorDecimal == null
        ? null
        : serializers.serialize(
            object.separadorDecimal,
            specifiedType: const FullType.nullable(String),
          );
    yield r'unidades';
    yield serializers.serialize(
      object.unidades,
      specifiedType: const FullType(BuiltList, [FullType(UnidadeDePara)]),
    );
    yield r'valoresVerdadeiros';
    yield serializers.serialize(
      object.valoresVerdadeiros,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'valoresFalsos';
    yield serializers.serialize(
      object.valoresFalsos,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegrasNormalizacao object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegrasNormalizacaoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'separadorDecimal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.separadorDecimal = valueDes;
          break;
        case r'unidades':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UnidadeDePara)]),
          ) as BuiltList<UnidadeDePara>;
          result.unidades.replace(valueDes);
          break;
        case r'valoresVerdadeiros':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.valoresVerdadeiros.replace(valueDes);
          break;
        case r'valoresFalsos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.valoresFalsos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegrasNormalizacao deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegrasNormalizacaoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
