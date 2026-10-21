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
  final String unidadeBase;
  @override
  final bool controlaLote;
  @override
  final bool controlaValidade;
  @override
  final String embalagemId;
  @override
  final TipoEmbalagem tipoEmbalagem;
  @override
  final double fatorConversao;
  @override
  final String? produtoFornecedorId;
  @override
  final bool? porGtinTributavel;

  factory _$CasamentoItem([void Function(CasamentoItemBuilder)? updates]) =>
      (CasamentoItemBuilder()..update(updates))._build();

  _$CasamentoItem._(
      {required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.controlaLote,
      required this.controlaValidade,
      required this.embalagemId,
      required this.tipoEmbalagem,
      required this.fatorConversao,
      this.produtoFornecedorId,
      this.porGtinTributavel})
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
        unidadeBase == other.unidadeBase &&
        controlaLote == other.controlaLote &&
        controlaValidade == other.controlaValidade &&
        embalagemId == other.embalagemId &&
        tipoEmbalagem == other.tipoEmbalagem &&
        fatorConversao == other.fatorConversao &&
        produtoFornecedorId == other.produtoFornecedorId &&
        porGtinTributavel == other.porGtinTributavel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, controlaLote.hashCode);
    _$hash = $jc(_$hash, controlaValidade.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, tipoEmbalagem.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, produtoFornecedorId.hashCode);
    _$hash = $jc(_$hash, porGtinTributavel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CasamentoItem')
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('controlaLote', controlaLote)
          ..add('controlaValidade', controlaValidade)
          ..add('embalagemId', embalagemId)
          ..add('tipoEmbalagem', tipoEmbalagem)
          ..add('fatorConversao', fatorConversao)
          ..add('produtoFornecedorId', produtoFornecedorId)
          ..add('porGtinTributavel', porGtinTributavel))
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

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  bool? _controlaLote;
  bool? get controlaLote => _$this._controlaLote;
  set controlaLote(bool? controlaLote) => _$this._controlaLote = controlaLote;

  bool? _controlaValidade;
  bool? get controlaValidade => _$this._controlaValidade;
  set controlaValidade(bool? controlaValidade) => _$this._controlaValidade = controlaValidade;

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

  bool? _porGtinTributavel;
  bool? get porGtinTributavel => _$this._porGtinTributavel;
  set porGtinTributavel(bool? porGtinTributavel) => _$this._porGtinTributavel = porGtinTributavel;

  CasamentoItemBuilder() {
    CasamentoItem._defaults(this);
  }

  CasamentoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _controlaLote = $v.controlaLote;
      _controlaValidade = $v.controlaValidade;
      _embalagemId = $v.embalagemId;
      _tipoEmbalagem = $v.tipoEmbalagem;
      _fatorConversao = $v.fatorConversao;
      _produtoFornecedorId = $v.produtoFornecedorId;
      _porGtinTributavel = $v.porGtinTributavel;
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
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'CasamentoItem', 'unidadeBase'),
          controlaLote: BuiltValueNullFieldError.checkNotNull(controlaLote, r'CasamentoItem', 'controlaLote'),
          controlaValidade:
              BuiltValueNullFieldError.checkNotNull(controlaValidade, r'CasamentoItem', 'controlaValidade'),
          embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'CasamentoItem', 'embalagemId'),
          tipoEmbalagem: BuiltValueNullFieldError.checkNotNull(tipoEmbalagem, r'CasamentoItem', 'tipoEmbalagem'),
          fatorConversao: BuiltValueNullFieldError.checkNotNull(fatorConversao, r'CasamentoItem', 'fatorConversao'),
          produtoFornecedorId: produtoFornecedorId,
          porGtinTributavel: porGtinTributavel,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
