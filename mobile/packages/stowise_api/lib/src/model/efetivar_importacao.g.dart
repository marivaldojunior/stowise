// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efetivar_importacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EfetivarImportacao extends EfetivarImportacao {
  @override
  final int? versao;

  factory _$EfetivarImportacao([void Function(EfetivarImportacaoBuilder)? updates]) =>
      (EfetivarImportacaoBuilder()..update(updates))._build();

  _$EfetivarImportacao._({this.versao}) : super._();
  @override
  EfetivarImportacao rebuild(void Function(EfetivarImportacaoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EfetivarImportacaoBuilder toBuilder() => EfetivarImportacaoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EfetivarImportacao && versao == other.versao;
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
    return (newBuiltValueToStringHelper(r'EfetivarImportacao')..add('versao', versao)).toString();
  }
}

class EfetivarImportacaoBuilder implements Builder<EfetivarImportacao, EfetivarImportacaoBuilder> {
  _$EfetivarImportacao? _$v;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  EfetivarImportacaoBuilder() {
    EfetivarImportacao._defaults(this);
  }

  EfetivarImportacaoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EfetivarImportacao other) {
    _$v = other as _$EfetivarImportacao;
  }

  @override
  void update(void Function(EfetivarImportacaoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EfetivarImportacao build() => _build();

  _$EfetivarImportacao _build() {
    final _$result = _$v ??
        _$EfetivarImportacao._(
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
