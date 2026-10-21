//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'regra_armazenagem_detalhe.g.dart';

/// RegraArmazenagemDetalhe
///
/// Properties:
/// * [id]
/// * [codigo]
/// * [restritiva]
/// * [peso]
/// * [ativa]
/// * [parametros]
/// * [parametrosPadrao]
/// * [atualizadoEm]
/// * [atualizadoPor]
/// * [versao]
@BuiltValue()
abstract class RegraArmazenagemDetalhe implements Built<RegraArmazenagemDetalhe, RegraArmazenagemDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'restritiva')
  bool get restritiva;

  @BuiltValueField(wireName: r'peso')
  double get peso;

  @BuiltValueField(wireName: r'ativa')
  bool get ativa;

  @BuiltValueField(wireName: r'parametros')
  BuiltMap<String, double> get parametros;

  @BuiltValueField(wireName: r'parametrosPadrao')
  BuiltMap<String, double> get parametrosPadrao;

  @BuiltValueField(wireName: r'atualizadoEm')
  DateTime? get atualizadoEm;

  @BuiltValueField(wireName: r'atualizadoPor')
  String? get atualizadoPor;

  @BuiltValueField(wireName: r'versao')
  int get versao;

  RegraArmazenagemDetalhe._();

  factory RegraArmazenagemDetalhe([void updates(RegraArmazenagemDetalheBuilder b)]) = _$RegraArmazenagemDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegraArmazenagemDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegraArmazenagemDetalhe> get serializer => _$RegraArmazenagemDetalheSerializer();
}

class _$RegraArmazenagemDetalheSerializer implements PrimitiveSerializer<RegraArmazenagemDetalhe> {
  @override
  final Iterable<Type> types = const [RegraArmazenagemDetalhe, _$RegraArmazenagemDetalhe];

  @override
  final String wireName = r'RegraArmazenagemDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegraArmazenagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'restritiva';
    yield serializers.serialize(
      object.restritiva,
      specifiedType: const FullType(bool),
    );
    yield r'peso';
    yield serializers.serialize(
      object.peso,
      specifiedType: const FullType(double),
    );
    yield r'ativa';
    yield serializers.serialize(
      object.ativa,
      specifiedType: const FullType(bool),
    );
    yield r'parametros';
    yield serializers.serialize(
      object.parametros,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
    );
    yield r'parametrosPadrao';
    yield serializers.serialize(
      object.parametrosPadrao,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
    );
    yield r'atualizadoEm';
    yield object.atualizadoEm == null
        ? null
        : serializers.serialize(
            object.atualizadoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'atualizadoPor';
    yield object.atualizadoPor == null
        ? null
        : serializers.serialize(
            object.atualizadoPor,
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
    RegraArmazenagemDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegraArmazenagemDetalheBuilder result,
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
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'restritiva':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.restritiva = valueDes;
          break;
        case r'peso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.peso = valueDes;
          break;
        case r'ativa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ativa = valueDes;
          break;
        case r'parametros':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
          ) as BuiltMap<String, double>;
          result.parametros.replace(valueDes);
          break;
        case r'parametrosPadrao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(double)]),
          ) as BuiltMap<String, double>;
          result.parametrosPadrao.replace(valueDes);
          break;
        case r'atualizadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.atualizadoEm = valueDes;
          break;
        case r'atualizadoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.atualizadoPor = valueDes;
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
  RegraArmazenagemDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegraArmazenagemDetalheBuilder();
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
