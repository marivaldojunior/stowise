//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'etiqueta_rfid.g.dart';

/// EtiquetaRfid
///
/// Properties:
/// * [epc]
/// * [epcUri]
/// * [serie]
@BuiltValue()
abstract class EtiquetaRfid implements Built<EtiquetaRfid, EtiquetaRfidBuilder> {
  @BuiltValueField(wireName: r'epc')
  String get epc;

  @BuiltValueField(wireName: r'epcUri')
  String get epcUri;

  @BuiltValueField(wireName: r'serie')
  int get serie;

  EtiquetaRfid._();

  factory EtiquetaRfid([void updates(EtiquetaRfidBuilder b)]) = _$EtiquetaRfid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EtiquetaRfidBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EtiquetaRfid> get serializer => _$EtiquetaRfidSerializer();
}

class _$EtiquetaRfidSerializer implements PrimitiveSerializer<EtiquetaRfid> {
  @override
  final Iterable<Type> types = const [EtiquetaRfid, _$EtiquetaRfid];

  @override
  final String wireName = r'EtiquetaRfid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EtiquetaRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'epc';
    yield serializers.serialize(
      object.epc,
      specifiedType: const FullType(String),
    );
    yield r'epcUri';
    yield serializers.serialize(
      object.epcUri,
      specifiedType: const FullType(String),
    );
    yield r'serie';
    yield serializers.serialize(
      object.serie,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EtiquetaRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EtiquetaRfidBuilder result,
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
        case r'epcUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.epcUri = valueDes;
          break;
        case r'serie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.serie = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EtiquetaRfid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EtiquetaRfidBuilder();
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
