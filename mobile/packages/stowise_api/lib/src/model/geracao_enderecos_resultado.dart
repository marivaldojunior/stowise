//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geracao_enderecos_resultado.g.dart';

/// GeracaoEnderecosResultado
///
/// Properties:
/// * [total]
/// * [criados]
/// * [ignorados]
/// * [simulado]
/// * [codigosExistentes]
/// * [amostra]
@BuiltValue()
abstract class GeracaoEnderecosResultado implements Built<GeracaoEnderecosResultado, GeracaoEnderecosResultadoBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'criados')
  int get criados;

  @BuiltValueField(wireName: r'ignorados')
  int get ignorados;

  @BuiltValueField(wireName: r'simulado')
  bool get simulado;

  @BuiltValueField(wireName: r'codigosExistentes')
  BuiltList<String> get codigosExistentes;

  @BuiltValueField(wireName: r'amostra')
  BuiltList<String> get amostra;

  GeracaoEnderecosResultado._();

  factory GeracaoEnderecosResultado([void updates(GeracaoEnderecosResultadoBuilder b)]) = _$GeracaoEnderecosResultado;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeracaoEnderecosResultadoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeracaoEnderecosResultado> get serializer => _$GeracaoEnderecosResultadoSerializer();
}

class _$GeracaoEnderecosResultadoSerializer implements PrimitiveSerializer<GeracaoEnderecosResultado> {
  @override
  final Iterable<Type> types = const [GeracaoEnderecosResultado, _$GeracaoEnderecosResultado];

  @override
  final String wireName = r'GeracaoEnderecosResultado';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeracaoEnderecosResultado object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'criados';
    yield serializers.serialize(
      object.criados,
      specifiedType: const FullType(int),
    );
    yield r'ignorados';
    yield serializers.serialize(
      object.ignorados,
      specifiedType: const FullType(int),
    );
    yield r'simulado';
    yield serializers.serialize(
      object.simulado,
      specifiedType: const FullType(bool),
    );
    yield r'codigosExistentes';
    yield serializers.serialize(
      object.codigosExistentes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'amostra';
    yield serializers.serialize(
      object.amostra,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeracaoEnderecosResultado object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeracaoEnderecosResultadoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'criados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.criados = valueDes;
          break;
        case r'ignorados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ignorados = valueDes;
          break;
        case r'simulado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.simulado = valueDes;
          break;
        case r'codigosExistentes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.codigosExistentes.replace(valueDes);
          break;
        case r'amostra':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.amostra.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeracaoEnderecosResultado deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeracaoEnderecosResultadoBuilder();
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
