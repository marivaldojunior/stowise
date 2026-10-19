// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salvar_cota_ia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalvarCotaIa extends SalvarCotaIa {
  @override
  final String? perfil;
  @override
  final String? usuarioId;
  @override
  final FuncionalidadeIa? funcionalidade;
  @override
  final int? limiteChamadasDia;
  @override
  final int? limiteTokensMes;

  factory _$SalvarCotaIa([void Function(SalvarCotaIaBuilder)? updates]) =>
      (SalvarCotaIaBuilder()..update(updates))._build();

  _$SalvarCotaIa._({this.perfil, this.usuarioId, this.funcionalidade, this.limiteChamadasDia, this.limiteTokensMes})
      : super._();
  @override
  SalvarCotaIa rebuild(void Function(SalvarCotaIaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SalvarCotaIaBuilder toBuilder() => SalvarCotaIaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalvarCotaIa &&
        perfil == other.perfil &&
        usuarioId == other.usuarioId &&
        funcionalidade == other.funcionalidade &&
        limiteChamadasDia == other.limiteChamadasDia &&
        limiteTokensMes == other.limiteTokensMes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, perfil.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, funcionalidade.hashCode);
    _$hash = $jc(_$hash, limiteChamadasDia.hashCode);
    _$hash = $jc(_$hash, limiteTokensMes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalvarCotaIa')
          ..add('perfil', perfil)
          ..add('usuarioId', usuarioId)
          ..add('funcionalidade', funcionalidade)
          ..add('limiteChamadasDia', limiteChamadasDia)
          ..add('limiteTokensMes', limiteTokensMes))
        .toString();
  }
}

class SalvarCotaIaBuilder implements Builder<SalvarCotaIa, SalvarCotaIaBuilder> {
  _$SalvarCotaIa? _$v;

  String? _perfil;
  String? get perfil => _$this._perfil;
  set perfil(String? perfil) => _$this._perfil = perfil;

  String? _usuarioId;
  String? get usuarioId => _$this._usuarioId;
  set usuarioId(String? usuarioId) => _$this._usuarioId = usuarioId;

  FuncionalidadeIa? _funcionalidade;
  FuncionalidadeIa? get funcionalidade => _$this._funcionalidade;
  set funcionalidade(FuncionalidadeIa? funcionalidade) => _$this._funcionalidade = funcionalidade;

  int? _limiteChamadasDia;
  int? get limiteChamadasDia => _$this._limiteChamadasDia;
  set limiteChamadasDia(int? limiteChamadasDia) => _$this._limiteChamadasDia = limiteChamadasDia;

  int? _limiteTokensMes;
  int? get limiteTokensMes => _$this._limiteTokensMes;
  set limiteTokensMes(int? limiteTokensMes) => _$this._limiteTokensMes = limiteTokensMes;

  SalvarCotaIaBuilder() {
    SalvarCotaIa._defaults(this);
  }

  SalvarCotaIaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _perfil = $v.perfil;
      _usuarioId = $v.usuarioId;
      _funcionalidade = $v.funcionalidade;
      _limiteChamadasDia = $v.limiteChamadasDia;
      _limiteTokensMes = $v.limiteTokensMes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalvarCotaIa other) {
    _$v = other as _$SalvarCotaIa;
  }

  @override
  void update(void Function(SalvarCotaIaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalvarCotaIa build() => _build();

  _$SalvarCotaIa _build() {
    final _$result = _$v ??
        _$SalvarCotaIa._(
          perfil: perfil,
          usuarioId: usuarioId,
          funcionalidade: funcionalidade,
          limiteChamadasDia: limiteChamadasDia,
          limiteTokensMes: limiteTokensMes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
