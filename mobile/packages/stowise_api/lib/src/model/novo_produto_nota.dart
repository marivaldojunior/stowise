//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'novo_produto_nota.g.dart';

/// NovoProdutoNota
///
/// Properties:
/// * [sku]
/// * [descricao]
/// * [categoriaId]
/// * [classeArmazenagem]
@BuiltValue()
abstract class NovoProdutoNota implements Built<NovoProdutoNota, NovoProdutoNotaBuilder> {
  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'descricao')
  String? get descricao;

  @BuiltValueField(wireName: r'categoriaId')
  String? get categoriaId;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem? get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  NovoProdutoNota._();

  factory NovoProdutoNota([void updates(NovoProdutoNotaBuilder b)]) = _$NovoProdutoNota;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NovoProdutoNotaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NovoProdutoNota> get serializer => _$NovoProdutoNotaSerializer();
}

class _$NovoProdutoNotaSerializer implements PrimitiveSerializer<NovoProdutoNota> {
  @override
  final Iterable<Type> types = const [NovoProdutoNota, _$NovoProdutoNota];

  @override
  final String wireName = r'NovoProdutoNota';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NovoProdutoNota object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sku';
    yield object.sku == null
        ? null
        : serializers.serialize(
            object.sku,
            specifiedType: const FullType.nullable(String),
          );
    yield r'descricao';
    yield object.descricao == null
        ? null
        : serializers.serialize(
            object.descricao,
            specifiedType: const FullType.nullable(String),
          );
    yield r'categoriaId';
    yield object.categoriaId == null
        ? null
        : serializers.serialize(
            object.categoriaId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'classeArmazenagem';
    yield object.classeArmazenagem == null
        ? null
        : serializers.serialize(
            object.classeArmazenagem,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    NovoProdutoNota object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NovoProdutoNotaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sku = valueDes;
          break;
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.descricao = valueDes;
          break;
        case r'categoriaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoriaId = valueDes;
          break;
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          ) as ClasseArmazenagem?;
          if (valueDes == null) continue;
          result.classeArmazenagem = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NovoProdutoNota deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NovoProdutoNotaBuilder();
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
