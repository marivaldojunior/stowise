//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/leitura_rfid.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/contagem_rfid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'leituras_rfid_resolvidas.g.dart';

/// LeiturasRfidResolvidas
///
/// Properties:
/// * [leituras]
/// * [produtos]
/// * [naoReconhecidas]
@BuiltValue()
abstract class LeiturasRfidResolvidas implements Built<LeiturasRfidResolvidas, LeiturasRfidResolvidasBuilder> {
  @BuiltValueField(wireName: r'leituras')
  BuiltList<LeituraRfid> get leituras;

  @BuiltValueField(wireName: r'produtos')
  BuiltList<ContagemRfid> get produtos;

  @BuiltValueField(wireName: r'naoReconhecidas')
  int get naoReconhecidas;

  LeiturasRfidResolvidas._();

  factory LeiturasRfidResolvidas([void updates(LeiturasRfidResolvidasBuilder b)]) = _$LeiturasRfidResolvidas;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LeiturasRfidResolvidasBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LeiturasRfidResolvidas> get serializer => _$LeiturasRfidResolvidasSerializer();
}

class _$LeiturasRfidResolvidasSerializer implements PrimitiveSerializer<LeiturasRfidResolvidas> {
  @override
  final Iterable<Type> types = const [LeiturasRfidResolvidas, _$LeiturasRfidResolvidas];

  @override
  final String wireName = r'LeiturasRfidResolvidas';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LeiturasRfidResolvidas object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'leituras';
    yield serializers.serialize(
      object.leituras,
      specifiedType: const FullType(BuiltList, [FullType(LeituraRfid)]),
    );
    yield r'produtos';
    yield serializers.serialize(
      object.produtos,
      specifiedType: const FullType(BuiltList, [FullType(ContagemRfid)]),
    );
    yield r'naoReconhecidas';
    yield serializers.serialize(
      object.naoReconhecidas,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LeiturasRfidResolvidas object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LeiturasRfidResolvidasBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'leituras':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LeituraRfid)]),
          ) as BuiltList<LeituraRfid>;
          result.leituras.replace(valueDes);
          break;
        case r'produtos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ContagemRfid)]),
          ) as BuiltList<ContagemRfid>;
          result.produtos.replace(valueDes);
          break;
        case r'naoReconhecidas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.naoReconhecidas = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LeiturasRfidResolvidas deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LeiturasRfidResolvidasBuilder();
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
