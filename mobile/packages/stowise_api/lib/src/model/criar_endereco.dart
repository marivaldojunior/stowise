//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_endereco.g.dart';

/// CriarEndereco
///
/// Properties:
/// * [zonaId]
/// * [rua]
/// * [modulo]
/// * [nivel]
/// * [posicao]
/// * [capacidadePesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [profundidadeCm]
/// * [distanciaExpedicao]
@BuiltValue()
abstract class CriarEndereco implements Built<CriarEndereco, CriarEnderecoBuilder> {
  @BuiltValueField(wireName: r'zonaId')
  String? get zonaId;

  @BuiltValueField(wireName: r'rua')
  String? get rua;

  @BuiltValueField(wireName: r'modulo')
  int? get modulo;

  @BuiltValueField(wireName: r'nivel')
  int? get nivel;

  @BuiltValueField(wireName: r'posicao')
  int? get posicao;

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

  CriarEndereco._();

  factory CriarEndereco([void updates(CriarEnderecoBuilder b)]) = _$CriarEndereco;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarEnderecoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarEndereco> get serializer => _$CriarEnderecoSerializer();
}

class _$CriarEnderecoSerializer implements PrimitiveSerializer<CriarEndereco> {
  @override
  final Iterable<Type> types = const [CriarEndereco, _$CriarEndereco];

  @override
  final String wireName = r'CriarEndereco';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zonaId';
    yield object.zonaId == null
        ? null
        : serializers.serialize(
            object.zonaId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'rua';
    yield object.rua == null
        ? null
        : serializers.serialize(
            object.rua,
            specifiedType: const FullType.nullable(String),
          );
    yield r'modulo';
    yield object.modulo == null
        ? null
        : serializers.serialize(
            object.modulo,
            specifiedType: const FullType.nullable(int),
          );
    yield r'nivel';
    yield object.nivel == null
        ? null
        : serializers.serialize(
            object.nivel,
            specifiedType: const FullType.nullable(int),
          );
    yield r'posicao';
    yield object.posicao == null
        ? null
        : serializers.serialize(
            object.posicao,
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
    CriarEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarEnderecoBuilder result,
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
        case r'rua':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rua = valueDes;
          break;
        case r'modulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.modulo = valueDes;
          break;
        case r'nivel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.nivel = valueDes;
          break;
        case r'posicao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.posicao = valueDes;
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
  CriarEndereco deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarEnderecoBuilder();
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
