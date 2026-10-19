//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_movimentacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'extrato_item.g.dart';

/// ExtratoItem
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [ocorridoEm]
/// * [recebidoEm]
/// * [produtoId]
/// * [sku]
/// * [loteNumero]
/// * [enderecoOrigemCodigo]
/// * [enderecoDestinoCodigo]
/// * [quantidade]
/// * [documentoReferencia]
/// * [observacao]
/// * [usuarioId]
@BuiltValue()
abstract class ExtratoItem implements Built<ExtratoItem, ExtratoItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoMovimentacao get tipo;
  // enum tipoEnum {  Entrada,  Saida,  Transferencia,  Ajuste,  };

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime get ocorridoEm;

  @BuiltValueField(wireName: r'recebidoEm')
  DateTime get recebidoEm;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'enderecoOrigemCodigo')
  String? get enderecoOrigemCodigo;

  @BuiltValueField(wireName: r'enderecoDestinoCodigo')
  String? get enderecoDestinoCodigo;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'observacao')
  String? get observacao;

  @BuiltValueField(wireName: r'usuarioId')
  String get usuarioId;

  ExtratoItem._();

  factory ExtratoItem([void updates(ExtratoItemBuilder b)]) = _$ExtratoItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExtratoItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExtratoItem> get serializer => _$ExtratoItemSerializer();
}

class _$ExtratoItemSerializer implements PrimitiveSerializer<ExtratoItem> {
  @override
  final Iterable<Type> types = const [ExtratoItem, _$ExtratoItem];

  @override
  final String wireName = r'ExtratoItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExtratoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'tipo';
    yield serializers.serialize(
      object.tipo,
      specifiedType: const FullType(TipoMovimentacao),
    );
    yield r'ocorridoEm';
    yield serializers.serialize(
      object.ocorridoEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'recebidoEm';
    yield serializers.serialize(
      object.recebidoEm,
      specifiedType: const FullType(DateTime),
    );
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
    yield r'loteNumero';
    yield object.loteNumero == null
        ? null
        : serializers.serialize(
            object.loteNumero,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoOrigemCodigo';
    yield object.enderecoOrigemCodigo == null
        ? null
        : serializers.serialize(
            object.enderecoOrigemCodigo,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoDestinoCodigo';
    yield object.enderecoDestinoCodigo == null
        ? null
        : serializers.serialize(
            object.enderecoDestinoCodigo,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'documentoReferencia';
    yield object.documentoReferencia == null
        ? null
        : serializers.serialize(
            object.documentoReferencia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'observacao';
    yield object.observacao == null
        ? null
        : serializers.serialize(
            object.observacao,
            specifiedType: const FullType.nullable(String),
          );
    yield r'usuarioId';
    yield serializers.serialize(
      object.usuarioId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExtratoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExtratoItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoMovimentacao),
          ) as TipoMovimentacao;
          result.tipo = valueDes;
          break;
        case r'ocorridoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.ocorridoEm = valueDes;
          break;
        case r'recebidoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recebidoEm = valueDes;
          break;
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
        case r'loteNumero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteNumero = valueDes;
          break;
        case r'enderecoOrigemCodigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoOrigemCodigo = valueDes;
          break;
        case r'enderecoDestinoCodigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoDestinoCodigo = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'documentoReferencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentoReferencia = valueDes;
          break;
        case r'observacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.observacao = valueDes;
          break;
        case r'usuarioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.usuarioId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExtratoItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExtratoItemBuilder();
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
