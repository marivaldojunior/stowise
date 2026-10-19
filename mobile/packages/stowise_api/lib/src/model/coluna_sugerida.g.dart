// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coluna_sugerida.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ColunaSugerida extends ColunaSugerida {
  @override
  final String campo;
  @override
  final int coluna;
  @override
  final double confianca;

  factory _$ColunaSugerida([void Function(ColunaSugeridaBuilder)? updates]) =>
      (ColunaSugeridaBuilder()..update(updates))._build();

  _$ColunaSugerida._({required this.campo, required this.coluna, required this.confianca}) : super._();
  @override
  ColunaSugerida rebuild(void Function(ColunaSugeridaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ColunaSugeridaBuilder toBuilder() => ColunaSugeridaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ColunaSugerida && campo == other.campo && coluna == other.coluna && confianca == other.confianca;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, campo.hashCode);
    _$hash = $jc(_$hash, coluna.hashCode);
    _$hash = $jc(_$hash, confianca.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ColunaSugerida')
          ..add('campo', campo)
          ..add('coluna', coluna)
          ..add('confianca', confianca))
        .toString();
  }
}

class ColunaSugeridaBuilder implements Builder<ColunaSugerida, ColunaSugeridaBuilder> {
  _$ColunaSugerida? _$v;

  String? _campo;
  String? get campo => _$this._campo;
  set campo(String? campo) => _$this._campo = campo;

  int? _coluna;
  int? get coluna => _$this._coluna;
  set coluna(int? coluna) => _$this._coluna = coluna;

  double? _confianca;
  double? get confianca => _$this._confianca;
  set confianca(double? confianca) => _$this._confianca = confianca;

  ColunaSugeridaBuilder() {
    ColunaSugerida._defaults(this);
  }

  ColunaSugeridaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _campo = $v.campo;
      _coluna = $v.coluna;
      _confianca = $v.confianca;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ColunaSugerida other) {
    _$v = other as _$ColunaSugerida;
  }

  @override
  void update(void Function(ColunaSugeridaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ColunaSugerida build() => _build();

  _$ColunaSugerida _build() {
    final _$result = _$v ??
        _$ColunaSugerida._(
          campo: BuiltValueNullFieldError.checkNotNull(campo, r'ColunaSugerida', 'campo'),
          coluna: BuiltValueNullFieldError.checkNotNull(coluna, r'ColunaSugerida', 'coluna'),
          confianca: BuiltValueNullFieldError.checkNotNull(confianca, r'ColunaSugerida', 'confianca'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
