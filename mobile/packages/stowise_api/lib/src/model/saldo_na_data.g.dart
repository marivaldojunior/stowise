// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saldo_na_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaldoNaData extends SaldoNaData {
  @override
  final String enderecoId;
  @override
  final String enderecoCodigo;
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String? loteId;
  @override
  final String? loteNumero;
  @override
  final double quantidade;

  factory _$SaldoNaData([void Function(SaldoNaDataBuilder)? updates]) =>
      (SaldoNaDataBuilder()..update(updates))._build();

  _$SaldoNaData._(
      {required this.enderecoId,
      required this.enderecoCodigo,
      required this.produtoId,
      required this.sku,
      this.loteId,
      this.loteNumero,
      required this.quantidade})
      : super._();
  @override
  SaldoNaData rebuild(void Function(SaldoNaDataBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SaldoNaDataBuilder toBuilder() => SaldoNaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaldoNaData &&
        enderecoId == other.enderecoId &&
        enderecoCodigo == other.enderecoCodigo &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        loteId == other.loteId &&
        loteNumero == other.loteNumero &&
        quantidade == other.quantidade;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, enderecoCodigo.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaldoNaData')
          ..add('enderecoId', enderecoId)
          ..add('enderecoCodigo', enderecoCodigo)
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('loteId', loteId)
          ..add('loteNumero', loteNumero)
          ..add('quantidade', quantidade))
        .toString();
  }
}

class SaldoNaDataBuilder implements Builder<SaldoNaData, SaldoNaDataBuilder> {
  _$SaldoNaData? _$v;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _enderecoCodigo;
  String? get enderecoCodigo => _$this._enderecoCodigo;
  set enderecoCodigo(String? enderecoCodigo) => _$this._enderecoCodigo = enderecoCodigo;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  SaldoNaDataBuilder() {
    SaldoNaData._defaults(this);
  }

  SaldoNaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enderecoId = $v.enderecoId;
      _enderecoCodigo = $v.enderecoCodigo;
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _loteId = $v.loteId;
      _loteNumero = $v.loteNumero;
      _quantidade = $v.quantidade;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaldoNaData other) {
    _$v = other as _$SaldoNaData;
  }

  @override
  void update(void Function(SaldoNaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaldoNaData build() => _build();

  _$SaldoNaData _build() {
    final _$result = _$v ??
        _$SaldoNaData._(
          enderecoId: BuiltValueNullFieldError.checkNotNull(enderecoId, r'SaldoNaData', 'enderecoId'),
          enderecoCodigo: BuiltValueNullFieldError.checkNotNull(enderecoCodigo, r'SaldoNaData', 'enderecoCodigo'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'SaldoNaData', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'SaldoNaData', 'sku'),
          loteId: loteId,
          loteNumero: loteNumero,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'SaldoNaData', 'quantidade'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
