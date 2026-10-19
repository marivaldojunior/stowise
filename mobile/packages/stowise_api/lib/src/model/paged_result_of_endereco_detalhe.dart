//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/endereco_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paged_result_of_endereco_detalhe.g.dart';

/// PagedResultOfEnderecoDetalhe
///
/// Properties:
/// * [itens]
/// * [pagina]
/// * [tamanhoPagina]
/// * [total]
/// * [totalPaginas]
@BuiltValue()
abstract class PagedResultOfEnderecoDetalhe
    implements Built<PagedResultOfEnderecoDetalhe, PagedResultOfEnderecoDetalheBuilder> {
  @BuiltValueField(wireName: r'itens')
  BuiltList<EnderecoDetalhe> get itens;

  @BuiltValueField(wireName: r'pagina')
  int get pagina;

  @BuiltValueField(wireName: r'tamanhoPagina')
  int get tamanhoPagina;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totalPaginas')
  int? get totalPaginas;

  PagedResultOfEnderecoDetalhe._();

  factory PagedResultOfEnderecoDetalhe([void updates(PagedResultOfEnderecoDetalheBuilder b)]) =
      _$PagedResultOfEnderecoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PagedResultOfEnderecoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PagedResultOfEnderecoDetalhe> get serializer => _$PagedResultOfEnderecoDetalheSerializer();
}

class _$PagedResultOfEnderecoDetalheSerializer implements PrimitiveSerializer<PagedResultOfEnderecoDetalhe> {
  @override
  final Iterable<Type> types = const [PagedResultOfEnderecoDetalhe, _$PagedResultOfEnderecoDetalhe];

  @override
  final String wireName = r'PagedResultOfEnderecoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PagedResultOfEnderecoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(EnderecoDetalhe)]),
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
    PagedResultOfEnderecoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PagedResultOfEnderecoDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EnderecoDetalhe)]),
          ) as BuiltList<EnderecoDetalhe>;
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
  PagedResultOfEnderecoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PagedResultOfEnderecoDetalheBuilder();
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
