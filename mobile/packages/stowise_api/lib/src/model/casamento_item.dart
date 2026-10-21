//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_embalagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'casamento_item.g.dart';

/// CasamentoItem
///
/// Properties:
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [controlaLote]
/// * [controlaValidade]
/// * [embalagemId]
/// * [tipoEmbalagem]
/// * [fatorConversao]
/// * [produtoFornecedorId]
/// * [porGtinTributavel]
@BuiltValue()
abstract class CasamentoItem implements Built<CasamentoItem, CasamentoItemBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'controlaLote')
  bool get controlaLote;

  @BuiltValueField(wireName: r'controlaValidade')
  bool get controlaValidade;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'tipoEmbalagem')
  TipoEmbalagem get tipoEmbalagem;
  // enum tipoEmbalagemEnum {  Unidade,  Caixa,  Palete,  };

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'produtoFornecedorId')
  String? get produtoFornecedorId;

  @BuiltValueField(wireName: r'porGtinTributavel')
  bool? get porGtinTributavel;

  CasamentoItem._();

  factory CasamentoItem([void updates(CasamentoItemBuilder b)]) = _$CasamentoItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CasamentoItemBuilder b) => b..porGtinTributavel = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<CasamentoItem> get serializer => _$CasamentoItemSerializer();
}

class _$CasamentoItemSerializer implements PrimitiveSerializer<CasamentoItem> {
  @override
  final Iterable<Type> types = const [CasamentoItem, _$CasamentoItem];

  @override
  final String wireName = r'CasamentoItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CasamentoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'descricao';
    yield serializers.serialize(
      object.descricao,
      specifiedType: const FullType(String),
    );
    yield r'unidadeBase';
    yield serializers.serialize(
      object.unidadeBase,
      specifiedType: const FullType(String),
    );
    yield r'controlaLote';
    yield serializers.serialize(
      object.controlaLote,
      specifiedType: const FullType(bool),
    );
    yield r'controlaValidade';
    yield serializers.serialize(
      object.controlaValidade,
      specifiedType: const FullType(bool),
    );
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'tipoEmbalagem';
    yield serializers.serialize(
      object.tipoEmbalagem,
      specifiedType: const FullType(TipoEmbalagem),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'produtoFornecedorId';
    yield object.produtoFornecedorId == null
        ? null
        : serializers.serialize(
            object.produtoFornecedorId,
            specifiedType: const FullType.nullable(String),
          );
    if (object.porGtinTributavel != null) {
      yield r'porGtinTributavel';
      yield serializers.serialize(
        object.porGtinTributavel,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CasamentoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CasamentoItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricao = valueDes;
          break;
        case r'unidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeBase = valueDes;
          break;
        case r'controlaLote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.controlaLote = valueDes;
          break;
        case r'controlaValidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.controlaValidade = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'tipoEmbalagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoEmbalagem),
          ) as TipoEmbalagem;
          result.tipoEmbalagem = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'produtoFornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoFornecedorId = valueDes;
          break;
        case r'porGtinTributavel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.porGtinTributavel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CasamentoItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CasamentoItemBuilder();
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
