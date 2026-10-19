//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/mapeamento_coluna.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/regras_normalizacao.dart';
import 'package:stowise_api/src/model/formato_arquivo.dart';
import 'package:stowise_api/src/model/tipo_importacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'template_detalhe.g.dart';

/// TemplateDetalhe
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [nome]
/// * [fingerprint]
/// * [formato]
/// * [encoding]
/// * [delimitador]
/// * [separadorDecimal]
/// * [mapeamento]
/// * [regras]
/// * [sugeridoPorIa]
/// * [confirmadoPor]
/// * [confirmadoEm]
/// * [vezesUsado]
/// * [ultimoUsoEm]
/// * [versao]
@BuiltValue()
abstract class TemplateDetalhe implements Built<TemplateDetalhe, TemplateDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoImportacao get tipo;
  // enum tipoEnum {  Produtos,  NotaFiscal,  BensPatrimoniais,  };

  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'fingerprint')
  String get fingerprint;

  @BuiltValueField(wireName: r'formato')
  FormatoArquivo get formato;
  // enum formatoEnum {  Delimitado,  Posicional,  Excel,  NFeXml,  };

  @BuiltValueField(wireName: r'encoding')
  String? get encoding;

  @BuiltValueField(wireName: r'delimitador')
  String? get delimitador;

  @BuiltValueField(wireName: r'separadorDecimal')
  String get separadorDecimal;

  @BuiltValueField(wireName: r'mapeamento')
  BuiltList<MapeamentoColuna> get mapeamento;

  @BuiltValueField(wireName: r'regras')
  RegrasNormalizacao get regras;

  @BuiltValueField(wireName: r'sugeridoPorIa')
  bool get sugeridoPorIa;

  @BuiltValueField(wireName: r'confirmadoPor')
  String get confirmadoPor;

  @BuiltValueField(wireName: r'confirmadoEm')
  DateTime get confirmadoEm;

  @BuiltValueField(wireName: r'vezesUsado')
  int get vezesUsado;

  @BuiltValueField(wireName: r'ultimoUsoEm')
  DateTime get ultimoUsoEm;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  TemplateDetalhe._();

  factory TemplateDetalhe([void updates(TemplateDetalheBuilder b)]) = _$TemplateDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TemplateDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TemplateDetalhe> get serializer => _$TemplateDetalheSerializer();
}

class _$TemplateDetalheSerializer implements PrimitiveSerializer<TemplateDetalhe> {
  @override
  final Iterable<Type> types = const [TemplateDetalhe, _$TemplateDetalhe];

  @override
  final String wireName = r'TemplateDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TemplateDetalhe object, {
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
    yield r'nome';
    yield serializers.serialize(
      object.nome,
      specifiedType: const FullType(String),
    );
    yield r'fingerprint';
    yield serializers.serialize(
      object.fingerprint,
      specifiedType: const FullType(String),
    );
    yield r'formato';
    yield serializers.serialize(
      object.formato,
      specifiedType: const FullType(FormatoArquivo),
    );
    yield r'encoding';
    yield object.encoding == null
        ? null
        : serializers.serialize(
            object.encoding,
            specifiedType: const FullType.nullable(String),
          );
    yield r'delimitador';
    yield object.delimitador == null
        ? null
        : serializers.serialize(
            object.delimitador,
            specifiedType: const FullType.nullable(String),
          );
    yield r'separadorDecimal';
    yield serializers.serialize(
      object.separadorDecimal,
      specifiedType: const FullType(String),
    );
    yield r'mapeamento';
    yield serializers.serialize(
      object.mapeamento,
      specifiedType: const FullType(BuiltList, [FullType(MapeamentoColuna)]),
    );
    yield r'regras';
    yield serializers.serialize(
      object.regras,
      specifiedType: const FullType(RegrasNormalizacao),
    );
    yield r'sugeridoPorIa';
    yield serializers.serialize(
      object.sugeridoPorIa,
      specifiedType: const FullType(bool),
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
    yield r'vezesUsado';
    yield serializers.serialize(
      object.vezesUsado,
      specifiedType: const FullType(int),
    );
    yield r'ultimoUsoEm';
    yield serializers.serialize(
      object.ultimoUsoEm,
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
    TemplateDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TemplateDetalheBuilder result,
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
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nome = valueDes;
          break;
        case r'fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fingerprint = valueDes;
          break;
        case r'formato':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FormatoArquivo),
          ) as FormatoArquivo;
          result.formato = valueDes;
          break;
        case r'encoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.encoding = valueDes;
          break;
        case r'delimitador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.delimitador = valueDes;
          break;
        case r'separadorDecimal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.separadorDecimal = valueDes;
          break;
        case r'mapeamento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MapeamentoColuna)]),
          ) as BuiltList<MapeamentoColuna>;
          result.mapeamento.replace(valueDes);
          break;
        case r'regras':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegrasNormalizacao),
          ) as RegrasNormalizacao;
          result.regras.replace(valueDes);
          break;
        case r'sugeridoPorIa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sugeridoPorIa = valueDes;
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
        case r'vezesUsado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vezesUsado = valueDes;
          break;
        case r'ultimoUsoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.ultimoUsoEm = valueDes;
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
  TemplateDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TemplateDetalheBuilder();
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
