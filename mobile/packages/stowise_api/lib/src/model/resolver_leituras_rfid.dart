//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resolver_leituras_rfid.g.dart';

/// ResolverLeiturasRfid
///
/// Properties:
/// * [epcs]
@BuiltValue()
abstract class ResolverLeiturasRfid implements Built<ResolverLeiturasRfid, ResolverLeiturasRfidBuilder> {
  @BuiltValueField(wireName: r'epcs')
  BuiltList<String>? get epcs;

  ResolverLeiturasRfid._();

  factory ResolverLeiturasRfid([void updates(ResolverLeiturasRfidBuilder b)]) = _$ResolverLeiturasRfid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResolverLeiturasRfidBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResolverLeiturasRfid> get serializer => _$ResolverLeiturasRfidSerializer();
}

class _$ResolverLeiturasRfidSerializer implements PrimitiveSerializer<ResolverLeiturasRfid> {
  @override
  final Iterable<Type> types = const [ResolverLeiturasRfid, _$ResolverLeiturasRfid];

  @override
  final String wireName = r'ResolverLeiturasRfid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResolverLeiturasRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'epcs';
    yield object.epcs == null
        ? null
        : serializers.serialize(
            object.epcs,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResolverLeiturasRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResolverLeiturasRfidBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'epcs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.epcs.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResolverLeiturasRfid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResolverLeiturasRfidBuilder();
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
