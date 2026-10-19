//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lote_informado.g.dart';

/// LoteInformado
///
/// Properties:
/// * [numero]
/// * [fabricacao]
/// * [validade]
@BuiltValue()
abstract class LoteInformado implements Built<LoteInformado, LoteInformadoBuilder> {
  @BuiltValueField(wireName: r'numero')
  String? get numero;

  @BuiltValueField(wireName: r'fabricacao')
  Date? get fabricacao;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  LoteInformado._();

  factory LoteInformado([void updates(LoteInformadoBuilder b)]) = _$LoteInformado;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoteInformadoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoteInformado> get serializer => _$LoteInformadoSerializer();
}

class _$LoteInformadoSerializer implements PrimitiveSerializer<LoteInformado> {
  @override
  final Iterable<Type> types = const [LoteInformado, _$LoteInformado];

  @override
  final String wireName = r'LoteInformado';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoteInformado object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numero';
    yield object.numero == null
        ? null
        : serializers.serialize(
            object.numero,
            specifiedType: const FullType.nullable(String),
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
    LoteInformado object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoteInformadoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.numero = valueDes;
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
  LoteInformado deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoteInformadoBuilder();
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
