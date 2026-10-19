//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mapeamento_coluna.g.dart';

/// MapeamentoColuna
///
/// Properties:
/// * [campo]
/// * [coluna]
@BuiltValue()
abstract class MapeamentoColuna implements Built<MapeamentoColuna, MapeamentoColunaBuilder> {
  @BuiltValueField(wireName: r'campo')
  String get campo;

  @BuiltValueField(wireName: r'coluna')
  int get coluna;

  MapeamentoColuna._();

  factory MapeamentoColuna([void updates(MapeamentoColunaBuilder b)]) = _$MapeamentoColuna;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MapeamentoColunaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MapeamentoColuna> get serializer => _$MapeamentoColunaSerializer();
}

class _$MapeamentoColunaSerializer implements PrimitiveSerializer<MapeamentoColuna> {
  @override
  final Iterable<Type> types = const [MapeamentoColuna, _$MapeamentoColuna];

  @override
  final String wireName = r'MapeamentoColuna';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MapeamentoColuna object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'campo';
    yield serializers.serialize(
      object.campo,
      specifiedType: const FullType(String),
    );
    yield r'coluna';
    yield serializers.serialize(
      object.coluna,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MapeamentoColuna object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MapeamentoColunaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'campo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.campo = valueDes;
          break;
        case r'coluna':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.coluna = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MapeamentoColuna deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MapeamentoColunaBuilder();
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
