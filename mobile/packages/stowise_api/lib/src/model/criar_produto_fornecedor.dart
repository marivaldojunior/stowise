//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_produto_fornecedor.g.dart';

/// CriarProdutoFornecedor
///
/// Properties:
/// * [codigoFornecedor]
/// * [produtoId]
/// * [embalagemId]
/// * [unidadeFornecedor]
/// * [fatorConversao]
@BuiltValue()
abstract class CriarProdutoFornecedor implements Built<CriarProdutoFornecedor, CriarProdutoFornecedorBuilder> {
  @BuiltValueField(wireName: r'codigoFornecedor')
  String? get codigoFornecedor;

  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'unidadeFornecedor')
  String? get unidadeFornecedor;

  @BuiltValueField(wireName: r'fatorConversao')
  double? get fatorConversao;

  CriarProdutoFornecedor._();

  factory CriarProdutoFornecedor([void updates(CriarProdutoFornecedorBuilder b)]) = _$CriarProdutoFornecedor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarProdutoFornecedorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarProdutoFornecedor> get serializer => _$CriarProdutoFornecedorSerializer();
}

class _$CriarProdutoFornecedorSerializer implements PrimitiveSerializer<CriarProdutoFornecedor> {
  @override
  final Iterable<Type> types = const [CriarProdutoFornecedor, _$CriarProdutoFornecedor];

  @override
  final String wireName = r'CriarProdutoFornecedor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarProdutoFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codigoFornecedor';
    yield object.codigoFornecedor == null
        ? null
        : serializers.serialize(
            object.codigoFornecedor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'produtoId';
    yield object.produtoId == null
        ? null
        : serializers.serialize(
            object.produtoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'embalagemId';
    yield object.embalagemId == null
        ? null
        : serializers.serialize(
            object.embalagemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'unidadeFornecedor';
    yield object.unidadeFornecedor == null
        ? null
        : serializers.serialize(
            object.unidadeFornecedor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'fatorConversao';
    yield object.fatorConversao == null
        ? null
        : serializers.serialize(
            object.fatorConversao,
            specifiedType: const FullType.nullable(double),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CriarProdutoFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarProdutoFornecedorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codigoFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codigoFornecedor = valueDes;
          break;
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoId = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.embalagemId = valueDes;
          break;
        case r'unidadeFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unidadeFornecedor = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fatorConversao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CriarProdutoFornecedor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarProdutoFornecedorBuilder();
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
