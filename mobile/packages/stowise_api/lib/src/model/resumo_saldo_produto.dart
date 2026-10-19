//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/resumo_saldo_lote.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resumo_saldo_produto.g.dart';

/// ResumoSaldoProduto
///
/// Properties:
/// * [produtoId]
/// * [sku]
/// * [descricao]
/// * [unidadeBase]
/// * [quantidade]
/// * [quantidadeReservada]
/// * [quantidadeDisponivel]
/// * [enderecos]
/// * [lotes]
@BuiltValue()
abstract class ResumoSaldoProduto implements Built<ResumoSaldoProduto, ResumoSaldoProdutoBuilder> {
  @BuiltValueField(wireName: r'produtoId')
  String get produtoId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'unidadeBase')
  String get unidadeBase;

  @BuiltValueField(wireName: r'quantidade')
  double get quantidade;

  @BuiltValueField(wireName: r'quantidadeReservada')
  double get quantidadeReservada;

  @BuiltValueField(wireName: r'quantidadeDisponivel')
  double get quantidadeDisponivel;

  @BuiltValueField(wireName: r'enderecos')
  int get enderecos;

  @BuiltValueField(wireName: r'lotes')
  BuiltList<ResumoSaldoLote> get lotes;

  ResumoSaldoProduto._();

  factory ResumoSaldoProduto([void updates(ResumoSaldoProdutoBuilder b)]) = _$ResumoSaldoProduto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResumoSaldoProdutoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResumoSaldoProduto> get serializer => _$ResumoSaldoProdutoSerializer();
}

class _$ResumoSaldoProdutoSerializer implements PrimitiveSerializer<ResumoSaldoProduto> {
  @override
  final Iterable<Type> types = const [ResumoSaldoProduto, _$ResumoSaldoProduto];

  @override
  final String wireName = r'ResumoSaldoProduto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResumoSaldoProduto object, {
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
    yield r'descricao';
    yield serializers.serialize(
      object.descricao,
      specifiedType: const FullType(String),
    );
    yield r'unidadeBase';
    yield serializers.serialize(
      object.unidadeBase,
      specifiedType: const FullType(String),
    );
    yield r'quantidade';
    yield serializers.serialize(
      object.quantidade,
      specifiedType: const FullType(double),
    );
    yield r'quantidadeReservada';
    yield serializers.serialize(
      object.quantidadeReservada,
      specifiedType: const FullType(double),
    );
    yield r'quantidadeDisponivel';
    yield serializers.serialize(
      object.quantidadeDisponivel,
      specifiedType: const FullType(double),
    );
    yield r'enderecos';
    yield serializers.serialize(
      object.enderecos,
      specifiedType: const FullType(int),
    );
    yield r'lotes';
    yield serializers.serialize(
      object.lotes,
      specifiedType: const FullType(BuiltList, [FullType(ResumoSaldoLote)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResumoSaldoProduto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResumoSaldoProdutoBuilder result,
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
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricao = valueDes;
          break;
        case r'unidadeBase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadeBase = valueDes;
          break;
        case r'quantidade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidade = valueDes;
          break;
        case r'quantidadeReservada':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeReservada = valueDes;
          break;
        case r'quantidadeDisponivel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.quantidadeDisponivel = valueDes;
          break;
        case r'enderecos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.enderecos = valueDes;
          break;
        case r'lotes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ResumoSaldoLote)]),
          ) as BuiltList<ResumoSaldoLote>;
          result.lotes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResumoSaldoProduto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResumoSaldoProdutoBuilder();
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
