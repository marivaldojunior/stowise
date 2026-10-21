//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pedido_sugestao_armazenagem.g.dart';

/// PedidoSugestaoArmazenagem
///
/// Properties:
/// * [produtoId]
/// * [embalagemId]
/// * [quantidade]
/// * [loteId]
/// * [validade]
/// * [armazemId]
/// * [limite]
@BuiltValue()
abstract class PedidoSugestaoArmazenagem implements Built<PedidoSugestaoArmazenagem, PedidoSugestaoArmazenagemBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String? get produtoId;

  @BuiltValueField(wireName: r'embalagemId')
  String? get embalagemId;

  @BuiltValueField(wireName: r'quantidade')
  double? get quantidade;

  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'validade')
  Date? get validade;

  @BuiltValueField(wireName: r'armazemId')
  String? get armazemId;

  @BuiltValueField(wireName: r'limite')
  int? get limite;

  PedidoSugestaoArmazenagem._();

  factory PedidoSugestaoArmazenagem([void updates(PedidoSugestaoArmazenagemBuilder b)]) = _$PedidoSugestaoArmazenagem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PedidoSugestaoArmazenagemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PedidoSugestaoArmazenagem> get serializer => _$PedidoSugestaoArmazenagemSerializer();
}

class _$PedidoSugestaoArmazenagemSerializer implements PrimitiveSerializer<PedidoSugestaoArmazenagem> {
  @override
  final Iterable<Type> types = const [PedidoSugestaoArmazenagem, _$PedidoSugestaoArmazenagem];

  @override
  final String wireName = r'PedidoSugestaoArmazenagem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PedidoSugestaoArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'produtoId';
    yield object.produtoId == null
        ? null
        : serializers.serialize(
            object.produtoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'embalagemId';
    yield object.embalagemId == null
        ? null
        : serializers.serialize(
            object.embalagemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield object.quantidade == null
        ? null
        : serializers.serialize(
            object.quantidade,
            specifiedType: const FullType.nullable(double),
          );
    yield r'loteId';
    yield object.loteId == null
        ? null
        : serializers.serialize(
            object.loteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'validade';
    yield object.validade == null
        ? null
        : serializers.serialize(
            object.validade,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'armazemId';
    yield object.armazemId == null
        ? null
        : serializers.serialize(
            object.armazemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'limite';
    yield object.limite == null
        ? null
        : serializers.serialize(
            object.limite,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PedidoSugestaoArmazenagem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PedidoSugestaoArmazenagemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.produtoId = valueDes;
          break;
        case r'embalagemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.embalagemId = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.quantidade = valueDes;
          break;
        case r'loteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteId = valueDes;
          break;
        case r'validade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validade = valueDes;
          break;
        case r'armazemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.armazemId = valueDes;
          break;
        case r'limite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.limite = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PedidoSugestaoArmazenagem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PedidoSugestaoArmazenagemBuilder();
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
