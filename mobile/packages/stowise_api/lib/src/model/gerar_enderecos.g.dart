// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerar_enderecos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GerarEnderecos extends GerarEnderecos {
  @override
  final String? zonaId;
  @override
  final BuiltList<String>? ruas;
  @override
  final int? moduloInicial;
  @override
  final int? moduloFinal;
  @override
  final int? nivelInicial;
  @override
  final int? nivelFinal;
  @override
  final int? posicaoInicial;
  @override
  final int? posicaoFinal;
  @override
  final double? capacidadePesoKg;
  @override
  final double? alturaCm;
  @override
  final double? larguraCm;
  @override
  final double? profundidadeCm;
  @override
  final double? distanciaBase;
  @override
  final double? distanciaPorModulo;
  @override
  final bool? ignorarExistentes;
  @override
  final bool? simular;

  factory _$GerarEnderecos([void Function(GerarEnderecosBuilder)? updates]) =>
      (GerarEnderecosBuilder()..update(updates))._build();

  _$GerarEnderecos._(
      {this.zonaId,
      this.ruas,
      this.moduloInicial,
      this.moduloFinal,
      this.nivelInicial,
      this.nivelFinal,
      this.posicaoInicial,
      this.posicaoFinal,
      this.capacidadePesoKg,
      this.alturaCm,
      this.larguraCm,
      this.profundidadeCm,
      this.distanciaBase,
      this.distanciaPorModulo,
      this.ignorarExistentes,
      this.simular})
      : super._();
  @override
  GerarEnderecos rebuild(void Function(GerarEnderecosBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  GerarEnderecosBuilder toBuilder() => GerarEnderecosBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GerarEnderecos &&
        zonaId == other.zonaId &&
        ruas == other.ruas &&
        moduloInicial == other.moduloInicial &&
        moduloFinal == other.moduloFinal &&
        nivelInicial == other.nivelInicial &&
        nivelFinal == other.nivelFinal &&
        posicaoInicial == other.posicaoInicial &&
        posicaoFinal == other.posicaoFinal &&
        capacidadePesoKg == other.capacidadePesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        profundidadeCm == other.profundidadeCm &&
        distanciaBase == other.distanciaBase &&
        distanciaPorModulo == other.distanciaPorModulo &&
        ignorarExistentes == other.ignorarExistentes &&
        simular == other.simular;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zonaId.hashCode);
    _$hash = $jc(_$hash, ruas.hashCode);
    _$hash = $jc(_$hash, moduloInicial.hashCode);
    _$hash = $jc(_$hash, moduloFinal.hashCode);
    _$hash = $jc(_$hash, nivelInicial.hashCode);
    _$hash = $jc(_$hash, nivelFinal.hashCode);
    _$hash = $jc(_$hash, posicaoInicial.hashCode);
    _$hash = $jc(_$hash, posicaoFinal.hashCode);
    _$hash = $jc(_$hash, capacidadePesoKg.hashCode);
    _$hash = $jc(_$hash, alturaCm.hashCode);
    _$hash = $jc(_$hash, larguraCm.hashCode);
    _$hash = $jc(_$hash, profundidadeCm.hashCode);
    _$hash = $jc(_$hash, distanciaBase.hashCode);
    _$hash = $jc(_$hash, distanciaPorModulo.hashCode);
    _$hash = $jc(_$hash, ignorarExistentes.hashCode);
    _$hash = $jc(_$hash, simular.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GerarEnderecos')
          ..add('zonaId', zonaId)
          ..add('ruas', ruas)
          ..add('moduloInicial', moduloInicial)
          ..add('moduloFinal', moduloFinal)
          ..add('nivelInicial', nivelInicial)
          ..add('nivelFinal', nivelFinal)
          ..add('posicaoInicial', posicaoInicial)
          ..add('posicaoFinal', posicaoFinal)
          ..add('capacidadePesoKg', capacidadePesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('profundidadeCm', profundidadeCm)
          ..add('distanciaBase', distanciaBase)
          ..add('distanciaPorModulo', distanciaPorModulo)
          ..add('ignorarExistentes', ignorarExistentes)
          ..add('simular', simular))
        .toString();
  }
}

class GerarEnderecosBuilder implements Builder<GerarEnderecos, GerarEnderecosBuilder> {
  _$GerarEnderecos? _$v;

  String? _zonaId;
  String? get zonaId => _$this._zonaId;
  set zonaId(String? zonaId) => _$this._zonaId = zonaId;

  ListBuilder<String>? _ruas;
  ListBuilder<String> get ruas => _$this._ruas ??= ListBuilder<String>();
  set ruas(ListBuilder<String>? ruas) => _$this._ruas = ruas;

  int? _moduloInicial;
  int? get moduloInicial => _$this._moduloInicial;
  set moduloInicial(int? moduloInicial) => _$this._moduloInicial = moduloInicial;

  int? _moduloFinal;
  int? get moduloFinal => _$this._moduloFinal;
  set moduloFinal(int? moduloFinal) => _$this._moduloFinal = moduloFinal;

  int? _nivelInicial;
  int? get nivelInicial => _$this._nivelInicial;
  set nivelInicial(int? nivelInicial) => _$this._nivelInicial = nivelInicial;

  int? _nivelFinal;
  int? get nivelFinal => _$this._nivelFinal;
  set nivelFinal(int? nivelFinal) => _$this._nivelFinal = nivelFinal;

  int? _posicaoInicial;
  int? get posicaoInicial => _$this._posicaoInicial;
  set posicaoInicial(int? posicaoInicial) => _$this._posicaoInicial = posicaoInicial;

  int? _posicaoFinal;
  int? get posicaoFinal => _$this._posicaoFinal;
  set posicaoFinal(int? posicaoFinal) => _$this._posicaoFinal = posicaoFinal;

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

  double? _distanciaBase;
  double? get distanciaBase => _$this._distanciaBase;
  set distanciaBase(double? distanciaBase) => _$this._distanciaBase = distanciaBase;

  double? _distanciaPorModulo;
  double? get distanciaPorModulo => _$this._distanciaPorModulo;
  set distanciaPorModulo(double? distanciaPorModulo) => _$this._distanciaPorModulo = distanciaPorModulo;

  bool? _ignorarExistentes;
  bool? get ignorarExistentes => _$this._ignorarExistentes;
  set ignorarExistentes(bool? ignorarExistentes) => _$this._ignorarExistentes = ignorarExistentes;

  bool? _simular;
  bool? get simular => _$this._simular;
  set simular(bool? simular) => _$this._simular = simular;

  GerarEnderecosBuilder() {
    GerarEnderecos._defaults(this);
  }

  GerarEnderecosBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zonaId = $v.zonaId;
      _ruas = $v.ruas?.toBuilder();
      _moduloInicial = $v.moduloInicial;
      _moduloFinal = $v.moduloFinal;
      _nivelInicial = $v.nivelInicial;
      _nivelFinal = $v.nivelFinal;
      _posicaoInicial = $v.posicaoInicial;
      _posicaoFinal = $v.posicaoFinal;
      _capacidadePesoKg = $v.capacidadePesoKg;
      _alturaCm = $v.alturaCm;
      _larguraCm = $v.larguraCm;
      _profundidadeCm = $v.profundidadeCm;
      _distanciaBase = $v.distanciaBase;
      _distanciaPorModulo = $v.distanciaPorModulo;
      _ignorarExistentes = $v.ignorarExistentes;
      _simular = $v.simular;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GerarEnderecos other) {
    _$v = other as _$GerarEnderecos;
  }

  @override
  void update(void Function(GerarEnderecosBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GerarEnderecos build() => _build();

  _$GerarEnderecos _build() {
    _$GerarEnderecos _$result;
    try {
      _$result = _$v ??
          _$GerarEnderecos._(
            zonaId: zonaId,
            ruas: _ruas?.build(),
            moduloInicial: moduloInicial,
            moduloFinal: moduloFinal,
            nivelInicial: nivelInicial,
            nivelFinal: nivelFinal,
            posicaoInicial: posicaoInicial,
            posicaoFinal: posicaoFinal,
            capacidadePesoKg: capacidadePesoKg,
            alturaCm: alturaCm,
            larguraCm: larguraCm,
            profundidadeCm: profundidadeCm,
            distanciaBase: distanciaBase,
            distanciaPorModulo: distanciaPorModulo,
            ignorarExistentes: ignorarExistentes,
            simular: simular,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ruas';
        _ruas?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'GerarEnderecos', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
