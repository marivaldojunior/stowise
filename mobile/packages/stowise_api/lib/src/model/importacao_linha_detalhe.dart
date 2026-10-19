//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/erro_linha.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/status_linha.dart';
import 'package:stowise_api/src/model/acao_linha.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'importacao_linha_detalhe.g.dart';

/// ImportacaoLinhaDetalhe
///
/// Properties:
/// * [id]
/// * [numeroLinha]
/// * [dadosBrutos]
/// * [dadosNormalizados]
/// * [status]
/// * [acao]
/// * [produtoCorrespondenteId]
/// * [similaridade]
/// * [erros]
/// * [efetivadaEm]
@BuiltValue()
abstract class ImportacaoLinhaDetalhe implements Built<ImportacaoLinhaDetalhe, ImportacaoLinhaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'numeroLinha')
  int get numeroLinha;

  @BuiltValueField(wireName: r'dadosBrutos')
  BuiltList<String> get dadosBrutos;

  @BuiltValueField(wireName: r'dadosNormalizados')
  BuiltMap<String, String> get dadosNormalizados;

  @BuiltValueField(wireName: r'status')
  StatusLinha get status;
  // enum statusEnum {  Valida,  Erro,  PossivelDuplicata,  Ignorada,  };

  @BuiltValueField(wireName: r'acao')
  AcaoLinha get acao;
  // enum acaoEnum {  Criar,  Atualizar,  Ignorar,  };

  @BuiltValueField(wireName: r'produtoCorrespondenteId')
  String? get produtoCorrespondenteId;

  @BuiltValueField(wireName: r'similaridade')
  double? get similaridade;

  @BuiltValueField(wireName: r'erros')
  BuiltList<ErroLinha> get erros;

  @BuiltValueField(wireName: r'efetivadaEm')
  DateTime? get efetivadaEm;

  ImportacaoLinhaDetalhe._();

  factory ImportacaoLinhaDetalhe([void updates(ImportacaoLinhaDetalheBuilder b)]) = _$ImportacaoLinhaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportacaoLinhaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportacaoLinhaDetalhe> get serializer => _$ImportacaoLinhaDetalheSerializer();
}

class _$ImportacaoLinhaDetalheSerializer implements PrimitiveSerializer<ImportacaoLinhaDetalhe> {
  @override
  final Iterable<Type> types = const [ImportacaoLinhaDetalhe, _$ImportacaoLinhaDetalhe];

  @override
  final String wireName = r'ImportacaoLinhaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportacaoLinhaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'numeroLinha';
    yield serializers.serialize(
      object.numeroLinha,
      specifiedType: const FullType(int),
    );
    yield r'dadosBrutos';
    yield serializers.serialize(
      object.dadosBrutos,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'dadosNormalizados';
    yield serializers.serialize(
      object.dadosNormalizados,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusLinha),
    );
    yield r'acao';
    yield serializers.serialize(
      object.acao,
      specifiedType: const FullType(AcaoLinha),
    );
    yield r'produtoCorrespondenteId';
    yield object.produtoCorrespondenteId == null
        ? null
        : serializers.serialize(
            object.produtoCorrespondenteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'similaridade';
    yield object.similaridade == null
        ? null
        : serializers.serialize(
            object.similaridade,
            specifiedType: const FullType.nullable(double),
          );
    yield r'erros';
    yield serializers.serialize(
      object.erros,
      specifiedType: const FullType(BuiltList, [FullType(ErroLinha)]),
    );
    yield r'efetivadaEm';
    yield object.efetivadaEm == null
        ? null
        : serializers.serialize(
            object.efetivadaEm,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportacaoLinhaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportacaoLinhaDetalheBuilder result,
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
        case r'numeroLinha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numeroLinha = valueDes;
          break;
        case r'dadosBrutos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.dadosBrutos.replace(valueDes);
          break;
        case r'dadosNormalizados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.dadosNormalizados.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusLinha),
          ) as StatusLinha;
          result.status = valueDes;
          break;
        case r'acao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AcaoLinha),
          ) as AcaoLinha;
          result.acao = valueDes;
          break;
        case r'produtoCorrespondenteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoCorrespondenteId = valueDes;
          break;
        case r'similaridade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.similaridade = valueDes;
          break;
        case r'erros':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ErroLinha)]),
          ) as BuiltList<ErroLinha>;
          result.erros.replace(valueDes);
          break;
        case r'efetivadaEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.efetivadaEm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportacaoLinhaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportacaoLinhaDetalheBuilder();
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
