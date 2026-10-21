//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/tarefa_armazenagem_resumo.dart';
import 'package:stowise_api/src/model/nota_regra.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tarefa_armazenagem_detalhe.g.dart';

/// TarefaArmazenagemDetalhe
///
/// Properties:
/// * [tarefa]
/// * [notas]
/// * [regrasVersao]
/// * [enderecoConfirmadoId]
/// * [movimentacaoId]
/// * [concluidoPor]
@BuiltValue()
abstract class TarefaArmazenagemDetalhe implements Built<TarefaArmazenagemDetalhe, TarefaArmazenagemDetalheBuilder> {
  @BuiltValueField(wireName: r'tarefa')
  TarefaArmazenagemResumo get tarefa;

  @BuiltValueField(wireName: r'notas')
  BuiltList<NotaRegra> get notas;

  @BuiltValueField(wireName: r'regrasVersao')
  String get regrasVersao;

  @BuiltValueField(wireName: r'enderecoConfirmadoId')
  String? get enderecoConfirmadoId;

  @BuiltValueField(wireName: r'movimentacaoId')
  String? get movimentacaoId;

  @BuiltValueField(wireName: r'concluidoPor')
  String? get concluidoPor;

  TarefaArmazenagemDetalhe._();

  factory TarefaArmazenagemDetalhe([void updates(TarefaArmazenagemDetalheBuilder b)]) = _$TarefaArmazenagemDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TarefaArmazenagemDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TarefaArmazenagemDetalhe> get serializer => _$TarefaArmazenagemDetalheSerializer();
}

class _$TarefaArmazenagemDetalheSerializer implements PrimitiveSerializer<TarefaArmazenagemDetalhe> {
  @override
  final Iterable<Type> types = const [TarefaArmazenagemDetalhe, _$TarefaArmazenagemDetalhe];

  @override
  final String wireName = r'TarefaArmazenagemDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TarefaArmazenagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tarefa';
    yield serializers.serialize(
      object.tarefa,
      specifiedType: const FullType(TarefaArmazenagemResumo),
    );
    yield r'notas';
    yield serializers.serialize(
      object.notas,
      specifiedType: const FullType(BuiltList, [FullType(NotaRegra)]),
    );
    yield r'regrasVersao';
    yield serializers.serialize(
      object.regrasVersao,
      specifiedType: const FullType(String),
    );
    yield r'enderecoConfirmadoId';
    yield object.enderecoConfirmadoId == null
        ? null
        : serializers.serialize(
            object.enderecoConfirmadoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'movimentacaoId';
    yield object.movimentacaoId == null
        ? null
        : serializers.serialize(
            object.movimentacaoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'concluidoPor';
    yield object.concluidoPor == null
        ? null
        : serializers.serialize(
            object.concluidoPor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    TarefaArmazenagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TarefaArmazenagemDetalheBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tarefa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TarefaArmazenagemResumo),
          ) as TarefaArmazenagemResumo;
          result.tarefa.replace(valueDes);
          break;
        case r'notas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotaRegra)]),
          ) as BuiltList<NotaRegra>;
          result.notas.replace(valueDes);
          break;
        case r'regrasVersao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.regrasVersao = valueDes;
          break;
        case r'enderecoConfirmadoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoConfirmadoId = valueDes;
          break;
        case r'movimentacaoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.movimentacaoId = valueDes;
          break;
        case r'concluidoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.concluidoPor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TarefaArmazenagemDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TarefaArmazenagemDetalheBuilder();
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
