//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'leitura_rfid.g.dart';

/// LeituraRfid
///
/// Properties:
/// * [epc]
/// * [gtin]
/// * [serie]
/// * [produtoId]
/// * [embalagemId]
@BuiltValue()
abstract class LeituraRfid implements Built<LeituraRfid, LeituraRfidBuilder> {
  @BuiltValueField(wireName: r'epc')
  String get epc;

  @BuiltValueField(wireName: r'gtin')
  String? get gtin;

  @BuiltValueField(wireName: r'serie')
  int? get serie;

  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  LeituraRfid._();

  factory LeituraRfid([void updates(LeituraRfidBuilder b)]) = _$LeituraRfid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LeituraRfidBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LeituraRfid> get serializer => _$LeituraRfidSerializer();
}

class _$LeituraRfidSerializer implements PrimitiveSerializer<LeituraRfid> {
  @override
  final Iterable<Type> types = const [LeituraRfid, _$LeituraRfid];

  @override
  final String wireName = r'LeituraRfid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LeituraRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'epc';
    yield serializers.serialize(
      object.epc,
      specifiedType: const FullType(String),
    );
    yield r'gtin';
    yield object.gtin == null
        ? null
        : serializers.serialize(
            object.gtin,
            specifiedType: const FullType.nullable(String),
          );
    yield r'serie';
    yield object.serie == null
        ? null
        : serializers.serialize(
            object.serie,
            specifiedType: const FullType.nullable(int),
          );
    yield r'produtoId';
    yield object.produtoId == null
        ? null
        : serializers.serialize(
            object.produtoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'embalagemId';
    yield object.embalagemId == null
        ? null
        : serializers.serialize(
            object.embalagemId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    LeituraRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LeituraRfidBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'epc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.epc = valueDes;
          break;
        case r'gtin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gtin = valueDes;
          break;
        case r'serie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.serie = valueDes;
          break;
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoId = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.embalagemId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LeituraRfid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LeituraRfidBuilder();
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
