// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cota_ia_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CotaIaDetalhe extends CotaIaDetalhe {
  @override
  final String id;
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
  @override
  final int versao;

  factory _$CotaIaDetalhe([void Function(CotaIaDetalheBuilder)? updates]) =>
      (CotaIaDetalheBuilder()..update(updates))._build();

  _$CotaIaDetalhe._(
      {required this.id,
      this.perfil,
      this.usuarioId,
      this.funcionalidade,
      this.limiteChamadasDia,
      this.limiteTokensMes,
      required this.versao})
      : super._();
  @override
  CotaIaDetalhe rebuild(void Function(CotaIaDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CotaIaDetalheBuilder toBuilder() => CotaIaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CotaIaDetalhe &&
        id == other.id &&
        perfil == other.perfil &&
        usuarioId == other.usuarioId &&
        funcionalidade == other.funcionalidade &&
        limiteChamadasDia == other.limiteChamadasDia &&
        limiteTokensMes == other.limiteTokensMes &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, perfil.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, funcionalidade.hashCode);
    _$hash = $jc(_$hash, limiteChamadasDia.hashCode);
    _$hash = $jc(_$hash, limiteTokensMes.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CotaIaDetalhe')
          ..add('id', id)
          ..add('perfil', perfil)
          ..add('usuarioId', usuarioId)
          ..add('funcionalidade', funcionalidade)
          ..add('limiteChamadasDia', limiteChamadasDia)
          ..add('limiteTokensMes', limiteTokensMes)
          ..add('versao', versao))
        .toString();
  }
}

class CotaIaDetalheBuilder implements Builder<CotaIaDetalhe, CotaIaDetalheBuilder> {
  _$CotaIaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  CotaIaDetalheBuilder() {
    CotaIaDetalhe._defaults(this);
  }

  CotaIaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _perfil = $v.perfil;
      _usuarioId = $v.usuarioId;
      _funcionalidade = $v.funcionalidade;
      _limiteChamadasDia = $v.limiteChamadasDia;
      _limiteTokensMes = $v.limiteTokensMes;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CotaIaDetalhe other) {
    _$v = other as _$CotaIaDetalhe;
  }

  @override
  void update(void Function(CotaIaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CotaIaDetalhe build() => _build();

  _$CotaIaDetalhe _build() {
    final _$result = _$v ??
        _$CotaIaDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CotaIaDetalhe', 'id'),
          perfil: perfil,
          usuarioId: usuarioId,
          funcionalidade: funcionalidade,
          limiteChamadasDia: limiteChamadasDia,
          limiteTokensMes: limiteTokensMes,
          versao: BuiltValueNullFieldError.checkNotNull(versao, r'CotaIaDetalhe', 'versao'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
