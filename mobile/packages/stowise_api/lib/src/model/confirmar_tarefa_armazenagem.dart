//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'confirmar_tarefa_armazenagem.g.dart';

/// ConfirmarTarefaArmazenagem
///
/// Properties:
/// * [enderecoId]
/// * [motivoDivergencia]
/// * [dispositivoId]
/// * [ocorridoEm]
@BuiltValue()
abstract class ConfirmarTarefaArmazenagem
    implements Built<ConfirmarTarefaArmazenagem, ConfirmarTarefaArmazenagemBuilder> {
  @BuiltValueField(wireName: r'enderecoId')
  String? get enderecoId;

  @BuiltValueField(wireName: r'motivoDivergencia')
  String? get motivoDivergencia;

  @BuiltValueField(wireName: r'dispositivoId')
  String? get dispositivoId;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime? get ocorridoEm;

  ConfirmarTarefaArmazenagem._();

  factory ConfirmarTarefaArmazenagem([void updates(ConfirmarTarefaArmazenagemBuilder b)]) =
      _$ConfirmarTarefaArmazenagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConfirmarTarefaArmazenagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConfirmarTarefaArmazenagem> get serializer => _$ConfirmarTarefaArmazenagemSerializer();
}

class _$ConfirmarTarefaArmazenagemSerializer implements PrimitiveSerializer<ConfirmarTarefaArmazenagem> {
  @override
  final Iterable<Type> types = const [ConfirmarTarefaArmazenagem, _$ConfirmarTarefaArmazenagem];

  @override
  final String wireName = r'ConfirmarTarefaArmazenagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConfirmarTarefaArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enderecoId';
    yield object.enderecoId == null
        ? null
        : serializers.serialize(
            object.enderecoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'motivoDivergencia';
    yield object.motivoDivergencia == null
        ? null
        : serializers.serialize(
            object.motivoDivergencia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'dispositivoId';
    yield object.dispositivoId == null
        ? null
        : serializers.serialize(
            object.dispositivoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ocorridoEm';
    yield object.ocorridoEm == null
        ? null
        : serializers.serialize(
            object.ocorridoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConfirmarTarefaArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConfirmarTarefaArmazenagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoId = valueDes;
          break;
        case r'motivoDivergencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoDivergencia = valueDes;
          break;
        case r'dispositivoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dispositivoId = valueDes;
          break;
        case r'ocorridoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.ocorridoEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConfirmarTarefaArmazenagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConfirmarTarefaArmazenagemBuilder();
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
