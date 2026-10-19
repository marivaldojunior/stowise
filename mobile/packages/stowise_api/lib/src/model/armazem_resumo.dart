//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'armazem_resumo.g.dart';

/// ArmazemResumo
///
/// Properties:
/// * [id]
/// * [codigo]
/// * [nome]
/// * [zonas]
/// * [enderecos]
@BuiltValue()
abstract class ArmazemResumo implements Built<ArmazemResumo, ArmazemResumoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'zonas')
  int get zonas;

  @BuiltValueField(wireName: r'enderecos')
  int get enderecos;

  ArmazemResumo._();

  factory ArmazemResumo([void updates(ArmazemResumoBuilder b)]) = _$ArmazemResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArmazemResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArmazemResumo> get serializer => _$ArmazemResumoSerializer();
}

class _$ArmazemResumoSerializer implements PrimitiveSerializer<ArmazemResumo> {
  @override
  final Iterable<Type> types = const [ArmazemResumo, _$ArmazemResumo];

  @override
  final String wireName = r'ArmazemResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArmazemResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'nome';
    yield serializers.serialize(
      object.nome,
      specifiedType: const FullType(String),
    );
    yield r'zonas';
    yield serializers.serialize(
      object.zonas,
      specifiedType: const FullType(int),
    );
    yield r'enderecos';
    yield serializers.serialize(
      object.enderecos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArmazemResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArmazemResumoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nome = valueDes;
          break;
        case r'zonas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.zonas = valueDes;
          break;
        case r'enderecos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.enderecos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArmazemResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArmazemResumoBuilder();
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
