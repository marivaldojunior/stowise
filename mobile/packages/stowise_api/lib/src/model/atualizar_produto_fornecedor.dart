//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'atualizar_produto_fornecedor.g.dart';

/// AtualizarProdutoFornecedor
///
/// Properties:
/// * [produtoId]
/// * [embalagemId]
/// * [unidadeFornecedor]
/// * [fatorConversao]
/// * [versao]
@BuiltValue()
abstract class AtualizarProdutoFornecedor
    implements Built<AtualizarProdutoFornecedor, AtualizarProdutoFornecedorBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'unidadeFornecedor')
  String? get unidadeFornecedor;

  @BuiltValueField(wireName: r'fatorConversao')
  double? get fatorConversao;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AtualizarProdutoFornecedor._();

  factory AtualizarProdutoFornecedor([void updates(AtualizarProdutoFornecedorBuilder b)]) =
      _$AtualizarProdutoFornecedor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AtualizarProdutoFornecedorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AtualizarProdutoFornecedor> get serializer => _$AtualizarProdutoFornecedorSerializer();
}

class _$AtualizarProdutoFornecedorSerializer implements PrimitiveSerializer<AtualizarProdutoFornecedor> {
  @override
  final Iterable<Type> types = const [AtualizarProdutoFornecedor, _$AtualizarProdutoFornecedor];

  @override
  final String wireName = r'AtualizarProdutoFornecedor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AtualizarProdutoFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'versao';
    yield object.versao == null
        ? null
        : serializers.serialize(
            object.versao,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AtualizarProdutoFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AtualizarProdutoFornecedorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.versao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AtualizarProdutoFornecedor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AtualizarProdutoFornecedorBuilder();
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
