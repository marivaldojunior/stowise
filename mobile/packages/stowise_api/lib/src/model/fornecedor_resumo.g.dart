// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fornecedor_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FornecedorResumo extends FornecedorResumo {
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

  factory _$FornecedorResumo([void Function(FornecedorResumoBuilder)? updates]) =>
      (FornecedorResumoBuilder()..update(updates))._build();

  _$FornecedorResumo._(
      {required this.id,
      required this.cnpj,
      required this.razaoSocial,
      this.nomeFantasia,
      required this.produtosVinculados})
      : super._();
  @override
  FornecedorResumo rebuild(void Function(FornecedorResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  FornecedorResumoBuilder toBuilder() => FornecedorResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FornecedorResumo &&
        id == other.id &&
        cnpj == other.cnpj &&
        razaoSocial == other.razaoSocial &&
        nomeFantasia == other.nomeFantasia &&
        produtosVinculados == other.produtosVinculados;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cnpj.hashCode);
    _$hash = $jc(_$hash, razaoSocial.hashCode);
    _$hash = $jc(_$hash, nomeFantasia.hashCode);
    _$hash = $jc(_$hash, produtosVinculados.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FornecedorResumo')
          ..add('id', id)
          ..add('cnpj', cnpj)
          ..add('razaoSocial', razaoSocial)
          ..add('nomeFantasia', nomeFantasia)
          ..add('produtosVinculados', produtosVinculados))
        .toString();
  }
}

class FornecedorResumoBuilder implements Builder<FornecedorResumo, FornecedorResumoBuilder> {
  _$FornecedorResumo? _$v;

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

  FornecedorResumoBuilder() {
    FornecedorResumo._defaults(this);
  }

  FornecedorResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cnpj = $v.cnpj;
      _razaoSocial = $v.razaoSocial;
      _nomeFantasia = $v.nomeFantasia;
      _produtosVinculados = $v.produtosVinculados;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FornecedorResumo other) {
    _$v = other as _$FornecedorResumo;
  }

  @override
  void update(void Function(FornecedorResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FornecedorResumo build() => _build();

  _$FornecedorResumo _build() {
    final _$result = _$v ??
        _$FornecedorResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FornecedorResumo', 'id'),
          cnpj: BuiltValueNullFieldError.checkNotNull(cnpj, r'FornecedorResumo', 'cnpj'),
          razaoSocial: BuiltValueNullFieldError.checkNotNull(razaoSocial, r'FornecedorResumo', 'razaoSocial'),
          nomeFantasia: nomeFantasia,
          produtosVinculados:
              BuiltValueNullFieldError.checkNotNull(produtosVinculados, r'FornecedorResumo', 'produtosVinculados'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
