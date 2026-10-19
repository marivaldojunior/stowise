//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/funcionalidade_ia.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salvar_cota_ia.g.dart';

/// SalvarCotaIa
///
/// Properties:
/// * [perfil]
/// * [usuarioId]
/// * [funcionalidade]
/// * [limiteChamadasDia]
/// * [limiteTokensMes]
@BuiltValue()
abstract class SalvarCotaIa implements Built<SalvarCotaIa, SalvarCotaIaBuilder> {
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

  SalvarCotaIa._();

  factory SalvarCotaIa([void updates(SalvarCotaIaBuilder b)]) = _$SalvarCotaIa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalvarCotaIaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalvarCotaIa> get serializer => _$SalvarCotaIaSerializer();
}

class _$SalvarCotaIaSerializer implements PrimitiveSerializer<SalvarCotaIa> {
  @override
  final Iterable<Type> types = const [SalvarCotaIa, _$SalvarCotaIa];

  @override
  final String wireName = r'SalvarCotaIa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalvarCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SalvarCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalvarCotaIaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalvarCotaIa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalvarCotaIaBuilder();
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
