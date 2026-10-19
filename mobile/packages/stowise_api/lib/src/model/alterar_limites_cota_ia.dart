//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'alterar_limites_cota_ia.g.dart';

/// AlterarLimitesCotaIa
///
/// Properties:
/// * [limiteChamadasDia]
/// * [limiteTokensMes]
/// * [versao]
@BuiltValue()
abstract class AlterarLimitesCotaIa implements Built<AlterarLimitesCotaIa, AlterarLimitesCotaIaBuilder> {
  @BuiltValueField(wireName: r'limiteChamadasDia')
  int? get limiteChamadasDia;

  @BuiltValueField(wireName: r'limiteTokensMes')
  int? get limiteTokensMes;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AlterarLimitesCotaIa._();

  factory AlterarLimitesCotaIa([void updates(AlterarLimitesCotaIaBuilder b)]) = _$AlterarLimitesCotaIa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlterarLimitesCotaIaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlterarLimitesCotaIa> get serializer => _$AlterarLimitesCotaIaSerializer();
}

class _$AlterarLimitesCotaIaSerializer implements PrimitiveSerializer<AlterarLimitesCotaIa> {
  @override
  final Iterable<Type> types = const [AlterarLimitesCotaIa, _$AlterarLimitesCotaIa];

  @override
  final String wireName = r'AlterarLimitesCotaIa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlterarLimitesCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'limiteChamadasDia';
    yield object.limiteChamadasDia == null
        ? null
        : serializers.serialize(
            object.limiteChamadasDia,
            specifiedType: const FullType.nullable(int),
          );
    yield r'limiteTokensMes';
    yield object.limiteTokensMes == null
        ? null
        : serializers.serialize(
            object.limiteTokensMes,
            specifiedType: const FullType.nullable(int),
          );
    yield r'versao';
    yield object.versao == null
        ? null
        : serializers.serialize(
            object.versao,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AlterarLimitesCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlterarLimitesCotaIaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'limiteChamadasDia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteChamadasDia = valueDes;
          break;
        case r'limiteTokensMes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteTokensMes = valueDes;
          break;
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.versao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AlterarLimitesCotaIa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlterarLimitesCotaIaBuilder();
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
