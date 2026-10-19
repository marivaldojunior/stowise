//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/importacao_resumo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paged_result_of_importacao_resumo.g.dart';

/// PagedResultOfImportacaoResumo
///
/// Properties:
/// * [itens]
/// * [pagina]
/// * [tamanhoPagina]
/// * [total]
/// * [totalPaginas]
@BuiltValue()
abstract class PagedResultOfImportacaoResumo
    implements Built<PagedResultOfImportacaoResumo, PagedResultOfImportacaoResumoBuilder> {
  @BuiltValueField(wireName: r'itens')
  BuiltList<ImportacaoResumo> get itens;

  @BuiltValueField(wireName: r'pagina')
  int get pagina;

  @BuiltValueField(wireName: r'tamanhoPagina')
  int get tamanhoPagina;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totalPaginas')
  int? get totalPaginas;

  PagedResultOfImportacaoResumo._();

  factory PagedResultOfImportacaoResumo([void updates(PagedResultOfImportacaoResumoBuilder b)]) =
      _$PagedResultOfImportacaoResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PagedResultOfImportacaoResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PagedResultOfImportacaoResumo> get serializer => _$PagedResultOfImportacaoResumoSerializer();
}

class _$PagedResultOfImportacaoResumoSerializer implements PrimitiveSerializer<PagedResultOfImportacaoResumo> {
  @override
  final Iterable<Type> types = const [PagedResultOfImportacaoResumo, _$PagedResultOfImportacaoResumo];

  @override
  final String wireName = r'PagedResultOfImportacaoResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PagedResultOfImportacaoResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(ImportacaoResumo)]),
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
    PagedResultOfImportacaoResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PagedResultOfImportacaoResumoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImportacaoResumo)]),
          ) as BuiltList<ImportacaoResumo>;
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
  PagedResultOfImportacaoResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PagedResultOfImportacaoResumoBuilder();
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
