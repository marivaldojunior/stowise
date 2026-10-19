//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/funcionalidade_ia.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cota_ia_detalhe.g.dart';

/// CotaIaDetalhe
///
/// Properties:
/// * [id]
/// * [perfil]
/// * [usuarioId]
/// * [funcionalidade]
/// * [limiteChamadasDia]
/// * [limiteTokensMes]
/// * [versao]
@BuiltValue()
abstract class CotaIaDetalhe implements Built<CotaIaDetalhe, CotaIaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'perfil')
  String? get perfil;

  @BuiltValueField(wireName: r'usuarioId')
  String? get usuarioId;

  @BuiltValueField(wireName: r'funcionalidade')
  FuncionalidadeIa? get funcionalidade;
  // enum funcionalidadeEnum {  Mapeamento,  CasamentoItens,  Camera,  CadastroPorFoto,  Consulta,  Embeddings,  Documentos,  LeituraPlaqueta,  EstadoConservacao,  CasamentoBens,  };

  @BuiltValueField(wireName: r'limiteChamadasDia')
  int? get limiteChamadasDia;

  @BuiltValueField(wireName: r'limiteTokensMes')
  int? get limiteTokensMes;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  CotaIaDetalhe._();

  factory CotaIaDetalhe([void updates(CotaIaDetalheBuilder b)]) = _$CotaIaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CotaIaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CotaIaDetalhe> get serializer => _$CotaIaDetalheSerializer();
}

class _$CotaIaDetalheSerializer implements PrimitiveSerializer<CotaIaDetalhe> {
  @override
  final Iterable<Type> types = const [CotaIaDetalhe, _$CotaIaDetalhe];

  @override
  final String wireName = r'CotaIaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CotaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'perfil';
    yield object.perfil == null
        ? null
        : serializers.serialize(
            object.perfil,
            specifiedType: const FullType.nullable(String),
          );
    yield r'usuarioId';
    yield object.usuarioId == null
        ? null
        : serializers.serialize(
            object.usuarioId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'funcionalidade';
    yield object.funcionalidade == null
        ? null
        : serializers.serialize(
            object.funcionalidade,
            specifiedType: const FullType.nullable(FuncionalidadeIa),
          );
    yield r'limiteChamadasDia';
    yield object.limiteChamadasDia == null
        ? null
        : serializers.serialize(
            object.limiteChamadasDia,
            specifiedType: const FullType.nullable(int),
          );
    yield r'limiteTokensMes';
    yield object.limiteTokensMes == null
        ? null
        : serializers.serialize(
            object.limiteTokensMes,
            specifiedType: const FullType.nullable(int),
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
    CotaIaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CotaIaDetalheBuilder result,
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
        case r'perfil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.perfil = valueDes;
          break;
        case r'usuarioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.usuarioId = valueDes;
          break;
        case r'funcionalidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FuncionalidadeIa),
          ) as FuncionalidadeIa?;
          if (valueDes == null) continue;
          result.funcionalidade = valueDes;
          break;
        case r'limiteChamadasDia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteChamadasDia = valueDes;
          break;
        case r'limiteTokensMes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteTokensMes = valueDes;
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
  CotaIaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CotaIaDetalheBuilder();
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
