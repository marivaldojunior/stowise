//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/decisao_item_nota.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'efetivar_nota_fiscal.g.dart';

/// EfetivarNotaFiscal
///
/// Properties:
/// * [xml]
/// * [itens]
@BuiltValue()
abstract class EfetivarNotaFiscal implements Built<EfetivarNotaFiscal, EfetivarNotaFiscalBuilder> {
  @BuiltValueField(wireName: r'xml')
  String? get xml;

  @BuiltValueField(wireName: r'itens')
  BuiltList<DecisaoItemNota>? get itens;

  EfetivarNotaFiscal._();

  factory EfetivarNotaFiscal([void updates(EfetivarNotaFiscalBuilder b)]) = _$EfetivarNotaFiscal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EfetivarNotaFiscalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EfetivarNotaFiscal> get serializer => _$EfetivarNotaFiscalSerializer();
}

class _$EfetivarNotaFiscalSerializer implements PrimitiveSerializer<EfetivarNotaFiscal> {
  @override
  final Iterable<Type> types = const [EfetivarNotaFiscal, _$EfetivarNotaFiscal];

  @override
  final String wireName = r'EfetivarNotaFiscal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EfetivarNotaFiscal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'xml';
    yield object.xml == null
        ? null
        : serializers.serialize(
            object.xml,
            specifiedType: const FullType.nullable(String),
          );
    yield r'itens';
    yield object.itens == null
        ? null
        : serializers.serialize(
            object.itens,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DecisaoItemNota)]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    EfetivarNotaFiscal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EfetivarNotaFiscalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'xml':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.xml = valueDes;
          break;
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DecisaoItemNota)]),
          ) as BuiltList<DecisaoItemNota>?;
          if (valueDes == null) continue;
          result.itens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EfetivarNotaFiscal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EfetivarNotaFiscalBuilder();
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
