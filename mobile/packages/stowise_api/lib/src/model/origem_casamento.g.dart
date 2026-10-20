// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origem_casamento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrigemCasamento _$dePara = const OrigemCasamento._('dePara');
const OrigemCasamento _$gtin = const OrigemCasamento._('gtin');
const OrigemCasamento _$similaridade = const OrigemCasamento._('similaridade');
const OrigemCasamento _$semCandidato = const OrigemCasamento._('semCandidato');

OrigemCasamento _$valueOf(String name) {
  switch (name) {
    case 'dePara':
      return _$dePara;
    case 'gtin':
      return _$gtin;
    case 'similaridade':
      return _$similaridade;
    case 'semCandidato':
      return _$semCandidato;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrigemCasamento> _$values = BuiltSet<OrigemCasamento>(const <OrigemCasamento>[
  _$dePara,
  _$gtin,
  _$similaridade,
  _$semCandidato,
]);

class _$OrigemCasamentoMeta {
  const _$OrigemCasamentoMeta();
  OrigemCasamento get dePara => _$dePara;
  OrigemCasamento get gtin => _$gtin;
  OrigemCasamento get similaridade => _$similaridade;
  OrigemCasamento get semCandidato => _$semCandidato;
  OrigemCasamento valueOf(String name) => _$valueOf(name);
  BuiltSet<OrigemCasamento> get values => _$values;
}

abstract class _$OrigemCasamentoMixin {
  // ignore: non_constant_identifier_names
  _$OrigemCasamentoMeta get OrigemCasamento => const _$OrigemCasamentoMeta();
}

Serializer<OrigemCasamento> _$origemCasamentoSerializer = _$OrigemCasamentoSerializer();

class _$OrigemCasamentoSerializer implements PrimitiveSerializer<OrigemCasamento> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'dePara': 'DePara',
    'gtin': 'Gtin',
    'similaridade': 'Similaridade',
    'semCandidato': 'SemCandidato',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DePara': 'dePara',
    'Gtin': 'gtin',
    'Similaridade': 'similaridade',
    'SemCandidato': 'semCandidato',
  };

  @override
  final Iterable<Type> types = const <Type>[OrigemCasamento];
  @override
  final String wireName = 'OrigemCasamento';

  @override
  Object serialize(Serializers serializers, OrigemCasamento object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrigemCasamento deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrigemCasamento.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
