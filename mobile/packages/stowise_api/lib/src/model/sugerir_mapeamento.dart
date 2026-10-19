//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sugerir_mapeamento.g.dart';

/// SugerirMapeamento
///
/// Properties:
/// * [versao]
@BuiltValue()
abstract class SugerirMapeamento implements Built<SugerirMapeamento, SugerirMapeamentoBuilder> {
  @BuiltValueField(wireName: r'versao')
  int? get versao;

  SugerirMapeamento._();

  factory SugerirMapeamento([void updates(SugerirMapeamentoBuilder b)]) = _$SugerirMapeamento;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SugerirMapeamentoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SugerirMapeamento> get serializer => _$SugerirMapeamentoSerializer();
}

class _$SugerirMapeamentoSerializer implements PrimitiveSerializer<SugerirMapeamento> {
  @override
  final Iterable<Type> types = const [SugerirMapeamento, _$SugerirMapeamento];

  @override
  final String wireName = r'SugerirMapeamento';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SugerirMapeamento object, {
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
    SugerirMapeamento object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SugerirMapeamentoBuilder result,
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
  SugerirMapeamento deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SugerirMapeamentoBuilder();
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
