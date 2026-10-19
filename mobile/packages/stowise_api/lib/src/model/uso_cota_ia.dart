//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/funcionalidade_ia.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'uso_cota_ia.g.dart';

/// UsoCotaIa
///
/// Properties:
/// * [funcionalidade]
/// * [chamadasHoje]
/// * [limiteChamadasDia]
/// * [tokensMes]
/// * [limiteTokensMes]
/// * [origem]
/// * [excedida]
@BuiltValue()
abstract class UsoCotaIa implements Built<UsoCotaIa, UsoCotaIaBuilder> {
  @BuiltValueField(wireName: r'funcionalidade')
  FuncionalidadeIa get funcionalidade;
  // enum funcionalidadeEnum {  Mapeamento,  CasamentoItens,  Camera,  CadastroPorFoto,  Consulta,  Embeddings,  Documentos,  LeituraPlaqueta,  EstadoConservacao,  CasamentoBens,  };

  @BuiltValueField(wireName: r'chamadasHoje')
  int get chamadasHoje;

  @BuiltValueField(wireName: r'limiteChamadasDia')
  int? get limiteChamadasDia;

  @BuiltValueField(wireName: r'tokensMes')
  int get tokensMes;

  @BuiltValueField(wireName: r'limiteTokensMes')
  int? get limiteTokensMes;

  @BuiltValueField(wireName: r'origem')
  String? get origem;

  @BuiltValueField(wireName: r'excedida')
  bool get excedida;

  UsoCotaIa._();

  factory UsoCotaIa([void updates(UsoCotaIaBuilder b)]) = _$UsoCotaIa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsoCotaIaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsoCotaIa> get serializer => _$UsoCotaIaSerializer();
}

class _$UsoCotaIaSerializer implements PrimitiveSerializer<UsoCotaIa> {
  @override
  final Iterable<Type> types = const [UsoCotaIa, _$UsoCotaIa];

  @override
  final String wireName = r'UsoCotaIa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsoCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'funcionalidade';
    yield serializers.serialize(
      object.funcionalidade,
      specifiedType: const FullType(FuncionalidadeIa),
    );
    yield r'chamadasHoje';
    yield serializers.serialize(
      object.chamadasHoje,
      specifiedType: const FullType(int),
    );
    yield r'limiteChamadasDia';
    yield object.limiteChamadasDia == null
        ? null
        : serializers.serialize(
            object.limiteChamadasDia,
            specifiedType: const FullType.nullable(int),
          );
    yield r'tokensMes';
    yield serializers.serialize(
      object.tokensMes,
      specifiedType: const FullType(int),
    );
    yield r'limiteTokensMes';
    yield object.limiteTokensMes == null
        ? null
        : serializers.serialize(
            object.limiteTokensMes,
            specifiedType: const FullType.nullable(int),
          );
    yield r'origem';
    yield object.origem == null
        ? null
        : serializers.serialize(
            object.origem,
            specifiedType: const FullType.nullable(String),
          );
    yield r'excedida';
    yield serializers.serialize(
      object.excedida,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UsoCotaIa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsoCotaIaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'funcionalidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FuncionalidadeIa),
          ) as FuncionalidadeIa;
          result.funcionalidade = valueDes;
          break;
        case r'chamadasHoje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.chamadasHoje = valueDes;
          break;
        case r'limiteChamadasDia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteChamadasDia = valueDes;
          break;
        case r'tokensMes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tokensMes = valueDes;
          break;
        case r'limiteTokensMes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limiteTokensMes = valueDes;
          break;
        case r'origem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.origem = valueDes;
          break;
        case r'excedida':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.excedida = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsoCotaIa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsoCotaIaBuilder();
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
