//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nota_regra.g.dart';

/// NotaRegra
///
/// Properties:
/// * [codigo]
/// * [peso]
/// * [ativa]
/// * [nota]
/// * [explicacao]
@BuiltValue()
abstract class NotaRegra implements Built<NotaRegra, NotaRegraBuilder> {
  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'peso')
  double get peso;

  @BuiltValueField(wireName: r'ativa')
  bool get ativa;

  @BuiltValueField(wireName: r'nota')
  double? get nota;

  @BuiltValueField(wireName: r'explicacao')
  String get explicacao;

  NotaRegra._();

  factory NotaRegra([void updates(NotaRegraBuilder b)]) = _$NotaRegra;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotaRegraBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotaRegra> get serializer => _$NotaRegraSerializer();
}

class _$NotaRegraSerializer implements PrimitiveSerializer<NotaRegra> {
  @override
  final Iterable<Type> types = const [NotaRegra, _$NotaRegra];

  @override
  final String wireName = r'NotaRegra';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotaRegra object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'peso';
    yield serializers.serialize(
      object.peso,
      specifiedType: const FullType(double),
    );
    yield r'ativa';
    yield serializers.serialize(
      object.ativa,
      specifiedType: const FullType(bool),
    );
    yield r'nota';
    yield object.nota == null
        ? null
        : serializers.serialize(
            object.nota,
            specifiedType: const FullType.nullable(double),
          );
    yield r'explicacao';
    yield serializers.serialize(
      object.explicacao,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotaRegra object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotaRegraBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'peso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.peso = valueDes;
          break;
        case r'ativa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ativa = valueDes;
          break;
        case r'nota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.nota = valueDes;
          break;
        case r'explicacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explicacao = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotaRegra deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotaRegraBuilder();
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
