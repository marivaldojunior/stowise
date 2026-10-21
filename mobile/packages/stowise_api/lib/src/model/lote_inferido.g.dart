// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_inferido.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoteInferido extends LoteInferido {
  @override
  final String numero;
  @override
  final double quantidadeNota;
  @override
  final double? quantidadeBase;
  @override
  final Date? fabricacao;
  @override
  final Date? validade;

  factory _$LoteInferido([void Function(LoteInferidoBuilder)? updates]) =>
      (LoteInferidoBuilder()..update(updates))._build();

  _$LoteInferido._(
      {required this.numero, required this.quantidadeNota, this.quantidadeBase, this.fabricacao, this.validade})
      : super._();
  @override
  LoteInferido rebuild(void Function(LoteInferidoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoteInferidoBuilder toBuilder() => LoteInferidoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoteInferido &&
        numero == other.numero &&
        quantidadeNota == other.quantidadeNota &&
        quantidadeBase == other.quantidadeBase &&
        fabricacao == other.fabricacao &&
        validade == other.validade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, quantidadeNota.hashCode);
    _$hash = $jc(_$hash, quantidadeBase.hashCode);
    _$hash = $jc(_$hash, fabricacao.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoteInferido')
          ..add('numero', numero)
          ..add('quantidadeNota', quantidadeNota)
          ..add('quantidadeBase', quantidadeBase)
          ..add('fabricacao', fabricacao)
          ..add('validade', validade))
        .toString();
  }
}

class LoteInferidoBuilder implements Builder<LoteInferido, LoteInferidoBuilder> {
  _$LoteInferido? _$v;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  double? _quantidadeNota;
  double? get quantidadeNota => _$this._quantidadeNota;
  set quantidadeNota(double? quantidadeNota) => _$this._quantidadeNota = quantidadeNota;

  double? _quantidadeBase;
  double? get quantidadeBase => _$this._quantidadeBase;
  set quantidadeBase(double? quantidadeBase) => _$this._quantidadeBase = quantidadeBase;

  Date? _fabricacao;
  Date? get fabricacao => _$this._fabricacao;
  set fabricacao(Date? fabricacao) => _$this._fabricacao = fabricacao;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  LoteInferidoBuilder() {
    LoteInferido._defaults(this);
  }

  LoteInferidoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numero = $v.numero;
      _quantidadeNota = $v.quantidadeNota;
      _quantidadeBase = $v.quantidadeBase;
      _fabricacao = $v.fabricacao;
      _validade = $v.validade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoteInferido other) {
    _$v = other as _$LoteInferido;
  }

  @override
  void update(void Function(LoteInferidoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoteInferido build() => _build();

  _$LoteInferido _build() {
    final _$result = _$v ??
        _$LoteInferido._(
          numero: BuiltValueNullFieldError.checkNotNull(numero, r'LoteInferido', 'numero'),
          quantidadeNota: BuiltValueNullFieldError.checkNotNull(quantidadeNota, r'LoteInferido', 'quantidadeNota'),
          quantidadeBase: quantidadeBase,
          fabricacao: fabricacao,
          validade: validade,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
