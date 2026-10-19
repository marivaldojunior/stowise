// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_importacao_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfImportacaoResumo extends PagedResultOfImportacaoResumo {
  @override
  final BuiltList<ImportacaoResumo> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfImportacaoResumo([void Function(PagedResultOfImportacaoResumoBuilder)? updates]) =>
      (PagedResultOfImportacaoResumoBuilder()..update(updates))._build();

  _$PagedResultOfImportacaoResumo._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfImportacaoResumo rebuild(void Function(PagedResultOfImportacaoResumoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfImportacaoResumoBuilder toBuilder() => PagedResultOfImportacaoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfImportacaoResumo &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfImportacaoResumo')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfImportacaoResumoBuilder
    implements Builder<PagedResultOfImportacaoResumo, PagedResultOfImportacaoResumoBuilder> {
  _$PagedResultOfImportacaoResumo? _$v;

  ListBuilder<ImportacaoResumo>? _itens;
  ListBuilder<ImportacaoResumo> get itens => _$this._itens ??= ListBuilder<ImportacaoResumo>();
  set itens(ListBuilder<ImportacaoResumo>? itens) => _$this._itens = itens;

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

  PagedResultOfImportacaoResumoBuilder() {
    PagedResultOfImportacaoResumo._defaults(this);
  }

  PagedResultOfImportacaoResumoBuilder get _$this {
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
  void replace(PagedResultOfImportacaoResumo other) {
    _$v = other as _$PagedResultOfImportacaoResumo;
  }

  @override
  void update(void Function(PagedResultOfImportacaoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfImportacaoResumo build() => _build();

  _$PagedResultOfImportacaoResumo _build() {
    _$PagedResultOfImportacaoResumo _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfImportacaoResumo._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfImportacaoResumo', 'pagina'),
            tamanhoPagina:
                BuiltValueNullFieldError.checkNotNull(tamanhoPagina, r'PagedResultOfImportacaoResumo', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfImportacaoResumo', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfImportacaoResumo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
