//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/etiqueta_rfid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'etiquetas_rfid_geradas.g.dart';

/// EtiquetasRfidGeradas
///
/// Properties:
/// * [produtoId]
/// * [embalagemId]
/// * [gtin]
/// * [etiquetas]
@BuiltValue()
abstract class EtiquetasRfidGeradas implements Built<EtiquetasRfidGeradas, EtiquetasRfidGeradasBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'gtin')
  String get gtin;

  @BuiltValueField(wireName: r'etiquetas')
  BuiltList<EtiquetaRfid> get etiquetas;

  EtiquetasRfidGeradas._();

  factory EtiquetasRfidGeradas([void updates(EtiquetasRfidGeradasBuilder b)]) = _$EtiquetasRfidGeradas;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EtiquetasRfidGeradasBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EtiquetasRfidGeradas> get serializer => _$EtiquetasRfidGeradasSerializer();
}

class _$EtiquetasRfidGeradasSerializer implements PrimitiveSerializer<EtiquetasRfidGeradas> {
  @override
  final Iterable<Type> types = const [EtiquetasRfidGeradas, _$EtiquetasRfidGeradas];

  @override
  final String wireName = r'EtiquetasRfidGeradas';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EtiquetasRfidGeradas object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
      specifiedType: const FullType(String),
    );
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'gtin';
    yield serializers.serialize(
      object.gtin,
      specifiedType: const FullType(String),
    );
    yield r'etiquetas';
    yield serializers.serialize(
      object.etiquetas,
      specifiedType: const FullType(BuiltList, [FullType(EtiquetaRfid)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EtiquetasRfidGeradas object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EtiquetasRfidGeradasBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'gtin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gtin = valueDes;
          break;
        case r'etiquetas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EtiquetaRfid)]),
          ) as BuiltList<EtiquetaRfid>;
          result.etiquetas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EtiquetasRfidGeradas deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EtiquetasRfidGeradasBuilder();
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
