// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produtos_similares.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProdutosSimilares extends ProdutosSimilares {
  @override
  final MetodoSimilaridade metodo;
  @override
  final BuiltList<ProdutoSimilar> produtos;

  factory _$ProdutosSimilares([void Function(ProdutosSimilaresBuilder)? updates]) =>
      (ProdutosSimilaresBuilder()..update(updates))._build();

  _$ProdutosSimilares._({required this.metodo, required this.produtos}) : super._();
  @override
  ProdutosSimilares rebuild(void Function(ProdutosSimilaresBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ProdutosSimilaresBuilder toBuilder() => ProdutosSimilaresBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProdutosSimilares && metodo == other.metodo && produtos == other.produtos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metodo.hashCode);
    _$hash = $jc(_$hash, produtos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProdutosSimilares')
          ..add('metodo', metodo)
          ..add('produtos', produtos))
        .toString();
  }
}

class ProdutosSimilaresBuilder implements Builder<ProdutosSimilares, ProdutosSimilaresBuilder> {
  _$ProdutosSimilares? _$v;

  MetodoSimilaridade? _metodo;
  MetodoSimilaridade? get metodo => _$this._metodo;
  set metodo(MetodoSimilaridade? metodo) => _$this._metodo = metodo;

  ListBuilder<ProdutoSimilar>? _produtos;
  ListBuilder<ProdutoSimilar> get produtos => _$this._produtos ??= ListBuilder<ProdutoSimilar>();
  set produtos(ListBuilder<ProdutoSimilar>? produtos) => _$this._produtos = produtos;

  ProdutosSimilaresBuilder() {
    ProdutosSimilares._defaults(this);
  }

  ProdutosSimilaresBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metodo = $v.metodo;
      _produtos = $v.produtos.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProdutosSimilares other) {
    _$v = other as _$ProdutosSimilares;
  }

  @override
  void update(void Function(ProdutosSimilaresBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProdutosSimilares build() => _build();

  _$ProdutosSimilares _build() {
    _$ProdutosSimilares _$result;
    try {
      _$result = _$v ??
          _$ProdutosSimilares._(
            metodo: BuiltValueNullFieldError.checkNotNull(metodo, r'ProdutosSimilares', 'metodo'),
            produtos: produtos.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'produtos';
        produtos.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ProdutosSimilares', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
