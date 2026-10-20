// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_fornecedor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AtualizarFornecedor extends AtualizarFornecedor {
  @override
  final String? razaoSocial;
  @override
  final String? nomeFantasia;
  @override
  final int? versao;

  factory _$AtualizarFornecedor([void Function(AtualizarFornecedorBuilder)? updates]) =>
      (AtualizarFornecedorBuilder()..update(updates))._build();

  _$AtualizarFornecedor._({this.razaoSocial, this.nomeFantasia, this.versao}) : super._();
  @override
  AtualizarFornecedor rebuild(void Function(AtualizarFornecedorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AtualizarFornecedorBuilder toBuilder() => AtualizarFornecedorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AtualizarFornecedor &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, razaoSocial.hashCode);
    _$hash = $jc(_$hash, nomeFantasia.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AtualizarFornecedor')
          ..add('razaoSocial', razaoSocial)
          ..add('nomeFantasia', nomeFantasia)
          ..add('versao', versao))
        .toString();
  }
}

class AtualizarFornecedorBuilder implements Builder<AtualizarFornecedor, AtualizarFornecedorBuilder> {
  _$AtualizarFornecedor? _$v;

  String? _razaoSocial;
  String? get razaoSocial => _$this._razaoSocial;
  set razaoSocial(String? razaoSocial) => _$this._razaoSocial = razaoSocial;

  String? _nomeFantasia;
  String? get nomeFantasia => _$this._nomeFantasia;
  set nomeFantasia(String? nomeFantasia) => _$this._nomeFantasia = nomeFantasia;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AtualizarFornecedorBuilder() {
    AtualizarFornecedor._defaults(this);
  }

  AtualizarFornecedorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _razaoSocial = $v.razaoSocial;
      _nomeFantasia = $v.nomeFantasia;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AtualizarFornecedor other) {
    _$v = other as _$AtualizarFornecedor;
  }

  @override
  void update(void Function(AtualizarFornecedorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AtualizarFornecedor build() => _build();

  _$AtualizarFornecedor _build() {
    final _$result = _$v ??
        _$AtualizarFornecedor._(
          razaoSocial: razaoSocial,
          nomeFantasia: nomeFantasia,
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
