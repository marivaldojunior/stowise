//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'alterar_regra_armazenagem.g.dart';

/// AlterarRegraArmazenagem
///
/// Properties:
/// * [peso]
/// * [ativa]
/// * [parametros]
/// * [versao]
@BuiltValue()
abstract class AlterarRegraArmazenagem implements Built<AlterarRegraArmazenagem, AlterarRegraArmazenagemBuilder> {
  @BuiltValueField(wireName: r'peso')
  double? get peso;

  @BuiltValueField(wireName: r'ativa')
  bool? get ativa;

  @BuiltValueField(wireName: r'parametros')
  BuiltMap<String, double> get parametros;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AlterarRegraArmazenagem._();

  factory AlterarRegraArmazenagem([void updates(AlterarRegraArmazenagemBuilder b)]) = _$AlterarRegraArmazenagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AlterarRegraArmazenagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AlterarRegraArmazenagem> get serializer => _$AlterarRegraArmazenagemSerializer();
}

class _$AlterarRegraArmazenagemSerializer implements PrimitiveSerializer<AlterarRegraArmazenagem> {
  @override
  final Iterable<Type> types = const [AlterarRegraArmazenagem, _$AlterarRegraArmazenagem];

  @override
  final String wireName = r'AlterarRegraArmazenagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AlterarRegraArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'peso';
    yield object.peso == null
        ? null
        : serializers.serialize(
            object.peso,
            specifiedType: const FullType.nullable(double),
          );
    yield r'ativa';
    yield object.ativa == null
        ? null
        : serializers.serialize(
            object.ativa,
            specifiedType: const FullType.nullable(bool),
          );
    yield r'parametros';
    yield serializers.serialize(
      object.parametros,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
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
    AlterarRegraArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AlterarRegraArmazenagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'peso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.peso = valueDes;
          break;
        case r'ativa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.ativa = valueDes;
          break;
        case r'parametros':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
          ) as BuiltMap<String, double>;
          result.parametros.replace(valueDes);
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
  AlterarRegraArmazenagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AlterarRegraArmazenagemBuilder();
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
