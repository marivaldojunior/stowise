//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'alterar_recebimento.g.dart';

/// AlterarRecebimento
///
/// Properties:
/// * [versao]
@BuiltValue()
abstract class AlterarRecebimento implements Built<AlterarRecebimento, AlterarRecebimentoBuilder> {
  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AlterarRecebimento._();

  factory AlterarRecebimento([void updates(AlterarRecebimentoBuilder b)]) = _$AlterarRecebimento;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlterarRecebimentoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlterarRecebimento> get serializer => _$AlterarRecebimentoSerializer();
}

class _$AlterarRecebimentoSerializer implements PrimitiveSerializer<AlterarRecebimento> {
  @override
  final Iterable<Type> types = const [AlterarRecebimento, _$AlterarRecebimento];

  @override
  final String wireName = r'AlterarRecebimento';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlterarRecebimento object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    AlterarRecebimento object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlterarRecebimentoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AlterarRecebimento deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlterarRecebimentoBuilder();
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
