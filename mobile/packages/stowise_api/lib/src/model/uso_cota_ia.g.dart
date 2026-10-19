// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uso_cota_ia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UsoCotaIa extends UsoCotaIa {
  @override
  final FuncionalidadeIa funcionalidade;
  @override
  final int chamadasHoje;
  @override
  final int? limiteChamadasDia;
  @override
  final int tokensMes;
  @override
  final int? limiteTokensMes;
  @override
  final String? origem;
  @override
  final bool excedida;

  factory _$UsoCotaIa([void Function(UsoCotaIaBuilder)? updates]) => (UsoCotaIaBuilder()..update(updates))._build();

  _$UsoCotaIa._(
      {required this.funcionalidade,
      required this.chamadasHoje,
      this.limiteChamadasDia,
      required this.tokensMes,
      this.limiteTokensMes,
      this.origem,
      required this.excedida})
      : super._();
  @override
  UsoCotaIa rebuild(void Function(UsoCotaIaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  UsoCotaIaBuilder toBuilder() => UsoCotaIaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsoCotaIa &&
        funcionalidade == other.funcionalidade &&
        chamadasHoje == other.chamadasHoje &&
        limiteChamadasDia == other.limiteChamadasDia &&
        tokensMes == other.tokensMes &&
        limiteTokensMes == other.limiteTokensMes &&
        origem == other.origem &&
        excedida == other.excedida;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, funcionalidade.hashCode);
    _$hash = $jc(_$hash, chamadasHoje.hashCode);
    _$hash = $jc(_$hash, limiteChamadasDia.hashCode);
    _$hash = $jc(_$hash, tokensMes.hashCode);
    _$hash = $jc(_$hash, limiteTokensMes.hashCode);
    _$hash = $jc(_$hash, origem.hashCode);
    _$hash = $jc(_$hash, excedida.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsoCotaIa')
          ..add('funcionalidade', funcionalidade)
          ..add('chamadasHoje', chamadasHoje)
          ..add('limiteChamadasDia', limiteChamadasDia)
          ..add('tokensMes', tokensMes)
          ..add('limiteTokensMes', limiteTokensMes)
          ..add('origem', origem)
          ..add('excedida', excedida))
        .toString();
  }
}

class UsoCotaIaBuilder implements Builder<UsoCotaIa, UsoCotaIaBuilder> {
  _$UsoCotaIa? _$v;

  FuncionalidadeIa? _funcionalidade;
  FuncionalidadeIa? get funcionalidade => _$this._funcionalidade;
  set funcionalidade(FuncionalidadeIa? funcionalidade) => _$this._funcionalidade = funcionalidade;

  int? _chamadasHoje;
  int? get chamadasHoje => _$this._chamadasHoje;
  set chamadasHoje(int? chamadasHoje) => _$this._chamadasHoje = chamadasHoje;

  int? _limiteChamadasDia;
  int? get limiteChamadasDia => _$this._limiteChamadasDia;
  set limiteChamadasDia(int? limiteChamadasDia) => _$this._limiteChamadasDia = limiteChamadasDia;

  int? _tokensMes;
  int? get tokensMes => _$this._tokensMes;
  set tokensMes(int? tokensMes) => _$this._tokensMes = tokensMes;

  int? _limiteTokensMes;
  int? get limiteTokensMes => _$this._limiteTokensMes;
  set limiteTokensMes(int? limiteTokensMes) => _$this._limiteTokensMes = limiteTokensMes;

  String? _origem;
  String? get origem => _$this._origem;
  set origem(String? origem) => _$this._origem = origem;

  bool? _excedida;
  bool? get excedida => _$this._excedida;
  set excedida(bool? excedida) => _$this._excedida = excedida;

  UsoCotaIaBuilder() {
    UsoCotaIa._defaults(this);
  }

  UsoCotaIaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _funcionalidade = $v.funcionalidade;
      _chamadasHoje = $v.chamadasHoje;
      _limiteChamadasDia = $v.limiteChamadasDia;
      _tokensMes = $v.tokensMes;
      _limiteTokensMes = $v.limiteTokensMes;
      _origem = $v.origem;
      _excedida = $v.excedida;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsoCotaIa other) {
    _$v = other as _$UsoCotaIa;
  }

  @override
  void update(void Function(UsoCotaIaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsoCotaIa build() => _build();

  _$UsoCotaIa _build() {
    final _$result = _$v ??
        _$UsoCotaIa._(
          funcionalidade: BuiltValueNullFieldError.checkNotNull(funcionalidade, r'UsoCotaIa', 'funcionalidade'),
          chamadasHoje: BuiltValueNullFieldError.checkNotNull(chamadasHoje, r'UsoCotaIa', 'chamadasHoje'),
          limiteChamadasDia: limiteChamadasDia,
          tokensMes: BuiltValueNullFieldError.checkNotNull(tokensMes, r'UsoCotaIa', 'tokensMes'),
          limiteTokensMes: limiteTokensMes,
          origem: origem,
          excedida: BuiltValueNullFieldError.checkNotNull(excedida, r'UsoCotaIa', 'excedida'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
