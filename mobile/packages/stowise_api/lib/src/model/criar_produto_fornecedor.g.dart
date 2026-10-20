// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_produto_fornecedor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarProdutoFornecedor extends CriarProdutoFornecedor {
  @override
  final String? codigoFornecedor;
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final String? unidadeFornecedor;
  @override
  final double? fatorConversao;

  factory _$CriarProdutoFornecedor([void Function(CriarProdutoFornecedorBuilder)? updates]) =>
      (CriarProdutoFornecedorBuilder()..update(updates))._build();

  _$CriarProdutoFornecedor._(
      {this.codigoFornecedor, this.produtoId, this.embalagemId, this.unidadeFornecedor, this.fatorConversao})
      : super._();
  @override
  CriarProdutoFornecedor rebuild(void Function(CriarProdutoFornecedorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CriarProdutoFornecedorBuilder toBuilder() => CriarProdutoFornecedorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarProdutoFornecedor &&
        codigoFornecedor == other.codigoFornecedor &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        unidadeFornecedor == other.unidadeFornecedor &&
        fatorConversao == other.fatorConversao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codigoFornecedor.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, unidadeFornecedor.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarProdutoFornecedor')
          ..add('codigoFornecedor', codigoFornecedor)
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('unidadeFornecedor', unidadeFornecedor)
          ..add('fatorConversao', fatorConversao))
        .toString();
  }
}

class CriarProdutoFornecedorBuilder implements Builder<CriarProdutoFornecedor, CriarProdutoFornecedorBuilder> {
  _$CriarProdutoFornecedor? _$v;

  String? _codigoFornecedor;
  String? get codigoFornecedor => _$this._codigoFornecedor;
  set codigoFornecedor(String? codigoFornecedor) => _$this._codigoFornecedor = codigoFornecedor;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _unidadeFornecedor;
  String? get unidadeFornecedor => _$this._unidadeFornecedor;
  set unidadeFornecedor(String? unidadeFornecedor) => _$this._unidadeFornecedor = unidadeFornecedor;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  CriarProdutoFornecedorBuilder() {
    CriarProdutoFornecedor._defaults(this);
  }

  CriarProdutoFornecedorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codigoFornecedor = $v.codigoFornecedor;
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _unidadeFornecedor = $v.unidadeFornecedor;
      _fatorConversao = $v.fatorConversao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarProdutoFornecedor other) {
    _$v = other as _$CriarProdutoFornecedor;
  }

  @override
  void update(void Function(CriarProdutoFornecedorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarProdutoFornecedor build() => _build();

  _$CriarProdutoFornecedor _build() {
    final _$result = _$v ??
        _$CriarProdutoFornecedor._(
          codigoFornecedor: codigoFornecedor,
          produtoId: produtoId,
          embalagemId: embalagemId,
          unidadeFornecedor: unidadeFornecedor,
          fatorConversao: fatorConversao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
