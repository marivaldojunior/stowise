// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_recebido.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoteRecebido extends LoteRecebido {
  @override
  final String numero;
  @override
  final double quantidadeBase;
  @override
  final Date? fabricacao;
  @override
  final Date? validade;

  factory _$LoteRecebido([void Function(LoteRecebidoBuilder)? updates]) =>
      (LoteRecebidoBuilder()..update(updates))._build();

  _$LoteRecebido._({required this.numero, required this.quantidadeBase, this.fabricacao, this.validade}) : super._();
  @override
  LoteRecebido rebuild(void Function(LoteRecebidoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoteRecebidoBuilder toBuilder() => LoteRecebidoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoteRecebido &&
        numero == other.numero &&
        quantidadeBase == other.quantidadeBase &&
        fabricacao == other.fabricacao &&
        validade == other.validade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, quantidadeBase.hashCode);
    _$hash = $jc(_$hash, fabricacao.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoteRecebido')
          ..add('numero', numero)
          ..add('quantidadeBase', quantidadeBase)
          ..add('fabricacao', fabricacao)
          ..add('validade', validade))
        .toString();
  }
}

class LoteRecebidoBuilder implements Builder<LoteRecebido, LoteRecebidoBuilder> {
  _$LoteRecebido? _$v;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  double? _quantidadeBase;
  double? get quantidadeBase => _$this._quantidadeBase;
  set quantidadeBase(double? quantidadeBase) => _$this._quantidadeBase = quantidadeBase;

  Date? _fabricacao;
  Date? get fabricacao => _$this._fabricacao;
  set fabricacao(Date? fabricacao) => _$this._fabricacao = fabricacao;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  LoteRecebidoBuilder() {
    LoteRecebido._defaults(this);
  }

  LoteRecebidoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numero = $v.numero;
      _quantidadeBase = $v.quantidadeBase;
      _fabricacao = $v.fabricacao;
      _validade = $v.validade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoteRecebido other) {
    _$v = other as _$LoteRecebido;
  }

  @override
  void update(void Function(LoteRecebidoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoteRecebido build() => _build();

  _$LoteRecebido _build() {
    final _$result = _$v ??
        _$LoteRecebido._(
          numero: BuiltValueNullFieldError.checkNotNull(numero, r'LoteRecebido', 'numero'),
          quantidadeBase: BuiltValueNullFieldError.checkNotNull(quantidadeBase, r'LoteRecebido', 'quantidadeBase'),
          fabricacao: fabricacao,
          validade: validade,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
