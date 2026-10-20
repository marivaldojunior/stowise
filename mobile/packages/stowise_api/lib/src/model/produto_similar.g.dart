// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_similar.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProdutoSimilar extends ProdutoSimilar {
  @override
  final String id;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final double pontuacao;

  factory _$ProdutoSimilar([void Function(ProdutoSimilarBuilder)? updates]) =>
      (ProdutoSimilarBuilder()..update(updates))._build();

  _$ProdutoSimilar._(
      {required this.id,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.pontuacao})
      : super._();
  @override
  ProdutoSimilar rebuild(void Function(ProdutoSimilarBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ProdutoSimilarBuilder toBuilder() => ProdutoSimilarBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProdutoSimilar &&
        id == other.id &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        pontuacao == other.pontuacao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, pontuacao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProdutoSimilar')
          ..add('id', id)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('pontuacao', pontuacao))
        .toString();
  }
}

class ProdutoSimilarBuilder implements Builder<ProdutoSimilar, ProdutoSimilarBuilder> {
  _$ProdutoSimilar? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  double? _pontuacao;
  double? get pontuacao => _$this._pontuacao;
  set pontuacao(double? pontuacao) => _$this._pontuacao = pontuacao;

  ProdutoSimilarBuilder() {
    ProdutoSimilar._defaults(this);
  }

  ProdutoSimilarBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _pontuacao = $v.pontuacao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProdutoSimilar other) {
    _$v = other as _$ProdutoSimilar;
  }

  @override
  void update(void Function(ProdutoSimilarBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProdutoSimilar build() => _build();

  _$ProdutoSimilar _build() {
    final _$result = _$v ??
        _$ProdutoSimilar._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProdutoSimilar', 'id'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'ProdutoSimilar', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ProdutoSimilar', 'descricao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'ProdutoSimilar', 'unidadeBase'),
          pontuacao: BuiltValueNullFieldError.checkNotNull(pontuacao, r'ProdutoSimilar', 'pontuacao'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
