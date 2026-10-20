//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/produto_fornecedor_detalhe.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paged_result_of_produto_fornecedor_detalhe.g.dart';

/// PagedResultOfProdutoFornecedorDetalhe
///
/// Properties:
/// * [itens]
/// * [pagina]
/// * [tamanhoPagina]
/// * [total]
/// * [totalPaginas]
@BuiltValue()
abstract class PagedResultOfProdutoFornecedorDetalhe
    implements Built<PagedResultOfProdutoFornecedorDetalhe, PagedResultOfProdutoFornecedorDetalheBuilder> {
  @BuiltValueField(wireName: r'itens')
  BuiltList<ProdutoFornecedorDetalhe> get itens;

  @BuiltValueField(wireName: r'pagina')
  int get pagina;

  @BuiltValueField(wireName: r'tamanhoPagina')
  int get tamanhoPagina;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totalPaginas')
  int? get totalPaginas;

  PagedResultOfProdutoFornecedorDetalhe._();

  factory PagedResultOfProdutoFornecedorDetalhe([void updates(PagedResultOfProdutoFornecedorDetalheBuilder b)]) =
      _$PagedResultOfProdutoFornecedorDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PagedResultOfProdutoFornecedorDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PagedResultOfProdutoFornecedorDetalhe> get serializer =>
      _$PagedResultOfProdutoFornecedorDetalheSerializer();
}

class _$PagedResultOfProdutoFornecedorDetalheSerializer
    implements PrimitiveSerializer<PagedResultOfProdutoFornecedorDetalhe> {
  @override
  final Iterable<Type> types = const [PagedResultOfProdutoFornecedorDetalhe, _$PagedResultOfProdutoFornecedorDetalhe];

  @override
  final String wireName = r'PagedResultOfProdutoFornecedorDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PagedResultOfProdutoFornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(ProdutoFornecedorDetalhe)]),
    );
    yield r'pagina';
    yield serializers.serialize(
      object.pagina,
      specifiedType: const FullType(int),
    );
    yield r'tamanhoPagina';
    yield serializers.serialize(
      object.tamanhoPagina,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    if (object.totalPaginas != null) {
      yield r'totalPaginas';
      yield serializers.serialize(
        object.totalPaginas,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PagedResultOfProdutoFornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PagedResultOfProdutoFornecedorDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProdutoFornecedorDetalhe)]),
          ) as BuiltList<ProdutoFornecedorDetalhe>;
          result.itens.replace(valueDes);
          break;
        case r'pagina':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pagina = valueDes;
          break;
        case r'tamanhoPagina':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tamanhoPagina = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'totalPaginas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPaginas = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PagedResultOfProdutoFornecedorDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PagedResultOfProdutoFornecedorDetalheBuilder();
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
