//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/item_nota.dart';
import 'package:stowise_api/src/model/metodo_similaridade.dart';
import 'package:stowise_api/src/model/origem_casamento.dart';
import 'package:stowise_api/src/model/casamento_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/produto_similar.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_analisado.g.dart';

/// ItemAnalisado
///
/// Properties:
/// * [item]
/// * [origem]
/// * [casamento]
/// * [metodoSugestoes]
/// * [sugestoes]
/// * [requerConfirmacao]
@BuiltValue()
abstract class ItemAnalisado implements Built<ItemAnalisado, ItemAnalisadoBuilder> {
  @BuiltValueField(wireName: r'item')
  ItemNota get item;

  @BuiltValueField(wireName: r'origem')
  OrigemCasamento get origem;
  // enum origemEnum {  DePara,  Gtin,  Similaridade,  SemCandidato,  };

  @BuiltValueField(wireName: r'casamento')
  CasamentoItem? get casamento;

  @BuiltValueField(wireName: r'metodoSugestoes')
  MetodoSimilaridade? get metodoSugestoes;
  // enum metodoSugestoesEnum {  Semantica,  Trigramas,  };

  @BuiltValueField(wireName: r'sugestoes')
  BuiltList<ProdutoSimilar> get sugestoes;

  @BuiltValueField(wireName: r'requerConfirmacao')
  bool get requerConfirmacao;

  ItemAnalisado._();

  factory ItemAnalisado([void updates(ItemAnalisadoBuilder b)]) = _$ItemAnalisado;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemAnalisadoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemAnalisado> get serializer => _$ItemAnalisadoSerializer();
}

class _$ItemAnalisadoSerializer implements PrimitiveSerializer<ItemAnalisado> {
  @override
  final Iterable<Type> types = const [ItemAnalisado, _$ItemAnalisado];

  @override
  final String wireName = r'ItemAnalisado';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemAnalisado object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'item';
    yield serializers.serialize(
      object.item,
      specifiedType: const FullType(ItemNota),
    );
    yield r'origem';
    yield serializers.serialize(
      object.origem,
      specifiedType: const FullType(OrigemCasamento),
    );
    yield r'casamento';
    yield object.casamento == null
        ? null
        : serializers.serialize(
            object.casamento,
            specifiedType: const FullType.nullable(CasamentoItem),
          );
    yield r'metodoSugestoes';
    yield object.metodoSugestoes == null
        ? null
        : serializers.serialize(
            object.metodoSugestoes,
            specifiedType: const FullType.nullable(MetodoSimilaridade),
          );
    yield r'sugestoes';
    yield serializers.serialize(
      object.sugestoes,
      specifiedType: const FullType(BuiltList, [FullType(ProdutoSimilar)]),
    );
    yield r'requerConfirmacao';
    yield serializers.serialize(
      object.requerConfirmacao,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ItemAnalisado object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemAnalisadoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ItemNota),
          ) as ItemNota;
          result.item.replace(valueDes);
          break;
        case r'origem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrigemCasamento),
          ) as OrigemCasamento;
          result.origem = valueDes;
          break;
        case r'casamento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CasamentoItem),
          ) as CasamentoItem?;
          if (valueDes == null) continue;
          result.casamento.replace(valueDes);
          break;
        case r'metodoSugestoes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MetodoSimilaridade),
          ) as MetodoSimilaridade?;
          if (valueDes == null) continue;
          result.metodoSugestoes = valueDes;
          break;
        case r'sugestoes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProdutoSimilar)]),
          ) as BuiltList<ProdutoSimilar>;
          result.sugestoes.replace(valueDes);
          break;
        case r'requerConfirmacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requerConfirmacao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ItemAnalisado deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemAnalisadoBuilder();
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
