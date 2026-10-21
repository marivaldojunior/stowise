//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/recebimento_item_detalhe.dart';
import 'package:stowise_api/src/model/status_recebimento.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recebimento_detalhe.g.dart';

/// RecebimentoDetalhe
///
/// Properties:
/// * [id]
/// * [numero]
/// * [serie]
/// * [chaveAcesso]
/// * [fornecedorId]
/// * [fornecedor]
/// * [dataEmissao]
/// * [status]
/// * [dataChegada]
/// * [conferidoPor]
/// * [conferidoEm]
/// * [temDivergencia]
/// * [versao]
/// * [itens]
@BuiltValue()
abstract class RecebimentoDetalhe implements Built<RecebimentoDetalhe, RecebimentoDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'numero')
  int get numero;

  @BuiltValueField(wireName: r'serie')
  int get serie;

  @BuiltValueField(wireName: r'chaveAcesso')
  String get chaveAcesso;

  @BuiltValueField(wireName: r'fornecedorId')
  String get fornecedorId;

  @BuiltValueField(wireName: r'fornecedor')
  String get fornecedor;

  @BuiltValueField(wireName: r'dataEmissao')
  DateTime get dataEmissao;

  @BuiltValueField(wireName: r'status')
  StatusRecebimento get status;
  // enum statusEnum {  AguardandoConferencia,  EmConferencia,  Conferido,  };

  @BuiltValueField(wireName: r'dataChegada')
  DateTime? get dataChegada;

  @BuiltValueField(wireName: r'conferidoPor')
  String? get conferidoPor;

  @BuiltValueField(wireName: r'conferidoEm')
  DateTime? get conferidoEm;

  @BuiltValueField(wireName: r'temDivergencia')
  bool get temDivergencia;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  @BuiltValueField(wireName: r'itens')
  BuiltList<RecebimentoItemDetalhe> get itens;

  RecebimentoDetalhe._();

  factory RecebimentoDetalhe([void updates(RecebimentoDetalheBuilder b)]) = _$RecebimentoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecebimentoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecebimentoDetalhe> get serializer => _$RecebimentoDetalheSerializer();
}

class _$RecebimentoDetalheSerializer implements PrimitiveSerializer<RecebimentoDetalhe> {
  @override
  final Iterable<Type> types = const [RecebimentoDetalhe, _$RecebimentoDetalhe];

  @override
  final String wireName = r'RecebimentoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecebimentoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'numero';
    yield serializers.serialize(
      object.numero,
      specifiedType: const FullType(int),
    );
    yield r'serie';
    yield serializers.serialize(
      object.serie,
      specifiedType: const FullType(int),
    );
    yield r'chaveAcesso';
    yield serializers.serialize(
      object.chaveAcesso,
      specifiedType: const FullType(String),
    );
    yield r'fornecedorId';
    yield serializers.serialize(
      object.fornecedorId,
      specifiedType: const FullType(String),
    );
    yield r'fornecedor';
    yield serializers.serialize(
      object.fornecedor,
      specifiedType: const FullType(String),
    );
    yield r'dataEmissao';
    yield serializers.serialize(
      object.dataEmissao,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusRecebimento),
    );
    yield r'dataChegada';
    yield object.dataChegada == null
        ? null
        : serializers.serialize(
            object.dataChegada,
            specifiedType: const FullType.nullable(DateTime),
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
    yield r'temDivergencia';
    yield serializers.serialize(
      object.temDivergencia,
      specifiedType: const FullType(bool),
    );
    yield r'versao';
    yield serializers.serialize(
      object.versao,
      specifiedType: const FullType(int),
    );
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(RecebimentoItemDetalhe)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecebimentoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecebimentoDetalheBuilder result,
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
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numero = valueDes;
          break;
        case r'serie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.serie = valueDes;
          break;
        case r'chaveAcesso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.chaveAcesso = valueDes;
          break;
        case r'fornecedorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fornecedorId = valueDes;
          break;
        case r'fornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fornecedor = valueDes;
          break;
        case r'dataEmissao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dataEmissao = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusRecebimento),
          ) as StatusRecebimento;
          result.status = valueDes;
          break;
        case r'dataChegada':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dataChegada = valueDes;
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
        case r'temDivergencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.temDivergencia = valueDes;
          break;
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.versao = valueDes;
          break;
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RecebimentoItemDetalhe)]),
          ) as BuiltList<RecebimentoItemDetalhe>;
          result.itens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecebimentoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecebimentoDetalheBuilder();
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
