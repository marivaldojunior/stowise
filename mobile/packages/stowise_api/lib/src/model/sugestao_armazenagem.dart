//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/sugestao_endereco.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/classe_abc.dart';
import 'package:stowise_api/src/model/date.dart';
import 'package:stowise_api/src/model/classe_armazenagem.dart';
import 'package:stowise_api/src/model/endereco_descartado.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sugestao_armazenagem.g.dart';

/// SugestaoArmazenagem
///
/// Properties:
/// * [produtoId]
/// * [sku]
/// * [classeArmazenagem]
/// * [classeAbc]
/// * [quantidade]
/// * [validade]
/// * [pesoKg]
/// * [volumeCm3]
/// * [totalCandidatos]
/// * [sugestoes]
/// * [totalDescartados]
/// * [descartados]
@BuiltValue()
abstract class SugestaoArmazenagem implements Built<SugestaoArmazenagem, SugestaoArmazenagemBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'classeArmazenagem')
  ClasseArmazenagem get classeArmazenagem;
  // enum classeArmazenagemEnum {  Normal,  Refrigerado,  Inflamavel,  Fragil,  };

  @BuiltValueField(wireName: r'classeAbc')
  ClasseAbc get classeAbc;
  // enum classeAbcEnum {  A,  B,  C,  };

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  @BuiltValueField(wireName: r'pesoKg')
  double? get pesoKg;

  @BuiltValueField(wireName: r'volumeCm3')
  double? get volumeCm3;

  @BuiltValueField(wireName: r'totalCandidatos')
  int get totalCandidatos;

  @BuiltValueField(wireName: r'sugestoes')
  BuiltList<SugestaoEndereco> get sugestoes;

  @BuiltValueField(wireName: r'totalDescartados')
  int get totalDescartados;

  @BuiltValueField(wireName: r'descartados')
  BuiltList<EnderecoDescartado> get descartados;

  SugestaoArmazenagem._();

  factory SugestaoArmazenagem([void updates(SugestaoArmazenagemBuilder b)]) = _$SugestaoArmazenagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SugestaoArmazenagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SugestaoArmazenagem> get serializer => _$SugestaoArmazenagemSerializer();
}

class _$SugestaoArmazenagemSerializer implements PrimitiveSerializer<SugestaoArmazenagem> {
  @override
  final Iterable<Type> types = const [SugestaoArmazenagem, _$SugestaoArmazenagem];

  @override
  final String wireName = r'SugestaoArmazenagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SugestaoArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'classeArmazenagem';
    yield serializers.serialize(
      object.classeArmazenagem,
      specifiedType: const FullType(ClasseArmazenagem),
    );
    yield r'classeAbc';
    yield serializers.serialize(
      object.classeAbc,
      specifiedType: const FullType(ClasseAbc),
    );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'validade';
    yield object.validade == null
        ? null
        : serializers.serialize(
            object.validade,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'pesoKg';
    yield object.pesoKg == null
        ? null
        : serializers.serialize(
            object.pesoKg,
            specifiedType: const FullType.nullable(double),
          );
    yield r'volumeCm3';
    yield object.volumeCm3 == null
        ? null
        : serializers.serialize(
            object.volumeCm3,
            specifiedType: const FullType.nullable(double),
          );
    yield r'totalCandidatos';
    yield serializers.serialize(
      object.totalCandidatos,
      specifiedType: const FullType(int),
    );
    yield r'sugestoes';
    yield serializers.serialize(
      object.sugestoes,
      specifiedType: const FullType(BuiltList, [FullType(SugestaoEndereco)]),
    );
    yield r'totalDescartados';
    yield serializers.serialize(
      object.totalDescartados,
      specifiedType: const FullType(int),
    );
    yield r'descartados';
    yield serializers.serialize(
      object.descartados,
      specifiedType: const FullType(BuiltList, [FullType(EnderecoDescartado)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SugestaoArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SugestaoArmazenagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'classeArmazenagem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClasseArmazenagem),
          ) as ClasseArmazenagem;
          result.classeArmazenagem = valueDes;
          break;
        case r'classeAbc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClasseAbc),
          ) as ClasseAbc;
          result.classeAbc = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'validade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validade = valueDes;
          break;
        case r'pesoKg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.pesoKg = valueDes;
          break;
        case r'volumeCm3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.volumeCm3 = valueDes;
          break;
        case r'totalCandidatos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCandidatos = valueDes;
          break;
        case r'sugestoes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SugestaoEndereco)]),
          ) as BuiltList<SugestaoEndereco>;
          result.sugestoes.replace(valueDes);
          break;
        case r'totalDescartados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDescartados = valueDes;
          break;
        case r'descartados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EnderecoDescartado)]),
          ) as BuiltList<EnderecoDescartado>;
          result.descartados.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SugestaoArmazenagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SugestaoArmazenagemBuilder();
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
