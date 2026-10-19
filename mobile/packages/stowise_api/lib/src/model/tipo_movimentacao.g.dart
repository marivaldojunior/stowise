// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_movimentacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TipoMovimentacao _$entrada = const TipoMovimentacao._('entrada');
const TipoMovimentacao _$saida = const TipoMovimentacao._('saida');
const TipoMovimentacao _$transferencia = const TipoMovimentacao._('transferencia');
const TipoMovimentacao _$ajuste = const TipoMovimentacao._('ajuste');

TipoMovimentacao _$valueOf(String name) {
  switch (name) {
    case 'entrada':
      return _$entrada;
    case 'saida':
      return _$saida;
    case 'transferencia':
      return _$transferencia;
    case 'ajuste':
      return _$ajuste;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TipoMovimentacao> _$values = BuiltSet<TipoMovimentacao>(const <TipoMovimentacao>[
  _$entrada,
  _$saida,
  _$transferencia,
  _$ajuste,
]);

class _$TipoMovimentacaoMeta {
  const _$TipoMovimentacaoMeta();
  TipoMovimentacao get entrada => _$entrada;
  TipoMovimentacao get saida => _$saida;
  TipoMovimentacao get transferencia => _$transferencia;
  TipoMovimentacao get ajuste => _$ajuste;
  TipoMovimentacao valueOf(String name) => _$valueOf(name);
  BuiltSet<TipoMovimentacao> get values => _$values;
}

abstract class _$TipoMovimentacaoMixin {
  // ignore: non_constant_identifier_names
  _$TipoMovimentacaoMeta get TipoMovimentacao => const _$TipoMovimentacaoMeta();
}

Serializer<TipoMovimentacao> _$tipoMovimentacaoSerializer = _$TipoMovimentacaoSerializer();

class _$TipoMovimentacaoSerializer implements PrimitiveSerializer<TipoMovimentacao> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'entrada': 'Entrada',
    'saida': 'Saida',
    'transferencia': 'Transferencia',
    'ajuste': 'Ajuste',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Entrada': 'entrada',
    'Saida': 'saida',
    'Transferencia': 'transferencia',
    'Ajuste': 'ajuste',
  };

  @override
  final Iterable<Type> types = const <Type>[TipoMovimentacao];
  @override
  final String wireName = 'TipoMovimentacao';

  @override
  Object serialize(Serializers serializers, TipoMovimentacao object, {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TipoMovimentacao deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TipoMovimentacao.valueOf(_fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
