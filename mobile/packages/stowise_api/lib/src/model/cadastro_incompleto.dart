//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/pendencia_embalagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cadastro_incompleto.g.dart';

/// CadastroIncompleto
///
/// Properties:
/// * [id]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [categoriaId]
/// * [pendencias]
@BuiltValue()
abstract class CadastroIncompleto implements Built<CadastroIncompleto, CadastroIncompletoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'categoriaId')
  String? get categoriaId;

  @BuiltValueField(wireName: r'pendencias')
  BuiltList<PendenciaEmbalagem> get pendencias;

  CadastroIncompleto._();

  factory CadastroIncompleto([void updates(CadastroIncompletoBuilder b)]) = _$CadastroIncompleto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CadastroIncompletoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CadastroIncompleto> get serializer => _$CadastroIncompletoSerializer();
}

class _$CadastroIncompletoSerializer implements PrimitiveSerializer<CadastroIncompleto> {
  @override
  final Iterable<Type> types = const [CadastroIncompleto, _$CadastroIncompleto];

  @override
  final String wireName = r'CadastroIncompleto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CadastroIncompleto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'descricao';
    yield serializers.serialize(
      object.descricao,
      specifiedType: const FullType(String),
    );
    yield r'unidadeBase';
    yield serializers.serialize(
      object.unidadeBase,
      specifiedType: const FullType(String),
    );
    yield r'categoriaId';
    yield object.categoriaId == null
        ? null
        : serializers.serialize(
            object.categoriaId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pendencias';
    yield serializers.serialize(
      object.pendencias,
      specifiedType: const FullType(BuiltList, [FullType(PendenciaEmbalagem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CadastroIncompleto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CadastroIncompletoBuilder result,
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
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricao = valueDes;
          break;
        case r'unidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeBase = valueDes;
          break;
        case r'categoriaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoriaId = valueDes;
          break;
        case r'pendencias':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PendenciaEmbalagem)]),
          ) as BuiltList<PendenciaEmbalagem>;
          result.pendencias.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CadastroIncompleto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CadastroIncompletoBuilder();
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
