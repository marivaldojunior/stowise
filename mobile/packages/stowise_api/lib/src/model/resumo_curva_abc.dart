//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resumo_curva_abc.g.dart';

/// ResumoCurvaAbc
///
/// Properties:
/// * [desde]
/// * [classeA]
/// * [classeB]
/// * [classeC]
/// * [alterados]
@BuiltValue()
abstract class ResumoCurvaAbc implements Built<ResumoCurvaAbc, ResumoCurvaAbcBuilder> {
  @BuiltValueField(wireName: r'desde')
  DateTime get desde;

  @BuiltValueField(wireName: r'classeA')
  int get classeA;

  @BuiltValueField(wireName: r'classeB')
  int get classeB;

  @BuiltValueField(wireName: r'classeC')
  int get classeC;

  @BuiltValueField(wireName: r'alterados')
  int get alterados;

  ResumoCurvaAbc._();

  factory ResumoCurvaAbc([void updates(ResumoCurvaAbcBuilder b)]) = _$ResumoCurvaAbc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResumoCurvaAbcBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResumoCurvaAbc> get serializer => _$ResumoCurvaAbcSerializer();
}

class _$ResumoCurvaAbcSerializer implements PrimitiveSerializer<ResumoCurvaAbc> {
  @override
  final Iterable<Type> types = const [ResumoCurvaAbc, _$ResumoCurvaAbc];

  @override
  final String wireName = r'ResumoCurvaAbc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResumoCurvaAbc object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'desde';
    yield serializers.serialize(
      object.desde,
      specifiedType: const FullType(DateTime),
    );
    yield r'classeA';
    yield serializers.serialize(
      object.classeA,
      specifiedType: const FullType(int),
    );
    yield r'classeB';
    yield serializers.serialize(
      object.classeB,
      specifiedType: const FullType(int),
    );
    yield r'classeC';
    yield serializers.serialize(
      object.classeC,
      specifiedType: const FullType(int),
    );
    yield r'alterados';
    yield serializers.serialize(
      object.alterados,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResumoCurvaAbc object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResumoCurvaAbcBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'desde':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.desde = valueDes;
          break;
        case r'classeA':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeA = valueDes;
          break;
        case r'classeB':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeB = valueDes;
          break;
        case r'classeC':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeC = valueDes;
          break;
        case r'alterados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.alterados = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResumoCurvaAbc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResumoCurvaAbcBuilder();
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
