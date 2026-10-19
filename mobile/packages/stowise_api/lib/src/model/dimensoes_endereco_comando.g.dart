// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dimensoes_endereco_comando.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DimensoesEnderecoComando extends DimensoesEnderecoComando {
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

  factory _$DimensoesEnderecoComando([void Function(DimensoesEnderecoComandoBuilder)? updates]) =>
      (DimensoesEnderecoComandoBuilder()..update(updates))._build();

  _$DimensoesEnderecoComando._(
      {this.capacidadePesoKg, this.alturaCm, this.larguraCm, this.profundidadeCm, this.distanciaExpedicao})
      : super._();
  @override
  DimensoesEnderecoComando rebuild(void Function(DimensoesEnderecoComandoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DimensoesEnderecoComandoBuilder toBuilder() => DimensoesEnderecoComandoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DimensoesEnderecoComando &&
        capacidadePesoKg == other.capacidadePesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        profundidadeCm == other.profundidadeCm &&
        distanciaExpedicao == other.distanciaExpedicao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(r'DimensoesEnderecoComando')
          ..add('capacidadePesoKg', capacidadePesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('profundidadeCm', profundidadeCm)
          ..add('distanciaExpedicao', distanciaExpedicao))
        .toString();
  }
}

class DimensoesEnderecoComandoBuilder implements Builder<DimensoesEnderecoComando, DimensoesEnderecoComandoBuilder> {
  _$DimensoesEnderecoComando? _$v;

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

  DimensoesEnderecoComandoBuilder() {
    DimensoesEnderecoComando._defaults(this);
  }

  DimensoesEnderecoComandoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(DimensoesEnderecoComando other) {
    _$v = other as _$DimensoesEnderecoComando;
  }

  @override
  void update(void Function(DimensoesEnderecoComandoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DimensoesEnderecoComando build() => _build();

  _$DimensoesEnderecoComando _build() {
    final _$result = _$v ??
        _$DimensoesEnderecoComando._(
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
