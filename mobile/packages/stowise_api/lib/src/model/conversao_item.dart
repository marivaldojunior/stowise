//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/origem_fator.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversao_item.g.dart';

/// ConversaoItem
///
/// Properties:
/// * [fator]
/// * [origem]
/// * [quantidadeBase]
@BuiltValue()
abstract class ConversaoItem implements Built<ConversaoItem, ConversaoItemBuilder> {
  @BuiltValueField(wireName: r'fator')
  double? get fator;

  @BuiltValueField(wireName: r'origem')
  OrigemFator get origem;
  // enum origemEnum {  Nota,  DePara,  Embalagem,  Desconhecido,  };

  @BuiltValueField(wireName: r'quantidadeBase')
  double? get quantidadeBase;

  ConversaoItem._();

  factory ConversaoItem([void updates(ConversaoItemBuilder b)]) = _$ConversaoItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversaoItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversaoItem> get serializer => _$ConversaoItemSerializer();
}

class _$ConversaoItemSerializer implements PrimitiveSerializer<ConversaoItem> {
  @override
  final Iterable<Type> types = const [ConversaoItem, _$ConversaoItem];

  @override
  final String wireName = r'ConversaoItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversaoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fator';
    yield object.fator == null
        ? null
        : serializers.serialize(
            object.fator,
            specifiedType: const FullType.nullable(double),
          );
    yield r'origem';
    yield serializers.serialize(
      object.origem,
      specifiedType: const FullType(OrigemFator),
    );
    yield r'quantidadeBase';
    yield object.quantidadeBase == null
        ? null
        : serializers.serialize(
            object.quantidadeBase,
            specifiedType: const FullType.nullable(double),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConversaoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversaoItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fator = valueDes;
          break;
        case r'origem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrigemFator),
          ) as OrigemFator;
          result.origem = valueDes;
          break;
        case r'quantidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidadeBase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConversaoItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversaoItemBuilder();
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
