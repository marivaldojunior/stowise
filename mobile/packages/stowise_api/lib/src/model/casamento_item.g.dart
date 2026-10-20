// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'casamento_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CasamentoItem extends CasamentoItem {
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String embalagemId;
  @override
  final TipoEmbalagem tipoEmbalagem;
  @override
  final double fatorConversao;
  @override
  final String? produtoFornecedorId;

  factory _$CasamentoItem([void Function(CasamentoItemBuilder)? updates]) =>
      (CasamentoItemBuilder()..update(updates))._build();

  _$CasamentoItem._(
      {required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.embalagemId,
      required this.tipoEmbalagem,
      required this.fatorConversao,
      this.produtoFornecedorId})
      : super._();
  @override
  CasamentoItem rebuild(void Function(CasamentoItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CasamentoItemBuilder toBuilder() => CasamentoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CasamentoItem &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        embalagemId == other.embalagemId &&
        tipoEmbalagem == other.tipoEmbalagem &&
        fatorConversao == other.fatorConversao &&
        produtoFornecedorId == other.produtoFornecedorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, tipoEmbalagem.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, produtoFornecedorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CasamentoItem')
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('embalagemId', embalagemId)
          ..add('tipoEmbalagem', tipoEmbalagem)
          ..add('fatorConversao', fatorConversao)
          ..add('produtoFornecedorId', produtoFornecedorId))
        .toString();
  }
}

class CasamentoItemBuilder implements Builder<CasamentoItem, CasamentoItemBuilder> {
  _$CasamentoItem? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  TipoEmbalagem? _tipoEmbalagem;
  TipoEmbalagem? get tipoEmbalagem => _$this._tipoEmbalagem;
  set tipoEmbalagem(TipoEmbalagem? tipoEmbalagem) => _$this._tipoEmbalagem = tipoEmbalagem;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  String? _produtoFornecedorId;
  String? get produtoFornecedorId => _$this._produtoFornecedorId;
  set produtoFornecedorId(String? produtoFornecedorId) => _$this._produtoFornecedorId = produtoFornecedorId;

  CasamentoItemBuilder() {
    CasamentoItem._defaults(this);
  }

  CasamentoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _embalagemId = $v.embalagemId;
      _tipoEmbalagem = $v.tipoEmbalagem;
      _fatorConversao = $v.fatorConversao;
      _produtoFornecedorId = $v.produtoFornecedorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CasamentoItem other) {
    _$v = other as _$CasamentoItem;
  }

  @override
  void update(void Function(CasamentoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CasamentoItem build() => _build();

  _$CasamentoItem _build() {
    final _$result = _$v ??
        _$CasamentoItem._(
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'CasamentoItem', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'CasamentoItem', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'CasamentoItem', 'descricao'),
          embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'CasamentoItem', 'embalagemId'),
          tipoEmbalagem: BuiltValueNullFieldError.checkNotNull(tipoEmbalagem, r'CasamentoItem', 'tipoEmbalagem'),
          fatorConversao: BuiltValueNullFieldError.checkNotNull(fatorConversao, r'CasamentoItem', 'fatorConversao'),
          produtoFornecedorId: produtoFornecedorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
