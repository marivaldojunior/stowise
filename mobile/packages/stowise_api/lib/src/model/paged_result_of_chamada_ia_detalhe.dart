//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/chamada_ia_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paged_result_of_chamada_ia_detalhe.g.dart';

/// PagedResultOfChamadaIaDetalhe
///
/// Properties:
/// * [itens]
/// * [pagina]
/// * [tamanhoPagina]
/// * [total]
/// * [totalPaginas]
@BuiltValue()
abstract class PagedResultOfChamadaIaDetalhe
    implements Built<PagedResultOfChamadaIaDetalhe, PagedResultOfChamadaIaDetalheBuilder> {
  @BuiltValueField(wireName: r'itens')
  BuiltList<ChamadaIaDetalhe> get itens;

  @BuiltValueField(wireName: r'pagina')
  int get pagina;

  @BuiltValueField(wireName: r'tamanhoPagina')
  int get tamanhoPagina;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totalPaginas')
  int? get totalPaginas;

  PagedResultOfChamadaIaDetalhe._();

  factory PagedResultOfChamadaIaDetalhe([void updates(PagedResultOfChamadaIaDetalheBuilder b)]) =
      _$PagedResultOfChamadaIaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PagedResultOfChamadaIaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PagedResultOfChamadaIaDetalhe> get serializer => _$PagedResultOfChamadaIaDetalheSerializer();
}

class _$PagedResultOfChamadaIaDetalheSerializer implements PrimitiveSerializer<PagedResultOfChamadaIaDetalhe> {
  @override
  final Iterable<Type> types = const [PagedResultOfChamadaIaDetalhe, _$PagedResultOfChamadaIaDetalhe];

  @override
  final String wireName = r'PagedResultOfChamadaIaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PagedResultOfChamadaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(ChamadaIaDetalhe)]),
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
    PagedResultOfChamadaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PagedResultOfChamadaIaDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChamadaIaDetalhe)]),
          ) as BuiltList<ChamadaIaDetalhe>;
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
  PagedResultOfChamadaIaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PagedResultOfChamadaIaDetalheBuilder();
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
