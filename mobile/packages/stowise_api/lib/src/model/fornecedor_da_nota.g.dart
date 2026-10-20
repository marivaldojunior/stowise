// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fornecedor_da_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FornecedorDaNota extends FornecedorDaNota {
  @override
  final String? fornecedorId;
  @override
  final String? cnpj;
  @override
  final String? cpf;
  @override
  final String razaoSocial;
  @override
  final String? nomeFantasia;

  factory _$FornecedorDaNota([void Function(FornecedorDaNotaBuilder)? updates]) =>
      (FornecedorDaNotaBuilder()..update(updates))._build();

  _$FornecedorDaNota._({this.fornecedorId, this.cnpj, this.cpf, required this.razaoSocial, this.nomeFantasia})
      : super._();
  @override
  FornecedorDaNota rebuild(void Function(FornecedorDaNotaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  FornecedorDaNotaBuilder toBuilder() => FornecedorDaNotaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FornecedorDaNota &&
        fornecedorId == other.fornecedorId &&
        cnpj == other.cnpj &&
        cpf == other.cpf &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fornecedorId.hashCode);
    _$hash = $jc(_$hash, cnpj.hashCode);
    _$hash = $jc(_$hash, cpf.hashCode);
    _$hash = $jc(_$hash, razaoSocial.hashCode);
    _$hash = $jc(_$hash, nomeFantasia.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FornecedorDaNota')
          ..add('fornecedorId', fornecedorId)
          ..add('cnpj', cnpj)
          ..add('cpf', cpf)
          ..add('razaoSocial', razaoSocial)
          ..add('nomeFantasia', nomeFantasia))
        .toString();
  }
}

class FornecedorDaNotaBuilder implements Builder<FornecedorDaNota, FornecedorDaNotaBuilder> {
  _$FornecedorDaNota? _$v;

  String? _fornecedorId;
  String? get fornecedorId => _$this._fornecedorId;
  set fornecedorId(String? fornecedorId) => _$this._fornecedorId = fornecedorId;

  String? _cnpj;
  String? get cnpj => _$this._cnpj;
  set cnpj(String? cnpj) => _$this._cnpj = cnpj;

  String? _cpf;
  String? get cpf => _$this._cpf;
  set cpf(String? cpf) => _$this._cpf = cpf;

  String? _razaoSocial;
  String? get razaoSocial => _$this._razaoSocial;
  set razaoSocial(String? razaoSocial) => _$this._razaoSocial = razaoSocial;

  String? _nomeFantasia;
  String? get nomeFantasia => _$this._nomeFantasia;
  set nomeFantasia(String? nomeFantasia) => _$this._nomeFantasia = nomeFantasia;

  FornecedorDaNotaBuilder() {
    FornecedorDaNota._defaults(this);
  }

  FornecedorDaNotaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fornecedorId = $v.fornecedorId;
      _cnpj = $v.cnpj;
      _cpf = $v.cpf;
      _razaoSocial = $v.razaoSocial;
      _nomeFantasia = $v.nomeFantasia;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FornecedorDaNota other) {
    _$v = other as _$FornecedorDaNota;
  }

  @override
  void update(void Function(FornecedorDaNotaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FornecedorDaNota build() => _build();

  _$FornecedorDaNota _build() {
    final _$result = _$v ??
        _$FornecedorDaNota._(
          fornecedorId: fornecedorId,
          cnpj: cnpj,
          cpf: cpf,
          razaoSocial: BuiltValueNullFieldError.checkNotNull(razaoSocial, r'FornecedorDaNota', 'razaoSocial'),
          nomeFantasia: nomeFantasia,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
