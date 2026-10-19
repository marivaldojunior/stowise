// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_informado.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoteInformado extends LoteInformado {
  @override
  final String? numero;
  @override
  final Date? fabricacao;
  @override
  final Date? validade;

  factory _$LoteInformado([void Function(LoteInformadoBuilder)? updates]) =>
      (LoteInformadoBuilder()..update(updates))._build();

  _$LoteInformado._({this.numero, this.fabricacao, this.validade}) : super._();
  @override
  LoteInformado rebuild(void Function(LoteInformadoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoteInformadoBuilder toBuilder() => LoteInformadoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoteInformado &&
        numero == other.numero &&
        fabricacao == other.fabricacao &&
        validade == other.validade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, fabricacao.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoteInformado')
          ..add('numero', numero)
          ..add('fabricacao', fabricacao)
          ..add('validade', validade))
        .toString();
  }
}

class LoteInformadoBuilder implements Builder<LoteInformado, LoteInformadoBuilder> {
  _$LoteInformado? _$v;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  Date? _fabricacao;
  Date? get fabricacao => _$this._fabricacao;
  set fabricacao(Date? fabricacao) => _$this._fabricacao = fabricacao;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  LoteInformadoBuilder() {
    LoteInformado._defaults(this);
  }

  LoteInformadoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numero = $v.numero;
      _fabricacao = $v.fabricacao;
      _validade = $v.validade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoteInformado other) {
    _$v = other as _$LoteInformado;
  }

  @override
  void update(void Function(LoteInformadoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoteInformado build() => _build();

  _$LoteInformado _build() {
    final _$result = _$v ??
        _$LoteInformado._(
          numero: numero,
          fabricacao: fabricacao,
          validade: validade,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
