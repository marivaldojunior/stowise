// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_fornecedor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarFornecedor extends CriarFornecedor {
  @override
  final String? cnpj;
  @override
  final String? razaoSocial;
  @override
  final String? nomeFantasia;

  factory _$CriarFornecedor([void Function(CriarFornecedorBuilder)? updates]) =>
      (CriarFornecedorBuilder()..update(updates))._build();

  _$CriarFornecedor._({this.cnpj, this.razaoSocial, this.nomeFantasia}) : super._();
  @override
  CriarFornecedor rebuild(void Function(CriarFornecedorBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CriarFornecedorBuilder toBuilder() => CriarFornecedorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarFornecedor &&
        cnpj == other.cnpj &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cnpj.hashCode);
    _$hash = $jc(_$hash, razaoSocial.hashCode);
    _$hash = $jc(_$hash, nomeFantasia.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarFornecedor')
          ..add('cnpj', cnpj)
          ..add('razaoSocial', razaoSocial)
          ..add('nomeFantasia', nomeFantasia))
        .toString();
  }
}

class CriarFornecedorBuilder implements Builder<CriarFornecedor, CriarFornecedorBuilder> {
  _$CriarFornecedor? _$v;

  String? _cnpj;
  String? get cnpj => _$this._cnpj;
  set cnpj(String? cnpj) => _$this._cnpj = cnpj;

  String? _razaoSocial;
  String? get razaoSocial => _$this._razaoSocial;
  set razaoSocial(String? razaoSocial) => _$this._razaoSocial = razaoSocial;

  String? _nomeFantasia;
  String? get nomeFantasia => _$this._nomeFantasia;
  set nomeFantasia(String? nomeFantasia) => _$this._nomeFantasia = nomeFantasia;

  CriarFornecedorBuilder() {
    CriarFornecedor._defaults(this);
  }

  CriarFornecedorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cnpj = $v.cnpj;
      _razaoSocial = $v.razaoSocial;
      _nomeFantasia = $v.nomeFantasia;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarFornecedor other) {
    _$v = other as _$CriarFornecedor;
  }

  @override
  void update(void Function(CriarFornecedorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarFornecedor build() => _build();

  _$CriarFornecedor _build() {
    final _$result = _$v ??
        _$CriarFornecedor._(
          cnpj: cnpj,
          razaoSocial: razaoSocial,
          nomeFantasia: nomeFantasia,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
