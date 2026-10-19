//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gerar_enderecos.g.dart';

/// GerarEnderecos
///
/// Properties:
/// * [zonaId]
/// * [ruas]
/// * [moduloInicial]
/// * [moduloFinal]
/// * [nivelInicial]
/// * [nivelFinal]
/// * [posicaoInicial]
/// * [posicaoFinal]
/// * [capacidadePesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [profundidadeCm]
/// * [distanciaBase]
/// * [distanciaPorModulo]
/// * [ignorarExistentes]
/// * [simular]
@BuiltValue()
abstract class GerarEnderecos implements Built<GerarEnderecos, GerarEnderecosBuilder> {
  @BuiltValueField(wireName: r'zonaId')
  String? get zonaId;

  @BuiltValueField(wireName: r'ruas')
  BuiltList<String>? get ruas;

  @BuiltValueField(wireName: r'moduloInicial')
  int? get moduloInicial;

  @BuiltValueField(wireName: r'moduloFinal')
  int? get moduloFinal;

  @BuiltValueField(wireName: r'nivelInicial')
  int? get nivelInicial;

  @BuiltValueField(wireName: r'nivelFinal')
  int? get nivelFinal;

  @BuiltValueField(wireName: r'posicaoInicial')
  int? get posicaoInicial;

  @BuiltValueField(wireName: r'posicaoFinal')
  int? get posicaoFinal;

  @BuiltValueField(wireName: r'capacidadePesoKg')
  double? get capacidadePesoKg;

  @BuiltValueField(wireName: r'alturaCm')
  double? get alturaCm;

  @BuiltValueField(wireName: r'larguraCm')
  double? get larguraCm;

  @BuiltValueField(wireName: r'profundidadeCm')
  double? get profundidadeCm;

  @BuiltValueField(wireName: r'distanciaBase')
  double? get distanciaBase;

  @BuiltValueField(wireName: r'distanciaPorModulo')
  double? get distanciaPorModulo;

  @BuiltValueField(wireName: r'ignorarExistentes')
  bool? get ignorarExistentes;

  @BuiltValueField(wireName: r'simular')
  bool? get simular;

  GerarEnderecos._();

  factory GerarEnderecos([void updates(GerarEnderecosBuilder b)]) = _$GerarEnderecos;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GerarEnderecosBuilder b) => b
    ..ignorarExistentes = false
    ..simular = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<GerarEnderecos> get serializer => _$GerarEnderecosSerializer();
}

class _$GerarEnderecosSerializer implements PrimitiveSerializer<GerarEnderecos> {
  @override
  final Iterable<Type> types = const [GerarEnderecos, _$GerarEnderecos];

  @override
  final String wireName = r'GerarEnderecos';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GerarEnderecos object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zonaId';
    yield object.zonaId == null
        ? null
        : serializers.serialize(
            object.zonaId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ruas';
    yield object.ruas == null
        ? null
        : serializers.serialize(
            object.ruas,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          );
    yield r'moduloInicial';
    yield object.moduloInicial == null
        ? null
        : serializers.serialize(
            object.moduloInicial,
            specifiedType: const FullType.nullable(int),
          );
    yield r'moduloFinal';
    yield object.moduloFinal == null
        ? null
        : serializers.serialize(
            object.moduloFinal,
            specifiedType: const FullType.nullable(int),
          );
    yield r'nivelInicial';
    yield object.nivelInicial == null
        ? null
        : serializers.serialize(
            object.nivelInicial,
            specifiedType: const FullType.nullable(int),
          );
    yield r'nivelFinal';
    yield object.nivelFinal == null
        ? null
        : serializers.serialize(
            object.nivelFinal,
            specifiedType: const FullType.nullable(int),
          );
    yield r'posicaoInicial';
    yield object.posicaoInicial == null
        ? null
        : serializers.serialize(
            object.posicaoInicial,
            specifiedType: const FullType.nullable(int),
          );
    yield r'posicaoFinal';
    yield object.posicaoFinal == null
        ? null
        : serializers.serialize(
            object.posicaoFinal,
            specifiedType: const FullType.nullable(int),
          );
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
    yield r'distanciaBase';
    yield object.distanciaBase == null
        ? null
        : serializers.serialize(
            object.distanciaBase,
            specifiedType: const FullType.nullable(double),
          );
    yield r'distanciaPorModulo';
    yield object.distanciaPorModulo == null
        ? null
        : serializers.serialize(
            object.distanciaPorModulo,
            specifiedType: const FullType.nullable(double),
          );
    if (object.ignorarExistentes != null) {
      yield r'ignorarExistentes';
      yield serializers.serialize(
        object.ignorarExistentes,
        specifiedType: const FullType(bool),
      );
    }
    if (object.simular != null) {
      yield r'simular';
      yield serializers.serialize(
        object.simular,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GerarEnderecos object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GerarEnderecosBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'zonaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.zonaId = valueDes;
          break;
        case r'ruas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.ruas.replace(valueDes);
          break;
        case r'moduloInicial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.moduloInicial = valueDes;
          break;
        case r'moduloFinal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.moduloFinal = valueDes;
          break;
        case r'nivelInicial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.nivelInicial = valueDes;
          break;
        case r'nivelFinal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.nivelFinal = valueDes;
          break;
        case r'posicaoInicial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.posicaoInicial = valueDes;
          break;
        case r'posicaoFinal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.posicaoFinal = valueDes;
          break;
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
        case r'distanciaBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.distanciaBase = valueDes;
          break;
        case r'distanciaPorModulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.distanciaPorModulo = valueDes;
          break;
        case r'ignorarExistentes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ignorarExistentes = valueDes;
          break;
        case r'simular':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.simular = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GerarEnderecos deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GerarEnderecosBuilder();
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
