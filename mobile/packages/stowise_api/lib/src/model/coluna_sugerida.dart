//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'coluna_sugerida.g.dart';

/// ColunaSugerida
///
/// Properties:
/// * [campo]
/// * [coluna]
/// * [confianca]
@BuiltValue()
abstract class ColunaSugerida implements Built<ColunaSugerida, ColunaSugeridaBuilder> {
  @BuiltValueField(wireName: r'campo')
  String get campo;

  @BuiltValueField(wireName: r'coluna')
  int get coluna;

  @BuiltValueField(wireName: r'confianca')
  double get confianca;

  ColunaSugerida._();

  factory ColunaSugerida([void updates(ColunaSugeridaBuilder b)]) = _$ColunaSugerida;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ColunaSugeridaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ColunaSugerida> get serializer => _$ColunaSugeridaSerializer();
}

class _$ColunaSugeridaSerializer implements PrimitiveSerializer<ColunaSugerida> {
  @override
  final Iterable<Type> types = const [ColunaSugerida, _$ColunaSugerida];

  @override
  final String wireName = r'ColunaSugerida';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ColunaSugerida object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'campo';
    yield serializers.serialize(
      object.campo,
      specifiedType: const FullType(String),
    );
    yield r'coluna';
    yield serializers.serialize(
      object.coluna,
      specifiedType: const FullType(int),
    );
    yield r'confianca';
    yield serializers.serialize(
      object.confianca,
      specifiedType: const FullType(double),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ColunaSugerida object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ColunaSugeridaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'campo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.campo = valueDes;
          break;
        case r'coluna':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.coluna = valueDes;
          break;
        case r'confianca':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.confianca = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ColunaSugerida deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ColunaSugeridaBuilder();
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
