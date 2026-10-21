//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'endereco_descartado.g.dart';

/// EnderecoDescartado
///
/// Properties:
/// * [enderecoId]
/// * [codigo]
/// * [motivos]
@BuiltValue()
abstract class EnderecoDescartado implements Built<EnderecoDescartado, EnderecoDescartadoBuilder> {
  @BuiltValueField(wireName: r'enderecoId')
  String get enderecoId;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'motivos')
  BuiltList<String> get motivos;

  EnderecoDescartado._();

  factory EnderecoDescartado([void updates(EnderecoDescartadoBuilder b)]) = _$EnderecoDescartado;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnderecoDescartadoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnderecoDescartado> get serializer => _$EnderecoDescartadoSerializer();
}

class _$EnderecoDescartadoSerializer implements PrimitiveSerializer<EnderecoDescartado> {
  @override
  final Iterable<Type> types = const [EnderecoDescartado, _$EnderecoDescartado];

  @override
  final String wireName = r'EnderecoDescartado';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnderecoDescartado object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enderecoId';
    yield serializers.serialize(
      object.enderecoId,
      specifiedType: const FullType(String),
    );
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'motivos';
    yield serializers.serialize(
      object.motivos,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnderecoDescartado object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnderecoDescartadoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enderecoId = valueDes;
          break;
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'motivos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.motivos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnderecoDescartado deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnderecoDescartadoBuilder();
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
