// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_chamada_ia_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfChamadaIaDetalhe extends PagedResultOfChamadaIaDetalhe {
  @override
  final BuiltList<ChamadaIaDetalhe> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfChamadaIaDetalhe([void Function(PagedResultOfChamadaIaDetalheBuilder)? updates]) =>
      (PagedResultOfChamadaIaDetalheBuilder()..update(updates))._build();

  _$PagedResultOfChamadaIaDetalhe._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfChamadaIaDetalhe rebuild(void Function(PagedResultOfChamadaIaDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfChamadaIaDetalheBuilder toBuilder() => PagedResultOfChamadaIaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfChamadaIaDetalhe &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfChamadaIaDetalhe')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfChamadaIaDetalheBuilder
    implements Builder<PagedResultOfChamadaIaDetalhe, PagedResultOfChamadaIaDetalheBuilder> {
  _$PagedResultOfChamadaIaDetalhe? _$v;

  ListBuilder<ChamadaIaDetalhe>? _itens;
  ListBuilder<ChamadaIaDetalhe> get itens => _$this._itens ??= ListBuilder<ChamadaIaDetalhe>();
  set itens(ListBuilder<ChamadaIaDetalhe>? itens) => _$this._itens = itens;

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

  PagedResultOfChamadaIaDetalheBuilder() {
    PagedResultOfChamadaIaDetalhe._defaults(this);
  }

  PagedResultOfChamadaIaDetalheBuilder get _$this {
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
  void replace(PagedResultOfChamadaIaDetalhe other) {
    _$v = other as _$PagedResultOfChamadaIaDetalhe;
  }

  @override
  void update(void Function(PagedResultOfChamadaIaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfChamadaIaDetalhe build() => _build();

  _$PagedResultOfChamadaIaDetalhe _build() {
    _$PagedResultOfChamadaIaDetalhe _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfChamadaIaDetalhe._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfChamadaIaDetalhe', 'pagina'),
            tamanhoPagina:
                BuiltValueNullFieldError.checkNotNull(tamanhoPagina, r'PagedResultOfChamadaIaDetalhe', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfChamadaIaDetalhe', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfChamadaIaDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
