//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/item_efetivado.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nota_fiscal_efetivada.g.dart';

/// NotaFiscalEfetivada
///
/// Properties:
/// * [recebimentoId]
/// * [fornecedorId]
/// * [fornecedorCriado]
/// * [produtosCriados]
/// * [vinculosCriados]
/// * [vinculosAtualizados]
/// * [itens]
@BuiltValue()
abstract class NotaFiscalEfetivada implements Built<NotaFiscalEfetivada, NotaFiscalEfetivadaBuilder> {
  @BuiltValueField(wireName: r'recebimentoId')
  String get recebimentoId;

  @BuiltValueField(wireName: r'fornecedorId')
  String get fornecedorId;

  @BuiltValueField(wireName: r'fornecedorCriado')
  bool get fornecedorCriado;

  @BuiltValueField(wireName: r'produtosCriados')
  int get produtosCriados;

  @BuiltValueField(wireName: r'vinculosCriados')
  int get vinculosCriados;

  @BuiltValueField(wireName: r'vinculosAtualizados')
  int get vinculosAtualizados;

  @BuiltValueField(wireName: r'itens')
  BuiltList<ItemEfetivado> get itens;

  NotaFiscalEfetivada._();

  factory NotaFiscalEfetivada([void updates(NotaFiscalEfetivadaBuilder b)]) = _$NotaFiscalEfetivada;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotaFiscalEfetivadaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotaFiscalEfetivada> get serializer => _$NotaFiscalEfetivadaSerializer();
}

class _$NotaFiscalEfetivadaSerializer implements PrimitiveSerializer<NotaFiscalEfetivada> {
  @override
  final Iterable<Type> types = const [NotaFiscalEfetivada, _$NotaFiscalEfetivada];

  @override
  final String wireName = r'NotaFiscalEfetivada';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotaFiscalEfetivada object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recebimentoId';
    yield serializers.serialize(
      object.recebimentoId,
      specifiedType: const FullType(String),
    );
    yield r'fornecedorId';
    yield serializers.serialize(
      object.fornecedorId,
      specifiedType: const FullType(String),
    );
    yield r'fornecedorCriado';
    yield serializers.serialize(
      object.fornecedorCriado,
      specifiedType: const FullType(bool),
    );
    yield r'produtosCriados';
    yield serializers.serialize(
      object.produtosCriados,
      specifiedType: const FullType(int),
    );
    yield r'vinculosCriados';
    yield serializers.serialize(
      object.vinculosCriados,
      specifiedType: const FullType(int),
    );
    yield r'vinculosAtualizados';
    yield serializers.serialize(
      object.vinculosAtualizados,
      specifiedType: const FullType(int),
    );
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(ItemEfetivado)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotaFiscalEfetivada object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotaFiscalEfetivadaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recebimentoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recebimentoId = valueDes;
          break;
        case r'fornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fornecedorId = valueDes;
          break;
        case r'fornecedorCriado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.fornecedorCriado = valueDes;
          break;
        case r'produtosCriados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.produtosCriados = valueDes;
          break;
        case r'vinculosCriados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vinculosCriados = valueDes;
          break;
        case r'vinculosAtualizados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vinculosAtualizados = valueDes;
          break;
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ItemEfetivado)]),
          ) as BuiltList<ItemEfetivado>;
          result.itens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotaFiscalEfetivada deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotaFiscalEfetivadaBuilder();
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
