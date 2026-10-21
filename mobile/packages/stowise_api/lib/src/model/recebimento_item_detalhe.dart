//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/lote_recebido.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recebimento_item_detalhe.g.dart';

/// RecebimentoItemDetalhe
///
/// Properties:
/// * [id]
/// * [numeroItem]
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [controlaLote]
/// * [controlaValidade]
/// * [embalagemId]
/// * [codigoFornecedor]
/// * [descricaoNota]
/// * [unidadeNota]
/// * [quantidadeNota]
/// * [fatorConversao]
/// * [quantidade]
/// * [lotes]
/// * [quantidadeConferida]
/// * [lotesConferidos]
/// * [divergente]
/// * [conferidoPor]
/// * [conferidoEm]
@BuiltValue()
abstract class RecebimentoItemDetalhe implements Built<RecebimentoItemDetalhe, RecebimentoItemDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'numeroItem')
  int get numeroItem;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'controlaLote')
  bool get controlaLote;

  @BuiltValueField(wireName: r'controlaValidade')
  bool get controlaValidade;

  @BuiltValueField(wireName: r'embalagemId')
  String get embalagemId;

  @BuiltValueField(wireName: r'codigoFornecedor')
  String get codigoFornecedor;

  @BuiltValueField(wireName: r'descricaoNota')
  String get descricaoNota;

  @BuiltValueField(wireName: r'unidadeNota')
  String get unidadeNota;

  @BuiltValueField(wireName: r'quantidadeNota')
  double get quantidadeNota;

  @BuiltValueField(wireName: r'fatorConversao')
  double get fatorConversao;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'lotes')
  BuiltList<LoteRecebido> get lotes;

  @BuiltValueField(wireName: r'quantidadeConferida')
  double? get quantidadeConferida;

  @BuiltValueField(wireName: r'lotesConferidos')
  BuiltList<LoteRecebido> get lotesConferidos;

  @BuiltValueField(wireName: r'divergente')
  bool get divergente;

  @BuiltValueField(wireName: r'conferidoPor')
  String? get conferidoPor;

  @BuiltValueField(wireName: r'conferidoEm')
  DateTime? get conferidoEm;

  RecebimentoItemDetalhe._();

  factory RecebimentoItemDetalhe([void updates(RecebimentoItemDetalheBuilder b)]) = _$RecebimentoItemDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecebimentoItemDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecebimentoItemDetalhe> get serializer => _$RecebimentoItemDetalheSerializer();
}

class _$RecebimentoItemDetalheSerializer implements PrimitiveSerializer<RecebimentoItemDetalhe> {
  @override
  final Iterable<Type> types = const [RecebimentoItemDetalhe, _$RecebimentoItemDetalhe];

  @override
  final String wireName = r'RecebimentoItemDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecebimentoItemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'numeroItem';
    yield serializers.serialize(
      object.numeroItem,
      specifiedType: const FullType(int),
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
    yield r'embalagemId';
    yield serializers.serialize(
      object.embalagemId,
      specifiedType: const FullType(String),
    );
    yield r'codigoFornecedor';
    yield serializers.serialize(
      object.codigoFornecedor,
      specifiedType: const FullType(String),
    );
    yield r'descricaoNota';
    yield serializers.serialize(
      object.descricaoNota,
      specifiedType: const FullType(String),
    );
    yield r'unidadeNota';
    yield serializers.serialize(
      object.unidadeNota,
      specifiedType: const FullType(String),
    );
    yield r'quantidadeNota';
    yield serializers.serialize(
      object.quantidadeNota,
      specifiedType: const FullType(double),
    );
    yield r'fatorConversao';
    yield serializers.serialize(
      object.fatorConversao,
      specifiedType: const FullType(double),
    );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'lotes';
    yield serializers.serialize(
      object.lotes,
      specifiedType: const FullType(BuiltList, [FullType(LoteRecebido)]),
    );
    yield r'quantidadeConferida';
    yield object.quantidadeConferida == null
        ? null
        : serializers.serialize(
            object.quantidadeConferida,
            specifiedType: const FullType.nullable(double),
          );
    yield r'lotesConferidos';
    yield serializers.serialize(
      object.lotesConferidos,
      specifiedType: const FullType(BuiltList, [FullType(LoteRecebido)]),
    );
    yield r'divergente';
    yield serializers.serialize(
      object.divergente,
      specifiedType: const FullType(bool),
    );
    yield r'conferidoPor';
    yield object.conferidoPor == null
        ? null
        : serializers.serialize(
            object.conferidoPor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'conferidoEm';
    yield object.conferidoEm == null
        ? null
        : serializers.serialize(
            object.conferidoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecebimentoItemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecebimentoItemDetalheBuilder result,
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
        case r'numeroItem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numeroItem = valueDes;
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
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.embalagemId = valueDes;
          break;
        case r'codigoFornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigoFornecedor = valueDes;
          break;
        case r'descricaoNota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricaoNota = valueDes;
          break;
        case r'unidadeNota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeNota = valueDes;
          break;
        case r'quantidadeNota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeNota = valueDes;
          break;
        case r'fatorConversao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.fatorConversao = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'lotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LoteRecebido)]),
          ) as BuiltList<LoteRecebido>;
          result.lotes.replace(valueDes);
          break;
        case r'quantidadeConferida':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidadeConferida = valueDes;
          break;
        case r'lotesConferidos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LoteRecebido)]),
          ) as BuiltList<LoteRecebido>;
          result.lotesConferidos.replace(valueDes);
          break;
        case r'divergente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.divergente = valueDes;
          break;
        case r'conferidoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.conferidoPor = valueDes;
          break;
        case r'conferidoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.conferidoEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecebimentoItemDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecebimentoItemDetalheBuilder();
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
