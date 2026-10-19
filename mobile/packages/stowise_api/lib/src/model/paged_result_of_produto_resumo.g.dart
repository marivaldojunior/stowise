// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_produto_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfProdutoResumo extends PagedResultOfProdutoResumo {
  @override
  final BuiltList<ProdutoResumo> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfProdutoResumo([void Function(PagedResultOfProdutoResumoBuilder)? updates]) =>
      (PagedResultOfProdutoResumoBuilder()..update(updates))._build();

  _$PagedResultOfProdutoResumo._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfProdutoResumo rebuild(void Function(PagedResultOfProdutoResumoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfProdutoResumoBuilder toBuilder() => PagedResultOfProdutoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfProdutoResumo &&
        itens == other.itens &&
        pagina == other.pagina &&
        tamanhoPagina == other.tamanhoPagina &&
        total == other.total &&
        totalPaginas == other.totalPaginas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jc(_$hash, pagina.hashCode);
    _$hash = $jc(_$hash, tamanhoPagina.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, totalPaginas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PagedResultOfProdutoResumo')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfProdutoResumoBuilder
    implements Builder<PagedResultOfProdutoResumo, PagedResultOfProdutoResumoBuilder> {
  _$PagedResultOfProdutoResumo? _$v;

  ListBuilder<ProdutoResumo>? _itens;
  ListBuilder<ProdutoResumo> get itens => _$this._itens ??= ListBuilder<ProdutoResumo>();
  set itens(ListBuilder<ProdutoResumo>? itens) => _$this._itens = itens;

  int? _pagina;
  int? get pagina => _$this._pagina;
  set pagina(int? pagina) => _$this._pagina = pagina;

  int? _tamanhoPagina;
  int? get tamanhoPagina => _$this._tamanhoPagina;
  set tamanhoPagina(int? tamanhoPagina) => _$this._tamanhoPagina = tamanhoPagina;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _totalPaginas;
  int? get totalPaginas => _$this._totalPaginas;
  set totalPaginas(int? totalPaginas) => _$this._totalPaginas = totalPaginas;

  PagedResultOfProdutoResumoBuilder() {
    PagedResultOfProdutoResumo._defaults(this);
  }

  PagedResultOfProdutoResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itens = $v.itens.toBuilder();
      _pagina = $v.pagina;
      _tamanhoPagina = $v.tamanhoPagina;
      _total = $v.total;
      _totalPaginas = $v.totalPaginas;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PagedResultOfProdutoResumo other) {
    _$v = other as _$PagedResultOfProdutoResumo;
  }

  @override
  void update(void Function(PagedResultOfProdutoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfProdutoResumo build() => _build();

  _$PagedResultOfProdutoResumo _build() {
    _$PagedResultOfProdutoResumo _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfProdutoResumo._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfProdutoResumo', 'pagina'),
            tamanhoPagina:
                BuiltValueNullFieldError.checkNotNull(tamanhoPagina, r'PagedResultOfProdutoResumo', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfProdutoResumo', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfProdutoResumo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
