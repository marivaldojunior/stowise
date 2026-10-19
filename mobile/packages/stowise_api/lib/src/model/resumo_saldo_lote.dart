//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resumo_saldo_lote.g.dart';

/// ResumoSaldoLote
///
/// Properties:
/// * [loteId]
/// * [numero]
/// * [validade]
/// * [quantidade]
/// * [quantidadeReservada]
@BuiltValue()
abstract class ResumoSaldoLote implements Built<ResumoSaldoLote, ResumoSaldoLoteBuilder> {
  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'numero')
  String? get numero;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'quantidadeReservada')
  double get quantidadeReservada;

  ResumoSaldoLote._();

  factory ResumoSaldoLote([void updates(ResumoSaldoLoteBuilder b)]) = _$ResumoSaldoLote;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResumoSaldoLoteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResumoSaldoLote> get serializer => _$ResumoSaldoLoteSerializer();
}

class _$ResumoSaldoLoteSerializer implements PrimitiveSerializer<ResumoSaldoLote> {
  @override
  final Iterable<Type> types = const [ResumoSaldoLote, _$ResumoSaldoLote];

  @override
  final String wireName = r'ResumoSaldoLote';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResumoSaldoLote object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loteId';
    yield object.loteId == null
        ? null
        : serializers.serialize(
            object.loteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'numero';
    yield object.numero == null
        ? null
        : serializers.serialize(
            object.numero,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ResumoSaldoLote object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResumoSaldoLoteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'loteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteId = valueDes;
          break;
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.numero = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResumoSaldoLote deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResumoSaldoLoteBuilder();
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
