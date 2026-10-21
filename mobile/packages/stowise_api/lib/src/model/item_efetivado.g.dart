// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_efetivado.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemEfetivado extends ItemEfetivado {
  @override
  final int numeroItem;
  @override
  final String produtoId;
  @override
  final String embalagemId;
  @override
  final String produtoFornecedorId;
  @override
  final double fatorConversao;
  @override
  final double quantidade;

  factory _$ItemEfetivado([void Function(ItemEfetivadoBuilder)? updates]) =>
      (ItemEfetivadoBuilder()..update(updates))._build();

  _$ItemEfetivado._(
      {required this.numeroItem,
      required this.produtoId,
      required this.embalagemId,
      required this.produtoFornecedorId,
      required this.fatorConversao,
      required this.quantidade})
      : super._();
  @override
  ItemEfetivado rebuild(void Function(ItemEfetivadoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ItemEfetivadoBuilder toBuilder() => ItemEfetivadoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemEfetivado &&
        numeroItem == other.numeroItem &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        produtoFornecedorId == other.produtoFornecedorId &&
        fatorConversao == other.fatorConversao &&
        quantidade == other.quantidade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numeroItem.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, produtoFornecedorId.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemEfetivado')
          ..add('numeroItem', numeroItem)
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('produtoFornecedorId', produtoFornecedorId)
          ..add('fatorConversao', fatorConversao)
          ..add('quantidade', quantidade))
        .toString();
  }
}

class ItemEfetivadoBuilder implements Builder<ItemEfetivado, ItemEfetivadoBuilder> {
  _$ItemEfetivado? _$v;

  int? _numeroItem;
  int? get numeroItem => _$this._numeroItem;
  set numeroItem(int? numeroItem) => _$this._numeroItem = numeroItem;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _produtoFornecedorId;
  String? get produtoFornecedorId => _$this._produtoFornecedorId;
  set produtoFornecedorId(String? produtoFornecedorId) => _$this._produtoFornecedorId = produtoFornecedorId;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  ItemEfetivadoBuilder() {
    ItemEfetivado._defaults(this);
  }

  ItemEfetivadoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numeroItem = $v.numeroItem;
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _produtoFornecedorId = $v.produtoFornecedorId;
      _fatorConversao = $v.fatorConversao;
      _quantidade = $v.quantidade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemEfetivado other) {
    _$v = other as _$ItemEfetivado;
  }

  @override
  void update(void Function(ItemEfetivadoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemEfetivado build() => _build();

  _$ItemEfetivado _build() {
    final _$result = _$v ??
        _$ItemEfetivado._(
          numeroItem: BuiltValueNullFieldError.checkNotNull(numeroItem, r'ItemEfetivado', 'numeroItem'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'ItemEfetivado', 'produtoId'),
          embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'ItemEfetivado', 'embalagemId'),
          produtoFornecedorId:
              BuiltValueNullFieldError.checkNotNull(produtoFornecedorId, r'ItemEfetivado', 'produtoFornecedorId'),
          fatorConversao: BuiltValueNullFieldError.checkNotNull(fatorConversao, r'ItemEfetivado', 'fatorConversao'),
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'ItemEfetivado', 'quantidade'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
