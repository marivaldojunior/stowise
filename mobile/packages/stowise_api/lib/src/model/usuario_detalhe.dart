//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'usuario_detalhe.g.dart';

/// UsuarioDetalhe
///
/// Properties:
/// * [id]
/// * [nome]
/// * [email]
/// * [perfis]
/// * [ativo]
/// * [bloqueado]
/// * [criadoEm]
@BuiltValue()
abstract class UsuarioDetalhe implements Built<UsuarioDetalhe, UsuarioDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'perfis')
  BuiltList<String> get perfis;

  @BuiltValueField(wireName: r'ativo')
  bool get ativo;

  @BuiltValueField(wireName: r'bloqueado')
  bool get bloqueado;

  @BuiltValueField(wireName: r'criadoEm')
  DateTime get criadoEm;

  UsuarioDetalhe._();

  factory UsuarioDetalhe([void updates(UsuarioDetalheBuilder b)]) = _$UsuarioDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsuarioDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsuarioDetalhe> get serializer => _$UsuarioDetalheSerializer();
}

class _$UsuarioDetalheSerializer implements PrimitiveSerializer<UsuarioDetalhe> {
  @override
  final Iterable<Type> types = const [UsuarioDetalhe, _$UsuarioDetalhe];

  @override
  final String wireName = r'UsuarioDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsuarioDetalhe object, {
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
    yield r'ativo';
    yield serializers.serialize(
      object.ativo,
      specifiedType: const FullType(bool),
    );
    yield r'bloqueado';
    yield serializers.serialize(
      object.bloqueado,
      specifiedType: const FullType(bool),
    );
    yield r'criadoEm';
    yield serializers.serialize(
      object.criadoEm,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UsuarioDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsuarioDetalheBuilder result,
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
        case r'ativo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ativo = valueDes;
          break;
        case r'bloqueado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bloqueado = valueDes;
          break;
        case r'criadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.criadoEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsuarioDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsuarioDetalheBuilder();
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
