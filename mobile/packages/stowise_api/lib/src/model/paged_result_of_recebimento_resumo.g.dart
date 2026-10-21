// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_of_recebimento_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PagedResultOfRecebimentoResumo extends PagedResultOfRecebimentoResumo {
  @override
  final BuiltList<RecebimentoResumo> itens;
  @override
  final int pagina;
  @override
  final int tamanhoPagina;
  @override
  final int total;
  @override
  final int? totalPaginas;

  factory _$PagedResultOfRecebimentoResumo([void Function(PagedResultOfRecebimentoResumoBuilder)? updates]) =>
      (PagedResultOfRecebimentoResumoBuilder()..update(updates))._build();

  _$PagedResultOfRecebimentoResumo._(
      {required this.itens, required this.pagina, required this.tamanhoPagina, required this.total, this.totalPaginas})
      : super._();
  @override
  PagedResultOfRecebimentoResumo rebuild(void Function(PagedResultOfRecebimentoResumoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PagedResultOfRecebimentoResumoBuilder toBuilder() => PagedResultOfRecebimentoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PagedResultOfRecebimentoResumo &&
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
    return (newBuiltValueToStringHelper(r'PagedResultOfRecebimentoResumo')
          ..add('itens', itens)
          ..add('pagina', pagina)
          ..add('tamanhoPagina', tamanhoPagina)
          ..add('total', total)
          ..add('totalPaginas', totalPaginas))
        .toString();
  }
}

class PagedResultOfRecebimentoResumoBuilder
    implements Builder<PagedResultOfRecebimentoResumo, PagedResultOfRecebimentoResumoBuilder> {
  _$PagedResultOfRecebimentoResumo? _$v;

  ListBuilder<RecebimentoResumo>? _itens;
  ListBuilder<RecebimentoResumo> get itens => _$this._itens ??= ListBuilder<RecebimentoResumo>();
  set itens(ListBuilder<RecebimentoResumo>? itens) => _$this._itens = itens;

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

  PagedResultOfRecebimentoResumoBuilder() {
    PagedResultOfRecebimentoResumo._defaults(this);
  }

  PagedResultOfRecebimentoResumoBuilder get _$this {
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
  void replace(PagedResultOfRecebimentoResumo other) {
    _$v = other as _$PagedResultOfRecebimentoResumo;
  }

  @override
  void update(void Function(PagedResultOfRecebimentoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PagedResultOfRecebimentoResumo build() => _build();

  _$PagedResultOfRecebimentoResumo _build() {
    _$PagedResultOfRecebimentoResumo _$result;
    try {
      _$result = _$v ??
          _$PagedResultOfRecebimentoResumo._(
            itens: itens.build(),
            pagina: BuiltValueNullFieldError.checkNotNull(pagina, r'PagedResultOfRecebimentoResumo', 'pagina'),
            tamanhoPagina: BuiltValueNullFieldError.checkNotNull(
                tamanhoPagina, r'PagedResultOfRecebimentoResumo', 'tamanhoPagina'),
            total: BuiltValueNullFieldError.checkNotNull(total, r'PagedResultOfRecebimentoResumo', 'total'),
            totalPaginas: totalPaginas,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PagedResultOfRecebimentoResumo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
