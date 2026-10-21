// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerta_item_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AlertaItemNota _$fatorDivergente = const AlertaItemNota._('fatorDivergente');
const AlertaItemNota _$lotesNaoFecham = const AlertaItemNota._('lotesNaoFecham');
const AlertaItemNota _$loteFaltando = const AlertaItemNota._('loteFaltando');
const AlertaItemNota _$validadeFaltando = const AlertaItemNota._('validadeFaltando');
const AlertaItemNota _$loteVencido = const AlertaItemNota._('loteVencido');

AlertaItemNota _$valueOf(String name) {
  switch (name) {
    case 'fatorDivergente':
      return _$fatorDivergente;
    case 'lotesNaoFecham':
      return _$lotesNaoFecham;
    case 'loteFaltando':
      return _$loteFaltando;
    case 'validadeFaltando':
      return _$validadeFaltando;
    case 'loteVencido':
      return _$loteVencido;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AlertaItemNota> _$values = BuiltSet<AlertaItemNota>(const <AlertaItemNota>[
  _$fatorDivergente,
  _$lotesNaoFecham,
  _$loteFaltando,
  _$validadeFaltando,
  _$loteVencido,
]);

class _$AlertaItemNotaMeta {
  const _$AlertaItemNotaMeta();
  AlertaItemNota get fatorDivergente => _$fatorDivergente;
  AlertaItemNota get lotesNaoFecham => _$lotesNaoFecham;
  AlertaItemNota get loteFaltando => _$loteFaltando;
  AlertaItemNota get validadeFaltando => _$validadeFaltando;
  AlertaItemNota get loteVencido => _$loteVencido;
  AlertaItemNota valueOf(String name) => _$valueOf(name);
  BuiltSet<AlertaItemNota> get values => _$values;
}

abstract class _$AlertaItemNotaMixin {
  // ignore: non_constant_identifier_names
  _$AlertaItemNotaMeta get AlertaItemNota => const _$AlertaItemNotaMeta();
}

Serializer<AlertaItemNota> _$alertaItemNotaSerializer = _$AlertaItemNotaSerializer();

class _$AlertaItemNotaSerializer implements PrimitiveSerializer<AlertaItemNota> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fatorDivergente': 'FatorDivergente',
    'lotesNaoFecham': 'LotesNaoFecham',
    'loteFaltando': 'LoteFaltando',
    'validadeFaltando': 'ValidadeFaltando',
    'loteVencido': 'LoteVencido',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FatorDivergente': 'fatorDivergente',
    'LotesNaoFecham': 'lotesNaoFecham',
    'LoteFaltando': 'loteFaltando',
    'ValidadeFaltando': 'validadeFaltando',
    'LoteVencido': 'loteVencido',
  };

  @override
  final Iterable<Type> types = const <Type>[AlertaItemNota];
  @override
  final String wireName = 'AlertaItemNota';

  @override
  Object serialize(Serializers serializers, AlertaItemNota object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AlertaItemNota deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AlertaItemNota.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
