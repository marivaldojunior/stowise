//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_reserva.g.dart';

/// CriarReserva
///
/// Properties:
/// * [produtoId]
/// * [enderecoId]
/// * [lote]
/// * [quantidade]
/// * [documentoReferencia]
@BuiltValue()
abstract class CriarReserva implements Built<CriarReserva, CriarReservaBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'enderecoId')
  String? get enderecoId;

  @BuiltValueField(wireName: r'lote')
  String? get lote;

  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  CriarReserva._();

  factory CriarReserva([void updates(CriarReservaBuilder b)]) = _$CriarReserva;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarReservaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarReserva> get serializer => _$CriarReservaSerializer();
}

class _$CriarReservaSerializer implements PrimitiveSerializer<CriarReserva> {
  @override
  final Iterable<Type> types = const [CriarReserva, _$CriarReserva];

  @override
  final String wireName = r'CriarReserva';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarReserva object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield object.produtoId == null
        ? null
        : serializers.serialize(
            object.produtoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoId';
    yield object.enderecoId == null
        ? null
        : serializers.serialize(
            object.enderecoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'lote';
    yield object.lote == null
        ? null
        : serializers.serialize(
            object.lote,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield object.quantidade == null
        ? null
        : serializers.serialize(
            object.quantidade,
            specifiedType: const FullType.nullable(double),
          );
    yield r'documentoReferencia';
    yield object.documentoReferencia == null
        ? null
        : serializers.serialize(
            object.documentoReferencia,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CriarReserva object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarReservaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoId = valueDes;
          break;
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoId = valueDes;
          break;
        case r'lote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lote = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CriarReserva deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarReservaBuilder();
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
