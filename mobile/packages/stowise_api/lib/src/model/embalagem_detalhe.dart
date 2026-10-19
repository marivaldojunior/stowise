//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_embalagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'embalagem_detalhe.g.dart';

/// EmbalagemDetalhe
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [fatorConversao]
/// * [unidadeBase]
/// * [gtin]
/// * [pesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [comprimentoCm]
@BuiltValue()
abstract class EmbalagemDetalhe implements Built<EmbalagemDetalhe, EmbalagemDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoEmbalagem get tipo;
  // enum tipoEnum {  Unidade,  Caixa,  Palete,  };

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'unidadeBase')
  bool get unidadeBase;

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

  EmbalagemDetalhe._();

  factory EmbalagemDetalhe([void updates(EmbalagemDetalheBuilder b)]) = _$EmbalagemDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmbalagemDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmbalagemDetalhe> get serializer => _$EmbalagemDetalheSerializer();
}

class _$EmbalagemDetalheSerializer implements PrimitiveSerializer<EmbalagemDetalhe> {
  @override
  final Iterable<Type> types = const [EmbalagemDetalhe, _$EmbalagemDetalhe];

  @override
  final String wireName = r'EmbalagemDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmbalagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'tipo';
    yield serializers.serialize(
      object.tipo,
      specifiedType: const FullType(TipoEmbalagem),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'unidadeBase';
    yield serializers.serialize(
      object.unidadeBase,
      specifiedType: const FullType(bool),
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
    EmbalagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmbalagemDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoEmbalagem),
          ) as TipoEmbalagem;
          result.tipo = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'unidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unidadeBase = valueDes;
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
  EmbalagemDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmbalagemDetalheBuilder();
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
