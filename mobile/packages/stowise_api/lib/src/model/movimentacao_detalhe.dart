//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/tipo_movimentacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'movimentacao_detalhe.g.dart';

/// MovimentacaoDetalhe
///
/// Properties:
/// * [id]
/// * [tipo]
/// * [produtoId]
/// * [loteId]
/// * [loteNumero]
/// * [enderecoOrigemId]
/// * [enderecoDestinoId]
/// * [quantidade]
/// * [documentoReferencia]
/// * [observacao]
/// * [usuarioId]
/// * [dispositivoId]
/// * [ocorridoEm]
/// * [recebidoEm]
/// * [idempotencyKey]
@BuiltValue()
abstract class MovimentacaoDetalhe implements Built<MovimentacaoDetalhe, MovimentacaoDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'tipo')
  TipoMovimentacao get tipo;
  // enum tipoEnum {  Entrada,  Saida,  Transferencia,  Ajuste,  };

  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'loteId')
  String? get loteId;

  @BuiltValueField(wireName: r'loteNumero')
  String? get loteNumero;

  @BuiltValueField(wireName: r'enderecoOrigemId')
  String? get enderecoOrigemId;

  @BuiltValueField(wireName: r'enderecoDestinoId')
  String? get enderecoDestinoId;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'documentoReferencia')
  String? get documentoReferencia;

  @BuiltValueField(wireName: r'observacao')
  String? get observacao;

  @BuiltValueField(wireName: r'usuarioId')
  String get usuarioId;

  @BuiltValueField(wireName: r'dispositivoId')
  String? get dispositivoId;

  @BuiltValueField(wireName: r'ocorridoEm')
  DateTime get ocorridoEm;

  @BuiltValueField(wireName: r'recebidoEm')
  DateTime get recebidoEm;

  @BuiltValueField(wireName: r'idempotencyKey')
  String? get idempotencyKey;

  MovimentacaoDetalhe._();

  factory MovimentacaoDetalhe([void updates(MovimentacaoDetalheBuilder b)]) = _$MovimentacaoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MovimentacaoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MovimentacaoDetalhe> get serializer => _$MovimentacaoDetalheSerializer();
}

class _$MovimentacaoDetalheSerializer implements PrimitiveSerializer<MovimentacaoDetalhe> {
  @override
  final Iterable<Type> types = const [MovimentacaoDetalhe, _$MovimentacaoDetalhe];

  @override
  final String wireName = r'MovimentacaoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MovimentacaoDetalhe object, {
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
      specifiedType: const FullType(TipoMovimentacao),
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
    yield r'enderecoOrigemId';
    yield object.enderecoOrigemId == null
        ? null
        : serializers.serialize(
            object.enderecoOrigemId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'enderecoDestinoId';
    yield object.enderecoDestinoId == null
        ? null
        : serializers.serialize(
            object.enderecoDestinoId,
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
    yield r'observacao';
    yield object.observacao == null
        ? null
        : serializers.serialize(
            object.observacao,
            specifiedType: const FullType.nullable(String),
          );
    yield r'usuarioId';
    yield serializers.serialize(
      object.usuarioId,
      specifiedType: const FullType(String),
    );
    yield r'dispositivoId';
    yield object.dispositivoId == null
        ? null
        : serializers.serialize(
            object.dispositivoId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ocorridoEm';
    yield serializers.serialize(
      object.ocorridoEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'recebidoEm';
    yield serializers.serialize(
      object.recebidoEm,
      specifiedType: const FullType(DateTime),
    );
    yield r'idempotencyKey';
    yield object.idempotencyKey == null
        ? null
        : serializers.serialize(
            object.idempotencyKey,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MovimentacaoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MovimentacaoDetalheBuilder result,
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
            specifiedType: const FullType(TipoMovimentacao),
          ) as TipoMovimentacao;
          result.tipo = valueDes;
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
        case r'enderecoOrigemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoOrigemId = valueDes;
          break;
        case r'enderecoDestinoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.enderecoDestinoId = valueDes;
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
        case r'observacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.observacao = valueDes;
          break;
        case r'usuarioId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.usuarioId = valueDes;
          break;
        case r'dispositivoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dispositivoId = valueDes;
          break;
        case r'ocorridoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.ocorridoEm = valueDes;
          break;
        case r'recebidoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recebidoEm = valueDes;
          break;
        case r'idempotencyKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idempotencyKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MovimentacaoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MovimentacaoDetalheBuilder();
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
