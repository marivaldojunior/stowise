//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bloquear_endereco.g.dart';

/// BloquearEndereco
///
/// Properties:
/// * [motivo]
@BuiltValue()
abstract class BloquearEndereco implements Built<BloquearEndereco, BloquearEnderecoBuilder> {
  @BuiltValueField(wireName: r'motivo')
  String? get motivo;

  BloquearEndereco._();

  factory BloquearEndereco([void updates(BloquearEnderecoBuilder b)]) = _$BloquearEndereco;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BloquearEnderecoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BloquearEndereco> get serializer => _$BloquearEnderecoSerializer();
}

class _$BloquearEnderecoSerializer implements PrimitiveSerializer<BloquearEndereco> {
  @override
  final Iterable<Type> types = const [BloquearEndereco, _$BloquearEndereco];

  @override
  final String wireName = r'BloquearEndereco';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BloquearEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'motivo';
    yield object.motivo == null
        ? null
        : serializers.serialize(
            object.motivo,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    BloquearEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BloquearEnderecoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'motivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BloquearEndereco deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BloquearEnderecoBuilder();
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
