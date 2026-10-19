// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alterar_limites_cota_ia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlterarLimitesCotaIa extends AlterarLimitesCotaIa {
  @override
  final int? limiteChamadasDia;
  @override
  final int? limiteTokensMes;
  @override
  final int? versao;

  factory _$AlterarLimitesCotaIa([void Function(AlterarLimitesCotaIaBuilder)? updates]) =>
      (AlterarLimitesCotaIaBuilder()..update(updates))._build();

  _$AlterarLimitesCotaIa._({this.limiteChamadasDia, this.limiteTokensMes, this.versao}) : super._();
  @override
  AlterarLimitesCotaIa rebuild(void Function(AlterarLimitesCotaIaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlterarLimitesCotaIaBuilder toBuilder() => AlterarLimitesCotaIaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlterarLimitesCotaIa &&
        limiteChamadasDia == other.limiteChamadasDia &&
        limiteTokensMes == other.limiteTokensMes &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limiteChamadasDia.hashCode);
    _$hash = $jc(_$hash, limiteTokensMes.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlterarLimitesCotaIa')
          ..add('limiteChamadasDia', limiteChamadasDia)
          ..add('limiteTokensMes', limiteTokensMes)
          ..add('versao', versao))
        .toString();
  }
}

class AlterarLimitesCotaIaBuilder implements Builder<AlterarLimitesCotaIa, AlterarLimitesCotaIaBuilder> {
  _$AlterarLimitesCotaIa? _$v;

  int? _limiteChamadasDia;
  int? get limiteChamadasDia => _$this._limiteChamadasDia;
  set limiteChamadasDia(int? limiteChamadasDia) => _$this._limiteChamadasDia = limiteChamadasDia;

  int? _limiteTokensMes;
  int? get limiteTokensMes => _$this._limiteTokensMes;
  set limiteTokensMes(int? limiteTokensMes) => _$this._limiteTokensMes = limiteTokensMes;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AlterarLimitesCotaIaBuilder() {
    AlterarLimitesCotaIa._defaults(this);
  }

  AlterarLimitesCotaIaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limiteChamadasDia = $v.limiteChamadasDia;
      _limiteTokensMes = $v.limiteTokensMes;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlterarLimitesCotaIa other) {
    _$v = other as _$AlterarLimitesCotaIa;
  }

  @override
  void update(void Function(AlterarLimitesCotaIaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlterarLimitesCotaIa build() => _build();

  _$AlterarLimitesCotaIa _build() {
    final _$result = _$v ??
        _$AlterarLimitesCotaIa._(
          limiteChamadasDia: limiteChamadasDia,
          limiteTokensMes: limiteTokensMes,
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
