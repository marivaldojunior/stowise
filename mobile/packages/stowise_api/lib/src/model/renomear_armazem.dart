//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'renomear_armazem.g.dart';

/// RenomearArmazem
///
/// Properties:
/// * [nome]
@BuiltValue()
abstract class RenomearArmazem implements Built<RenomearArmazem, RenomearArmazemBuilder> {
  @BuiltValueField(wireName: r'nome')
  String? get nome;

  RenomearArmazem._();

  factory RenomearArmazem([void updates(RenomearArmazemBuilder b)]) = _$RenomearArmazem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RenomearArmazemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RenomearArmazem> get serializer => _$RenomearArmazemSerializer();
}

class _$RenomearArmazemSerializer implements PrimitiveSerializer<RenomearArmazem> {
  @override
  final Iterable<Type> types = const [RenomearArmazem, _$RenomearArmazem];

  @override
  final String wireName = r'RenomearArmazem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RenomearArmazem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield object.nome == null
        ? null
        : serializers.serialize(
            object.nome,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    RenomearArmazem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RenomearArmazemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nome = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RenomearArmazem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RenomearArmazemBuilder();
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
