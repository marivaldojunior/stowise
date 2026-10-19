// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumo_saldo_lote.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResumoSaldoLote extends ResumoSaldoLote {
  @override
  final String? loteId;
  @override
  final String? numero;
  @override
  final Date? validade;
  @override
  final double quantidade;
  @override
  final double quantidadeReservada;

  factory _$ResumoSaldoLote([void Function(ResumoSaldoLoteBuilder)? updates]) =>
      (ResumoSaldoLoteBuilder()..update(updates))._build();

  _$ResumoSaldoLote._(
      {this.loteId, this.numero, this.validade, required this.quantidade, required this.quantidadeReservada})
      : super._();
  @override
  ResumoSaldoLote rebuild(void Function(ResumoSaldoLoteBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ResumoSaldoLoteBuilder toBuilder() => ResumoSaldoLoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResumoSaldoLote &&
        loteId == other.loteId &&
        numero == other.numero &&
        validade == other.validade &&
        quantidade == other.quantidade &&
        quantidadeReservada == other.quantidadeReservada;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, quantidadeReservada.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResumoSaldoLote')
          ..add('loteId', loteId)
          ..add('numero', numero)
          ..add('validade', validade)
          ..add('quantidade', quantidade)
          ..add('quantidadeReservada', quantidadeReservada))
        .toString();
  }
}

class ResumoSaldoLoteBuilder implements Builder<ResumoSaldoLote, ResumoSaldoLoteBuilder> {
  _$ResumoSaldoLote? _$v;

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  double? _quantidadeReservada;
  double? get quantidadeReservada => _$this._quantidadeReservada;
  set quantidadeReservada(double? quantidadeReservada) => _$this._quantidadeReservada = quantidadeReservada;

  ResumoSaldoLoteBuilder() {
    ResumoSaldoLote._defaults(this);
  }

  ResumoSaldoLoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loteId = $v.loteId;
      _numero = $v.numero;
      _validade = $v.validade;
      _quantidade = $v.quantidade;
      _quantidadeReservada = $v.quantidadeReservada;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResumoSaldoLote other) {
    _$v = other as _$ResumoSaldoLote;
  }

  @override
  void update(void Function(ResumoSaldoLoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResumoSaldoLote build() => _build();

  _$ResumoSaldoLote _build() {
    final _$result = _$v ??
        _$ResumoSaldoLote._(
          loteId: loteId,
          numero: numero,
          validade: validade,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'ResumoSaldoLote', 'quantidade'),
          quantidadeReservada:
              BuiltValueNullFieldError.checkNotNull(quantidadeReservada, r'ResumoSaldoLote', 'quantidadeReservada'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
