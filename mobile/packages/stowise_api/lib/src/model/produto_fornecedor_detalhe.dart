//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_embalagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'produto_fornecedor_detalhe.g.dart';

/// ProdutoFornecedorDetalhe
///
/// Properties:
/// * [id]
/// * [fornecedorId]
/// * [codigoFornecedor]
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [embalagemId]
/// * [tipoEmbalagem]
/// * [unidadeFornecedor]
/// * [fatorConversao]
/// * [confirmadoPor]
/// * [confirmadoEm]
/// * [versao]
@BuiltValue()
abstract class ProdutoFornecedorDetalhe implements Built<ProdutoFornecedorDetalhe, ProdutoFornecedorDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'fornecedorId')
  String get fornecedorId;

  @BuiltValueField(wireName: r'codigoFornecedor')
  String get codigoFornecedor;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'tipoEmbalagem')
  TipoEmbalagem get tipoEmbalagem;
  // enum tipoEmbalagemEnum {  Unidade,  Caixa,  Palete,  };

  @BuiltValueField(wireName: r'unidadeFornecedor')
  String get unidadeFornecedor;

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'confirmadoPor')
  String get confirmadoPor;

  @BuiltValueField(wireName: r'confirmadoEm')
  DateTime get confirmadoEm;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  ProdutoFornecedorDetalhe._();

  factory ProdutoFornecedorDetalhe([void updates(ProdutoFornecedorDetalheBuilder b)]) = _$ProdutoFornecedorDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProdutoFornecedorDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProdutoFornecedorDetalhe> get serializer => _$ProdutoFornecedorDetalheSerializer();
}

class _$ProdutoFornecedorDetalheSerializer implements PrimitiveSerializer<ProdutoFornecedorDetalhe> {
  @override
  final Iterable<Type> types = const [ProdutoFornecedorDetalhe, _$ProdutoFornecedorDetalhe];

  @override
  final String wireName = r'ProdutoFornecedorDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProdutoFornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'fornecedorId';
    yield serializers.serialize(
      object.fornecedorId,
      specifiedType: const FullType(String),
    );
    yield r'codigoFornecedor';
    yield serializers.serialize(
      object.codigoFornecedor,
      specifiedType: const FullType(String),
    );
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
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
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'tipoEmbalagem';
    yield serializers.serialize(
      object.tipoEmbalagem,
      specifiedType: const FullType(TipoEmbalagem),
    );
    yield r'unidadeFornecedor';
    yield serializers.serialize(
      object.unidadeFornecedor,
      specifiedType: const FullType(String),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'confirmadoPor';
    yield serializers.serialize(
      object.confirmadoPor,
      specifiedType: const FullType(String),
    );
    yield r'confirmadoEm';
    yield serializers.serialize(
      object.confirmadoEm,
      specifiedType: const FullType(DateTime),
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
    ProdutoFornecedorDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProdutoFornecedorDetalheBuilder result,
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
        case r'fornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fornecedorId = valueDes;
          break;
        case r'codigoFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigoFornecedor = valueDes;
          break;
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
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
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'tipoEmbalagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoEmbalagem),
          ) as TipoEmbalagem;
          result.tipoEmbalagem = valueDes;
          break;
        case r'unidadeFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeFornecedor = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'confirmadoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.confirmadoPor = valueDes;
          break;
        case r'confirmadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.confirmadoEm = valueDes;
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
  ProdutoFornecedorDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProdutoFornecedorDetalheBuilder();
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
