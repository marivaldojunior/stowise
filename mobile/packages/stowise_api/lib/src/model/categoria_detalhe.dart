//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'categoria_detalhe.g.dart';

/// CategoriaDetalhe
///
/// Properties:
/// * [id]
/// * [nome]
/// * [parentId]
/// * [caminho]
@BuiltValue()
abstract class CategoriaDetalhe implements Built<CategoriaDetalhe, CategoriaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  @BuiltValueField(wireName: r'caminho')
  String get caminho;

  CategoriaDetalhe._();

  factory CategoriaDetalhe([void updates(CategoriaDetalheBuilder b)]) = _$CategoriaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CategoriaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CategoriaDetalhe> get serializer => _$CategoriaDetalheSerializer();
}

class _$CategoriaDetalheSerializer implements PrimitiveSerializer<CategoriaDetalhe> {
  @override
  final Iterable<Type> types = const [CategoriaDetalhe, _$CategoriaDetalhe];

  @override
  final String wireName = r'CategoriaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CategoriaDetalhe object, {
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
    yield r'parentId';
    yield object.parentId == null
        ? null
        : serializers.serialize(
            object.parentId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'caminho';
    yield serializers.serialize(
      object.caminho,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CategoriaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CategoriaDetalheBuilder result,
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
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'caminho':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.caminho = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CategoriaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CategoriaDetalheBuilder();
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
