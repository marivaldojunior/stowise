//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/lote_conferido.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conferir_item_recebimento.g.dart';

/// ConferirItemRecebimento
///
/// Properties:
/// * [quantidade]
/// * [lotes]
@BuiltValue()
abstract class ConferirItemRecebimento implements Built<ConferirItemRecebimento, ConferirItemRecebimentoBuilder> {
  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'lotes')
  BuiltList<LoteConferido>? get lotes;

  ConferirItemRecebimento._();

  factory ConferirItemRecebimento([void updates(ConferirItemRecebimentoBuilder b)]) = _$ConferirItemRecebimento;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConferirItemRecebimentoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConferirItemRecebimento> get serializer => _$ConferirItemRecebimentoSerializer();
}

class _$ConferirItemRecebimentoSerializer implements PrimitiveSerializer<ConferirItemRecebimento> {
  @override
  final Iterable<Type> types = const [ConferirItemRecebimento, _$ConferirItemRecebimento];

  @override
  final String wireName = r'ConferirItemRecebimento';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConferirItemRecebimento object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quantidade';
    yield object.quantidade == null
        ? null
        : serializers.serialize(
            object.quantidade,
            specifiedType: const FullType.nullable(double),
          );
    yield r'lotes';
    yield object.lotes == null
        ? null
        : serializers.serialize(
            object.lotes,
            specifiedType: const FullType.nullable(BuiltList, [FullType(LoteConferido)]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConferirItemRecebimento object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConferirItemRecebimentoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidade = valueDes;
          break;
        case r'lotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(LoteConferido)]),
          ) as BuiltList<LoteConferido>?;
          if (valueDes == null) continue;
          result.lotes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConferirItemRecebimento deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConferirItemRecebimentoBuilder();
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
