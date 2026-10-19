// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_saldo_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfSaldoItem extends PagedResultOfSaldoItem {
  @override
  final BuiltList<SaldoItem> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfSaldoItem([void Function(PagedResultOfSaldoItemBuilder)? updates]) =>
      (PagedResultOfSaldoItemBuilder()..update(updates))._build();

  _$PagedResultOfSaldoItem._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfSaldoItem rebuild(void Function(PagedResultOfSaldoItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfSaldoItemBuilder toBuilder() => PagedResultOfSaldoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfSaldoItem &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfSaldoItem')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfSaldoItemBuilder implements Builder<PagedResultOfSaldoItem, PagedResultOfSaldoItemBuilder> {
  _$PagedResultOfSaldoItem? _$v;

  ListBuilder<SaldoItem>? _itens;
  ListBuilder<SaldoItem> get itens => _$this._itens ??= ListBuilder<SaldoItem>();
  set itens(ListBuilder<SaldoItem>? itens) => _$this._itens = itens;

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

  PagedResultOfSaldoItemBuilder() {
    PagedResultOfSaldoItem._defaults(this);
  }

  PagedResultOfSaldoItemBuilder get _$this {
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
  void replace(PagedResultOfSaldoItem other) {
    _$v = other as _$PagedResultOfSaldoItem;
  }

  @override
  void update(void Function(PagedResultOfSaldoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfSaldoItem build() => _build();

  _$PagedResultOfSaldoItem _build() {
    _$PagedResultOfSaldoItem _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfSaldoItem._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfSaldoItem', 'pagina'),
            tamanhoPagina:
                BuiltValueNullFieldError.checkNotNull(tamanhoPagina, r'PagedResultOfSaldoItem', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfSaldoItem', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfSaldoItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
