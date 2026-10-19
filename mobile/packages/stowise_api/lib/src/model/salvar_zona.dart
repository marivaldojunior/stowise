//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salvar_zona.g.dart';

/// SalvarZona
///
/// Properties:
/// * [codigo]
/// * [classeArmazenagem]
@BuiltValue()
abstract class SalvarZona implements Built<SalvarZona, SalvarZonaBuilder> {
  @BuiltValueField(wireName: r'codigo')
  String? get codigo;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem? get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  SalvarZona._();

  factory SalvarZona([void updates(SalvarZonaBuilder b)]) = _$SalvarZona;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalvarZonaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalvarZona> get serializer => _$SalvarZonaSerializer();
}

class _$SalvarZonaSerializer implements PrimitiveSerializer<SalvarZona> {
  @override
  final Iterable<Type> types = const [SalvarZona, _$SalvarZona];

  @override
  final String wireName = r'SalvarZona';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalvarZona object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codigo';
    yield object.codigo == null
        ? null
        : serializers.serialize(
            object.codigo,
            specifiedType: const FullType.nullable(String),
          );
    yield r'classeArmazenagem';
    yield object.classeArmazenagem == null
        ? null
        : serializers.serialize(
            object.classeArmazenagem,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalvarZona object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalvarZonaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.codigo = valueDes;
          break;
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          ) as ClasseArmazenagem?;
          if (valueDes == null) continue;
          result.classeArmazenagem = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalvarZona deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalvarZonaBuilder();
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
