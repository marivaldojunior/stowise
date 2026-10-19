//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'renomear_template.g.dart';

/// RenomearTemplate
///
/// Properties:
/// * [nome]
/// * [versao]
@BuiltValue()
abstract class RenomearTemplate implements Built<RenomearTemplate, RenomearTemplateBuilder> {
  @BuiltValueField(wireName: r'nome')
  String? get nome;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  RenomearTemplate._();

  factory RenomearTemplate([void updates(RenomearTemplateBuilder b)]) = _$RenomearTemplate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RenomearTemplateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RenomearTemplate> get serializer => _$RenomearTemplateSerializer();
}

class _$RenomearTemplateSerializer implements PrimitiveSerializer<RenomearTemplate> {
  @override
  final Iterable<Type> types = const [RenomearTemplate, _$RenomearTemplate];

  @override
  final String wireName = r'RenomearTemplate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RenomearTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield object.nome == null
        ? null
        : serializers.serialize(
            object.nome,
            specifiedType: const FullType.nullable(String),
          );
    yield r'versao';
    yield object.versao == null
        ? null
        : serializers.serialize(
            object.versao,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    RenomearTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RenomearTemplateBuilder result,
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
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.versao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RenomearTemplate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RenomearTemplateBuilder();
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
