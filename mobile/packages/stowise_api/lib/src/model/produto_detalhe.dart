//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/status_cadastro.dart';
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:stowise_api/src/model/embalagem_detalhe.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'produto_detalhe.g.dart';

/// ProdutoDetalhe
///
/// Properties:
/// * [id]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [classeArmazenagem]
/// * [controlaLote]
/// * [controlaValidade]
/// * [ncm]
/// * [cest]
/// * [categoriaId]
/// * [ativo]
/// * [statusCadastro]
/// * [versao]
/// * [embalagens]
@BuiltValue()
abstract class ProdutoDetalhe implements Built<ProdutoDetalhe, ProdutoDetalheBuilder> {
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

  @BuiltValueField(wireName: r'ativo')
  bool get ativo;

  @BuiltValueField(wireName: r'statusCadastro')
  StatusCadastro get statusCadastro;
  // enum statusCadastroEnum {  Incompleto,  Completo,  };

  @BuiltValueField(wireName: r'versao')
  int get versao;

  @BuiltValueField(wireName: r'embalagens')
  BuiltList<EmbalagemDetalhe> get embalagens;

  ProdutoDetalhe._();

  factory ProdutoDetalhe([void updates(ProdutoDetalheBuilder b)]) = _$ProdutoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProdutoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProdutoDetalhe> get serializer => _$ProdutoDetalheSerializer();
}

class _$ProdutoDetalheSerializer implements PrimitiveSerializer<ProdutoDetalhe> {
  @override
  final Iterable<Type> types = const [ProdutoDetalhe, _$ProdutoDetalhe];

  @override
  final String wireName = r'ProdutoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProdutoDetalhe object, {
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
    yield r'ativo';
    yield serializers.serialize(
      object.ativo,
      specifiedType: const FullType(bool),
    );
    yield r'statusCadastro';
    yield serializers.serialize(
      object.statusCadastro,
      specifiedType: const FullType(StatusCadastro),
    );
    yield r'versao';
    yield serializers.serialize(
      object.versao,
      specifiedType: const FullType(int),
    );
    yield r'embalagens';
    yield serializers.serialize(
      object.embalagens,
      specifiedType: const FullType(BuiltList, [FullType(EmbalagemDetalhe)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProdutoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProdutoDetalheBuilder result,
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
        case r'ativo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ativo = valueDes;
          break;
        case r'statusCadastro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusCadastro),
          ) as StatusCadastro;
          result.statusCadastro = valueDes;
          break;
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.versao = valueDes;
          break;
        case r'embalagens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmbalagemDetalhe)]),
          ) as BuiltList<EmbalagemDetalhe>;
          result.embalagens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProdutoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProdutoDetalheBuilder();
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
