//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/acao_item_nota.dart';
import 'package:stowise_api/src/model/novo_produto_nota.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decisao_item_nota.g.dart';

/// DecisaoItemNota
///
/// Properties:
/// * [numeroItem]
/// * [acao]
/// * [produtoId]
/// * [embalagemId]
/// * [fatorConversao]
/// * [novoProduto]
@BuiltValue()
abstract class DecisaoItemNota implements Built<DecisaoItemNota, DecisaoItemNotaBuilder> {
  @BuiltValueField(wireName: r'numeroItem')
  int get numeroItem;

  @BuiltValueField(wireName: r'acao')
  AcaoItemNota get acao;
  // enum acaoEnum {  Confirmar,  Vincular,  CriarProduto,  };

  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'fatorConversao')
  double? get fatorConversao;

  @BuiltValueField(wireName: r'novoProduto')
  NovoProdutoNota? get novoProduto;

  DecisaoItemNota._();

  factory DecisaoItemNota([void updates(DecisaoItemNotaBuilder b)]) = _$DecisaoItemNota;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecisaoItemNotaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecisaoItemNota> get serializer => _$DecisaoItemNotaSerializer();
}

class _$DecisaoItemNotaSerializer implements PrimitiveSerializer<DecisaoItemNota> {
  @override
  final Iterable<Type> types = const [DecisaoItemNota, _$DecisaoItemNota];

  @override
  final String wireName = r'DecisaoItemNota';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecisaoItemNota object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numeroItem';
    yield serializers.serialize(
      object.numeroItem,
      specifiedType: const FullType(int),
    );
    yield r'acao';
    yield serializers.serialize(
      object.acao,
      specifiedType: const FullType(AcaoItemNota),
    );
    if (object.produtoId != null) {
      yield r'produtoId';
      yield serializers.serialize(
        object.produtoId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.embalagemId != null) {
      yield r'embalagemId';
      yield serializers.serialize(
        object.embalagemId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fatorConversao != null) {
      yield r'fatorConversao';
      yield serializers.serialize(
        object.fatorConversao,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.novoProduto != null) {
      yield r'novoProduto';
      yield serializers.serialize(
        object.novoProduto,
        specifiedType: const FullType.nullable(NovoProdutoNota),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DecisaoItemNota object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DecisaoItemNotaBuilder result,
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
        case r'acao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AcaoItemNota),
          ) as AcaoItemNota;
          result.acao = valueDes;
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
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fatorConversao = valueDes;
          break;
        case r'novoProduto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NovoProdutoNota),
          ) as NovoProdutoNota?;
          if (valueDes == null) continue;
          result.novoProduto.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DecisaoItemNota deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecisaoItemNotaBuilder();
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
