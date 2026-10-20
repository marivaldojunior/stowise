// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemNota extends ItemNota {
  @override
  final int numeroItem;
  @override
  final String codigoFornecedor;
  @override
  final String? gtin;
  @override
  final String descricao;
  @override
  final String? ncm;
  @override
  final String? cest;
  @override
  final String cfop;
  @override
  final String unidadeComercial;
  @override
  final double quantidadeComercial;
  @override
  final double valorUnitarioComercial;
  @override
  final String? gtinTributavel;
  @override
  final String unidadeTributavel;
  @override
  final double quantidadeTributavel;
  @override
  final BuiltList<LoteNota> lotes;

  factory _$ItemNota([void Function(ItemNotaBuilder)? updates]) => (ItemNotaBuilder()..update(updates))._build();

  _$ItemNota._(
      {required this.numeroItem,
      required this.codigoFornecedor,
      this.gtin,
      required this.descricao,
      this.ncm,
      this.cest,
      required this.cfop,
      required this.unidadeComercial,
      required this.quantidadeComercial,
      required this.valorUnitarioComercial,
      this.gtinTributavel,
      required this.unidadeTributavel,
      required this.quantidadeTributavel,
      required this.lotes})
      : super._();
  @override
  ItemNota rebuild(void Function(ItemNotaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ItemNotaBuilder toBuilder() => ItemNotaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemNota &&
        numeroItem == other.numeroItem &&
        codigoFornecedor == other.codigoFornecedor &&
        gtin == other.gtin &&
        descricao == other.descricao &&
        ncm == other.ncm &&
        cest == other.cest &&
        cfop == other.cfop &&
        unidadeComercial == other.unidadeComercial &&
        quantidadeComercial == other.quantidadeComercial &&
        valorUnitarioComercial == other.valorUnitarioComercial &&
        gtinTributavel == other.gtinTributavel &&
        unidadeTributavel == other.unidadeTributavel &&
        quantidadeTributavel == other.quantidadeTributavel &&
        lotes == other.lotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numeroItem.hashCode);
    _$hash = $jc(_$hash, codigoFornecedor.hashCode);
    _$hash = $jc(_$hash, gtin.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, ncm.hashCode);
    _$hash = $jc(_$hash, cest.hashCode);
    _$hash = $jc(_$hash, cfop.hashCode);
    _$hash = $jc(_$hash, unidadeComercial.hashCode);
    _$hash = $jc(_$hash, quantidadeComercial.hashCode);
    _$hash = $jc(_$hash, valorUnitarioComercial.hashCode);
    _$hash = $jc(_$hash, gtinTributavel.hashCode);
    _$hash = $jc(_$hash, unidadeTributavel.hashCode);
    _$hash = $jc(_$hash, quantidadeTributavel.hashCode);
    _$hash = $jc(_$hash, lotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemNota')
          ..add('numeroItem', numeroItem)
          ..add('codigoFornecedor', codigoFornecedor)
          ..add('gtin', gtin)
          ..add('descricao', descricao)
          ..add('ncm', ncm)
          ..add('cest', cest)
          ..add('cfop', cfop)
          ..add('unidadeComercial', unidadeComercial)
          ..add('quantidadeComercial', quantidadeComercial)
          ..add('valorUnitarioComercial', valorUnitarioComercial)
          ..add('gtinTributavel', gtinTributavel)
          ..add('unidadeTributavel', unidadeTributavel)
          ..add('quantidadeTributavel', quantidadeTributavel)
          ..add('lotes', lotes))
        .toString();
  }
}

class ItemNotaBuilder implements Builder<ItemNota, ItemNotaBuilder> {
  _$ItemNota? _$v;

  int? _numeroItem;
  int? get numeroItem => _$this._numeroItem;
  set numeroItem(int? numeroItem) => _$this._numeroItem = numeroItem;

  String? _codigoFornecedor;
  String? get codigoFornecedor => _$this._codigoFornecedor;
  set codigoFornecedor(String? codigoFornecedor) => _$this._codigoFornecedor = codigoFornecedor;

  String? _gtin;
  String? get gtin => _$this._gtin;
  set gtin(String? gtin) => _$this._gtin = gtin;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _ncm;
  String? get ncm => _$this._ncm;
  set ncm(String? ncm) => _$this._ncm = ncm;

  String? _cest;
  String? get cest => _$this._cest;
  set cest(String? cest) => _$this._cest = cest;

  String? _cfop;
  String? get cfop => _$this._cfop;
  set cfop(String? cfop) => _$this._cfop = cfop;

  String? _unidadeComercial;
  String? get unidadeComercial => _$this._unidadeComercial;
  set unidadeComercial(String? unidadeComercial) => _$this._unidadeComercial = unidadeComercial;

  double? _quantidadeComercial;
  double? get quantidadeComercial => _$this._quantidadeComercial;
  set quantidadeComercial(double? quantidadeComercial) => _$this._quantidadeComercial = quantidadeComercial;

  double? _valorUnitarioComercial;
  double? get valorUnitarioComercial => _$this._valorUnitarioComercial;
  set valorUnitarioComercial(double? valorUnitarioComercial) => _$this._valorUnitarioComercial = valorUnitarioComercial;

  String? _gtinTributavel;
  String? get gtinTributavel => _$this._gtinTributavel;
  set gtinTributavel(String? gtinTributavel) => _$this._gtinTributavel = gtinTributavel;

  String? _unidadeTributavel;
  String? get unidadeTributavel => _$this._unidadeTributavel;
  set unidadeTributavel(String? unidadeTributavel) => _$this._unidadeTributavel = unidadeTributavel;

  double? _quantidadeTributavel;
  double? get quantidadeTributavel => _$this._quantidadeTributavel;
  set quantidadeTributavel(double? quantidadeTributavel) => _$this._quantidadeTributavel = quantidadeTributavel;

  ListBuilder<LoteNota>? _lotes;
  ListBuilder<LoteNota> get lotes => _$this._lotes ??= ListBuilder<LoteNota>();
  set lotes(ListBuilder<LoteNota>? lotes) => _$this._lotes = lotes;

  ItemNotaBuilder() {
    ItemNota._defaults(this);
  }

  ItemNotaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numeroItem = $v.numeroItem;
      _codigoFornecedor = $v.codigoFornecedor;
      _gtin = $v.gtin;
      _descricao = $v.descricao;
      _ncm = $v.ncm;
      _cest = $v.cest;
      _cfop = $v.cfop;
      _unidadeComercial = $v.unidadeComercial;
      _quantidadeComercial = $v.quantidadeComercial;
      _valorUnitarioComercial = $v.valorUnitarioComercial;
      _gtinTributavel = $v.gtinTributavel;
      _unidadeTributavel = $v.unidadeTributavel;
      _quantidadeTributavel = $v.quantidadeTributavel;
      _lotes = $v.lotes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemNota other) {
    _$v = other as _$ItemNota;
  }

  @override
  void update(void Function(ItemNotaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemNota build() => _build();

  _$ItemNota _build() {
    _$ItemNota _$result;
    try {
      _$result = _$v ??
          _$ItemNota._(
            numeroItem: BuiltValueNullFieldError.checkNotNull(numeroItem, r'ItemNota', 'numeroItem'),
            codigoFornecedor: BuiltValueNullFieldError.checkNotNull(codigoFornecedor, r'ItemNota', 'codigoFornecedor'),
            gtin: gtin,
            descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ItemNota', 'descricao'),
            ncm: ncm,
            cest: cest,
            cfop: BuiltValueNullFieldError.checkNotNull(cfop, r'ItemNota', 'cfop'),
            unidadeComercial: BuiltValueNullFieldError.checkNotNull(unidadeComercial, r'ItemNota', 'unidadeComercial'),
            quantidadeComercial:
                BuiltValueNullFieldError.checkNotNull(quantidadeComercial, r'ItemNota', 'quantidadeComercial'),
            valorUnitarioComercial:
                BuiltValueNullFieldError.checkNotNull(valorUnitarioComercial, r'ItemNota', 'valorUnitarioComercial'),
            gtinTributavel: gtinTributavel,
            unidadeTributavel:
                BuiltValueNullFieldError.checkNotNull(unidadeTributavel, r'ItemNota', 'unidadeTributavel'),
            quantidadeTributavel:
                BuiltValueNullFieldError.checkNotNull(quantidadeTributavel, r'ItemNota', 'quantidadeTributavel'),
            lotes: lotes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lotes';
        lotes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ItemNota', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
