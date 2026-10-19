//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/usuario_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paged_result_of_usuario_detalhe.g.dart';

/// PagedResultOfUsuarioDetalhe
///
/// Properties:
/// * [itens]
/// * [pagina]
/// * [tamanhoPagina]
/// * [total]
/// * [totalPaginas]
@BuiltValue()
abstract class PagedResultOfUsuarioDetalhe
    implements Built<PagedResultOfUsuarioDetalhe, PagedResultOfUsuarioDetalheBuilder> {
  @BuiltValueField(wireName: r'itens')
  BuiltList<UsuarioDetalhe> get itens;

  @BuiltValueField(wireName: r'pagina')
  int get pagina;

  @BuiltValueField(wireName: r'tamanhoPagina')
  int get tamanhoPagina;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totalPaginas')
  int? get totalPaginas;

  PagedResultOfUsuarioDetalhe._();

  factory PagedResultOfUsuarioDetalhe([void updates(PagedResultOfUsuarioDetalheBuilder b)]) =
      _$PagedResultOfUsuarioDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PagedResultOfUsuarioDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PagedResultOfUsuarioDetalhe> get serializer => _$PagedResultOfUsuarioDetalheSerializer();
}

class _$PagedResultOfUsuarioDetalheSerializer implements PrimitiveSerializer<PagedResultOfUsuarioDetalhe> {
  @override
  final Iterable<Type> types = const [PagedResultOfUsuarioDetalhe, _$PagedResultOfUsuarioDetalhe];

  @override
  final String wireName = r'PagedResultOfUsuarioDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PagedResultOfUsuarioDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(UsuarioDetalhe)]),
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
    PagedResultOfUsuarioDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PagedResultOfUsuarioDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UsuarioDetalhe)]),
          ) as BuiltList<UsuarioDetalhe>;
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
  PagedResultOfUsuarioDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PagedResultOfUsuarioDetalheBuilder();
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
