// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saldo_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaldoItem extends SaldoItem {
  @override
  final String enderecoId;
  @override
  final String enderecoCodigo;
  @override
  final String armazemId;
  @override
  final String zonaId;
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final String? loteId;
  @override
  final String? loteNumero;
  @override
  final Date? validade;
  @override
  final double quantidade;
  @override
  final double quantidadeReservada;
  @override
  final double quantidadeDisponivel;

  factory _$SaldoItem([void Function(SaldoItemBuilder)? updates]) => (SaldoItemBuilder()..update(updates))._build();

  _$SaldoItem._(
      {required this.enderecoId,
      required this.enderecoCodigo,
      required this.armazemId,
      required this.zonaId,
      required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      this.loteId,
      this.loteNumero,
      this.validade,
      required this.quantidade,
      required this.quantidadeReservada,
      required this.quantidadeDisponivel})
      : super._();
  @override
  SaldoItem rebuild(void Function(SaldoItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SaldoItemBuilder toBuilder() => SaldoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaldoItem &&
        enderecoId == other.enderecoId &&
        enderecoCodigo == other.enderecoCodigo &&
        armazemId == other.armazemId &&
        zonaId == other.zonaId &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        loteId == other.loteId &&
        loteNumero == other.loteNumero &&
        validade == other.validade &&
        quantidade == other.quantidade &&
        quantidadeReservada == other.quantidadeReservada &&
        quantidadeDisponivel == other.quantidadeDisponivel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, enderecoCodigo.hashCode);
    _$hash = $jc(_$hash, armazemId.hashCode);
    _$hash = $jc(_$hash, zonaId.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, quantidadeReservada.hashCode);
    _$hash = $jc(_$hash, quantidadeDisponivel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaldoItem')
          ..add('enderecoId', enderecoId)
          ..add('enderecoCodigo', enderecoCodigo)
          ..add('armazemId', armazemId)
          ..add('zonaId', zonaId)
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('loteId', loteId)
          ..add('loteNumero', loteNumero)
          ..add('validade', validade)
          ..add('quantidade', quantidade)
          ..add('quantidadeReservada', quantidadeReservada)
          ..add('quantidadeDisponivel', quantidadeDisponivel))
        .toString();
  }
}

class SaldoItemBuilder implements Builder<SaldoItem, SaldoItemBuilder> {
  _$SaldoItem? _$v;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _enderecoCodigo;
  String? get enderecoCodigo => _$this._enderecoCodigo;
  set enderecoCodigo(String? enderecoCodigo) => _$this._enderecoCodigo = enderecoCodigo;

  String? _armazemId;
  String? get armazemId => _$this._armazemId;
  set armazemId(String? armazemId) => _$this._armazemId = armazemId;

  String? _zonaId;
  String? get zonaId => _$this._zonaId;
  set zonaId(String? zonaId) => _$this._zonaId = zonaId;

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

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  double? _quantidadeReservada;
  double? get quantidadeReservada => _$this._quantidadeReservada;
  set quantidadeReservada(double? quantidadeReservada) => _$this._quantidadeReservada = quantidadeReservada;

  double? _quantidadeDisponivel;
  double? get quantidadeDisponivel => _$this._quantidadeDisponivel;
  set quantidadeDisponivel(double? quantidadeDisponivel) => _$this._quantidadeDisponivel = quantidadeDisponivel;

  SaldoItemBuilder() {
    SaldoItem._defaults(this);
  }

  SaldoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enderecoId = $v.enderecoId;
      _enderecoCodigo = $v.enderecoCodigo;
      _armazemId = $v.armazemId;
      _zonaId = $v.zonaId;
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _loteId = $v.loteId;
      _loteNumero = $v.loteNumero;
      _validade = $v.validade;
      _quantidade = $v.quantidade;
      _quantidadeReservada = $v.quantidadeReservada;
      _quantidadeDisponivel = $v.quantidadeDisponivel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaldoItem other) {
    _$v = other as _$SaldoItem;
  }

  @override
  void update(void Function(SaldoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaldoItem build() => _build();

  _$SaldoItem _build() {
    final _$result = _$v ??
        _$SaldoItem._(
          enderecoId: BuiltValueNullFieldError.checkNotNull(enderecoId, r'SaldoItem', 'enderecoId'),
          enderecoCodigo: BuiltValueNullFieldError.checkNotNull(enderecoCodigo, r'SaldoItem', 'enderecoCodigo'),
          armazemId: BuiltValueNullFieldError.checkNotNull(armazemId, r'SaldoItem', 'armazemId'),
          zonaId: BuiltValueNullFieldError.checkNotNull(zonaId, r'SaldoItem', 'zonaId'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'SaldoItem', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'SaldoItem', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'SaldoItem', 'descricao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'SaldoItem', 'unidadeBase'),
          loteId: loteId,
          loteNumero: loteNumero,
          validade: validade,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'SaldoItem', 'quantidade'),
          quantidadeReservada:
              BuiltValueNullFieldError.checkNotNull(quantidadeReservada, r'SaldoItem', 'quantidadeReservada'),
          quantidadeDisponivel:
              BuiltValueNullFieldError.checkNotNull(quantidadeDisponivel, r'SaldoItem', 'quantidadeDisponivel'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
