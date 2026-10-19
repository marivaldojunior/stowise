//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'atualizar_usuario_request.g.dart';

/// AtualizarUsuarioRequest
///
/// Properties:
/// * [nome]
/// * [perfis]
@BuiltValue()
abstract class AtualizarUsuarioRequest implements Built<AtualizarUsuarioRequest, AtualizarUsuarioRequestBuilder> {
  @BuiltValueField(wireName: r'nome')
  String? get nome;

  @BuiltValueField(wireName: r'perfis')
  BuiltList<String>? get perfis;

  AtualizarUsuarioRequest._();

  factory AtualizarUsuarioRequest([void updates(AtualizarUsuarioRequestBuilder b)]) = _$AtualizarUsuarioRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AtualizarUsuarioRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AtualizarUsuarioRequest> get serializer => _$AtualizarUsuarioRequestSerializer();
}

class _$AtualizarUsuarioRequestSerializer implements PrimitiveSerializer<AtualizarUsuarioRequest> {
  @override
  final Iterable<Type> types = const [AtualizarUsuarioRequest, _$AtualizarUsuarioRequest];

  @override
  final String wireName = r'AtualizarUsuarioRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AtualizarUsuarioRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield object.nome == null
        ? null
        : serializers.serialize(
            object.nome,
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
    AtualizarUsuarioRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AtualizarUsuarioRequestBuilder result,
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
  AtualizarUsuarioRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AtualizarUsuarioRequestBuilder();
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
