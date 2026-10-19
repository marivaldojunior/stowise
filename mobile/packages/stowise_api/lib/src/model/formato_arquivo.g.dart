// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formato_arquivo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FormatoArquivo _$delimitado = const FormatoArquivo._('delimitado');
const FormatoArquivo _$posicional = const FormatoArquivo._('posicional');
const FormatoArquivo _$excel = const FormatoArquivo._('excel');
const FormatoArquivo _$nFeXml = const FormatoArquivo._('nFeXml');

FormatoArquivo _$valueOf(String name) {
  switch (name) {
    case 'delimitado':
      return _$delimitado;
    case 'posicional':
      return _$posicional;
    case 'excel':
      return _$excel;
    case 'nFeXml':
      return _$nFeXml;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FormatoArquivo> _$values = BuiltSet<FormatoArquivo>(const <FormatoArquivo>[
  _$delimitado,
  _$posicional,
  _$excel,
  _$nFeXml,
]);

class _$FormatoArquivoMeta {
  const _$FormatoArquivoMeta();
  FormatoArquivo get delimitado => _$delimitado;
  FormatoArquivo get posicional => _$posicional;
  FormatoArquivo get excel => _$excel;
  FormatoArquivo get nFeXml => _$nFeXml;
  FormatoArquivo valueOf(String name) => _$valueOf(name);
  BuiltSet<FormatoArquivo> get values => _$values;
}

abstract class _$FormatoArquivoMixin {
  // ignore: non_constant_identifier_names
  _$FormatoArquivoMeta get FormatoArquivo => const _$FormatoArquivoMeta();
}

Serializer<FormatoArquivo> _$formatoArquivoSerializer = _$FormatoArquivoSerializer();

class _$FormatoArquivoSerializer implements PrimitiveSerializer<FormatoArquivo> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'delimitado': 'Delimitado',
    'posicional': 'Posicional',
    'excel': 'Excel',
    'nFeXml': 'NFeXml',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Delimitado': 'delimitado',
    'Posicional': 'posicional',
    'Excel': 'excel',
    'NFeXml': 'nFeXml',
  };

  @override
  final Iterable<Type> types = const <Type>[FormatoArquivo];
  @override
  final String wireName = 'FormatoArquivo';

  @override
  Object serialize(Serializers serializers, FormatoArquivo object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FormatoArquivo deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FormatoArquivo.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
