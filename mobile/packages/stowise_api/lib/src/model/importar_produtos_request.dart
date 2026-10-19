//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:typed_data';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'importar_produtos_request.g.dart';

/// ImportarProdutosRequest
///
/// Properties:
/// * [arquivo]
@BuiltValue()
abstract class ImportarProdutosRequest implements Built<ImportarProdutosRequest, ImportarProdutosRequestBuilder> {
  @BuiltValueField(wireName: r'arquivo')
  Uint8List? get arquivo;

  ImportarProdutosRequest._();

  factory ImportarProdutosRequest([void updates(ImportarProdutosRequestBuilder b)]) = _$ImportarProdutosRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportarProdutosRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportarProdutosRequest> get serializer => _$ImportarProdutosRequestSerializer();
}

class _$ImportarProdutosRequestSerializer implements PrimitiveSerializer<ImportarProdutosRequest> {
  @override
  final Iterable<Type> types = const [ImportarProdutosRequest, _$ImportarProdutosRequest];

  @override
  final String wireName = r'ImportarProdutosRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportarProdutosRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.arquivo != null) {
      yield r'arquivo';
      yield serializers.serialize(
        object.arquivo,
        specifiedType: const FullType(Uint8List),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportarProdutosRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportarProdutosRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'arquivo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Uint8List),
          ) as Uint8List;
          result.arquivo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportarProdutosRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportarProdutosRequestBuilder();
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
