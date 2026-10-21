//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/status_recebimento.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recebimento_resumo.g.dart';

/// RecebimentoResumo
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
/// * [itens]
/// * [itensConferidos]
/// * [temDivergencia]
/// * [criadoEm]
@BuiltValue()
abstract class RecebimentoResumo implements Built<RecebimentoResumo, RecebimentoResumoBuilder> {
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

  @BuiltValueField(wireName: r'itens')
  int get itens;

  @BuiltValueField(wireName: r'itensConferidos')
  int get itensConferidos;

  @BuiltValueField(wireName: r'temDivergencia')
  bool get temDivergencia;

  @BuiltValueField(wireName: r'criadoEm')
  DateTime get criadoEm;

  RecebimentoResumo._();

  factory RecebimentoResumo([void updates(RecebimentoResumoBuilder b)]) = _$RecebimentoResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecebimentoResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecebimentoResumo> get serializer => _$RecebimentoResumoSerializer();
}

class _$RecebimentoResumoSerializer implements PrimitiveSerializer<RecebimentoResumo> {
  @override
  final Iterable<Type> types = const [RecebimentoResumo, _$RecebimentoResumo];

  @override
  final String wireName = r'RecebimentoResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecebimentoResumo object, {
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
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(int),
    );
    yield r'itensConferidos';
    yield serializers.serialize(
      object.itensConferidos,
      specifiedType: const FullType(int),
    );
    yield r'temDivergencia';
    yield serializers.serialize(
      object.temDivergencia,
      specifiedType: const FullType(bool),
    );
    yield r'criadoEm';
    yield serializers.serialize(
      object.criadoEm,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecebimentoResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecebimentoResumoBuilder result,
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
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.itens = valueDes;
          break;
        case r'itensConferidos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.itensConferidos = valueDes;
          break;
        case r'temDivergencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.temDivergencia = valueDes;
          break;
        case r'criadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.criadoEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecebimentoResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecebimentoResumoBuilder();
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
