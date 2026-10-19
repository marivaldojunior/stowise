//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unidade_de_para.g.dart';

/// UnidadeDePara
///
/// Properties:
/// * [origem]
/// * [destino]
@BuiltValue()
abstract class UnidadeDePara implements Built<UnidadeDePara, UnidadeDeParaBuilder> {
  @BuiltValueField(wireName: r'origem')
  String get origem;

  @BuiltValueField(wireName: r'destino')
  String get destino;

  UnidadeDePara._();

  factory UnidadeDePara([void updates(UnidadeDeParaBuilder b)]) = _$UnidadeDePara;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnidadeDeParaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnidadeDePara> get serializer => _$UnidadeDeParaSerializer();
}

class _$UnidadeDeParaSerializer implements PrimitiveSerializer<UnidadeDePara> {
  @override
  final Iterable<Type> types = const [UnidadeDePara, _$UnidadeDePara];

  @override
  final String wireName = r'UnidadeDePara';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnidadeDePara object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'origem';
    yield serializers.serialize(
      object.origem,
      specifiedType: const FullType(String),
    );
    yield r'destino';
    yield serializers.serialize(
      object.destino,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnidadeDePara object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UnidadeDeParaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'origem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origem = valueDes;
          break;
        case r'destino':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destino = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnidadeDePara deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnidadeDeParaBuilder();
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
