//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lote_inferido.g.dart';

/// LoteInferido
///
/// Properties:
/// * [numero]
/// * [quantidadeNota]
/// * [quantidadeBase]
/// * [fabricacao]
/// * [validade]
@BuiltValue()
abstract class LoteInferido implements Built<LoteInferido, LoteInferidoBuilder> {
  @BuiltValueField(wireName: r'numero')
  String get numero;

  @BuiltValueField(wireName: r'quantidadeNota')
  double get quantidadeNota;

  @BuiltValueField(wireName: r'quantidadeBase')
  double? get quantidadeBase;

  @BuiltValueField(wireName: r'fabricacao')
  Date? get fabricacao;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  LoteInferido._();

  factory LoteInferido([void updates(LoteInferidoBuilder b)]) = _$LoteInferido;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoteInferidoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoteInferido> get serializer => _$LoteInferidoSerializer();
}

class _$LoteInferidoSerializer implements PrimitiveSerializer<LoteInferido> {
  @override
  final Iterable<Type> types = const [LoteInferido, _$LoteInferido];

  @override
  final String wireName = r'LoteInferido';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoteInferido object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numero';
    yield serializers.serialize(
      object.numero,
      specifiedType: const FullType(String),
    );
    yield r'quantidadeNota';
    yield serializers.serialize(
      object.quantidadeNota,
      specifiedType: const FullType(double),
    );
    yield r'quantidadeBase';
    yield object.quantidadeBase == null
        ? null
        : serializers.serialize(
            object.quantidadeBase,
            specifiedType: const FullType.nullable(double),
          );
    yield r'fabricacao';
    yield object.fabricacao == null
        ? null
        : serializers.serialize(
            object.fabricacao,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'validade';
    yield object.validade == null
        ? null
        : serializers.serialize(
            object.validade,
            specifiedType: const FullType.nullable(Date),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoteInferido object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoteInferidoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numero = valueDes;
          break;
        case r'quantidadeNota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeNota = valueDes;
          break;
        case r'quantidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidadeBase = valueDes;
          break;
        case r'fabricacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.fabricacao = valueDes;
          break;
        case r'validade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validade = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoteInferido deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoteInferidoBuilder();
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
