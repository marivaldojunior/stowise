//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/funcionalidade_ia.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chamada_ia_detalhe.g.dart';

/// ChamadaIaDetalhe
///
/// Properties:
/// * [id]
/// * [funcionalidade]
/// * [usuarioId]
/// * [provedor]
/// * [modelo]
/// * [promptVersao]
/// * [tokensEntrada]
/// * [tokensSaida]
/// * [custoEstimado]
/// * [latenciaMs]
/// * [tentativas]
/// * [usouFallback]
/// * [sucesso]
/// * [erro]
/// * [correlacaoId]
/// * [criadaEm]
@BuiltValue()
abstract class ChamadaIaDetalhe implements Built<ChamadaIaDetalhe, ChamadaIaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'funcionalidade')
  FuncionalidadeIa get funcionalidade;
  // enum funcionalidadeEnum {  Mapeamento,  CasamentoItens,  Camera,  CadastroPorFoto,  Consulta,  Embeddings,  Documentos,  LeituraPlaqueta,  EstadoConservacao,  CasamentoBens,  };

  @BuiltValueField(wireName: r'usuarioId')
  String? get usuarioId;

  @BuiltValueField(wireName: r'provedor')
  String get provedor;

  @BuiltValueField(wireName: r'modelo')
  String get modelo;

  @BuiltValueField(wireName: r'promptVersao')
  String get promptVersao;

  @BuiltValueField(wireName: r'tokensEntrada')
  int? get tokensEntrada;

  @BuiltValueField(wireName: r'tokensSaida')
  int? get tokensSaida;

  @BuiltValueField(wireName: r'custoEstimado')
  double? get custoEstimado;

  @BuiltValueField(wireName: r'latenciaMs')
  int get latenciaMs;

  @BuiltValueField(wireName: r'tentativas')
  int get tentativas;

  @BuiltValueField(wireName: r'usouFallback')
  bool get usouFallback;

  @BuiltValueField(wireName: r'sucesso')
  bool get sucesso;

  @BuiltValueField(wireName: r'erro')
  String? get erro;

  @BuiltValueField(wireName: r'correlacaoId')
  String? get correlacaoId;

  @BuiltValueField(wireName: r'criadaEm')
  DateTime get criadaEm;

  ChamadaIaDetalhe._();

  factory ChamadaIaDetalhe([void updates(ChamadaIaDetalheBuilder b)]) = _$ChamadaIaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChamadaIaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChamadaIaDetalhe> get serializer => _$ChamadaIaDetalheSerializer();
}

class _$ChamadaIaDetalheSerializer implements PrimitiveSerializer<ChamadaIaDetalhe> {
  @override
  final Iterable<Type> types = const [ChamadaIaDetalhe, _$ChamadaIaDetalhe];

  @override
  final String wireName = r'ChamadaIaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChamadaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'funcionalidade';
    yield serializers.serialize(
      object.funcionalidade,
      specifiedType: const FullType(FuncionalidadeIa),
    );
    yield r'usuarioId';
    yield object.usuarioId == null
        ? null
        : serializers.serialize(
            object.usuarioId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'provedor';
    yield serializers.serialize(
      object.provedor,
      specifiedType: const FullType(String),
    );
    yield r'modelo';
    yield serializers.serialize(
      object.modelo,
      specifiedType: const FullType(String),
    );
    yield r'promptVersao';
    yield serializers.serialize(
      object.promptVersao,
      specifiedType: const FullType(String),
    );
    yield r'tokensEntrada';
    yield object.tokensEntrada == null
        ? null
        : serializers.serialize(
            object.tokensEntrada,
            specifiedType: const FullType.nullable(int),
          );
    yield r'tokensSaida';
    yield object.tokensSaida == null
        ? null
        : serializers.serialize(
            object.tokensSaida,
            specifiedType: const FullType.nullable(int),
          );
    yield r'custoEstimado';
    yield object.custoEstimado == null
        ? null
        : serializers.serialize(
            object.custoEstimado,
            specifiedType: const FullType.nullable(double),
          );
    yield r'latenciaMs';
    yield serializers.serialize(
      object.latenciaMs,
      specifiedType: const FullType(int),
    );
    yield r'tentativas';
    yield serializers.serialize(
      object.tentativas,
      specifiedType: const FullType(int),
    );
    yield r'usouFallback';
    yield serializers.serialize(
      object.usouFallback,
      specifiedType: const FullType(bool),
    );
    yield r'sucesso';
    yield serializers.serialize(
      object.sucesso,
      specifiedType: const FullType(bool),
    );
    yield r'erro';
    yield object.erro == null
        ? null
        : serializers.serialize(
            object.erro,
            specifiedType: const FullType.nullable(String),
          );
    yield r'correlacaoId';
    yield object.correlacaoId == null
        ? null
        : serializers.serialize(
            object.correlacaoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'criadaEm';
    yield serializers.serialize(
      object.criadaEm,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChamadaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChamadaIaDetalheBuilder result,
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
        case r'funcionalidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FuncionalidadeIa),
          ) as FuncionalidadeIa;
          result.funcionalidade = valueDes;
          break;
        case r'usuarioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.usuarioId = valueDes;
          break;
        case r'provedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provedor = valueDes;
          break;
        case r'modelo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelo = valueDes;
          break;
        case r'promptVersao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.promptVersao = valueDes;
          break;
        case r'tokensEntrada':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.tokensEntrada = valueDes;
          break;
        case r'tokensSaida':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.tokensSaida = valueDes;
          break;
        case r'custoEstimado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.custoEstimado = valueDes;
          break;
        case r'latenciaMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.latenciaMs = valueDes;
          break;
        case r'tentativas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tentativas = valueDes;
          break;
        case r'usouFallback':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.usouFallback = valueDes;
          break;
        case r'sucesso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sucesso = valueDes;
          break;
        case r'erro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.erro = valueDes;
          break;
        case r'correlacaoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlacaoId = valueDes;
          break;
        case r'criadaEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.criadaEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChamadaIaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChamadaIaDetalheBuilder();
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
