//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/mapeamento_coluna.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/regras_normalizacao.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'confirmar_mapeamento.g.dart';

/// ConfirmarMapeamento
///
/// Properties:
/// * [colunas]
/// * [versao]
/// * [salvarTemplate]
/// * [nomeTemplate]
/// * [regras]
@BuiltValue()
abstract class ConfirmarMapeamento implements Built<ConfirmarMapeamento, ConfirmarMapeamentoBuilder> {
  @BuiltValueField(wireName: r'colunas')
  BuiltList<MapeamentoColuna>? get colunas;

  @BuiltValueField(wireName: r'versao')
  int? get versao;

  @BuiltValueField(wireName: r'salvarTemplate')
  bool? get salvarTemplate;

  @BuiltValueField(wireName: r'nomeTemplate')
  String? get nomeTemplate;

  @BuiltValueField(wireName: r'regras')
  RegrasNormalizacao? get regras;

  ConfirmarMapeamento._();

  factory ConfirmarMapeamento([void updates(ConfirmarMapeamentoBuilder b)]) = _$ConfirmarMapeamento;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConfirmarMapeamentoBuilder b) => b..salvarTemplate = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConfirmarMapeamento> get serializer => _$ConfirmarMapeamentoSerializer();
}

class _$ConfirmarMapeamentoSerializer implements PrimitiveSerializer<ConfirmarMapeamento> {
  @override
  final Iterable<Type> types = const [ConfirmarMapeamento, _$ConfirmarMapeamento];

  @override
  final String wireName = r'ConfirmarMapeamento';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConfirmarMapeamento object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'colunas';
    yield object.colunas == null
        ? null
        : serializers.serialize(
            object.colunas,
            specifiedType: const FullType.nullable(BuiltList, [FullType(MapeamentoColuna)]),
          );
    yield r'versao';
    yield object.versao == null
        ? null
        : serializers.serialize(
            object.versao,
            specifiedType: const FullType.nullable(int),
          );
    if (object.salvarTemplate != null) {
      yield r'salvarTemplate';
      yield serializers.serialize(
        object.salvarTemplate,
        specifiedType: const FullType(bool),
      );
    }
    if (object.nomeTemplate != null) {
      yield r'nomeTemplate';
      yield serializers.serialize(
        object.nomeTemplate,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.regras != null) {
      yield r'regras';
      yield serializers.serialize(
        object.regras,
        specifiedType: const FullType.nullable(RegrasNormalizacao),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConfirmarMapeamento object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConfirmarMapeamentoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'colunas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(MapeamentoColuna)]),
          ) as BuiltList<MapeamentoColuna>?;
          if (valueDes == null) continue;
          result.colunas.replace(valueDes);
          break;
        case r'versao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.versao = valueDes;
          break;
        case r'salvarTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.salvarTemplate = valueDes;
          break;
        case r'nomeTemplate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nomeTemplate = valueDes;
          break;
        case r'regras':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegrasNormalizacao),
          ) as RegrasNormalizacao?;
          if (valueDes == null) continue;
          result.regras.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConfirmarMapeamento deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConfirmarMapeamentoBuilder();
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
