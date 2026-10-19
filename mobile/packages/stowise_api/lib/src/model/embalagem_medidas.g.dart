// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embalagem_medidas.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmbalagemMedidas extends EmbalagemMedidas {
  @override
  final String? gtin;
  @override
  final double? pesoKg;
  @override
  final double? alturaCm;
  @override
  final double? larguraCm;
  @override
  final double? comprimentoCm;

  factory _$EmbalagemMedidas([void Function(EmbalagemMedidasBuilder)? updates]) =>
      (EmbalagemMedidasBuilder()..update(updates))._build();

  _$EmbalagemMedidas._({this.gtin, this.pesoKg, this.alturaCm, this.larguraCm, this.comprimentoCm}) : super._();
  @override
  EmbalagemMedidas rebuild(void Function(EmbalagemMedidasBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EmbalagemMedidasBuilder toBuilder() => EmbalagemMedidasBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmbalagemMedidas &&
        gtin == other.gtin &&
        pesoKg == other.pesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        comprimentoCm == other.comprimentoCm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gtin.hashCode);
    _$hash = $jc(_$hash, pesoKg.hashCode);
    _$hash = $jc(_$hash, alturaCm.hashCode);
    _$hash = $jc(_$hash, larguraCm.hashCode);
    _$hash = $jc(_$hash, comprimentoCm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmbalagemMedidas')
          ..add('gtin', gtin)
          ..add('pesoKg', pesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('comprimentoCm', comprimentoCm))
        .toString();
  }
}

class EmbalagemMedidasBuilder implements Builder<EmbalagemMedidas, EmbalagemMedidasBuilder> {
  _$EmbalagemMedidas? _$v;

  String? _gtin;
  String? get gtin => _$this._gtin;
  set gtin(String? gtin) => _$this._gtin = gtin;

  double? _pesoKg;
  double? get pesoKg => _$this._pesoKg;
  set pesoKg(double? pesoKg) => _$this._pesoKg = pesoKg;

  double? _alturaCm;
  double? get alturaCm => _$this._alturaCm;
  set alturaCm(double? alturaCm) => _$this._alturaCm = alturaCm;

  double? _larguraCm;
  double? get larguraCm => _$this._larguraCm;
  set larguraCm(double? larguraCm) => _$this._larguraCm = larguraCm;

  double? _comprimentoCm;
  double? get comprimentoCm => _$this._comprimentoCm;
  set comprimentoCm(double? comprimentoCm) => _$this._comprimentoCm = comprimentoCm;

  EmbalagemMedidasBuilder() {
    EmbalagemMedidas._defaults(this);
  }

  EmbalagemMedidasBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gtin = $v.gtin;
      _pesoKg = $v.pesoKg;
      _alturaCm = $v.alturaCm;
      _larguraCm = $v.larguraCm;
      _comprimentoCm = $v.comprimentoCm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmbalagemMedidas other) {
    _$v = other as _$EmbalagemMedidas;
  }

  @override
  void update(void Function(EmbalagemMedidasBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmbalagemMedidas build() => _build();

  _$EmbalagemMedidas _build() {
    final _$result = _$v ??
        _$EmbalagemMedidas._(
          gtin: gtin,
          pesoKg: pesoKg,
          alturaCm: alturaCm,
          larguraCm: larguraCm,
          comprimentoCm: comprimentoCm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
