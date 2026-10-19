// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regras_normalizacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegrasNormalizacao extends RegrasNormalizacao {
  @override
  final String? separadorDecimal;
  @override
  final BuiltList<UnidadeDePara> unidades;
  @override
  final BuiltList<String> valoresVerdadeiros;
  @override
  final BuiltList<String> valoresFalsos;

  factory _$RegrasNormalizacao([void Function(RegrasNormalizacaoBuilder)? updates]) =>
      (RegrasNormalizacaoBuilder()..update(updates))._build();

  _$RegrasNormalizacao._(
      {this.separadorDecimal, required this.unidades, required this.valoresVerdadeiros, required this.valoresFalsos})
      : super._();
  @override
  RegrasNormalizacao rebuild(void Function(RegrasNormalizacaoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegrasNormalizacaoBuilder toBuilder() => RegrasNormalizacaoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegrasNormalizacao &&
        separadorDecimal == other.separadorDecimal &&
        unidades == other.unidades &&
        valoresVerdadeiros == other.valoresVerdadeiros &&
        valoresFalsos == other.valoresFalsos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, separadorDecimal.hashCode);
    _$hash = $jc(_$hash, unidades.hashCode);
    _$hash = $jc(_$hash, valoresVerdadeiros.hashCode);
    _$hash = $jc(_$hash, valoresFalsos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegrasNormalizacao')
          ..add('separadorDecimal', separadorDecimal)
          ..add('unidades', unidades)
          ..add('valoresVerdadeiros', valoresVerdadeiros)
          ..add('valoresFalsos', valoresFalsos))
        .toString();
  }
}

class RegrasNormalizacaoBuilder implements Builder<RegrasNormalizacao, RegrasNormalizacaoBuilder> {
  _$RegrasNormalizacao? _$v;

  String? _separadorDecimal;
  String? get separadorDecimal => _$this._separadorDecimal;
  set separadorDecimal(String? separadorDecimal) => _$this._separadorDecimal = separadorDecimal;

  ListBuilder<UnidadeDePara>? _unidades;
  ListBuilder<UnidadeDePara> get unidades => _$this._unidades ??= ListBuilder<UnidadeDePara>();
  set unidades(ListBuilder<UnidadeDePara>? unidades) => _$this._unidades = unidades;

  ListBuilder<String>? _valoresVerdadeiros;
  ListBuilder<String> get valoresVerdadeiros => _$this._valoresVerdadeiros ??= ListBuilder<String>();
  set valoresVerdadeiros(ListBuilder<String>? valoresVerdadeiros) => _$this._valoresVerdadeiros = valoresVerdadeiros;

  ListBuilder<String>? _valoresFalsos;
  ListBuilder<String> get valoresFalsos => _$this._valoresFalsos ??= ListBuilder<String>();
  set valoresFalsos(ListBuilder<String>? valoresFalsos) => _$this._valoresFalsos = valoresFalsos;

  RegrasNormalizacaoBuilder() {
    RegrasNormalizacao._defaults(this);
  }

  RegrasNormalizacaoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _separadorDecimal = $v.separadorDecimal;
      _unidades = $v.unidades.toBuilder();
      _valoresVerdadeiros = $v.valoresVerdadeiros.toBuilder();
      _valoresFalsos = $v.valoresFalsos.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegrasNormalizacao other) {
    _$v = other as _$RegrasNormalizacao;
  }

  @override
  void update(void Function(RegrasNormalizacaoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegrasNormalizacao build() => _build();

  _$RegrasNormalizacao _build() {
    _$RegrasNormalizacao _$result;
    try {
      _$result = _$v ??
          _$RegrasNormalizacao._(
            separadorDecimal: separadorDecimal,
            unidades: unidades.build(),
            valoresVerdadeiros: valoresVerdadeiros.build(),
            valoresFalsos: valoresFalsos.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'unidades';
        unidades.build();
        _$failedField = 'valoresVerdadeiros';
        valoresVerdadeiros.build();
        _$failedField = 'valoresFalsos';
        valoresFalsos.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RegrasNormalizacao', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
