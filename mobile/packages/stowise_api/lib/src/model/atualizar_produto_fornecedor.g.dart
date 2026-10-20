// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto_fornecedor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AtualizarProdutoFornecedor extends AtualizarProdutoFornecedor {
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final String? unidadeFornecedor;
  @override
  final double? fatorConversao;
  @override
  final int? versao;

  factory _$AtualizarProdutoFornecedor([void Function(AtualizarProdutoFornecedorBuilder)? updates]) =>
      (AtualizarProdutoFornecedorBuilder()..update(updates))._build();

  _$AtualizarProdutoFornecedor._(
      {this.produtoId, this.embalagemId, this.unidadeFornecedor, this.fatorConversao, this.versao})
      : super._();
  @override
  AtualizarProdutoFornecedor rebuild(void Function(AtualizarProdutoFornecedorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AtualizarProdutoFornecedorBuilder toBuilder() => AtualizarProdutoFornecedorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AtualizarProdutoFornecedor &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        unidadeFornecedor == other.unidadeFornecedor &&
        fatorConversao == other.fatorConversao &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, unidadeFornecedor.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AtualizarProdutoFornecedor')
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('unidadeFornecedor', unidadeFornecedor)
          ..add('fatorConversao', fatorConversao)
          ..add('versao', versao))
        .toString();
  }
}

class AtualizarProdutoFornecedorBuilder
    implements Builder<AtualizarProdutoFornecedor, AtualizarProdutoFornecedorBuilder> {
  _$AtualizarProdutoFornecedor? _$v;

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

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AtualizarProdutoFornecedorBuilder() {
    AtualizarProdutoFornecedor._defaults(this);
  }

  AtualizarProdutoFornecedorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _unidadeFornecedor = $v.unidadeFornecedor;
      _fatorConversao = $v.fatorConversao;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AtualizarProdutoFornecedor other) {
    _$v = other as _$AtualizarProdutoFornecedor;
  }

  @override
  void update(void Function(AtualizarProdutoFornecedorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AtualizarProdutoFornecedor build() => _build();

  _$AtualizarProdutoFornecedor _build() {
    final _$result = _$v ??
        _$AtualizarProdutoFornecedor._(
          produtoId: produtoId,
          embalagemId: embalagemId,
          unidadeFornecedor: unidadeFornecedor,
          fatorConversao: fatorConversao,
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
