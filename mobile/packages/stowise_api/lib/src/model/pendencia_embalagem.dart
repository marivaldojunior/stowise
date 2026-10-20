//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_embalagem.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pendencia_embalagem.g.dart';

/// PendenciaEmbalagem
///
/// Properties:
/// * [embalagemId]
/// * [tipo]
/// * [fatorConversao]
/// * [gtin]
/// * [faltando]
@BuiltValue()
abstract class PendenciaEmbalagem implements Built<PendenciaEmbalagem, PendenciaEmbalagemBuilder> {
  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'tipo')
  TipoEmbalagem get tipo;
  // enum tipoEnum {  Unidade,  Caixa,  Palete,  };

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'gtin')
  String? get gtin;

  @BuiltValueField(wireName: r'faltando')
  BuiltList<String> get faltando;

  PendenciaEmbalagem._();

  factory PendenciaEmbalagem([void updates(PendenciaEmbalagemBuilder b)]) = _$PendenciaEmbalagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PendenciaEmbalagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PendenciaEmbalagem> get serializer => _$PendenciaEmbalagemSerializer();
}

class _$PendenciaEmbalagemSerializer implements PrimitiveSerializer<PendenciaEmbalagem> {
  @override
  final Iterable<Type> types = const [PendenciaEmbalagem, _$PendenciaEmbalagem];

  @override
  final String wireName = r'PendenciaEmbalagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PendenciaEmbalagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'tipo';
    yield serializers.serialize(
      object.tipo,
      specifiedType: const FullType(TipoEmbalagem),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'gtin';
    yield object.gtin == null
        ? null
        : serializers.serialize(
            object.gtin,
            specifiedType: const FullType.nullable(String),
          );
    yield r'faltando';
    yield serializers.serialize(
      object.faltando,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PendenciaEmbalagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PendenciaEmbalagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoEmbalagem),
          ) as TipoEmbalagem;
          result.tipo = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'gtin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gtin = valueDes;
          break;
        case r'faltando':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.faltando.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PendenciaEmbalagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PendenciaEmbalagemBuilder();
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
