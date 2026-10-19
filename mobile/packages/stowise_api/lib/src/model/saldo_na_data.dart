//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'saldo_na_data.g.dart';

/// SaldoNaData
///
/// Properties:
/// * [enderecoId]
/// * [enderecoCodigo]
/// * [produtoId]
/// * [sku]
/// * [loteId]
/// * [loteNumero]
/// * [quantidade]
@BuiltValue()
abstract class SaldoNaData implements Built<SaldoNaData, SaldoNaDataBuilder> {
  @BuiltValueField(wireName: r'enderecoId')
  String get enderecoId;

  @BuiltValueField(wireName: r'enderecoCodigo')
  String get enderecoCodigo;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  SaldoNaData._();

  factory SaldoNaData([void updates(SaldoNaDataBuilder b)]) = _$SaldoNaData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaldoNaDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaldoNaData> get serializer => _$SaldoNaDataSerializer();
}

class _$SaldoNaDataSerializer implements PrimitiveSerializer<SaldoNaData> {
  @override
  final Iterable<Type> types = const [SaldoNaData, _$SaldoNaData];

  @override
  final String wireName = r'SaldoNaData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaldoNaData object, {
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
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaldoNaData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaldoNaDataBuilder result,
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
  SaldoNaData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaldoNaDataBuilder();
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
