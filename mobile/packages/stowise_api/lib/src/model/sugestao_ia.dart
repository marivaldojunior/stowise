//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/coluna_sugerida.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/regras_normalizacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sugestao_ia.g.dart';

/// SugestaoIa
///
/// Properties:
/// * [colunas]
/// * [regras]
/// * [observacao]
/// * [chamadaIaId]
@BuiltValue()
abstract class SugestaoIa implements Built<SugestaoIa, SugestaoIaBuilder> {
  @BuiltValueField(wireName: r'colunas')
  BuiltList<ColunaSugerida> get colunas;

  @BuiltValueField(wireName: r'regras')
  RegrasNormalizacao get regras;

  @BuiltValueField(wireName: r'observacao')
  String? get observacao;

  @BuiltValueField(wireName: r'chamadaIaId')
  String? get chamadaIaId;

  SugestaoIa._();

  factory SugestaoIa([void updates(SugestaoIaBuilder b)]) = _$SugestaoIa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SugestaoIaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SugestaoIa> get serializer => _$SugestaoIaSerializer();
}

class _$SugestaoIaSerializer implements PrimitiveSerializer<SugestaoIa> {
  @override
  final Iterable<Type> types = const [SugestaoIa, _$SugestaoIa];

  @override
  final String wireName = r'SugestaoIa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SugestaoIa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'colunas';
    yield serializers.serialize(
      object.colunas,
      specifiedType: const FullType(BuiltList, [FullType(ColunaSugerida)]),
    );
    yield r'regras';
    yield serializers.serialize(
      object.regras,
      specifiedType: const FullType(RegrasNormalizacao),
    );
    yield r'observacao';
    yield object.observacao == null
        ? null
        : serializers.serialize(
            object.observacao,
            specifiedType: const FullType.nullable(String),
          );
    yield r'chamadaIaId';
    yield object.chamadaIaId == null
        ? null
        : serializers.serialize(
            object.chamadaIaId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SugestaoIa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SugestaoIaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'colunas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ColunaSugerida)]),
          ) as BuiltList<ColunaSugerida>;
          result.colunas.replace(valueDes);
          break;
        case r'regras':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegrasNormalizacao),
          ) as RegrasNormalizacao;
          result.regras.replace(valueDes);
          break;
        case r'observacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.observacao = valueDes;
          break;
        case r'chamadaIaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.chamadaIaId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SugestaoIa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SugestaoIaBuilder();
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
