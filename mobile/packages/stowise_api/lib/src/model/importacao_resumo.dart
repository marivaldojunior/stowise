//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/status_importacao.dart';
import 'package:stowise_api/src/model/formato_arquivo.dart';
import 'package:stowise_api/src/model/tipo_importacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'importacao_resumo.g.dart';

/// ImportacaoResumo
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [formato]
/// * [status]
/// * [nomeArquivo]
/// * [totalLinhas]
/// * [linhasValidas]
/// * [linhasComErro]
/// * [usuarioId]
/// * [iniciadoEm]
/// * [concluidoEm]
@BuiltValue()
abstract class ImportacaoResumo implements Built<ImportacaoResumo, ImportacaoResumoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoImportacao get tipo;
  // enum tipoEnum {  Produtos,  NotaFiscal,  BensPatrimoniais,  };

  @BuiltValueField(wireName: r'formato')
  FormatoArquivo get formato;
  // enum formatoEnum {  Delimitado,  Posicional,  Excel,  NFeXml,  };

  @BuiltValueField(wireName: r'status')
  StatusImportacao get status;
  // enum statusEnum {  Recebido,  Mapeando,  AguardandoConfirmacao,  Validando,  AguardandoRevisao,  Efetivando,  Concluido,  Falhou,  };

  @BuiltValueField(wireName: r'nomeArquivo')
  String get nomeArquivo;

  @BuiltValueField(wireName: r'totalLinhas')
  int get totalLinhas;

  @BuiltValueField(wireName: r'linhasValidas')
  int get linhasValidas;

  @BuiltValueField(wireName: r'linhasComErro')
  int get linhasComErro;

  @BuiltValueField(wireName: r'usuarioId')
  String get usuarioId;

  @BuiltValueField(wireName: r'iniciadoEm')
  DateTime get iniciadoEm;

  @BuiltValueField(wireName: r'concluidoEm')
  DateTime? get concluidoEm;

  ImportacaoResumo._();

  factory ImportacaoResumo([void updates(ImportacaoResumoBuilder b)]) = _$ImportacaoResumo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportacaoResumoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportacaoResumo> get serializer => _$ImportacaoResumoSerializer();
}

class _$ImportacaoResumoSerializer implements PrimitiveSerializer<ImportacaoResumo> {
  @override
  final Iterable<Type> types = const [ImportacaoResumo, _$ImportacaoResumo];

  @override
  final String wireName = r'ImportacaoResumo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportacaoResumo object, {
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
    yield r'formato';
    yield serializers.serialize(
      object.formato,
      specifiedType: const FullType(FormatoArquivo),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportacaoResumo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportacaoResumoBuilder result,
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
        case r'formato':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FormatoArquivo),
          ) as FormatoArquivo;
          result.formato = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportacaoResumo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportacaoResumoBuilder();
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
