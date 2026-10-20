//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'criar_fornecedor.g.dart';

/// CriarFornecedor
///
/// Properties:
/// * [cnpj]
/// * [razaoSocial]
/// * [nomeFantasia]
@BuiltValue()
abstract class CriarFornecedor implements Built<CriarFornecedor, CriarFornecedorBuilder> {
  @BuiltValueField(wireName: r'cnpj')
  String? get cnpj;

  @BuiltValueField(wireName: r'razaoSocial')
  String? get razaoSocial;

  @BuiltValueField(wireName: r'nomeFantasia')
  String? get nomeFantasia;

  CriarFornecedor._();

  factory CriarFornecedor([void updates(CriarFornecedorBuilder b)]) = _$CriarFornecedor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CriarFornecedorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CriarFornecedor> get serializer => _$CriarFornecedorSerializer();
}

class _$CriarFornecedorSerializer implements PrimitiveSerializer<CriarFornecedor> {
  @override
  final Iterable<Type> types = const [CriarFornecedor, _$CriarFornecedor];

  @override
  final String wireName = r'CriarFornecedor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CriarFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cnpj';
    yield object.cnpj == null
        ? null
        : serializers.serialize(
            object.cnpj,
            specifiedType: const FullType.nullable(String),
          );
    yield r'razaoSocial';
    yield object.razaoSocial == null
        ? null
        : serializers.serialize(
            object.razaoSocial,
            specifiedType: const FullType.nullable(String),
          );
    yield r'nomeFantasia';
    yield object.nomeFantasia == null
        ? null
        : serializers.serialize(
            object.nomeFantasia,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CriarFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CriarFornecedorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cnpj':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cnpj = valueDes;
          break;
        case r'razaoSocial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.razaoSocial = valueDes;
          break;
        case r'nomeFantasia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nomeFantasia = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CriarFornecedor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CriarFornecedorBuilder();
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
