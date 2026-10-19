//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'coluna_arquivo.g.dart';

/// ColunaArquivo
///
/// Properties:
/// * [indice]
/// * [nome]
/// * [inicio]
/// * [tamanho]
@BuiltValue()
abstract class ColunaArquivo implements Built<ColunaArquivo, ColunaArquivoBuilder> {
  @BuiltValueField(wireName: r'indice')
  int get indice;

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'inicio')
  int? get inicio;

  @BuiltValueField(wireName: r'tamanho')
  int? get tamanho;

  ColunaArquivo._();

  factory ColunaArquivo([void updates(ColunaArquivoBuilder b)]) = _$ColunaArquivo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ColunaArquivoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ColunaArquivo> get serializer => _$ColunaArquivoSerializer();
}

class _$ColunaArquivoSerializer implements PrimitiveSerializer<ColunaArquivo> {
  @override
  final Iterable<Type> types = const [ColunaArquivo, _$ColunaArquivo];

  @override
  final String wireName = r'ColunaArquivo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ColunaArquivo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'indice';
    yield serializers.serialize(
      object.indice,
      specifiedType: const FullType(int),
    );
    yield r'nome';
    yield serializers.serialize(
      object.nome,
      specifiedType: const FullType(String),
    );
    if (object.inicio != null) {
      yield r'inicio';
      yield serializers.serialize(
        object.inicio,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.tamanho != null) {
      yield r'tamanho';
      yield serializers.serialize(
        object.tamanho,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ColunaArquivo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ColunaArquivoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'indice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.indice = valueDes;
          break;
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nome = valueDes;
          break;
        case r'inicio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inicio = valueDes;
          break;
        case r'tamanho':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.tamanho = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ColunaArquivo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ColunaArquivoBuilder();
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
