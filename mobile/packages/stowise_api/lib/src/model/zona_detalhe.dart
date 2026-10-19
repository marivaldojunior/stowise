//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zona_detalhe.g.dart';

/// ZonaDetalhe
///
/// Properties:
/// * [id]
/// * [codigo]
/// * [classeArmazenagem]
/// * [enderecos]
@BuiltValue()
abstract class ZonaDetalhe implements Built<ZonaDetalhe, ZonaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  @BuiltValueField(wireName: r'enderecos')
  int get enderecos;

  ZonaDetalhe._();

  factory ZonaDetalhe([void updates(ZonaDetalheBuilder b)]) = _$ZonaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZonaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZonaDetalhe> get serializer => _$ZonaDetalheSerializer();
}

class _$ZonaDetalheSerializer implements PrimitiveSerializer<ZonaDetalhe> {
  @override
  final Iterable<Type> types = const [ZonaDetalhe, _$ZonaDetalhe];

  @override
  final String wireName = r'ZonaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZonaDetalhe object, {
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
    yield r'classeArmazenagem';
    yield serializers.serialize(
      object.classeArmazenagem,
      specifiedType: const FullType(ClasseArmazenagem),
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
    ZonaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZonaDetalheBuilder result,
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
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClasseArmazenagem),
          ) as ClasseArmazenagem;
          result.classeArmazenagem = valueDes;
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
  ZonaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZonaDetalheBuilder();
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
