// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sugerir_mapeamento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SugerirMapeamento extends SugerirMapeamento {
  @override
  final int? versao;

  factory _$SugerirMapeamento([void Function(SugerirMapeamentoBuilder)? updates]) =>
      (SugerirMapeamentoBuilder()..update(updates))._build();

  _$SugerirMapeamento._({this.versao}) : super._();
  @override
  SugerirMapeamento rebuild(void Function(SugerirMapeamentoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SugerirMapeamentoBuilder toBuilder() => SugerirMapeamentoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SugerirMapeamento && versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SugerirMapeamento')..add('versao', versao)).toString();
  }
}

class SugerirMapeamentoBuilder implements Builder<SugerirMapeamento, SugerirMapeamentoBuilder> {
  _$SugerirMapeamento? _$v;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  SugerirMapeamentoBuilder() {
    SugerirMapeamento._defaults(this);
  }

  SugerirMapeamentoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SugerirMapeamento other) {
    _$v = other as _$SugerirMapeamento;
  }

  @override
  void update(void Function(SugerirMapeamentoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SugerirMapeamento build() => _build();

  _$SugerirMapeamento _build() {
    final _$result = _$v ??
        _$SugerirMapeamento._(
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
