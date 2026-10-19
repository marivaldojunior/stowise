//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_usuario_request.g.dart';

/// CriarUsuarioRequest
///
/// Properties:
/// * [nome]
/// * [email]
/// * [senha]
/// * [perfis]
@BuiltValue()
abstract class CriarUsuarioRequest implements Built<CriarUsuarioRequest, CriarUsuarioRequestBuilder> {
  @BuiltValueField(wireName: r'nome')
  String? get nome;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'senha')
  String? get senha;

  @BuiltValueField(wireName: r'perfis')
  BuiltList<String>? get perfis;

  CriarUsuarioRequest._();

  factory CriarUsuarioRequest([void updates(CriarUsuarioRequestBuilder b)]) = _$CriarUsuarioRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarUsuarioRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarUsuarioRequest> get serializer => _$CriarUsuarioRequestSerializer();
}

class _$CriarUsuarioRequestSerializer implements PrimitiveSerializer<CriarUsuarioRequest> {
  @override
  final Iterable<Type> types = const [CriarUsuarioRequest, _$CriarUsuarioRequest];

  @override
  final String wireName = r'CriarUsuarioRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarUsuarioRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield object.nome == null
        ? null
        : serializers.serialize(
            object.nome,
            specifiedType: const FullType.nullable(String),
          );
    yield r'email';
    yield object.email == null
        ? null
        : serializers.serialize(
            object.email,
            specifiedType: const FullType.nullable(String),
          );
    yield r'senha';
    yield object.senha == null
        ? null
        : serializers.serialize(
            object.senha,
            specifiedType: const FullType.nullable(String),
          );
    yield r'perfis';
    yield object.perfis == null
        ? null
        : serializers.serialize(
            object.perfis,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CriarUsuarioRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarUsuarioRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nome = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'senha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.senha = valueDes;
          break;
        case r'perfis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.perfis.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CriarUsuarioRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarUsuarioRequestBuilder();
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
