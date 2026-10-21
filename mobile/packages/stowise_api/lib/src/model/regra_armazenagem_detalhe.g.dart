// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regra_armazenagem_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegraArmazenagemDetalhe extends RegraArmazenagemDetalhe {
  @override
  final String id;
  @override
  final String codigo;
  @override
  final bool restritiva;
  @override
  final double peso;
  @override
  final bool ativa;
  @override
  final BuiltMap<String, double> parametros;
  @override
  final BuiltMap<String, double> parametrosPadrao;
  @override
  final DateTime? atualizadoEm;
  @override
  final String? atualizadoPor;
  @override
  final int versao;

  factory _$RegraArmazenagemDetalhe([void Function(RegraArmazenagemDetalheBuilder)? updates]) =>
      (RegraArmazenagemDetalheBuilder()..update(updates))._build();

  _$RegraArmazenagemDetalhe._(
      {required this.id,
      required this.codigo,
      required this.restritiva,
      required this.peso,
      required this.ativa,
      required this.parametros,
      required this.parametrosPadrao,
      this.atualizadoEm,
      this.atualizadoPor,
      required this.versao})
      : super._();
  @override
  RegraArmazenagemDetalhe rebuild(void Function(RegraArmazenagemDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegraArmazenagemDetalheBuilder toBuilder() => RegraArmazenagemDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegraArmazenagemDetalhe &&
        id == other.id &&
        codigo == other.codigo &&
        restritiva == other.restritiva &&
        peso == other.peso &&
        ativa == other.ativa &&
        parametros == other.parametros &&
        parametrosPadrao == other.parametrosPadrao &&
        atualizadoEm == other.atualizadoEm &&
        atualizadoPor == other.atualizadoPor &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, restritiva.hashCode);
    _$hash = $jc(_$hash, peso.hashCode);
    _$hash = $jc(_$hash, ativa.hashCode);
    _$hash = $jc(_$hash, parametros.hashCode);
    _$hash = $jc(_$hash, parametrosPadrao.hashCode);
    _$hash = $jc(_$hash, atualizadoEm.hashCode);
    _$hash = $jc(_$hash, atualizadoPor.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegraArmazenagemDetalhe')
          ..add('id', id)
          ..add('codigo', codigo)
          ..add('restritiva', restritiva)
          ..add('peso', peso)
          ..add('ativa', ativa)
          ..add('parametros', parametros)
          ..add('parametrosPadrao', parametrosPadrao)
          ..add('atualizadoEm', atualizadoEm)
          ..add('atualizadoPor', atualizadoPor)
          ..add('versao', versao))
        .toString();
  }
}

class RegraArmazenagemDetalheBuilder implements Builder<RegraArmazenagemDetalhe, RegraArmazenagemDetalheBuilder> {
  _$RegraArmazenagemDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  bool? _restritiva;
  bool? get restritiva => _$this._restritiva;
  set restritiva(bool? restritiva) => _$this._restritiva = restritiva;

  double? _peso;
  double? get peso => _$this._peso;
  set peso(double? peso) => _$this._peso = peso;

  bool? _ativa;
  bool? get ativa => _$this._ativa;
  set ativa(bool? ativa) => _$this._ativa = ativa;

  MapBuilder<String, double>? _parametros;
  MapBuilder<String, double> get parametros => _$this._parametros ??= MapBuilder<String, double>();
  set parametros(MapBuilder<String, double>? parametros) => _$this._parametros = parametros;

  MapBuilder<String, double>? _parametrosPadrao;
  MapBuilder<String, double> get parametrosPadrao => _$this._parametrosPadrao ??= MapBuilder<String, double>();
  set parametrosPadrao(MapBuilder<String, double>? parametrosPadrao) => _$this._parametrosPadrao = parametrosPadrao;

  DateTime? _atualizadoEm;
  DateTime? get atualizadoEm => _$this._atualizadoEm;
  set atualizadoEm(DateTime? atualizadoEm) => _$this._atualizadoEm = atualizadoEm;

  String? _atualizadoPor;
  String? get atualizadoPor => _$this._atualizadoPor;
  set atualizadoPor(String? atualizadoPor) => _$this._atualizadoPor = atualizadoPor;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  RegraArmazenagemDetalheBuilder() {
    RegraArmazenagemDetalhe._defaults(this);
  }

  RegraArmazenagemDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _codigo = $v.codigo;
      _restritiva = $v.restritiva;
      _peso = $v.peso;
      _ativa = $v.ativa;
      _parametros = $v.parametros.toBuilder();
      _parametrosPadrao = $v.parametrosPadrao.toBuilder();
      _atualizadoEm = $v.atualizadoEm;
      _atualizadoPor = $v.atualizadoPor;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegraArmazenagemDetalhe other) {
    _$v = other as _$RegraArmazenagemDetalhe;
  }

  @override
  void update(void Function(RegraArmazenagemDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegraArmazenagemDetalhe build() => _build();

  _$RegraArmazenagemDetalhe _build() {
    _$RegraArmazenagemDetalhe _$result;
    try {
      _$result = _$v ??
          _$RegraArmazenagemDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'RegraArmazenagemDetalhe', 'id'),
            codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'RegraArmazenagemDetalhe', 'codigo'),
            restritiva: BuiltValueNullFieldError.checkNotNull(restritiva, r'RegraArmazenagemDetalhe', 'restritiva'),
            peso: BuiltValueNullFieldError.checkNotNull(peso, r'RegraArmazenagemDetalhe', 'peso'),
            ativa: BuiltValueNullFieldError.checkNotNull(ativa, r'RegraArmazenagemDetalhe', 'ativa'),
            parametros: parametros.build(),
            parametrosPadrao: parametrosPadrao.build(),
            atualizadoEm: atualizadoEm,
            atualizadoPor: atualizadoPor,
            versao: BuiltValueNullFieldError.checkNotNull(versao, r'RegraArmazenagemDetalhe', 'versao'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parametros';
        parametros.build();
        _$failedField = 'parametrosPadrao';
        parametrosPadrao.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RegraArmazenagemDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
