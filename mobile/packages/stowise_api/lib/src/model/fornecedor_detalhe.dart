//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fornecedor_detalhe.g.dart';

/// FornecedorDetalhe
///
/// Properties:
/// * [id]
/// * [cnpj]
/// * [razaoSocial]
/// * [nomeFantasia]
/// * [produtosVinculados]
/// * [versao]
@BuiltValue()
abstract class FornecedorDetalhe implements Built<FornecedorDetalhe, FornecedorDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cnpj')
  String get cnpj;

  @BuiltValueField(wireName: r'razaoSocial')
  String get razaoSocial;

  @BuiltValueField(wireName: r'nomeFantasia')
  String? get nomeFantasia;

  @BuiltValueField(wireName: r'produtosVinculados')
  int get produtosVinculados;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  FornecedorDetalhe._();

  factory FornecedorDetalhe([void updates(FornecedorDetalheBuilder b)]) = _$FornecedorDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FornecedorDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FornecedorDetalhe> get serializer => _$FornecedorDetalheSerializer();
}

class _$FornecedorDetalheSerializer implements PrimitiveSerializer<FornecedorDetalhe> {
  @override
  final Iterable<Type> types = const [FornecedorDetalhe, _$FornecedorDetalhe];

  @override
  final String wireName = r'FornecedorDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cnpj';
    yield serializers.serialize(
      object.cnpj,
      specifiedType: const FullType(String),
    );
    yield r'razaoSocial';
    yield serializers.serialize(
      object.razaoSocial,
      specifiedType: const FullType(String),
    );
    yield r'nomeFantasia';
    yield object.nomeFantasia == null
        ? null
        : serializers.serialize(
            object.nomeFantasia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'produtosVinculados';
    yield serializers.serialize(
      object.produtosVinculados,
      specifiedType: const FullType(int),
    );
    yield r'versao';
    yield serializers.serialize(
      object.versao,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FornecedorDetalheBuilder result,
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
        case r'cnpj':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cnpj = valueDes;
          break;
        case r'razaoSocial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'produtosVinculados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.produtosVinculados = valueDes;
          break;
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  FornecedorDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FornecedorDetalheBuilder();
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
