//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registrar_saida.g.dart';

/// RegistrarSaida
///
/// Properties:
/// * [produtoId]
/// * [embalagemId]
/// * [enderecoId]
/// * [quantidade]
/// * [lote]
/// * [documentoReferencia]
/// * [dispositivoId]
/// * [ocorridoEm]
/// * [idempotencyKey]
@BuiltValue()
abstract class RegistrarSaida implements Built<RegistrarSaida, RegistrarSaidaBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'enderecoId')
  String? get enderecoId;

  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'lote')
  String? get lote;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'dispositivoId')
  String? get dispositivoId;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime? get ocorridoEm;

  @BuiltValueField(wireName: r'idempotencyKey')
  String? get idempotencyKey;

  RegistrarSaida._();

  factory RegistrarSaida([void updates(RegistrarSaidaBuilder b)]) = _$RegistrarSaida;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrarSaidaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrarSaida> get serializer => _$RegistrarSaidaSerializer();
}

class _$RegistrarSaidaSerializer implements PrimitiveSerializer<RegistrarSaida> {
  @override
  final Iterable<Type> types = const [RegistrarSaida, _$RegistrarSaida];

  @override
  final String wireName = r'RegistrarSaida';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrarSaida object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield object.produtoId == null
        ? null
        : serializers.serialize(
            object.produtoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'embalagemId';
    yield object.embalagemId == null
        ? null
        : serializers.serialize(
            object.embalagemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoId';
    yield object.enderecoId == null
        ? null
        : serializers.serialize(
            object.enderecoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield object.quantidade == null
        ? null
        : serializers.serialize(
            object.quantidade,
            specifiedType: const FullType.nullable(double),
          );
    yield r'lote';
    yield object.lote == null
        ? null
        : serializers.serialize(
            object.lote,
            specifiedType: const FullType.nullable(String),
          );
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
    RegistrarSaida object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegistrarSaidaBuilder result,
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
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.embalagemId = valueDes;
          break;
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoId = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidade = valueDes;
          break;
        case r'lote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lote = valueDes;
          break;
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
  RegistrarSaida deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrarSaidaBuilder();
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
