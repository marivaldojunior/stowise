// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_endereco.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarEndereco extends CriarEndereco {
  @override
  final String? zonaId;
  @override
  final String? rua;
  @override
  final int? modulo;
  @override
  final int? nivel;
  @override
  final int? posicao;
  @override
  final double? capacidadePesoKg;
  @override
  final double? alturaCm;
  @override
  final double? larguraCm;
  @override
  final double? profundidadeCm;
  @override
  final double? distanciaExpedicao;

  factory _$CriarEndereco([void Function(CriarEnderecoBuilder)? updates]) =>
      (CriarEnderecoBuilder()..update(updates))._build();

  _$CriarEndereco._(
      {this.zonaId,
      this.rua,
      this.modulo,
      this.nivel,
      this.posicao,
      this.capacidadePesoKg,
      this.alturaCm,
      this.larguraCm,
      this.profundidadeCm,
      this.distanciaExpedicao})
      : super._();
  @override
  CriarEndereco rebuild(void Function(CriarEnderecoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CriarEnderecoBuilder toBuilder() => CriarEnderecoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarEndereco &&
        zonaId == other.zonaId &&
        rua == other.rua &&
        modulo == other.modulo &&
        nivel == other.nivel &&
        posicao == other.posicao &&
        capacidadePesoKg == other.capacidadePesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        profundidadeCm == other.profundidadeCm &&
        distanciaExpedicao == other.distanciaExpedicao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zonaId.hashCode);
    _$hash = $jc(_$hash, rua.hashCode);
    _$hash = $jc(_$hash, modulo.hashCode);
    _$hash = $jc(_$hash, nivel.hashCode);
    _$hash = $jc(_$hash, posicao.hashCode);
    _$hash = $jc(_$hash, capacidadePesoKg.hashCode);
    _$hash = $jc(_$hash, alturaCm.hashCode);
    _$hash = $jc(_$hash, larguraCm.hashCode);
    _$hash = $jc(_$hash, profundidadeCm.hashCode);
    _$hash = $jc(_$hash, distanciaExpedicao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarEndereco')
          ..add('zonaId', zonaId)
          ..add('rua', rua)
          ..add('modulo', modulo)
          ..add('nivel', nivel)
          ..add('posicao', posicao)
          ..add('capacidadePesoKg', capacidadePesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('profundidadeCm', profundidadeCm)
          ..add('distanciaExpedicao', distanciaExpedicao))
        .toString();
  }
}

class CriarEnderecoBuilder implements Builder<CriarEndereco, CriarEnderecoBuilder> {
  _$CriarEndereco? _$v;

  String? _zonaId;
  String? get zonaId => _$this._zonaId;
  set zonaId(String? zonaId) => _$this._zonaId = zonaId;

  String? _rua;
  String? get rua => _$this._rua;
  set rua(String? rua) => _$this._rua = rua;

  int? _modulo;
  int? get modulo => _$this._modulo;
  set modulo(int? modulo) => _$this._modulo = modulo;

  int? _nivel;
  int? get nivel => _$this._nivel;
  set nivel(int? nivel) => _$this._nivel = nivel;

  int? _posicao;
  int? get posicao => _$this._posicao;
  set posicao(int? posicao) => _$this._posicao = posicao;

  double? _capacidadePesoKg;
  double? get capacidadePesoKg => _$this._capacidadePesoKg;
  set capacidadePesoKg(double? capacidadePesoKg) => _$this._capacidadePesoKg = capacidadePesoKg;

  double? _alturaCm;
  double? get alturaCm => _$this._alturaCm;
  set alturaCm(double? alturaCm) => _$this._alturaCm = alturaCm;

  double? _larguraCm;
  double? get larguraCm => _$this._larguraCm;
  set larguraCm(double? larguraCm) => _$this._larguraCm = larguraCm;

  double? _profundidadeCm;
  double? get profundidadeCm => _$this._profundidadeCm;
  set profundidadeCm(double? profundidadeCm) => _$this._profundidadeCm = profundidadeCm;

  double? _distanciaExpedicao;
  double? get distanciaExpedicao => _$this._distanciaExpedicao;
  set distanciaExpedicao(double? distanciaExpedicao) => _$this._distanciaExpedicao = distanciaExpedicao;

  CriarEnderecoBuilder() {
    CriarEndereco._defaults(this);
  }

  CriarEnderecoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zonaId = $v.zonaId;
      _rua = $v.rua;
      _modulo = $v.modulo;
      _nivel = $v.nivel;
      _posicao = $v.posicao;
      _capacidadePesoKg = $v.capacidadePesoKg;
      _alturaCm = $v.alturaCm;
      _larguraCm = $v.larguraCm;
      _profundidadeCm = $v.profundidadeCm;
      _distanciaExpedicao = $v.distanciaExpedicao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarEndereco other) {
    _$v = other as _$CriarEndereco;
  }

  @override
  void update(void Function(CriarEnderecoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarEndereco build() => _build();

  _$CriarEndereco _build() {
    final _$result = _$v ??
        _$CriarEndereco._(
          zonaId: zonaId,
          rua: rua,
          modulo: modulo,
          nivel: nivel,
          posicao: posicao,
          capacidadePesoKg: capacidadePesoKg,
          alturaCm: alturaCm,
          larguraCm: larguraCm,
          profundidadeCm: profundidadeCm,
          distanciaExpedicao: distanciaExpedicao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
