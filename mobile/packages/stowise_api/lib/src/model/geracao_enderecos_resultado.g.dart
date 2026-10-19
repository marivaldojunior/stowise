// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geracao_enderecos_resultado.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeracaoEnderecosResultado extends GeracaoEnderecosResultado {
  @override
  final int total;
  @override
  final int criados;
  @override
  final int ignorados;
  @override
  final bool simulado;
  @override
  final BuiltList<String> codigosExistentes;
  @override
  final BuiltList<String> amostra;

  factory _$GeracaoEnderecosResultado([void Function(GeracaoEnderecosResultadoBuilder)? updates]) =>
      (GeracaoEnderecosResultadoBuilder()..update(updates))._build();

  _$GeracaoEnderecosResultado._(
      {required this.total,
      required this.criados,
      required this.ignorados,
      required this.simulado,
      required this.codigosExistentes,
      required this.amostra})
      : super._();
  @override
  GeracaoEnderecosResultado rebuild(void Function(GeracaoEnderecosResultadoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeracaoEnderecosResultadoBuilder toBuilder() => GeracaoEnderecosResultadoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeracaoEnderecosResultado &&
        total == other.total &&
        criados == other.criados &&
        ignorados == other.ignorados &&
        simulado == other.simulado &&
        codigosExistentes == other.codigosExistentes &&
        amostra == other.amostra;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, criados.hashCode);
    _$hash = $jc(_$hash, ignorados.hashCode);
    _$hash = $jc(_$hash, simulado.hashCode);
    _$hash = $jc(_$hash, codigosExistentes.hashCode);
    _$hash = $jc(_$hash, amostra.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeracaoEnderecosResultado')
          ..add('total', total)
          ..add('criados', criados)
          ..add('ignorados', ignorados)
          ..add('simulado', simulado)
          ..add('codigosExistentes', codigosExistentes)
          ..add('amostra', amostra))
        .toString();
  }
}

class GeracaoEnderecosResultadoBuilder implements Builder<GeracaoEnderecosResultado, GeracaoEnderecosResultadoBuilder> {
  _$GeracaoEnderecosResultado? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _criados;
  int? get criados => _$this._criados;
  set criados(int? criados) => _$this._criados = criados;

  int? _ignorados;
  int? get ignorados => _$this._ignorados;
  set ignorados(int? ignorados) => _$this._ignorados = ignorados;

  bool? _simulado;
  bool? get simulado => _$this._simulado;
  set simulado(bool? simulado) => _$this._simulado = simulado;

  ListBuilder<String>? _codigosExistentes;
  ListBuilder<String> get codigosExistentes => _$this._codigosExistentes ??= ListBuilder<String>();
  set codigosExistentes(ListBuilder<String>? codigosExistentes) => _$this._codigosExistentes = codigosExistentes;

  ListBuilder<String>? _amostra;
  ListBuilder<String> get amostra => _$this._amostra ??= ListBuilder<String>();
  set amostra(ListBuilder<String>? amostra) => _$this._amostra = amostra;

  GeracaoEnderecosResultadoBuilder() {
    GeracaoEnderecosResultado._defaults(this);
  }

  GeracaoEnderecosResultadoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _criados = $v.criados;
      _ignorados = $v.ignorados;
      _simulado = $v.simulado;
      _codigosExistentes = $v.codigosExistentes.toBuilder();
      _amostra = $v.amostra.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeracaoEnderecosResultado other) {
    _$v = other as _$GeracaoEnderecosResultado;
  }

  @override
  void update(void Function(GeracaoEnderecosResultadoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeracaoEnderecosResultado build() => _build();

  _$GeracaoEnderecosResultado _build() {
    _$GeracaoEnderecosResultado _$result;
    try {
      _$result = _$v ??
          _$GeracaoEnderecosResultado._(
            total: BuiltValueNullFieldError.checkNotNull(total, r'GeracaoEnderecosResultado', 'total'),
            criados: BuiltValueNullFieldError.checkNotNull(criados, r'GeracaoEnderecosResultado', 'criados'),
            ignorados: BuiltValueNullFieldError.checkNotNull(ignorados, r'GeracaoEnderecosResultado', 'ignorados'),
            simulado: BuiltValueNullFieldError.checkNotNull(simulado, r'GeracaoEnderecosResultado', 'simulado'),
            codigosExistentes: codigosExistentes.build(),
            amostra: amostra.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'codigosExistentes';
        codigosExistentes.build();
        _$failedField = 'amostra';
        amostra.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'GeracaoEnderecosResultado', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
