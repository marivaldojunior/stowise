//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campo_importacao.g.dart';

/// CampoImportacao
///
/// Properties:
/// * [nome]
/// * [descricao]
/// * [obrigatorio]
@BuiltValue()
abstract class CampoImportacao implements Built<CampoImportacao, CampoImportacaoBuilder> {
  @BuiltValueField(wireName: r'nome')
  String get nome;

  @BuiltValueField(wireName: r'descricao')
  String get descricao;

  @BuiltValueField(wireName: r'obrigatorio')
  bool get obrigatorio;

  CampoImportacao._();

  factory CampoImportacao([void updates(CampoImportacaoBuilder b)]) = _$CampoImportacao;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampoImportacaoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampoImportacao> get serializer => _$CampoImportacaoSerializer();
}

class _$CampoImportacaoSerializer implements PrimitiveSerializer<CampoImportacao> {
  @override
  final Iterable<Type> types = const [CampoImportacao, _$CampoImportacao];

  @override
  final String wireName = r'CampoImportacao';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampoImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nome';
    yield serializers.serialize(
      object.nome,
      specifiedType: const FullType(String),
    );
    yield r'descricao';
    yield serializers.serialize(
      object.descricao,
      specifiedType: const FullType(String),
    );
    yield r'obrigatorio';
    yield serializers.serialize(
      object.obrigatorio,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampoImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampoImportacaoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nome = valueDes;
          break;
        case r'descricao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descricao = valueDes;
          break;
        case r'obrigatorio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.obrigatorio = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampoImportacao deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampoImportacaoBuilder();
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
