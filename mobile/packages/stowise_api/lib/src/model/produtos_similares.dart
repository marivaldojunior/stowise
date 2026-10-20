//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/metodo_similaridade.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/produto_similar.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'produtos_similares.g.dart';

/// ProdutosSimilares
///
/// Properties:
/// * [metodo]
/// * [produtos]
@BuiltValue()
abstract class ProdutosSimilares implements Built<ProdutosSimilares, ProdutosSimilaresBuilder> {
  @BuiltValueField(wireName: r'metodo')
  MetodoSimilaridade get metodo;
  // enum metodoEnum {  Semantica,  Trigramas,  };

  @BuiltValueField(wireName: r'produtos')
  BuiltList<ProdutoSimilar> get produtos;

  ProdutosSimilares._();

  factory ProdutosSimilares([void updates(ProdutosSimilaresBuilder b)]) = _$ProdutosSimilares;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProdutosSimilaresBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProdutosSimilares> get serializer => _$ProdutosSimilaresSerializer();
}

class _$ProdutosSimilaresSerializer implements PrimitiveSerializer<ProdutosSimilares> {
  @override
  final Iterable<Type> types = const [ProdutosSimilares, _$ProdutosSimilares];

  @override
  final String wireName = r'ProdutosSimilares';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProdutosSimilares object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'metodo';
    yield serializers.serialize(
      object.metodo,
      specifiedType: const FullType(MetodoSimilaridade),
    );
    yield r'produtos';
    yield serializers.serialize(
      object.produtos,
      specifiedType: const FullType(BuiltList, [FullType(ProdutoSimilar)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProdutosSimilares object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProdutosSimilaresBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metodo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MetodoSimilaridade),
          ) as MetodoSimilaridade;
          result.metodo = valueDes;
          break;
        case r'produtos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProdutoSimilar)]),
          ) as BuiltList<ProdutoSimilar>;
          result.produtos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProdutosSimilares deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProdutosSimilaresBuilder();
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
