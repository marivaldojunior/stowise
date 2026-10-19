//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registrar_ajuste.g.dart';

/// RegistrarAjuste
///
/// Properties:
/// * [produtoId]
/// * [enderecoId]
/// * [quantidade]
/// * [lote]
/// * [motivo]
/// * [ocorridoEm]
/// * [idempotencyKey]
@BuiltValue()
abstract class RegistrarAjuste implements Built<RegistrarAjuste, RegistrarAjusteBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'enderecoId')
  String? get enderecoId;

  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'lote')
  String? get lote;

  @BuiltValueField(wireName: r'motivo')
  String? get motivo;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime? get ocorridoEm;

  @BuiltValueField(wireName: r'idempotencyKey')
  String? get idempotencyKey;

  RegistrarAjuste._();

  factory RegistrarAjuste([void updates(RegistrarAjusteBuilder b)]) = _$RegistrarAjuste;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrarAjusteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrarAjuste> get serializer => _$RegistrarAjusteSerializer();
}

class _$RegistrarAjusteSerializer implements PrimitiveSerializer<RegistrarAjuste> {
  @override
  final Iterable<Type> types = const [RegistrarAjuste, _$RegistrarAjuste];

  @override
  final String wireName = r'RegistrarAjuste';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrarAjuste object, {
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
    yield r'motivo';
    yield object.motivo == null
        ? null
        : serializers.serialize(
            object.motivo,
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
    RegistrarAjuste object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegistrarAjusteBuilder result,
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
        case r'motivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivo = valueDes;
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
  RegistrarAjuste deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrarAjusteBuilder();
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
