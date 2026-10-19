//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'produto_resumo.g.dart';

/// ProdutoResumo
///
/// Properties:
/// * [id]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [classeArmazenagem]
/// * [categoriaId]
/// * [ativo]
@BuiltValue()
abstract class ProdutoResumo implements Built<ProdutoResumo, ProdutoResumoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  @BuiltValueField(wireName: r'categoriaId')
  String? get categoriaId;

  @BuiltValueField(wireName: r'ativo')
  bool get ativo;

  ProdutoResumo._();

  factory ProdutoResumo([void updates(ProdutoResumoBuilder b)]) = _$ProdutoResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProdutoResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProdutoResumo> get serializer => _$ProdutoResumoSerializer();
}

class _$ProdutoResumoSerializer implements PrimitiveSerializer<ProdutoResumo> {
  @override
  final Iterable<Type> types = const [ProdutoResumo, _$ProdutoResumo];

  @override
  final String wireName = r'ProdutoResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProdutoResumo object, {
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
    yield r'classeArmazenagem';
    yield serializers.serialize(
      object.classeArmazenagem,
      specifiedType: const FullType(ClasseArmazenagem),
    );
    yield r'categoriaId';
    yield object.categoriaId == null
        ? null
        : serializers.serialize(
            object.categoriaId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ativo';
    yield serializers.serialize(
      object.ativo,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProdutoResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProdutoResumoBuilder result,
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
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClasseArmazenagem),
          ) as ClasseArmazenagem;
          result.classeArmazenagem = valueDes;
          break;
        case r'categoriaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoriaId = valueDes;
          break;
        case r'ativo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ativo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProdutoResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProdutoResumoBuilder();
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
