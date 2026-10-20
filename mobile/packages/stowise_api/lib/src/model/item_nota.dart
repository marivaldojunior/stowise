//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/lote_nota.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_nota.g.dart';

/// ItemNota
///
/// Properties:
/// * [numeroItem]
/// * [codigoFornecedor]
/// * [gtin]
/// * [descricao]
/// * [ncm]
/// * [cest]
/// * [cfop]
/// * [unidadeComercial]
/// * [quantidadeComercial]
/// * [valorUnitarioComercial]
/// * [gtinTributavel]
/// * [unidadeTributavel]
/// * [quantidadeTributavel]
/// * [lotes]
@BuiltValue()
abstract class ItemNota implements Built<ItemNota, ItemNotaBuilder> {
  @BuiltValueField(wireName: r'numeroItem')
  int get numeroItem;

  @BuiltValueField(wireName: r'codigoFornecedor')
  String get codigoFornecedor;

  @BuiltValueField(wireName: r'gtin')
  String? get gtin;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'ncm')
  String? get ncm;

  @BuiltValueField(wireName: r'cest')
  String? get cest;

  @BuiltValueField(wireName: r'cfop')
  String get cfop;

  @BuiltValueField(wireName: r'unidadeComercial')
  String get unidadeComercial;

  @BuiltValueField(wireName: r'quantidadeComercial')
  double get quantidadeComercial;

  @BuiltValueField(wireName: r'valorUnitarioComercial')
  double get valorUnitarioComercial;

  @BuiltValueField(wireName: r'gtinTributavel')
  String? get gtinTributavel;

  @BuiltValueField(wireName: r'unidadeTributavel')
  String get unidadeTributavel;

  @BuiltValueField(wireName: r'quantidadeTributavel')
  double get quantidadeTributavel;

  @BuiltValueField(wireName: r'lotes')
  BuiltList<LoteNota> get lotes;

  ItemNota._();

  factory ItemNota([void updates(ItemNotaBuilder b)]) = _$ItemNota;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemNotaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemNota> get serializer => _$ItemNotaSerializer();
}

class _$ItemNotaSerializer implements PrimitiveSerializer<ItemNota> {
  @override
  final Iterable<Type> types = const [ItemNota, _$ItemNota];

  @override
  final String wireName = r'ItemNota';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemNota object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numeroItem';
    yield serializers.serialize(
      object.numeroItem,
      specifiedType: const FullType(int),
    );
    yield r'codigoFornecedor';
    yield serializers.serialize(
      object.codigoFornecedor,
      specifiedType: const FullType(String),
    );
    yield r'gtin';
    yield object.gtin == null
        ? null
        : serializers.serialize(
            object.gtin,
            specifiedType: const FullType.nullable(String),
          );
    yield r'descricao';
    yield serializers.serialize(
      object.descricao,
      specifiedType: const FullType(String),
    );
    yield r'ncm';
    yield object.ncm == null
        ? null
        : serializers.serialize(
            object.ncm,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cest';
    yield object.cest == null
        ? null
        : serializers.serialize(
            object.cest,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cfop';
    yield serializers.serialize(
      object.cfop,
      specifiedType: const FullType(String),
    );
    yield r'unidadeComercial';
    yield serializers.serialize(
      object.unidadeComercial,
      specifiedType: const FullType(String),
    );
    yield r'quantidadeComercial';
    yield serializers.serialize(
      object.quantidadeComercial,
      specifiedType: const FullType(double),
    );
    yield r'valorUnitarioComercial';
    yield serializers.serialize(
      object.valorUnitarioComercial,
      specifiedType: const FullType(double),
    );
    yield r'gtinTributavel';
    yield object.gtinTributavel == null
        ? null
        : serializers.serialize(
            object.gtinTributavel,
            specifiedType: const FullType.nullable(String),
          );
    yield r'unidadeTributavel';
    yield serializers.serialize(
      object.unidadeTributavel,
      specifiedType: const FullType(String),
    );
    yield r'quantidadeTributavel';
    yield serializers.serialize(
      object.quantidadeTributavel,
      specifiedType: const FullType(double),
    );
    yield r'lotes';
    yield serializers.serialize(
      object.lotes,
      specifiedType: const FullType(BuiltList, [FullType(LoteNota)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ItemNota object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemNotaBuilder result,
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
        case r'codigoFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigoFornecedor = valueDes;
          break;
        case r'gtin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gtin = valueDes;
          break;
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricao = valueDes;
          break;
        case r'ncm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ncm = valueDes;
          break;
        case r'cest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cest = valueDes;
          break;
        case r'cfop':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cfop = valueDes;
          break;
        case r'unidadeComercial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeComercial = valueDes;
          break;
        case r'quantidadeComercial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeComercial = valueDes;
          break;
        case r'valorUnitarioComercial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.valorUnitarioComercial = valueDes;
          break;
        case r'gtinTributavel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gtinTributavel = valueDes;
          break;
        case r'unidadeTributavel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeTributavel = valueDes;
          break;
        case r'quantidadeTributavel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeTributavel = valueDes;
          break;
        case r'lotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LoteNota)]),
          ) as BuiltList<LoteNota>;
          result.lotes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ItemNota deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemNotaBuilder();
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
