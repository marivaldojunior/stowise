// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_por_codigo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProdutoPorCodigo extends ProdutoPorCodigo {
  @override
  final ProdutoDetalhe produto;
  @override
  final String embalagemId;

  factory _$ProdutoPorCodigo([void Function(ProdutoPorCodigoBuilder)? updates]) =>
      (ProdutoPorCodigoBuilder()..update(updates))._build();

  _$ProdutoPorCodigo._({required this.produto, required this.embalagemId}) : super._();
  @override
  ProdutoPorCodigo rebuild(void Function(ProdutoPorCodigoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ProdutoPorCodigoBuilder toBuilder() => ProdutoPorCodigoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProdutoPorCodigo && produto == other.produto && embalagemId == other.embalagemId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produto.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProdutoPorCodigo')
          ..add('produto', produto)
          ..add('embalagemId', embalagemId))
        .toString();
  }
}

class ProdutoPorCodigoBuilder implements Builder<ProdutoPorCodigo, ProdutoPorCodigoBuilder> {
  _$ProdutoPorCodigo? _$v;

  ProdutoDetalheBuilder? _produto;
  ProdutoDetalheBuilder get produto => _$this._produto ??= ProdutoDetalheBuilder();
  set produto(ProdutoDetalheBuilder? produto) => _$this._produto = produto;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  ProdutoPorCodigoBuilder() {
    ProdutoPorCodigo._defaults(this);
  }

  ProdutoPorCodigoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produto = $v.produto.toBuilder();
      _embalagemId = $v.embalagemId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProdutoPorCodigo other) {
    _$v = other as _$ProdutoPorCodigo;
  }

  @override
  void update(void Function(ProdutoPorCodigoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProdutoPorCodigo build() => _build();

  _$ProdutoPorCodigo _build() {
    _$ProdutoPorCodigo _$result;
    try {
      _$result = _$v ??
          _$ProdutoPorCodigo._(
            produto: produto.build(),
            embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'ProdutoPorCodigo', 'embalagemId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'produto';
        produto.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ProdutoPorCodigo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
