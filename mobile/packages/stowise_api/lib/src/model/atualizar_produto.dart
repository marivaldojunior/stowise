//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'atualizar_produto.g.dart';

/// AtualizarProduto
///
/// Properties:
/// * [descricao]
/// * [unidadeBase]
/// * [classeArmazenagem]
/// * [controlaLote]
/// * [controlaValidade]
/// * [ncm]
/// * [cest]
/// * [categoriaId]
/// * [versao]
@BuiltValue()
abstract class AtualizarProduto implements Built<AtualizarProduto, AtualizarProdutoBuilder> {
  @BuiltValueField(wireName: r'descricao')
  String? get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String? get unidadeBase;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem? get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  @BuiltValueField(wireName: r'controlaLote')
  bool get controlaLote;

  @BuiltValueField(wireName: r'controlaValidade')
  bool get controlaValidade;

  @BuiltValueField(wireName: r'ncm')
  String? get ncm;

  @BuiltValueField(wireName: r'cest')
  String? get cest;

  @BuiltValueField(wireName: r'categoriaId')
  String? get categoriaId;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  AtualizarProduto._();

  factory AtualizarProduto([void updates(AtualizarProdutoBuilder b)]) = _$AtualizarProduto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AtualizarProdutoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AtualizarProduto> get serializer => _$AtualizarProdutoSerializer();
}

class _$AtualizarProdutoSerializer implements PrimitiveSerializer<AtualizarProduto> {
  @override
  final Iterable<Type> types = const [AtualizarProduto, _$AtualizarProduto];

  @override
  final String wireName = r'AtualizarProduto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AtualizarProduto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'descricao';
    yield object.descricao == null
        ? null
        : serializers.serialize(
            object.descricao,
            specifiedType: const FullType.nullable(String),
          );
    yield r'unidadeBase';
    yield object.unidadeBase == null
        ? null
        : serializers.serialize(
            object.unidadeBase,
            specifiedType: const FullType.nullable(String),
          );
    yield r'classeArmazenagem';
    yield object.classeArmazenagem == null
        ? null
        : serializers.serialize(
            object.classeArmazenagem,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          );
    yield r'controlaLote';
    yield serializers.serialize(
      object.controlaLote,
      specifiedType: const FullType(bool),
    );
    yield r'controlaValidade';
    yield serializers.serialize(
      object.controlaValidade,
      specifiedType: const FullType(bool),
    );
    yield r'ncm';
    yield object.ncm == null
        ? null
        : serializers.serialize(
            object.ncm,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cest';
    yield object.cest == null
        ? null
        : serializers.serialize(
            object.cest,
            specifiedType: const FullType.nullable(String),
          );
    yield r'categoriaId';
    yield object.categoriaId == null
        ? null
        : serializers.serialize(
            object.categoriaId,
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
    AtualizarProduto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AtualizarProdutoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.descricao = valueDes;
          break;
        case r'unidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unidadeBase = valueDes;
          break;
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ClasseArmazenagem),
          ) as ClasseArmazenagem?;
          if (valueDes == null) continue;
          result.classeArmazenagem = valueDes;
          break;
        case r'controlaLote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.controlaLote = valueDes;
          break;
        case r'controlaValidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.controlaValidade = valueDes;
          break;
        case r'ncm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ncm = valueDes;
          break;
        case r'cest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cest = valueDes;
          break;
        case r'categoriaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoriaId = valueDes;
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
  AtualizarProduto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AtualizarProdutoBuilder();
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
