//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'efetivar_importacao.g.dart';

/// EfetivarImportacao
///
/// Properties:
/// * [versao]
@BuiltValue()
abstract class EfetivarImportacao implements Built<EfetivarImportacao, EfetivarImportacaoBuilder> {
  @BuiltValueField(wireName: r'versao')
  int? get versao;

  EfetivarImportacao._();

  factory EfetivarImportacao([void updates(EfetivarImportacaoBuilder b)]) = _$EfetivarImportacao;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EfetivarImportacaoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EfetivarImportacao> get serializer => _$EfetivarImportacaoSerializer();
}

class _$EfetivarImportacaoSerializer implements PrimitiveSerializer<EfetivarImportacao> {
  @override
  final Iterable<Type> types = const [EfetivarImportacao, _$EfetivarImportacao];

  @override
  final String wireName = r'EfetivarImportacao';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EfetivarImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'versao';
    yield object.versao == null
        ? null
        : serializers.serialize(
            object.versao,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    EfetivarImportacao object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EfetivarImportacaoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  EfetivarImportacao deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EfetivarImportacaoBuilder();
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
