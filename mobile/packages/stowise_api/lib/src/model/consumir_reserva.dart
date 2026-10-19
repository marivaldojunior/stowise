//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'consumir_reserva.g.dart';

/// ConsumirReserva
///
/// Properties:
/// * [documentoReferencia]
/// * [dispositivoId]
/// * [ocorridoEm]
/// * [idempotencyKey]
@BuiltValue()
abstract class ConsumirReserva implements Built<ConsumirReserva, ConsumirReservaBuilder> {
  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'dispositivoId')
  String? get dispositivoId;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime? get ocorridoEm;

  @BuiltValueField(wireName: r'idempotencyKey')
  String? get idempotencyKey;

  ConsumirReserva._();

  factory ConsumirReserva([void updates(ConsumirReservaBuilder b)]) = _$ConsumirReserva;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConsumirReservaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConsumirReserva> get serializer => _$ConsumirReservaSerializer();
}

class _$ConsumirReservaSerializer implements PrimitiveSerializer<ConsumirReserva> {
  @override
  final Iterable<Type> types = const [ConsumirReserva, _$ConsumirReserva];

  @override
  final String wireName = r'ConsumirReserva';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConsumirReserva object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'documentoReferencia';
    yield object.documentoReferencia == null
        ? null
        : serializers.serialize(
            object.documentoReferencia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'dispositivoId';
    yield object.dispositivoId == null
        ? null
        : serializers.serialize(
            object.dispositivoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ocorridoEm';
    yield object.ocorridoEm == null
        ? null
        : serializers.serialize(
            object.ocorridoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
    if (object.idempotencyKey != null) {
      yield r'idempotencyKey';
      yield serializers.serialize(
        object.idempotencyKey,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConsumirReserva object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConsumirReservaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documentoReferencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentoReferencia = valueDes;
          break;
        case r'dispositivoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dispositivoId = valueDes;
          break;
        case r'ocorridoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.ocorridoEm = valueDes;
          break;
        case r'idempotencyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idempotencyKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConsumirReserva deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConsumirReservaBuilder();
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
