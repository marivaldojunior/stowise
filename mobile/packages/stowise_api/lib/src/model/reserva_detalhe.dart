//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/status_reserva.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reserva_detalhe.g.dart';

/// ReservaDetalhe
///
/// Properties:
/// * [id]
/// * [enderecoId]
/// * [produtoId]
/// * [loteId]
/// * [loteNumero]
/// * [quantidade]
/// * [documentoReferencia]
/// * [status]
/// * [criadaPor]
/// * [criadaEm]
/// * [encerradaPor]
/// * [encerradaEm]
/// * [movimentacaoId]
@BuiltValue()
abstract class ReservaDetalhe implements Built<ReservaDetalhe, ReservaDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'enderecoId')
  String get enderecoId;

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'status')
  StatusReserva get status;
  // enum statusEnum {  Ativa,  Cancelada,  Consumida,  };

  @BuiltValueField(wireName: r'criadaPor')
  String get criadaPor;

  @BuiltValueField(wireName: r'criadaEm')
  DateTime get criadaEm;

  @BuiltValueField(wireName: r'encerradaPor')
  String? get encerradaPor;

  @BuiltValueField(wireName: r'encerradaEm')
  DateTime? get encerradaEm;

  @BuiltValueField(wireName: r'movimentacaoId')
  String? get movimentacaoId;

  ReservaDetalhe._();

  factory ReservaDetalhe([void updates(ReservaDetalheBuilder b)]) = _$ReservaDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReservaDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReservaDetalhe> get serializer => _$ReservaDetalheSerializer();
}

class _$ReservaDetalheSerializer implements PrimitiveSerializer<ReservaDetalhe> {
  @override
  final Iterable<Type> types = const [ReservaDetalhe, _$ReservaDetalhe];

  @override
  final String wireName = r'ReservaDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReservaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'enderecoId';
    yield serializers.serialize(
      object.enderecoId,
      specifiedType: const FullType(String),
    );
    yield r'produtoId';
    yield serializers.serialize(
      object.produtoId,
      specifiedType: const FullType(String),
    );
    yield r'loteId';
    yield object.loteId == null
        ? null
        : serializers.serialize(
            object.loteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'loteNumero';
    yield object.loteNumero == null
        ? null
        : serializers.serialize(
            object.loteNumero,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'documentoReferencia';
    yield object.documentoReferencia == null
        ? null
        : serializers.serialize(
            object.documentoReferencia,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusReserva),
    );
    yield r'criadaPor';
    yield serializers.serialize(
      object.criadaPor,
      specifiedType: const FullType(String),
    );
    yield r'criadaEm';
    yield serializers.serialize(
      object.criadaEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'encerradaPor';
    yield object.encerradaPor == null
        ? null
        : serializers.serialize(
            object.encerradaPor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'encerradaEm';
    yield object.encerradaEm == null
        ? null
        : serializers.serialize(
            object.encerradaEm,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'movimentacaoId';
    yield object.movimentacaoId == null
        ? null
        : serializers.serialize(
            object.movimentacaoId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReservaDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReservaDetalheBuilder result,
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
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enderecoId = valueDes;
          break;
        case r'produtoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.produtoId = valueDes;
          break;
        case r'loteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteId = valueDes;
          break;
        case r'loteNumero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loteNumero = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'documentoReferencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentoReferencia = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusReserva),
          ) as StatusReserva;
          result.status = valueDes;
          break;
        case r'criadaPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.criadaPor = valueDes;
          break;
        case r'criadaEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.criadaEm = valueDes;
          break;
        case r'encerradaPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.encerradaPor = valueDes;
          break;
        case r'encerradaEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.encerradaEm = valueDes;
          break;
        case r'movimentacaoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.movimentacaoId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReservaDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReservaDetalheBuilder();
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
