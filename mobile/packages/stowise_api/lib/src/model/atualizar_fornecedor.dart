//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'atualizar_fornecedor.g.dart';

/// AtualizarFornecedor
///
/// Properties:
/// * [razaoSocial]
/// * [nomeFantasia]
/// * [versao]
@BuiltValue()
abstract class AtualizarFornecedor implements Built<AtualizarFornecedor, AtualizarFornecedorBuilder> {
  @BuiltValueField(wireName: r'razaoSocial')
  String? get razaoSocial;

  @BuiltValueField(wireName: r'nomeFantasia')
  String? get nomeFantasia;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AtualizarFornecedor._();

  factory AtualizarFornecedor([void updates(AtualizarFornecedorBuilder b)]) = _$AtualizarFornecedor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AtualizarFornecedorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AtualizarFornecedor> get serializer => _$AtualizarFornecedorSerializer();
}

class _$AtualizarFornecedorSerializer implements PrimitiveSerializer<AtualizarFornecedor> {
  @override
  final Iterable<Type> types = const [AtualizarFornecedor, _$AtualizarFornecedor];

  @override
  final String wireName = r'AtualizarFornecedor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AtualizarFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    AtualizarFornecedor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AtualizarFornecedorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AtualizarFornecedor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AtualizarFornecedorBuilder();
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
