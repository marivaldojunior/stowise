//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'usuario_resumo.g.dart';

/// UsuarioResumo
///
/// Properties:
/// * [id]
/// * [nome]
/// * [email]
/// * [perfis]
@BuiltValue()
abstract class UsuarioResumo implements Built<UsuarioResumo, UsuarioResumoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'perfis')
  BuiltList<String> get perfis;

  UsuarioResumo._();

  factory UsuarioResumo([void updates(UsuarioResumoBuilder b)]) = _$UsuarioResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsuarioResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsuarioResumo> get serializer => _$UsuarioResumoSerializer();
}

class _$UsuarioResumoSerializer implements PrimitiveSerializer<UsuarioResumo> {
  @override
  final Iterable<Type> types = const [UsuarioResumo, _$UsuarioResumo];

  @override
  final String wireName = r'UsuarioResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsuarioResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nome';
    yield serializers.serialize(
      object.nome,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'perfis';
    yield serializers.serialize(
      object.perfis,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UsuarioResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsuarioResumoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nome = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'perfis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
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
  UsuarioResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsuarioResumoBuilder();
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
