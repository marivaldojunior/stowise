// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoteNota extends LoteNota {
  @override
  final String numero;
  @override
  final double quantidade;
  @override
  final Date? fabricacao;
  @override
  final Date? validade;

  factory _$LoteNota([void Function(LoteNotaBuilder)? updates]) => (LoteNotaBuilder()..update(updates))._build();

  _$LoteNota._({required this.numero, required this.quantidade, this.fabricacao, this.validade}) : super._();
  @override
  LoteNota rebuild(void Function(LoteNotaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoteNotaBuilder toBuilder() => LoteNotaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoteNota &&
        numero == other.numero &&
        quantidade == other.quantidade &&
        fabricacao == other.fabricacao &&
        validade == other.validade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, fabricacao.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoteNota')
          ..add('numero', numero)
          ..add('quantidade', quantidade)
          ..add('fabricacao', fabricacao)
          ..add('validade', validade))
        .toString();
  }
}

class LoteNotaBuilder implements Builder<LoteNota, LoteNotaBuilder> {
  _$LoteNota? _$v;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  Date? _fabricacao;
  Date? get fabricacao => _$this._fabricacao;
  set fabricacao(Date? fabricacao) => _$this._fabricacao = fabricacao;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  LoteNotaBuilder() {
    LoteNota._defaults(this);
  }

  LoteNotaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numero = $v.numero;
      _quantidade = $v.quantidade;
      _fabricacao = $v.fabricacao;
      _validade = $v.validade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoteNota other) {
    _$v = other as _$LoteNota;
  }

  @override
  void update(void Function(LoteNotaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoteNota build() => _build();

  _$LoteNota _build() {
    final _$result = _$v ??
        _$LoteNota._(
          numero: BuiltValueNullFieldError.checkNotNull(numero, r'LoteNota', 'numero'),
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'LoteNota', 'quantidade'),
          fabricacao: fabricacao,
          validade: validade,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
