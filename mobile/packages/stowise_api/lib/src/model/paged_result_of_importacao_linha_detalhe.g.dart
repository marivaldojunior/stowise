// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_importacao_linha_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfImportacaoLinhaDetalhe extends PagedResultOfImportacaoLinhaDetalhe {
  @override
  final BuiltList<ImportacaoLinhaDetalhe> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfImportacaoLinhaDetalhe([void Function(PagedResultOfImportacaoLinhaDetalheBuilder)? updates]) =>
      (PagedResultOfImportacaoLinhaDetalheBuilder()..update(updates))._build();

  _$PagedResultOfImportacaoLinhaDetalhe._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfImportacaoLinhaDetalhe rebuild(void Function(PagedResultOfImportacaoLinhaDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfImportacaoLinhaDetalheBuilder toBuilder() => PagedResultOfImportacaoLinhaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfImportacaoLinhaDetalhe &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfImportacaoLinhaDetalhe')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfImportacaoLinhaDetalheBuilder
    implements Builder<PagedResultOfImportacaoLinhaDetalhe, PagedResultOfImportacaoLinhaDetalheBuilder> {
  _$PagedResultOfImportacaoLinhaDetalhe? _$v;

  ListBuilder<ImportacaoLinhaDetalhe>? _itens;
  ListBuilder<ImportacaoLinhaDetalhe> get itens => _$this._itens ??= ListBuilder<ImportacaoLinhaDetalhe>();
  set itens(ListBuilder<ImportacaoLinhaDetalhe>? itens) => _$this._itens = itens;

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

  PagedResultOfImportacaoLinhaDetalheBuilder() {
    PagedResultOfImportacaoLinhaDetalhe._defaults(this);
  }

  PagedResultOfImportacaoLinhaDetalheBuilder get _$this {
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
  void replace(PagedResultOfImportacaoLinhaDetalhe other) {
    _$v = other as _$PagedResultOfImportacaoLinhaDetalhe;
  }

  @override
  void update(void Function(PagedResultOfImportacaoLinhaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfImportacaoLinhaDetalhe build() => _build();

  _$PagedResultOfImportacaoLinhaDetalhe _build() {
    _$PagedResultOfImportacaoLinhaDetalhe _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfImportacaoLinhaDetalhe._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfImportacaoLinhaDetalhe', 'pagina'),
            tamanhoPagina: BuiltValueNullFieldError.checkNotNull(
                tamanhoPagina, r'PagedResultOfImportacaoLinhaDetalhe', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfImportacaoLinhaDetalhe', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfImportacaoLinhaDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
