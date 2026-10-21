// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_conferido.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoteConferido extends LoteConferido {
  @override
  final String? numero;
  @override
  final double quantidade;
  @override
  final Date? fabricacao;
  @override
  final Date? validade;

  factory _$LoteConferido([void Function(LoteConferidoBuilder)? updates]) =>
      (LoteConferidoBuilder()..update(updates))._build();

  _$LoteConferido._({this.numero, required this.quantidade, this.fabricacao, this.validade}) : super._();
  @override
  LoteConferido rebuild(void Function(LoteConferidoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoteConferidoBuilder toBuilder() => LoteConferidoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoteConferido &&
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
    return (newBuiltValueToStringHelper(r'LoteConferido')
          ..add('numero', numero)
          ..add('quantidade', quantidade)
          ..add('fabricacao', fabricacao)
          ..add('validade', validade))
        .toString();
  }
}

class LoteConferidoBuilder implements Builder<LoteConferido, LoteConferidoBuilder> {
  _$LoteConferido? _$v;

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

  LoteConferidoBuilder() {
    LoteConferido._defaults(this);
  }

  LoteConferidoBuilder get _$this {
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
  void replace(LoteConferido other) {
    _$v = other as _$LoteConferido;
  }

  @override
  void update(void Function(LoteConferidoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoteConferido build() => _build();

  _$LoteConferido _build() {
    final _$result = _$v ??
        _$LoteConferido._(
          numero: numero,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'LoteConferido', 'quantidade'),
          fabricacao: fabricacao,
          validade: validade,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
