//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'refresh_request.g.dart';

/// RefreshRequest
///
/// Properties:
/// * [refreshToken]
/// * [useCookie]
@BuiltValue()
abstract class RefreshRequest implements Built<RefreshRequest, RefreshRequestBuilder> {
  @BuiltValueField(wireName: r'refreshToken')
  String? get refreshToken;

  @BuiltValueField(wireName: r'useCookie')
  bool? get useCookie;

  RefreshRequest._();

  factory RefreshRequest([void updates(RefreshRequestBuilder b)]) = _$RefreshRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RefreshRequestBuilder b) => b..useCookie = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<RefreshRequest> get serializer => _$RefreshRequestSerializer();
}

class _$RefreshRequestSerializer implements PrimitiveSerializer<RefreshRequest> {
  @override
  final Iterable<Type> types = const [RefreshRequest, _$RefreshRequest];

  @override
  final String wireName = r'RefreshRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refreshToken';
    yield object.refreshToken == null
        ? null
        : serializers.serialize(
            object.refreshToken,
            specifiedType: const FullType.nullable(String),
          );
    if (object.useCookie != null) {
      yield r'useCookie';
      yield serializers.serialize(
        object.useCookie,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RefreshRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refreshToken = valueDes;
          break;
        case r'useCookie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.useCookie = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RefreshRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RefreshRequestBuilder();
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
