//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/status_importacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'relatorio_importacao.g.dart';

/// RelatorioImportacao
///
/// Properties:
/// * [id]
/// * [nomeArquivo]
/// * [status]
/// * [totalLinhas]
/// * [linhasValidas]
/// * [linhasComErro]
/// * [linhasPossivelDuplicata]
/// * [produtosCriados]
/// * [produtosAtualizados]
/// * [errosPorCampo]
/// * [iniciadoEm]
/// * [concluidoEm]
/// * [motivoFalha]
@BuiltValue()
abstract class RelatorioImportacao implements Built<RelatorioImportacao, RelatorioImportacaoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'nomeArquivo')
  String get nomeArquivo;

  @BuiltValueField(wireName: r'status')
  StatusImportacao get status;
  // enum statusEnum {  Recebido,  Mapeando,  AguardandoConfirmacao,  Validando,  AguardandoRevisao,  Efetivando,  Concluido,  Falhou,  };

  @BuiltValueField(wireName: r'totalLinhas')
  int get totalLinhas;

  @BuiltValueField(wireName: r'linhasValidas')
  int get linhasValidas;

  @BuiltValueField(wireName: r'linhasComErro')
  int get linhasComErro;

  @BuiltValueField(wireName: r'linhasPossivelDuplicata')
  int get linhasPossivelDuplicata;

  @BuiltValueField(wireName: r'produtosCriados')
  int get produtosCriados;

  @BuiltValueField(wireName: r'produtosAtualizados')
  int get produtosAtualizados;

  @BuiltValueField(wireName: r'errosPorCampo')
  BuiltMap<String, int> get errosPorCampo;

  @BuiltValueField(wireName: r'iniciadoEm')
  DateTime get iniciadoEm;

  @BuiltValueField(wireName: r'concluidoEm')
  DateTime? get concluidoEm;

  @BuiltValueField(wireName: r'motivoFalha')
  String? get motivoFalha;

  RelatorioImportacao._();

  factory RelatorioImportacao([void updates(RelatorioImportacaoBuilder b)]) = _$RelatorioImportacao;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RelatorioImportacaoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RelatorioImportacao> get serializer => _$RelatorioImportacaoSerializer();
}

class _$RelatorioImportacaoSerializer implements PrimitiveSerializer<RelatorioImportacao> {
  @override
  final Iterable<Type> types = const [RelatorioImportacao, _$RelatorioImportacao];

  @override
  final String wireName = r'RelatorioImportacao';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RelatorioImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'nomeArquivo';
    yield serializers.serialize(
      object.nomeArquivo,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusImportacao),
    );
    yield r'totalLinhas';
    yield serializers.serialize(
      object.totalLinhas,
      specifiedType: const FullType(int),
    );
    yield r'linhasValidas';
    yield serializers.serialize(
      object.linhasValidas,
      specifiedType: const FullType(int),
    );
    yield r'linhasComErro';
    yield serializers.serialize(
      object.linhasComErro,
      specifiedType: const FullType(int),
    );
    yield r'linhasPossivelDuplicata';
    yield serializers.serialize(
      object.linhasPossivelDuplicata,
      specifiedType: const FullType(int),
    );
    yield r'produtosCriados';
    yield serializers.serialize(
      object.produtosCriados,
      specifiedType: const FullType(int),
    );
    yield r'produtosAtualizados';
    yield serializers.serialize(
      object.produtosAtualizados,
      specifiedType: const FullType(int),
    );
    yield r'errosPorCampo';
    yield serializers.serialize(
      object.errosPorCampo,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    yield r'iniciadoEm';
    yield serializers.serialize(
      object.iniciadoEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'concluidoEm';
    yield object.concluidoEm == null
        ? null
        : serializers.serialize(
            object.concluidoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'motivoFalha';
    yield object.motivoFalha == null
        ? null
        : serializers.serialize(
            object.motivoFalha,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    RelatorioImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RelatorioImportacaoBuilder result,
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
        case r'nomeArquivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nomeArquivo = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusImportacao),
          ) as StatusImportacao;
          result.status = valueDes;
          break;
        case r'totalLinhas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalLinhas = valueDes;
          break;
        case r'linhasValidas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linhasValidas = valueDes;
          break;
        case r'linhasComErro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linhasComErro = valueDes;
          break;
        case r'linhasPossivelDuplicata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linhasPossivelDuplicata = valueDes;
          break;
        case r'produtosCriados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.produtosCriados = valueDes;
          break;
        case r'produtosAtualizados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.produtosAtualizados = valueDes;
          break;
        case r'errosPorCampo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.errosPorCampo.replace(valueDes);
          break;
        case r'iniciadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.iniciadoEm = valueDes;
          break;
        case r'concluidoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.concluidoEm = valueDes;
          break;
        case r'motivoFalha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoFalha = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RelatorioImportacao deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RelatorioImportacaoBuilder();
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
