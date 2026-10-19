//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/produto_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'produto_por_codigo.g.dart';

/// ProdutoPorCodigo
///
/// Properties:
/// * [produto]
/// * [embalagemId]
@BuiltValue()
abstract class ProdutoPorCodigo implements Built<ProdutoPorCodigo, ProdutoPorCodigoBuilder> {
  @BuiltValueField(wireName: r'produto')
  ProdutoDetalhe get produto;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  ProdutoPorCodigo._();

  factory ProdutoPorCodigo([void updates(ProdutoPorCodigoBuilder b)]) = _$ProdutoPorCodigo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProdutoPorCodigoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProdutoPorCodigo> get serializer => _$ProdutoPorCodigoSerializer();
}

class _$ProdutoPorCodigoSerializer implements PrimitiveSerializer<ProdutoPorCodigo> {
  @override
  final Iterable<Type> types = const [ProdutoPorCodigo, _$ProdutoPorCodigo];

  @override
  final String wireName = r'ProdutoPorCodigo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProdutoPorCodigo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produto';
    yield serializers.serialize(
      object.produto,
      specifiedType: const FullType(ProdutoDetalhe),
    );
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProdutoPorCodigo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProdutoPorCodigoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProdutoDetalhe),
          ) as ProdutoDetalhe;
          result.produto.replace(valueDes);
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProdutoPorCodigo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProdutoPorCodigoBuilder();
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
