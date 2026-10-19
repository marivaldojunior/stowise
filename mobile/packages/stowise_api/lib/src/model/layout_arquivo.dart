//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/coluna_arquivo.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stowise_api/src/model/formato_arquivo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'layout_arquivo.g.dart';

/// LayoutArquivo
///
/// Properties:
/// * [formato]
/// * [encoding]
/// * [delimitador]
/// * [separadorDecimal]
/// * [temCabecalho]
/// * [colunas]
/// * [planilha]
@BuiltValue()
abstract class LayoutArquivo implements Built<LayoutArquivo, LayoutArquivoBuilder> {
  @BuiltValueField(wireName: r'formato')
  FormatoArquivo get formato;
  // enum formatoEnum {  Delimitado,  Posicional,  Excel,  NFeXml,  };

  @BuiltValueField(wireName: r'encoding')
  String? get encoding;

  @BuiltValueField(wireName: r'delimitador')
  String? get delimitador;

  @BuiltValueField(wireName: r'separadorDecimal')
  String get separadorDecimal;

  @BuiltValueField(wireName: r'temCabecalho')
  bool get temCabecalho;

  @BuiltValueField(wireName: r'colunas')
  BuiltList<ColunaArquivo> get colunas;

  @BuiltValueField(wireName: r'planilha')
  String? get planilha;

  LayoutArquivo._();

  factory LayoutArquivo([void updates(LayoutArquivoBuilder b)]) = _$LayoutArquivo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LayoutArquivoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LayoutArquivo> get serializer => _$LayoutArquivoSerializer();
}

class _$LayoutArquivoSerializer implements PrimitiveSerializer<LayoutArquivo> {
  @override
  final Iterable<Type> types = const [LayoutArquivo, _$LayoutArquivo];

  @override
  final String wireName = r'LayoutArquivo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LayoutArquivo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'formato';
    yield serializers.serialize(
      object.formato,
      specifiedType: const FullType(FormatoArquivo),
    );
    yield r'encoding';
    yield object.encoding == null
        ? null
        : serializers.serialize(
            object.encoding,
            specifiedType: const FullType.nullable(String),
          );
    yield r'delimitador';
    yield object.delimitador == null
        ? null
        : serializers.serialize(
            object.delimitador,
            specifiedType: const FullType.nullable(String),
          );
    yield r'separadorDecimal';
    yield serializers.serialize(
      object.separadorDecimal,
      specifiedType: const FullType(String),
    );
    yield r'temCabecalho';
    yield serializers.serialize(
      object.temCabecalho,
      specifiedType: const FullType(bool),
    );
    yield r'colunas';
    yield serializers.serialize(
      object.colunas,
      specifiedType: const FullType(BuiltList, [FullType(ColunaArquivo)]),
    );
    if (object.planilha != null) {
      yield r'planilha';
      yield serializers.serialize(
        object.planilha,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LayoutArquivo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LayoutArquivoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'formato':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FormatoArquivo),
          ) as FormatoArquivo;
          result.formato = valueDes;
          break;
        case r'encoding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.encoding = valueDes;
          break;
        case r'delimitador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.delimitador = valueDes;
          break;
        case r'separadorDecimal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.separadorDecimal = valueDes;
          break;
        case r'temCabecalho':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.temCabecalho = valueDes;
          break;
        case r'colunas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ColunaArquivo)]),
          ) as BuiltList<ColunaArquivo>;
          result.colunas.replace(valueDes);
          break;
        case r'planilha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.planilha = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LayoutArquivo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LayoutArquivoBuilder();
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
