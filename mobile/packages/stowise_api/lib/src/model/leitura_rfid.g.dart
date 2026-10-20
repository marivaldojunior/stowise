// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leitura_rfid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LeituraRfid extends LeituraRfid {
  @override
  final String epc;
  @override
  final String? gtin;
  @override
  final int? serie;
  @override
  final String? produtoId;
  @override
  final String? embalagemId;

  factory _$LeituraRfid([void Function(LeituraRfidBuilder)? updates]) =>
      (LeituraRfidBuilder()..update(updates))._build();

  _$LeituraRfid._({required this.epc, this.gtin, this.serie, this.produtoId, this.embalagemId}) : super._();
  @override
  LeituraRfid rebuild(void Function(LeituraRfidBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LeituraRfidBuilder toBuilder() => LeituraRfidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LeituraRfid &&
        epc == other.epc &&
        gtin == other.gtin &&
        serie == other.serie &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, epc.hashCode);
    _$hash = $jc(_$hash, gtin.hashCode);
    _$hash = $jc(_$hash, serie.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LeituraRfid')
          ..add('epc', epc)
          ..add('gtin', gtin)
          ..add('serie', serie)
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId))
        .toString();
  }
}

class LeituraRfidBuilder implements Builder<LeituraRfid, LeituraRfidBuilder> {
  _$LeituraRfid? _$v;

  String? _epc;
  String? get epc => _$this._epc;
  set epc(String? epc) => _$this._epc = epc;

  String? _gtin;
  String? get gtin => _$this._gtin;
  set gtin(String? gtin) => _$this._gtin = gtin;

  int? _serie;
  int? get serie => _$this._serie;
  set serie(int? serie) => _$this._serie = serie;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  LeituraRfidBuilder() {
    LeituraRfid._defaults(this);
  }

  LeituraRfidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _epc = $v.epc;
      _gtin = $v.gtin;
      _serie = $v.serie;
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LeituraRfid other) {
    _$v = other as _$LeituraRfid;
  }

  @override
  void update(void Function(LeituraRfidBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LeituraRfid build() => _build();

  _$LeituraRfid _build() {
    final _$result = _$v ??
        _$LeituraRfid._(
          epc: BuiltValueNullFieldError.checkNotNull(epc, r'LeituraRfid', 'epc'),
          gtin: gtin,
          serie: serie,
          produtoId: produtoId,
          embalagemId: embalagemId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
