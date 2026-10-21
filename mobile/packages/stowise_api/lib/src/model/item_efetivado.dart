//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_efetivado.g.dart';

/// ItemEfetivado
///
/// Properties:
/// * [numeroItem]
/// * [produtoId]
/// * [embalagemId]
/// * [produtoFornecedorId]
/// * [fatorConversao]
/// * [quantidade]
@BuiltValue()
abstract class ItemEfetivado implements Built<ItemEfetivado, ItemEfetivadoBuilder> {
  @BuiltValueField(wireName: r'numeroItem')
  int get numeroItem;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'produtoFornecedorId')
  String get produtoFornecedorId;

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  ItemEfetivado._();

  factory ItemEfetivado([void updates(ItemEfetivadoBuilder b)]) = _$ItemEfetivado;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemEfetivadoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemEfetivado> get serializer => _$ItemEfetivadoSerializer();
}

class _$ItemEfetivadoSerializer implements PrimitiveSerializer<ItemEfetivado> {
  @override
  final Iterable<Type> types = const [ItemEfetivado, _$ItemEfetivado];

  @override
  final String wireName = r'ItemEfetivado';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemEfetivado object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numeroItem';
    yield serializers.serialize(
      object.numeroItem,
      specifiedType: const FullType(int),
    );
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
      specifiedType: const FullType(String),
    );
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'produtoFornecedorId';
    yield serializers.serialize(
      object.produtoFornecedorId,
      specifiedType: const FullType(String),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ItemEfetivado object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemEfetivadoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numeroItem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numeroItem = valueDes;
          break;
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'produtoFornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoFornecedorId = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ItemEfetivado deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemEfetivadoBuilder();
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
