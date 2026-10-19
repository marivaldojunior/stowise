//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salvar_categoria.g.dart';

/// SalvarCategoria
///
/// Properties:
/// * [nome]
/// * [parentId]
@BuiltValue()
abstract class SalvarCategoria implements Built<SalvarCategoria, SalvarCategoriaBuilder> {
  @BuiltValueField(wireName: r'nome')
  String? get nome;

  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  SalvarCategoria._();

  factory SalvarCategoria([void updates(SalvarCategoriaBuilder b)]) = _$SalvarCategoria;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalvarCategoriaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalvarCategoria> get serializer => _$SalvarCategoriaSerializer();
}

class _$SalvarCategoriaSerializer implements PrimitiveSerializer<SalvarCategoria> {
  @override
  final Iterable<Type> types = const [SalvarCategoria, _$SalvarCategoria];

  @override
  final String wireName = r'SalvarCategoria';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalvarCategoria object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield object.nome == null
        ? null
        : serializers.serialize(
            object.nome,
            specifiedType: const FullType.nullable(String),
          );
    yield r'parentId';
    yield object.parentId == null
        ? null
        : serializers.serialize(
            object.parentId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalvarCategoria object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalvarCategoriaBuilder result,
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
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalvarCategoria deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalvarCategoriaBuilder();
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
