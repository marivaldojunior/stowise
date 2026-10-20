//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fornecedor_resumo.g.dart';

/// FornecedorResumo
///
/// Properties:
/// * [id]
/// * [cnpj]
/// * [razaoSocial]
/// * [nomeFantasia]
/// * [produtosVinculados]
@BuiltValue()
abstract class FornecedorResumo implements Built<FornecedorResumo, FornecedorResumoBuilder> {
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

  FornecedorResumo._();

  factory FornecedorResumo([void updates(FornecedorResumoBuilder b)]) = _$FornecedorResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FornecedorResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FornecedorResumo> get serializer => _$FornecedorResumoSerializer();
}

class _$FornecedorResumoSerializer implements PrimitiveSerializer<FornecedorResumo> {
  @override
  final Iterable<Type> types = const [FornecedorResumo, _$FornecedorResumo];

  @override
  final String wireName = r'FornecedorResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FornecedorResumo object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FornecedorResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FornecedorResumoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FornecedorResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FornecedorResumoBuilder();
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
