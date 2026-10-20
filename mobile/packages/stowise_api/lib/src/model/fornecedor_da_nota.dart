//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fornecedor_da_nota.g.dart';

/// FornecedorDaNota
///
/// Properties:
/// * [fornecedorId]
/// * [cnpj]
/// * [cpf]
/// * [razaoSocial]
/// * [nomeFantasia]
@BuiltValue()
abstract class FornecedorDaNota implements Built<FornecedorDaNota, FornecedorDaNotaBuilder> {
  @BuiltValueField(wireName: r'fornecedorId')
  String? get fornecedorId;

  @BuiltValueField(wireName: r'cnpj')
  String? get cnpj;

  @BuiltValueField(wireName: r'cpf')
  String? get cpf;

  @BuiltValueField(wireName: r'razaoSocial')
  String get razaoSocial;

  @BuiltValueField(wireName: r'nomeFantasia')
  String? get nomeFantasia;

  FornecedorDaNota._();

  factory FornecedorDaNota([void updates(FornecedorDaNotaBuilder b)]) = _$FornecedorDaNota;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FornecedorDaNotaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FornecedorDaNota> get serializer => _$FornecedorDaNotaSerializer();
}

class _$FornecedorDaNotaSerializer implements PrimitiveSerializer<FornecedorDaNota> {
  @override
  final Iterable<Type> types = const [FornecedorDaNota, _$FornecedorDaNota];

  @override
  final String wireName = r'FornecedorDaNota';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FornecedorDaNota object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fornecedorId';
    yield object.fornecedorId == null
        ? null
        : serializers.serialize(
            object.fornecedorId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cnpj';
    yield object.cnpj == null
        ? null
        : serializers.serialize(
            object.cnpj,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cpf';
    yield object.cpf == null
        ? null
        : serializers.serialize(
            object.cpf,
            specifiedType: const FullType.nullable(String),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FornecedorDaNota object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FornecedorDaNotaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fornecedorId = valueDes;
          break;
        case r'cnpj':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cnpj = valueDes;
          break;
        case r'cpf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cpf = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FornecedorDaNota deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FornecedorDaNotaBuilder();
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
