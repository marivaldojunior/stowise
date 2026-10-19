//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_embalagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adicionar_embalagem.g.dart';

/// AdicionarEmbalagem
///
/// Properties:
/// * [tipo]
/// * [fatorConversao]
/// * [gtin]
/// * [pesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [comprimentoCm]
@BuiltValue()
abstract class AdicionarEmbalagem implements Built<AdicionarEmbalagem, AdicionarEmbalagemBuilder> {
  @BuiltValueField(wireName: r'tipo')
  TipoEmbalagem? get tipo;
  // enum tipoEnum {  Unidade,  Caixa,  Palete,  };

  @BuiltValueField(wireName: r'fatorConversao')
  double? get fatorConversao;

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

  AdicionarEmbalagem._();

  factory AdicionarEmbalagem([void updates(AdicionarEmbalagemBuilder b)]) = _$AdicionarEmbalagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdicionarEmbalagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdicionarEmbalagem> get serializer => _$AdicionarEmbalagemSerializer();
}

class _$AdicionarEmbalagemSerializer implements PrimitiveSerializer<AdicionarEmbalagem> {
  @override
  final Iterable<Type> types = const [AdicionarEmbalagem, _$AdicionarEmbalagem];

  @override
  final String wireName = r'AdicionarEmbalagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdicionarEmbalagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tipo';
    yield object.tipo == null
        ? null
        : serializers.serialize(
            object.tipo,
            specifiedType: const FullType.nullable(TipoEmbalagem),
          );
    yield r'fatorConversao';
    yield object.fatorConversao == null
        ? null
        : serializers.serialize(
            object.fatorConversao,
            specifiedType: const FullType.nullable(double),
          );
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
    AdicionarEmbalagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdicionarEmbalagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TipoEmbalagem),
          ) as TipoEmbalagem?;
          if (valueDes == null) continue;
          result.tipo = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fatorConversao = valueDes;
          break;
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
  AdicionarEmbalagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdicionarEmbalagemBuilder();
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
