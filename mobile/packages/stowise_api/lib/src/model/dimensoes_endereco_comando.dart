//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dimensoes_endereco_comando.g.dart';

/// DimensoesEnderecoComando
///
/// Properties:
/// * [capacidadePesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [profundidadeCm]
/// * [distanciaExpedicao]
@BuiltValue()
abstract class DimensoesEnderecoComando implements Built<DimensoesEnderecoComando, DimensoesEnderecoComandoBuilder> {
  @BuiltValueField(wireName: r'capacidadePesoKg')
  double? get capacidadePesoKg;

  @BuiltValueField(wireName: r'alturaCm')
  double? get alturaCm;

  @BuiltValueField(wireName: r'larguraCm')
  double? get larguraCm;

  @BuiltValueField(wireName: r'profundidadeCm')
  double? get profundidadeCm;

  @BuiltValueField(wireName: r'distanciaExpedicao')
  double? get distanciaExpedicao;

  DimensoesEnderecoComando._();

  factory DimensoesEnderecoComando([void updates(DimensoesEnderecoComandoBuilder b)]) = _$DimensoesEnderecoComando;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DimensoesEnderecoComandoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DimensoesEnderecoComando> get serializer => _$DimensoesEnderecoComandoSerializer();
}

class _$DimensoesEnderecoComandoSerializer implements PrimitiveSerializer<DimensoesEnderecoComando> {
  @override
  final Iterable<Type> types = const [DimensoesEnderecoComando, _$DimensoesEnderecoComando];

  @override
  final String wireName = r'DimensoesEnderecoComando';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DimensoesEnderecoComando object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'capacidadePesoKg';
    yield object.capacidadePesoKg == null
        ? null
        : serializers.serialize(
            object.capacidadePesoKg,
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
    yield r'profundidadeCm';
    yield object.profundidadeCm == null
        ? null
        : serializers.serialize(
            object.profundidadeCm,
            specifiedType: const FullType.nullable(double),
          );
    yield r'distanciaExpedicao';
    yield object.distanciaExpedicao == null
        ? null
        : serializers.serialize(
            object.distanciaExpedicao,
            specifiedType: const FullType.nullable(double),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    DimensoesEnderecoComando object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DimensoesEnderecoComandoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'capacidadePesoKg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.capacidadePesoKg = valueDes;
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
        case r'profundidadeCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.profundidadeCm = valueDes;
          break;
        case r'distanciaExpedicao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.distanciaExpedicao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DimensoesEnderecoComando deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DimensoesEnderecoComandoBuilder();
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
