// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embalagem_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmbalagemDetalhe extends EmbalagemDetalhe {
  @override
  final String id;
  @override
  final TipoEmbalagem tipo;
  @override
  final double fatorConversao;
  @override
  final bool unidadeBase;
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

  factory _$EmbalagemDetalhe([void Function(EmbalagemDetalheBuilder)? updates]) =>
      (EmbalagemDetalheBuilder()..update(updates))._build();

  _$EmbalagemDetalhe._(
      {required this.id,
      required this.tipo,
      required this.fatorConversao,
      required this.unidadeBase,
      this.gtin,
      this.pesoKg,
      this.alturaCm,
      this.larguraCm,
      this.comprimentoCm})
      : super._();
  @override
  EmbalagemDetalhe rebuild(void Function(EmbalagemDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EmbalagemDetalheBuilder toBuilder() => EmbalagemDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmbalagemDetalhe &&
        id == other.id &&
        tipo == other.tipo &&
        fatorConversao == other.fatorConversao &&
        unidadeBase == other.unidadeBase &&
        gtin == other.gtin &&
        pesoKg == other.pesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        comprimentoCm == other.comprimentoCm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
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
    return (newBuiltValueToStringHelper(r'EmbalagemDetalhe')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('fatorConversao', fatorConversao)
          ..add('unidadeBase', unidadeBase)
          ..add('gtin', gtin)
          ..add('pesoKg', pesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('comprimentoCm', comprimentoCm))
        .toString();
  }
}

class EmbalagemDetalheBuilder implements Builder<EmbalagemDetalhe, EmbalagemDetalheBuilder> {
  _$EmbalagemDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoEmbalagem? _tipo;
  TipoEmbalagem? get tipo => _$this._tipo;
  set tipo(TipoEmbalagem? tipo) => _$this._tipo = tipo;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  bool? _unidadeBase;
  bool? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(bool? unidadeBase) => _$this._unidadeBase = unidadeBase;

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

  EmbalagemDetalheBuilder() {
    EmbalagemDetalhe._defaults(this);
  }

  EmbalagemDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _fatorConversao = $v.fatorConversao;
      _unidadeBase = $v.unidadeBase;
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
  void replace(EmbalagemDetalhe other) {
    _$v = other as _$EmbalagemDetalhe;
  }

  @override
  void update(void Function(EmbalagemDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmbalagemDetalhe build() => _build();

  _$EmbalagemDetalhe _build() {
    final _$result = _$v ??
        _$EmbalagemDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'EmbalagemDetalhe', 'id'),
          tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'EmbalagemDetalhe', 'tipo'),
          fatorConversao: BuiltValueNullFieldError.checkNotNull(fatorConversao, r'EmbalagemDetalhe', 'fatorConversao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'EmbalagemDetalhe', 'unidadeBase'),
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
