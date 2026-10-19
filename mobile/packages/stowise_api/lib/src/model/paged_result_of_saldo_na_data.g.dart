// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_saldo_na_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfSaldoNaData extends PagedResultOfSaldoNaData {
  @override
  final BuiltList<SaldoNaData> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfSaldoNaData([void Function(PagedResultOfSaldoNaDataBuilder)? updates]) =>
      (PagedResultOfSaldoNaDataBuilder()..update(updates))._build();

  _$PagedResultOfSaldoNaData._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfSaldoNaData rebuild(void Function(PagedResultOfSaldoNaDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfSaldoNaDataBuilder toBuilder() => PagedResultOfSaldoNaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfSaldoNaData &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfSaldoNaData')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfSaldoNaDataBuilder implements Builder<PagedResultOfSaldoNaData, PagedResultOfSaldoNaDataBuilder> {
  _$PagedResultOfSaldoNaData? _$v;

  ListBuilder<SaldoNaData>? _itens;
  ListBuilder<SaldoNaData> get itens => _$this._itens ??= ListBuilder<SaldoNaData>();
  set itens(ListBuilder<SaldoNaData>? itens) => _$this._itens = itens;

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

  PagedResultOfSaldoNaDataBuilder() {
    PagedResultOfSaldoNaData._defaults(this);
  }

  PagedResultOfSaldoNaDataBuilder get _$this {
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
  void replace(PagedResultOfSaldoNaData other) {
    _$v = other as _$PagedResultOfSaldoNaData;
  }

  @override
  void update(void Function(PagedResultOfSaldoNaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfSaldoNaData build() => _build();

  _$PagedResultOfSaldoNaData _build() {
    _$PagedResultOfSaldoNaData _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfSaldoNaData._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfSaldoNaData', 'pagina'),
            tamanhoPagina:
                BuiltValueNullFieldError.checkNotNull(tamanhoPagina, r'PagedResultOfSaldoNaData', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfSaldoNaData', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfSaldoNaData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
