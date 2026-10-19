// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adicionar_embalagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdicionarEmbalagem extends AdicionarEmbalagem {
  @override
  final TipoEmbalagem? tipo;
  @override
  final double? fatorConversao;
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

  factory _$AdicionarEmbalagem([void Function(AdicionarEmbalagemBuilder)? updates]) =>
      (AdicionarEmbalagemBuilder()..update(updates))._build();

  _$AdicionarEmbalagem._(
      {this.tipo, this.fatorConversao, this.gtin, this.pesoKg, this.alturaCm, this.larguraCm, this.comprimentoCm})
      : super._();
  @override
  AdicionarEmbalagem rebuild(void Function(AdicionarEmbalagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdicionarEmbalagemBuilder toBuilder() => AdicionarEmbalagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdicionarEmbalagem &&
        tipo == other.tipo &&
        fatorConversao == other.fatorConversao &&
        gtin == other.gtin &&
        pesoKg == other.pesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        comprimentoCm == other.comprimentoCm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
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
    return (newBuiltValueToStringHelper(r'AdicionarEmbalagem')
          ..add('tipo', tipo)
          ..add('fatorConversao', fatorConversao)
          ..add('gtin', gtin)
          ..add('pesoKg', pesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('comprimentoCm', comprimentoCm))
        .toString();
  }
}

class AdicionarEmbalagemBuilder implements Builder<AdicionarEmbalagem, AdicionarEmbalagemBuilder> {
  _$AdicionarEmbalagem? _$v;

  TipoEmbalagem? _tipo;
  TipoEmbalagem? get tipo => _$this._tipo;
  set tipo(TipoEmbalagem? tipo) => _$this._tipo = tipo;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

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

  AdicionarEmbalagemBuilder() {
    AdicionarEmbalagem._defaults(this);
  }

  AdicionarEmbalagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tipo = $v.tipo;
      _fatorConversao = $v.fatorConversao;
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
  void replace(AdicionarEmbalagem other) {
    _$v = other as _$AdicionarEmbalagem;
  }

  @override
  void update(void Function(AdicionarEmbalagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdicionarEmbalagem build() => _build();

  _$AdicionarEmbalagem _build() {
    final _$result = _$v ??
        _$AdicionarEmbalagem._(
          tipo: tipo,
          fatorConversao: fatorConversao,
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
