//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/fornecedor_da_nota.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/item_analisado.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analise_nota_fiscal.g.dart';

/// AnaliseNotaFiscal
///
/// Properties:
/// * [chaveAcesso]
/// * [numero]
/// * [serie]
/// * [dataEmissao]
/// * [autorizada]
/// * [fornecedor]
/// * [itens]
@BuiltValue()
abstract class AnaliseNotaFiscal implements Built<AnaliseNotaFiscal, AnaliseNotaFiscalBuilder> {
  @BuiltValueField(wireName: r'chaveAcesso')
  String get chaveAcesso;

  @BuiltValueField(wireName: r'numero')
  int get numero;

  @BuiltValueField(wireName: r'serie')
  int get serie;

  @BuiltValueField(wireName: r'dataEmissao')
  DateTime get dataEmissao;

  @BuiltValueField(wireName: r'autorizada')
  bool get autorizada;

  @BuiltValueField(wireName: r'fornecedor')
  FornecedorDaNota get fornecedor;

  @BuiltValueField(wireName: r'itens')
  BuiltList<ItemAnalisado> get itens;

  AnaliseNotaFiscal._();

  factory AnaliseNotaFiscal([void updates(AnaliseNotaFiscalBuilder b)]) = _$AnaliseNotaFiscal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnaliseNotaFiscalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnaliseNotaFiscal> get serializer => _$AnaliseNotaFiscalSerializer();
}

class _$AnaliseNotaFiscalSerializer implements PrimitiveSerializer<AnaliseNotaFiscal> {
  @override
  final Iterable<Type> types = const [AnaliseNotaFiscal, _$AnaliseNotaFiscal];

  @override
  final String wireName = r'AnaliseNotaFiscal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnaliseNotaFiscal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'chaveAcesso';
    yield serializers.serialize(
      object.chaveAcesso,
      specifiedType: const FullType(String),
    );
    yield r'numero';
    yield serializers.serialize(
      object.numero,
      specifiedType: const FullType(int),
    );
    yield r'serie';
    yield serializers.serialize(
      object.serie,
      specifiedType: const FullType(int),
    );
    yield r'dataEmissao';
    yield serializers.serialize(
      object.dataEmissao,
      specifiedType: const FullType(DateTime),
    );
    yield r'autorizada';
    yield serializers.serialize(
      object.autorizada,
      specifiedType: const FullType(bool),
    );
    yield r'fornecedor';
    yield serializers.serialize(
      object.fornecedor,
      specifiedType: const FullType(FornecedorDaNota),
    );
    yield r'itens';
    yield serializers.serialize(
      object.itens,
      specifiedType: const FullType(BuiltList, [FullType(ItemAnalisado)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnaliseNotaFiscal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnaliseNotaFiscalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'chaveAcesso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.chaveAcesso = valueDes;
          break;
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numero = valueDes;
          break;
        case r'serie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.serie = valueDes;
          break;
        case r'dataEmissao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dataEmissao = valueDes;
          break;
        case r'autorizada':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autorizada = valueDes;
          break;
        case r'fornecedor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FornecedorDaNota),
          ) as FornecedorDaNota;
          result.fornecedor.replace(valueDes);
          break;
        case r'itens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ItemAnalisado)]),
          ) as BuiltList<ItemAnalisado>;
          result.itens.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnaliseNotaFiscal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnaliseNotaFiscalBuilder();
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
