//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/zona_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'armazem_detalhe.g.dart';

/// ArmazemDetalhe
///
/// Properties:
/// * [id]
/// * [codigo]
/// * [nome]
/// * [zonas]
@BuiltValue()
abstract class ArmazemDetalhe implements Built<ArmazemDetalhe, ArmazemDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'zonas')
  BuiltList<ZonaDetalhe> get zonas;

  ArmazemDetalhe._();

  factory ArmazemDetalhe([void updates(ArmazemDetalheBuilder b)]) = _$ArmazemDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ArmazemDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ArmazemDetalhe> get serializer => _$ArmazemDetalheSerializer();
}

class _$ArmazemDetalheSerializer implements PrimitiveSerializer<ArmazemDetalhe> {
  @override
  final Iterable<Type> types = const [ArmazemDetalhe, _$ArmazemDetalhe];

  @override
  final String wireName = r'ArmazemDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ArmazemDetalhe object, {
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
      specifiedType: const FullType(BuiltList, [FullType(ZonaDetalhe)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ArmazemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ArmazemDetalheBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(ZonaDetalhe)]),
          ) as BuiltList<ZonaDetalhe>;
          result.zonas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ArmazemDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ArmazemDetalheBuilder();
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
