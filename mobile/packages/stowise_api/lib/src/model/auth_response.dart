//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/usuario_resumo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_response.g.dart';

/// AuthResponse
///
/// Properties:
/// * [accessToken]
/// * [accessTokenExpiresAt]
/// * [refreshToken]
/// * [refreshTokenExpiresAt]
/// * [usuario]
@BuiltValue()
abstract class AuthResponse implements Built<AuthResponse, AuthResponseBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'accessTokenExpiresAt')
  DateTime get accessTokenExpiresAt;

  @BuiltValueField(wireName: r'refreshToken')
  String? get refreshToken;

  @BuiltValueField(wireName: r'refreshTokenExpiresAt')
  DateTime get refreshTokenExpiresAt;

  @BuiltValueField(wireName: r'usuario')
  UsuarioResumo get usuario;

  AuthResponse._();

  factory AuthResponse([void updates(AuthResponseBuilder b)]) = _$AuthResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthResponse> get serializer => _$AuthResponseSerializer();
}

class _$AuthResponseSerializer implements PrimitiveSerializer<AuthResponse> {
  @override
  final Iterable<Type> types = const [AuthResponse, _$AuthResponse];

  @override
  final String wireName = r'AuthResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'accessTokenExpiresAt';
    yield serializers.serialize(
      object.accessTokenExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'refreshToken';
    yield object.refreshToken == null
        ? null
        : serializers.serialize(
            object.refreshToken,
            specifiedType: const FullType.nullable(String),
          );
    yield r'refreshTokenExpiresAt';
    yield serializers.serialize(
      object.refreshTokenExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'usuario';
    yield serializers.serialize(
      object.usuario,
      specifiedType: const FullType(UsuarioResumo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'accessTokenExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.accessTokenExpiresAt = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refreshToken = valueDes;
          break;
        case r'refreshTokenExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.refreshTokenExpiresAt = valueDes;
          break;
        case r'usuario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UsuarioResumo),
          ) as UsuarioResumo;
          result.usuario.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthResponseBuilder();
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
