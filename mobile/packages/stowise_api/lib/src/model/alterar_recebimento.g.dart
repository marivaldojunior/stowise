// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alterar_recebimento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlterarRecebimento extends AlterarRecebimento {
  @override
  final int? versao;

  factory _$AlterarRecebimento([void Function(AlterarRecebimentoBuilder)? updates]) =>
      (AlterarRecebimentoBuilder()..update(updates))._build();

  _$AlterarRecebimento._({this.versao}) : super._();
  @override
  AlterarRecebimento rebuild(void Function(AlterarRecebimentoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlterarRecebimentoBuilder toBuilder() => AlterarRecebimentoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlterarRecebimento && versao == other.versao;
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
    return (newBuiltValueToStringHelper(r'AlterarRecebimento')..add('versao', versao)).toString();
  }
}

class AlterarRecebimentoBuilder implements Builder<AlterarRecebimento, AlterarRecebimentoBuilder> {
  _$AlterarRecebimento? _$v;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AlterarRecebimentoBuilder() {
    AlterarRecebimento._defaults(this);
  }

  AlterarRecebimentoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlterarRecebimento other) {
    _$v = other as _$AlterarRecebimento;
  }

  @override
  void update(void Function(AlterarRecebimentoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlterarRecebimento build() => _build();

  _$AlterarRecebimento _build() {
    final _$result = _$v ??
        _$AlterarRecebimento._(
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
