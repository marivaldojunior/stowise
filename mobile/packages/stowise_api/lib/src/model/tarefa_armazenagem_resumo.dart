//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:stowise_api/src/model/status_tarefa_armazenagem.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tarefa_armazenagem_resumo.g.dart';

/// TarefaArmazenagemResumo
///
/// Properties:
/// * [id]
/// * [recebimentoId]
/// * [numeroNota]
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [loteNumero]
/// * [loteValidade]
/// * [quantidade]
/// * [enderecoSugeridoId]
/// * [enderecoSugerido]
/// * [pontuacao]
/// * [status]
/// * [enderecoConfirmado]
/// * [motivoDivergencia]
/// * [criadoEm]
/// * [concluidoEm]
@BuiltValue()
abstract class TarefaArmazenagemResumo implements Built<TarefaArmazenagemResumo, TarefaArmazenagemResumoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'recebimentoId')
  String get recebimentoId;

  @BuiltValueField(wireName: r'numeroNota')
  int get numeroNota;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'loteValidade')
  Date? get loteValidade;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'enderecoSugeridoId')
  String? get enderecoSugeridoId;

  @BuiltValueField(wireName: r'enderecoSugerido')
  String? get enderecoSugerido;

  @BuiltValueField(wireName: r'pontuacao')
  double? get pontuacao;

  @BuiltValueField(wireName: r'status')
  StatusTarefaArmazenagem get status;
  // enum statusEnum {  Pendente,  Concluida,  Divergente,  };

  @BuiltValueField(wireName: r'enderecoConfirmado')
  String? get enderecoConfirmado;

  @BuiltValueField(wireName: r'motivoDivergencia')
  String? get motivoDivergencia;

  @BuiltValueField(wireName: r'criadoEm')
  DateTime get criadoEm;

  @BuiltValueField(wireName: r'concluidoEm')
  DateTime? get concluidoEm;

  TarefaArmazenagemResumo._();

  factory TarefaArmazenagemResumo([void updates(TarefaArmazenagemResumoBuilder b)]) = _$TarefaArmazenagemResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TarefaArmazenagemResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TarefaArmazenagemResumo> get serializer => _$TarefaArmazenagemResumoSerializer();
}

class _$TarefaArmazenagemResumoSerializer implements PrimitiveSerializer<TarefaArmazenagemResumo> {
  @override
  final Iterable<Type> types = const [TarefaArmazenagemResumo, _$TarefaArmazenagemResumo];

  @override
  final String wireName = r'TarefaArmazenagemResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TarefaArmazenagemResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'recebimentoId';
    yield serializers.serialize(
      object.recebimentoId,
      specifiedType: const FullType(String),
    );
    yield r'numeroNota';
    yield serializers.serialize(
      object.numeroNota,
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
    yield r'loteNumero';
    yield object.loteNumero == null
        ? null
        : serializers.serialize(
            object.loteNumero,
            specifiedType: const FullType.nullable(String),
          );
    yield r'loteValidade';
    yield object.loteValidade == null
        ? null
        : serializers.serialize(
            object.loteValidade,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'enderecoSugeridoId';
    yield object.enderecoSugeridoId == null
        ? null
        : serializers.serialize(
            object.enderecoSugeridoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoSugerido';
    yield object.enderecoSugerido == null
        ? null
        : serializers.serialize(
            object.enderecoSugerido,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pontuacao';
    yield object.pontuacao == null
        ? null
        : serializers.serialize(
            object.pontuacao,
            specifiedType: const FullType.nullable(double),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusTarefaArmazenagem),
    );
    yield r'enderecoConfirmado';
    yield object.enderecoConfirmado == null
        ? null
        : serializers.serialize(
            object.enderecoConfirmado,
            specifiedType: const FullType.nullable(String),
          );
    yield r'motivoDivergencia';
    yield object.motivoDivergencia == null
        ? null
        : serializers.serialize(
            object.motivoDivergencia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'criadoEm';
    yield serializers.serialize(
      object.criadoEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'concluidoEm';
    yield object.concluidoEm == null
        ? null
        : serializers.serialize(
            object.concluidoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    TarefaArmazenagemResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TarefaArmazenagemResumoBuilder result,
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
        case r'recebimentoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recebimentoId = valueDes;
          break;
        case r'numeroNota':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numeroNota = valueDes;
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
        case r'loteNumero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteNumero = valueDes;
          break;
        case r'loteValidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.loteValidade = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'enderecoSugeridoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoSugeridoId = valueDes;
          break;
        case r'enderecoSugerido':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoSugerido = valueDes;
          break;
        case r'pontuacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.pontuacao = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusTarefaArmazenagem),
          ) as StatusTarefaArmazenagem;
          result.status = valueDes;
          break;
        case r'enderecoConfirmado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoConfirmado = valueDes;
          break;
        case r'motivoDivergencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoDivergencia = valueDes;
          break;
        case r'criadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.criadoEm = valueDes;
          break;
        case r'concluidoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.concluidoEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TarefaArmazenagemResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TarefaArmazenagemResumoBuilder();
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
