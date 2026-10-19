//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'saldo_item.g.dart';

/// SaldoItem
///
/// Properties:
/// * [enderecoId]
/// * [enderecoCodigo]
/// * [armazemId]
/// * [zonaId]
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [loteId]
/// * [loteNumero]
/// * [validade]
/// * [quantidade]
/// * [quantidadeReservada]
/// * [quantidadeDisponivel]
@BuiltValue()
abstract class SaldoItem implements Built<SaldoItem, SaldoItemBuilder> {
  @BuiltValueField(wireName: r'enderecoId')
  String get enderecoId;

  @BuiltValueField(wireName: r'enderecoCodigo')
  String get enderecoCodigo;

  @BuiltValueField(wireName: r'armazemId')
  String get armazemId;

  @BuiltValueField(wireName: r'zonaId')
  String get zonaId;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'quantidadeReservada')
  double get quantidadeReservada;

  @BuiltValueField(wireName: r'quantidadeDisponivel')
  double get quantidadeDisponivel;

  SaldoItem._();

  factory SaldoItem([void updates(SaldoItemBuilder b)]) = _$SaldoItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaldoItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaldoItem> get serializer => _$SaldoItemSerializer();
}

class _$SaldoItemSerializer implements PrimitiveSerializer<SaldoItem> {
  @override
  final Iterable<Type> types = const [SaldoItem, _$SaldoItem];

  @override
  final String wireName = r'SaldoItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaldoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enderecoId';
    yield serializers.serialize(
      object.enderecoId,
      specifiedType: const FullType(String),
    );
    yield r'enderecoCodigo';
    yield serializers.serialize(
      object.enderecoCodigo,
      specifiedType: const FullType(String),
    );
    yield r'armazemId';
    yield serializers.serialize(
      object.armazemId,
      specifiedType: const FullType(String),
    );
    yield r'zonaId';
    yield serializers.serialize(
      object.zonaId,
      specifiedType: const FullType(String),
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
    yield r'loteId';
    yield object.loteId == null
        ? null
        : serializers.serialize(
            object.loteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'loteNumero';
    yield object.loteNumero == null
        ? null
        : serializers.serialize(
            object.loteNumero,
            specifiedType: const FullType.nullable(String),
          );
    yield r'validade';
    yield object.validade == null
        ? null
        : serializers.serialize(
            object.validade,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'quantidadeReservada';
    yield serializers.serialize(
      object.quantidadeReservada,
      specifiedType: const FullType(double),
    );
    yield r'quantidadeDisponivel';
    yield serializers.serialize(
      object.quantidadeDisponivel,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaldoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaldoItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enderecoId = valueDes;
          break;
        case r'enderecoCodigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enderecoCodigo = valueDes;
          break;
        case r'armazemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.armazemId = valueDes;
          break;
        case r'zonaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.zonaId = valueDes;
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
        case r'loteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteId = valueDes;
          break;
        case r'loteNumero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteNumero = valueDes;
          break;
        case r'validade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validade = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'quantidadeReservada':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeReservada = valueDes;
          break;
        case r'quantidadeDisponivel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeDisponivel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaldoItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaldoItemBuilder();
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
