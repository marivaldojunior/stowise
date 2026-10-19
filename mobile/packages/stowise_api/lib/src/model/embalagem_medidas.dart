//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'embalagem_medidas.g.dart';

/// EmbalagemMedidas
///
/// Properties:
/// * [gtin]
/// * [pesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [comprimentoCm]
@BuiltValue()
abstract class EmbalagemMedidas implements Built<EmbalagemMedidas, EmbalagemMedidasBuilder> {
  @BuiltValueField(wireName: r'gtin')
  String? get gtin;

  @BuiltValueField(wireName: r'pesoKg')
  double? get pesoKg;

  @BuiltValueField(wireName: r'alturaCm')
  double? get alturaCm;

  @BuiltValueField(wireName: r'larguraCm')
  double? get larguraCm;

  @BuiltValueField(wireName: r'comprimentoCm')
  double? get comprimentoCm;

  EmbalagemMedidas._();

  factory EmbalagemMedidas([void updates(EmbalagemMedidasBuilder b)]) = _$EmbalagemMedidas;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmbalagemMedidasBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmbalagemMedidas> get serializer => _$EmbalagemMedidasSerializer();
}

class _$EmbalagemMedidasSerializer implements PrimitiveSerializer<EmbalagemMedidas> {
  @override
  final Iterable<Type> types = const [EmbalagemMedidas, _$EmbalagemMedidas];

  @override
  final String wireName = r'EmbalagemMedidas';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmbalagemMedidas object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gtin';
    yield object.gtin == null
        ? null
        : serializers.serialize(
            object.gtin,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pesoKg';
    yield object.pesoKg == null
        ? null
        : serializers.serialize(
            object.pesoKg,
            specifiedType: const FullType.nullable(double),
          );
    yield r'alturaCm';
    yield object.alturaCm == null
        ? null
        : serializers.serialize(
            object.alturaCm,
            specifiedType: const FullType.nullable(double),
          );
    yield r'larguraCm';
    yield object.larguraCm == null
        ? null
        : serializers.serialize(
            object.larguraCm,
            specifiedType: const FullType.nullable(double),
          );
    yield r'comprimentoCm';
    yield object.comprimentoCm == null
        ? null
        : serializers.serialize(
            object.comprimentoCm,
            specifiedType: const FullType.nullable(double),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmbalagemMedidas object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmbalagemMedidasBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gtin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gtin = valueDes;
          break;
        case r'pesoKg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.pesoKg = valueDes;
          break;
        case r'alturaCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.alturaCm = valueDes;
          break;
        case r'larguraCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.larguraCm = valueDes;
          break;
        case r'comprimentoCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.comprimentoCm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmbalagemMedidas deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmbalagemMedidasBuilder();
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
