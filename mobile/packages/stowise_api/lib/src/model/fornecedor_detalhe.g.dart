// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fornecedor_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FornecedorDetalhe extends FornecedorDetalhe {
  @override
  final String id;
  @override
  final String cnpj;
  @override
  final String razaoSocial;
  @override
  final String? nomeFantasia;
  @override
  final int produtosVinculados;
  @override
  final int versao;

  factory _$FornecedorDetalhe([void Function(FornecedorDetalheBuilder)? updates]) =>
      (FornecedorDetalheBuilder()..update(updates))._build();

  _$FornecedorDetalhe._(
      {required this.id,
      required this.cnpj,
      required this.razaoSocial,
      this.nomeFantasia,
      required this.produtosVinculados,
      required this.versao})
      : super._();
  @override
  FornecedorDetalhe rebuild(void Function(FornecedorDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  FornecedorDetalheBuilder toBuilder() => FornecedorDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FornecedorDetalhe &&
        id == other.id &&
        cnpj == other.cnpj &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia &&
        produtosVinculados == other.produtosVinculados &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cnpj.hashCode);
    _$hash = $jc(_$hash, razaoSocial.hashCode);
    _$hash = $jc(_$hash, nomeFantasia.hashCode);
    _$hash = $jc(_$hash, produtosVinculados.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FornecedorDetalhe')
          ..add('id', id)
          ..add('cnpj', cnpj)
          ..add('razaoSocial', razaoSocial)
          ..add('nomeFantasia', nomeFantasia)
          ..add('produtosVinculados', produtosVinculados)
          ..add('versao', versao))
        .toString();
  }
}

class FornecedorDetalheBuilder implements Builder<FornecedorDetalhe, FornecedorDetalheBuilder> {
  _$FornecedorDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cnpj;
  String? get cnpj => _$this._cnpj;
  set cnpj(String? cnpj) => _$this._cnpj = cnpj;

  String? _razaoSocial;
  String? get razaoSocial => _$this._razaoSocial;
  set razaoSocial(String? razaoSocial) => _$this._razaoSocial = razaoSocial;

  String? _nomeFantasia;
  String? get nomeFantasia => _$this._nomeFantasia;
  set nomeFantasia(String? nomeFantasia) => _$this._nomeFantasia = nomeFantasia;

  int? _produtosVinculados;
  int? get produtosVinculados => _$this._produtosVinculados;
  set produtosVinculados(int? produtosVinculados) => _$this._produtosVinculados = produtosVinculados;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  FornecedorDetalheBuilder() {
    FornecedorDetalhe._defaults(this);
  }

  FornecedorDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cnpj = $v.cnpj;
      _razaoSocial = $v.razaoSocial;
      _nomeFantasia = $v.nomeFantasia;
      _produtosVinculados = $v.produtosVinculados;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FornecedorDetalhe other) {
    _$v = other as _$FornecedorDetalhe;
  }

  @override
  void update(void Function(FornecedorDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FornecedorDetalhe build() => _build();

  _$FornecedorDetalhe _build() {
    final _$result = _$v ??
        _$FornecedorDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FornecedorDetalhe', 'id'),
          cnpj: BuiltValueNullFieldError.checkNotNull(cnpj, r'FornecedorDetalhe', 'cnpj'),
          razaoSocial: BuiltValueNullFieldError.checkNotNull(razaoSocial, r'FornecedorDetalhe', 'razaoSocial'),
          nomeFantasia: nomeFantasia,
          produtosVinculados:
              BuiltValueNullFieldError.checkNotNull(produtosVinculados, r'FornecedorDetalhe', 'produtosVinculados'),
          versao: BuiltValueNullFieldError.checkNotNull(versao, r'FornecedorDetalhe', 'versao'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
