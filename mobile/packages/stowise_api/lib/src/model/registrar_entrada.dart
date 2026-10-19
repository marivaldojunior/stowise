//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/lote_informado.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registrar_entrada.g.dart';

/// RegistrarEntrada
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
abstract class RegistrarEntrada implements Built<RegistrarEntrada, RegistrarEntradaBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'enderecoId')
  String? get enderecoId;

  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'lote')
  LoteInformado? get lote;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'dispositivoId')
  String? get dispositivoId;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime? get ocorridoEm;

  @BuiltValueField(wireName: r'idempotencyKey')
  String? get idempotencyKey;

  RegistrarEntrada._();

  factory RegistrarEntrada([void updates(RegistrarEntradaBuilder b)]) = _$RegistrarEntrada;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrarEntradaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrarEntrada> get serializer => _$RegistrarEntradaSerializer();
}

class _$RegistrarEntradaSerializer implements PrimitiveSerializer<RegistrarEntrada> {
  @override
  final Iterable<Type> types = const [RegistrarEntrada, _$RegistrarEntrada];

  @override
  final String wireName = r'RegistrarEntrada';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrarEntrada object, {
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
            specifiedType: const FullType.nullable(LoteInformado),
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
    RegistrarEntrada object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegistrarEntradaBuilder result,
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
            specifiedType: const FullType.nullable(LoteInformado),
          ) as LoteInformado?;
          if (valueDes == null) continue;
          result.lote.replace(valueDes);
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
  RegistrarEntrada deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrarEntradaBuilder();
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
