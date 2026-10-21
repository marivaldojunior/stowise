//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/nota_regra.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sugestao_endereco.g.dart';

/// SugestaoEndereco
///
/// Properties:
/// * [enderecoId]
/// * [codigo]
/// * [pontuacao]
/// * [notas]
@BuiltValue()
abstract class SugestaoEndereco implements Built<SugestaoEndereco, SugestaoEnderecoBuilder> {
  @BuiltValueField(wireName: r'enderecoId')
  String get enderecoId;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'pontuacao')
  double get pontuacao;

  @BuiltValueField(wireName: r'notas')
  BuiltList<NotaRegra> get notas;

  SugestaoEndereco._();

  factory SugestaoEndereco([void updates(SugestaoEnderecoBuilder b)]) = _$SugestaoEndereco;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SugestaoEnderecoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SugestaoEndereco> get serializer => _$SugestaoEnderecoSerializer();
}

class _$SugestaoEnderecoSerializer implements PrimitiveSerializer<SugestaoEndereco> {
  @override
  final Iterable<Type> types = const [SugestaoEndereco, _$SugestaoEndereco];

  @override
  final String wireName = r'SugestaoEndereco';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SugestaoEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enderecoId';
    yield serializers.serialize(
      object.enderecoId,
      specifiedType: const FullType(String),
    );
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'pontuacao';
    yield serializers.serialize(
      object.pontuacao,
      specifiedType: const FullType(double),
    );
    yield r'notas';
    yield serializers.serialize(
      object.notas,
      specifiedType: const FullType(BuiltList, [FullType(NotaRegra)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SugestaoEndereco object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SugestaoEnderecoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enderecoId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enderecoId = valueDes;
          break;
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'pontuacao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.pontuacao = valueDes;
          break;
        case r'notas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotaRegra)]),
          ) as BuiltList<NotaRegra>;
          result.notas.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SugestaoEndereco deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SugestaoEnderecoBuilder();
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
