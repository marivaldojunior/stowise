//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/mapeamento_coluna.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/sugestao_ia.dart';
import 'package:stowise_api/src/model/status_importacao.dart';
import 'package:stowise_api/src/model/regras_normalizacao.dart';
import 'package:stowise_api/src/model/tipo_importacao.dart';
import 'package:stowise_api/src/model/layout_arquivo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'importacao_detalhe.g.dart';

/// ImportacaoDetalhe
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [status]
/// * [nomeArquivo]
/// * [hashArquivo]
/// * [tamanhoBytes]
/// * [layout]
/// * [amostra]
/// * [totalLinhas]
/// * [usuarioId]
/// * [iniciadoEm]
/// * [concluidoEm]
/// * [fingerprint]
/// * [templateId]
/// * [mapeamento]
/// * [mapeamentoConfirmadoPor]
/// * [mapeamentoConfirmadoEm]
/// * [linhasValidas]
/// * [linhasComErro]
/// * [linhasPossivelDuplicata]
/// * [linhasProcessadas]
/// * [produtosCriados]
/// * [produtosAtualizados]
/// * [motivoFalha]
/// * [regras]
/// * [sugestaoIa]
/// * [mapeamentoSugeridoPorIa]
/// * [motivoSemSugestao]
/// * [versao]
@BuiltValue()
abstract class ImportacaoDetalhe implements Built<ImportacaoDetalhe, ImportacaoDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoImportacao get tipo;
  // enum tipoEnum {  Produtos,  NotaFiscal,  BensPatrimoniais,  };

  @BuiltValueField(wireName: r'status')
  StatusImportacao get status;
  // enum statusEnum {  Recebido,  Mapeando,  AguardandoConfirmacao,  Validando,  AguardandoRevisao,  Efetivando,  Concluido,  Falhou,  };

  @BuiltValueField(wireName: r'nomeArquivo')
  String get nomeArquivo;

  @BuiltValueField(wireName: r'hashArquivo')
  String get hashArquivo;

  @BuiltValueField(wireName: r'tamanhoBytes')
  int get tamanhoBytes;

  @BuiltValueField(wireName: r'layout')
  LayoutArquivo get layout;

  @BuiltValueField(wireName: r'amostra')
  BuiltList<BuiltList<String>> get amostra;

  @BuiltValueField(wireName: r'totalLinhas')
  int get totalLinhas;

  @BuiltValueField(wireName: r'usuarioId')
  String get usuarioId;

  @BuiltValueField(wireName: r'iniciadoEm')
  DateTime get iniciadoEm;

  @BuiltValueField(wireName: r'concluidoEm')
  DateTime? get concluidoEm;

  @BuiltValueField(wireName: r'fingerprint')
  String? get fingerprint;

  @BuiltValueField(wireName: r'templateId')
  String? get templateId;

  @BuiltValueField(wireName: r'mapeamento')
  BuiltList<MapeamentoColuna>? get mapeamento;

  @BuiltValueField(wireName: r'mapeamentoConfirmadoPor')
  String? get mapeamentoConfirmadoPor;

  @BuiltValueField(wireName: r'mapeamentoConfirmadoEm')
  DateTime? get mapeamentoConfirmadoEm;

  @BuiltValueField(wireName: r'linhasValidas')
  int get linhasValidas;

  @BuiltValueField(wireName: r'linhasComErro')
  int get linhasComErro;

  @BuiltValueField(wireName: r'linhasPossivelDuplicata')
  int get linhasPossivelDuplicata;

  @BuiltValueField(wireName: r'linhasProcessadas')
  int get linhasProcessadas;

  @BuiltValueField(wireName: r'produtosCriados')
  int get produtosCriados;

  @BuiltValueField(wireName: r'produtosAtualizados')
  int get produtosAtualizados;

  @BuiltValueField(wireName: r'motivoFalha')
  String? get motivoFalha;

  @BuiltValueField(wireName: r'regras')
  RegrasNormalizacao? get regras;

  @BuiltValueField(wireName: r'sugestaoIa')
  SugestaoIa? get sugestaoIa;

  @BuiltValueField(wireName: r'mapeamentoSugeridoPorIa')
  bool get mapeamentoSugeridoPorIa;

  @BuiltValueField(wireName: r'motivoSemSugestao')
  String? get motivoSemSugestao;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  ImportacaoDetalhe._();

  factory ImportacaoDetalhe([void updates(ImportacaoDetalheBuilder b)]) = _$ImportacaoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportacaoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportacaoDetalhe> get serializer => _$ImportacaoDetalheSerializer();
}

class _$ImportacaoDetalheSerializer implements PrimitiveSerializer<ImportacaoDetalhe> {
  @override
  final Iterable<Type> types = const [ImportacaoDetalhe, _$ImportacaoDetalhe];

  @override
  final String wireName = r'ImportacaoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportacaoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'tipo';
    yield serializers.serialize(
      object.tipo,
      specifiedType: const FullType(TipoImportacao),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusImportacao),
    );
    yield r'nomeArquivo';
    yield serializers.serialize(
      object.nomeArquivo,
      specifiedType: const FullType(String),
    );
    yield r'hashArquivo';
    yield serializers.serialize(
      object.hashArquivo,
      specifiedType: const FullType(String),
    );
    yield r'tamanhoBytes';
    yield serializers.serialize(
      object.tamanhoBytes,
      specifiedType: const FullType(int),
    );
    yield r'layout';
    yield serializers.serialize(
      object.layout,
      specifiedType: const FullType(LayoutArquivo),
    );
    yield r'amostra';
    yield serializers.serialize(
      object.amostra,
      specifiedType: const FullType(BuiltList, [
        FullType(BuiltList, [FullType(String)])
      ]),
    );
    yield r'totalLinhas';
    yield serializers.serialize(
      object.totalLinhas,
      specifiedType: const FullType(int),
    );
    yield r'usuarioId';
    yield serializers.serialize(
      object.usuarioId,
      specifiedType: const FullType(String),
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
    yield r'fingerprint';
    yield object.fingerprint == null
        ? null
        : serializers.serialize(
            object.fingerprint,
            specifiedType: const FullType.nullable(String),
          );
    yield r'templateId';
    yield object.templateId == null
        ? null
        : serializers.serialize(
            object.templateId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'mapeamento';
    yield object.mapeamento == null
        ? null
        : serializers.serialize(
            object.mapeamento,
            specifiedType: const FullType.nullable(BuiltList, [FullType(MapeamentoColuna)]),
          );
    yield r'mapeamentoConfirmadoPor';
    yield object.mapeamentoConfirmadoPor == null
        ? null
        : serializers.serialize(
            object.mapeamentoConfirmadoPor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'mapeamentoConfirmadoEm';
    yield object.mapeamentoConfirmadoEm == null
        ? null
        : serializers.serialize(
            object.mapeamentoConfirmadoEm,
            specifiedType: const FullType.nullable(DateTime),
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
    yield r'linhasProcessadas';
    yield serializers.serialize(
      object.linhasProcessadas,
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
    yield r'motivoFalha';
    yield object.motivoFalha == null
        ? null
        : serializers.serialize(
            object.motivoFalha,
            specifiedType: const FullType.nullable(String),
          );
    yield r'regras';
    yield object.regras == null
        ? null
        : serializers.serialize(
            object.regras,
            specifiedType: const FullType.nullable(RegrasNormalizacao),
          );
    yield r'sugestaoIa';
    yield object.sugestaoIa == null
        ? null
        : serializers.serialize(
            object.sugestaoIa,
            specifiedType: const FullType.nullable(SugestaoIa),
          );
    yield r'mapeamentoSugeridoPorIa';
    yield serializers.serialize(
      object.mapeamentoSugeridoPorIa,
      specifiedType: const FullType(bool),
    );
    yield r'motivoSemSugestao';
    yield object.motivoSemSugestao == null
        ? null
        : serializers.serialize(
            object.motivoSemSugestao,
            specifiedType: const FullType.nullable(String),
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
    ImportacaoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportacaoDetalheBuilder result,
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
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TipoImportacao),
          ) as TipoImportacao;
          result.tipo = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusImportacao),
          ) as StatusImportacao;
          result.status = valueDes;
          break;
        case r'nomeArquivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nomeArquivo = valueDes;
          break;
        case r'hashArquivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hashArquivo = valueDes;
          break;
        case r'tamanhoBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tamanhoBytes = valueDes;
          break;
        case r'layout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LayoutArquivo),
          ) as LayoutArquivo;
          result.layout.replace(valueDes);
          break;
        case r'amostra':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [
              FullType(BuiltList, [FullType(String)])
            ]),
          ) as BuiltList<BuiltList<String>>;
          result.amostra.replace(valueDes);
          break;
        case r'totalLinhas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalLinhas = valueDes;
          break;
        case r'usuarioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.usuarioId = valueDes;
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
        case r'fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fingerprint = valueDes;
          break;
        case r'templateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.templateId = valueDes;
          break;
        case r'mapeamento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(MapeamentoColuna)]),
          ) as BuiltList<MapeamentoColuna>?;
          if (valueDes == null) continue;
          result.mapeamento.replace(valueDes);
          break;
        case r'mapeamentoConfirmadoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mapeamentoConfirmadoPor = valueDes;
          break;
        case r'mapeamentoConfirmadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.mapeamentoConfirmadoEm = valueDes;
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
        case r'linhasProcessadas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linhasProcessadas = valueDes;
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
        case r'motivoFalha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoFalha = valueDes;
          break;
        case r'regras':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegrasNormalizacao),
          ) as RegrasNormalizacao?;
          if (valueDes == null) continue;
          result.regras.replace(valueDes);
          break;
        case r'sugestaoIa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SugestaoIa),
          ) as SugestaoIa?;
          if (valueDes == null) continue;
          result.sugestaoIa.replace(valueDes);
          break;
        case r'mapeamentoSugeridoPorIa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mapeamentoSugeridoPorIa = valueDes;
          break;
        case r'motivoSemSugestao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoSemSugestao = valueDes;
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
  ImportacaoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportacaoDetalheBuilder();
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
