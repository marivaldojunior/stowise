//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gerar_etiquetas_rfid.g.dart';

/// GerarEtiquetasRfid
///
/// Properties:
/// * [embalagemId]
/// * [quantidade]
/// * [tamanhoPrefixoEmpresa]
@BuiltValue()
abstract class GerarEtiquetasRfid implements Built<GerarEtiquetasRfid, GerarEtiquetasRfidBuilder> {
  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'quantidade')
  int? get quantidade;

  @BuiltValueField(wireName: r'tamanhoPrefixoEmpresa')
  int? get tamanhoPrefixoEmpresa;

  GerarEtiquetasRfid._();

  factory GerarEtiquetasRfid([void updates(GerarEtiquetasRfidBuilder b)]) = _$GerarEtiquetasRfid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GerarEtiquetasRfidBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GerarEtiquetasRfid> get serializer => _$GerarEtiquetasRfidSerializer();
}

class _$GerarEtiquetasRfidSerializer implements PrimitiveSerializer<GerarEtiquetasRfid> {
  @override
  final Iterable<Type> types = const [GerarEtiquetasRfid, _$GerarEtiquetasRfid];

  @override
  final String wireName = r'GerarEtiquetasRfid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GerarEtiquetasRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'embalagemId';
    yield object.embalagemId == null
        ? null
        : serializers.serialize(
            object.embalagemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield object.quantidade == null
        ? null
        : serializers.serialize(
            object.quantidade,
            specifiedType: const FullType.nullable(int),
          );
    yield r'tamanhoPrefixoEmpresa';
    yield object.tamanhoPrefixoEmpresa == null
        ? null
        : serializers.serialize(
            object.tamanhoPrefixoEmpresa,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    GerarEtiquetasRfid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GerarEtiquetasRfidBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.embalagemId = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.quantidade = valueDes;
          break;
        case r'tamanhoPrefixoEmpresa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.tamanhoPrefixoEmpresa = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GerarEtiquetasRfid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GerarEtiquetasRfidBuilder();
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
