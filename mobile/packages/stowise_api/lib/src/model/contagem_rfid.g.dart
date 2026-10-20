// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contagem_rfid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContagemRfid extends ContagemRfid {
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final String embalagemId;
  @override
  final TipoEmbalagem tipo;
  @override
  final double fatorConversao;
  @override
  final int etiquetas;
  @override
  final double quantidadeBase;

  factory _$ContagemRfid([void Function(ContagemRfidBuilder)? updates]) =>
      (ContagemRfidBuilder()..update(updates))._build();

  _$ContagemRfid._(
      {required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.embalagemId,
      required this.tipo,
      required this.fatorConversao,
      required this.etiquetas,
      required this.quantidadeBase})
      : super._();
  @override
  ContagemRfid rebuild(void Function(ContagemRfidBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ContagemRfidBuilder toBuilder() => ContagemRfidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContagemRfid &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        embalagemId == other.embalagemId &&
        tipo == other.tipo &&
        fatorConversao == other.fatorConversao &&
        etiquetas == other.etiquetas &&
        quantidadeBase == other.quantidadeBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, etiquetas.hashCode);
    _$hash = $jc(_$hash, quantidadeBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContagemRfid')
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('embalagemId', embalagemId)
          ..add('tipo', tipo)
          ..add('fatorConversao', fatorConversao)
          ..add('etiquetas', etiquetas)
          ..add('quantidadeBase', quantidadeBase))
        .toString();
  }
}

class ContagemRfidBuilder implements Builder<ContagemRfid, ContagemRfidBuilder> {
  _$ContagemRfid? _$v;

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

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  TipoEmbalagem? _tipo;
  TipoEmbalagem? get tipo => _$this._tipo;
  set tipo(TipoEmbalagem? tipo) => _$this._tipo = tipo;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  int? _etiquetas;
  int? get etiquetas => _$this._etiquetas;
  set etiquetas(int? etiquetas) => _$this._etiquetas = etiquetas;

  double? _quantidadeBase;
  double? get quantidadeBase => _$this._quantidadeBase;
  set quantidadeBase(double? quantidadeBase) => _$this._quantidadeBase = quantidadeBase;

  ContagemRfidBuilder() {
    ContagemRfid._defaults(this);
  }

  ContagemRfidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _embalagemId = $v.embalagemId;
      _tipo = $v.tipo;
      _fatorConversao = $v.fatorConversao;
      _etiquetas = $v.etiquetas;
      _quantidadeBase = $v.quantidadeBase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContagemRfid other) {
    _$v = other as _$ContagemRfid;
  }

  @override
  void update(void Function(ContagemRfidBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContagemRfid build() => _build();

  _$ContagemRfid _build() {
    final _$result = _$v ??
        _$ContagemRfid._(
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'ContagemRfid', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'ContagemRfid', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ContagemRfid', 'descricao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'ContagemRfid', 'unidadeBase'),
          embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'ContagemRfid', 'embalagemId'),
          tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'ContagemRfid', 'tipo'),
          fatorConversao: BuiltValueNullFieldError.checkNotNull(fatorConversao, r'ContagemRfid', 'fatorConversao'),
          etiquetas: BuiltValueNullFieldError.checkNotNull(etiquetas, r'ContagemRfid', 'etiquetas'),
          quantidadeBase: BuiltValueNullFieldError.checkNotNull(quantidadeBase, r'ContagemRfid', 'quantidadeBase'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
