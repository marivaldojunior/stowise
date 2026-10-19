//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'erro_linha.g.dart';

/// ErroLinha
///
/// Properties:
/// * [campo]
/// * [mensagem]
@BuiltValue()
abstract class ErroLinha implements Built<ErroLinha, ErroLinhaBuilder> {
  @BuiltValueField(wireName: r'campo')
  String get campo;

  @BuiltValueField(wireName: r'mensagem')
  String get mensagem;

  ErroLinha._();

  factory ErroLinha([void updates(ErroLinhaBuilder b)]) = _$ErroLinha;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ErroLinhaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ErroLinha> get serializer => _$ErroLinhaSerializer();
}

class _$ErroLinhaSerializer implements PrimitiveSerializer<ErroLinha> {
  @override
  final Iterable<Type> types = const [ErroLinha, _$ErroLinha];

  @override
  final String wireName = r'ErroLinha';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ErroLinha object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'campo';
    yield serializers.serialize(
      object.campo,
      specifiedType: const FullType(String),
    );
    yield r'mensagem';
    yield serializers.serialize(
      object.mensagem,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ErroLinha object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ErroLinhaBuilder result,
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
        case r'mensagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensagem = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ErroLinha deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ErroLinhaBuilder();
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
