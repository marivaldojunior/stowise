//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stowise_api/src/model/status_endereco.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'endereco_detalhe.g.dart';

/// EnderecoDetalhe
///
/// Properties:
/// * [id]
/// * [armazemId]
/// * [zonaId]
/// * [codigo]
/// * [rua]
/// * [modulo]
/// * [nivel]
/// * [posicao]
/// * [capacidadePesoKg]
/// * [alturaCm]
/// * [larguraCm]
/// * [profundidadeCm]
/// * [distanciaExpedicao]
/// * [status]
/// * [motivoBloqueio]
/// * [bloqueadoEm]
/// * [bloqueadoPor]
@BuiltValue()
abstract class EnderecoDetalhe implements Built<EnderecoDetalhe, EnderecoDetalheBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'armazemId')
  String get armazemId;

  @BuiltValueField(wireName: r'zonaId')
  String get zonaId;

  @BuiltValueField(wireName: r'codigo')
  String get codigo;

  @BuiltValueField(wireName: r'rua')
  String get rua;

  @BuiltValueField(wireName: r'modulo')
  int get modulo;

  @BuiltValueField(wireName: r'nivel')
  int get nivel;

  @BuiltValueField(wireName: r'posicao')
  int get posicao;

  @BuiltValueField(wireName: r'capacidadePesoKg')
  double get capacidadePesoKg;

  @BuiltValueField(wireName: r'alturaCm')
  double get alturaCm;

  @BuiltValueField(wireName: r'larguraCm')
  double get larguraCm;

  @BuiltValueField(wireName: r'profundidadeCm')
  double get profundidadeCm;

  @BuiltValueField(wireName: r'distanciaExpedicao')
  double get distanciaExpedicao;

  @BuiltValueField(wireName: r'status')
  StatusEndereco get status;
  // enum statusEnum {  Livre,  Ocupado,  Bloqueado,  };

  @BuiltValueField(wireName: r'motivoBloqueio')
  String? get motivoBloqueio;

  @BuiltValueField(wireName: r'bloqueadoEm')
  DateTime? get bloqueadoEm;

  @BuiltValueField(wireName: r'bloqueadoPor')
  String? get bloqueadoPor;

  EnderecoDetalhe._();

  factory EnderecoDetalhe([void updates(EnderecoDetalheBuilder b)]) = _$EnderecoDetalhe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnderecoDetalheBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnderecoDetalhe> get serializer => _$EnderecoDetalheSerializer();
}

class _$EnderecoDetalheSerializer implements PrimitiveSerializer<EnderecoDetalhe> {
  @override
  final Iterable<Type> types = const [EnderecoDetalhe, _$EnderecoDetalhe];

  @override
  final String wireName = r'EnderecoDetalhe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnderecoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'armazemId';
    yield serializers.serialize(
      object.armazemId,
      specifiedType: const FullType(String),
    );
    yield r'zonaId';
    yield serializers.serialize(
      object.zonaId,
      specifiedType: const FullType(String),
    );
    yield r'codigo';
    yield serializers.serialize(
      object.codigo,
      specifiedType: const FullType(String),
    );
    yield r'rua';
    yield serializers.serialize(
      object.rua,
      specifiedType: const FullType(String),
    );
    yield r'modulo';
    yield serializers.serialize(
      object.modulo,
      specifiedType: const FullType(int),
    );
    yield r'nivel';
    yield serializers.serialize(
      object.nivel,
      specifiedType: const FullType(int),
    );
    yield r'posicao';
    yield serializers.serialize(
      object.posicao,
      specifiedType: const FullType(int),
    );
    yield r'capacidadePesoKg';
    yield serializers.serialize(
      object.capacidadePesoKg,
      specifiedType: const FullType(double),
    );
    yield r'alturaCm';
    yield serializers.serialize(
      object.alturaCm,
      specifiedType: const FullType(double),
    );
    yield r'larguraCm';
    yield serializers.serialize(
      object.larguraCm,
      specifiedType: const FullType(double),
    );
    yield r'profundidadeCm';
    yield serializers.serialize(
      object.profundidadeCm,
      specifiedType: const FullType(double),
    );
    yield r'distanciaExpedicao';
    yield serializers.serialize(
      object.distanciaExpedicao,
      specifiedType: const FullType(double),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StatusEndereco),
    );
    yield r'motivoBloqueio';
    yield object.motivoBloqueio == null
        ? null
        : serializers.serialize(
            object.motivoBloqueio,
            specifiedType: const FullType.nullable(String),
          );
    yield r'bloqueadoEm';
    yield object.bloqueadoEm == null
        ? null
        : serializers.serialize(
            object.bloqueadoEm,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'bloqueadoPor';
    yield object.bloqueadoPor == null
        ? null
        : serializers.serialize(
            object.bloqueadoPor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnderecoDetalhe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnderecoDetalheBuilder result,
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
        case r'armazemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.armazemId = valueDes;
          break;
        case r'zonaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.zonaId = valueDes;
          break;
        case r'codigo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigo = valueDes;
          break;
        case r'rua':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rua = valueDes;
          break;
        case r'modulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.modulo = valueDes;
          break;
        case r'nivel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nivel = valueDes;
          break;
        case r'posicao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.posicao = valueDes;
          break;
        case r'capacidadePesoKg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.capacidadePesoKg = valueDes;
          break;
        case r'alturaCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.alturaCm = valueDes;
          break;
        case r'larguraCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.larguraCm = valueDes;
          break;
        case r'profundidadeCm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.profundidadeCm = valueDes;
          break;
        case r'distanciaExpedicao':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.distanciaExpedicao = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatusEndereco),
          ) as StatusEndereco;
          result.status = valueDes;
          break;
        case r'motivoBloqueio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.motivoBloqueio = valueDes;
          break;
        case r'bloqueadoEm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.bloqueadoEm = valueDes;
          break;
        case r'bloqueadoPor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bloqueadoPor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnderecoDetalhe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnderecoDetalheBuilder();
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
