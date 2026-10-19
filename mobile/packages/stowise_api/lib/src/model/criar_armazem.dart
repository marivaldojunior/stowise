//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_armazem.g.dart';

/// CriarArmazem
///
/// Properties:
/// * [codigo]
/// * [nome]
@BuiltValue()
abstract class CriarArmazem implements Built<CriarArmazem, CriarArmazemBuilder> {
  @BuiltValueField(wireName: r'codigo')
  String? get codigo;

  @BuiltValueField(wireName: r'nome')
  String? get nome;

  CriarArmazem._();

  factory CriarArmazem([void updates(CriarArmazemBuilder b)]) = _$CriarArmazem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarArmazemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarArmazem> get serializer => _$CriarArmazemSerializer();
}

class _$CriarArmazemSerializer implements PrimitiveSerializer<CriarArmazem> {
  @override
  final Iterable<Type> types = const [CriarArmazem, _$CriarArmazem];

  @override
  final String wireName = r'CriarArmazem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarArmazem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codigo';
    yield object.codigo == null
        ? null
        : serializers.serialize(
            object.codigo,
            specifiedType: const FullType.nullable(String),
          );
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
    CriarArmazem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarArmazemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codigo = valueDes;
          break;
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
  CriarArmazem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarArmazemBuilder();
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
