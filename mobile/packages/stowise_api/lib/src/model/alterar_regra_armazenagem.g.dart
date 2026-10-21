// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alterar_regra_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlterarRegraArmazenagem extends AlterarRegraArmazenagem {
  @override
  final double? peso;
  @override
  final bool? ativa;
  @override
  final BuiltMap<String, double> parametros;
  @override
  final int? versao;

  factory _$AlterarRegraArmazenagem([void Function(AlterarRegraArmazenagemBuilder)? updates]) =>
      (AlterarRegraArmazenagemBuilder()..update(updates))._build();

  _$AlterarRegraArmazenagem._({this.peso, this.ativa, required this.parametros, this.versao}) : super._();
  @override
  AlterarRegraArmazenagem rebuild(void Function(AlterarRegraArmazenagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlterarRegraArmazenagemBuilder toBuilder() => AlterarRegraArmazenagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlterarRegraArmazenagem &&
        peso == other.peso &&
        ativa == other.ativa &&
        parametros == other.parametros &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, peso.hashCode);
    _$hash = $jc(_$hash, ativa.hashCode);
    _$hash = $jc(_$hash, parametros.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AlterarRegraArmazenagem')
          ..add('peso', peso)
          ..add('ativa', ativa)
          ..add('parametros', parametros)
          ..add('versao', versao))
        .toString();
  }
}

class AlterarRegraArmazenagemBuilder implements Builder<AlterarRegraArmazenagem, AlterarRegraArmazenagemBuilder> {
  _$AlterarRegraArmazenagem? _$v;

  double? _peso;
  double? get peso => _$this._peso;
  set peso(double? peso) => _$this._peso = peso;

  bool? _ativa;
  bool? get ativa => _$this._ativa;
  set ativa(bool? ativa) => _$this._ativa = ativa;

  MapBuilder<String, double>? _parametros;
  MapBuilder<String, double> get parametros => _$this._parametros ??= MapBuilder<String, double>();
  set parametros(MapBuilder<String, double>? parametros) => _$this._parametros = parametros;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AlterarRegraArmazenagemBuilder() {
    AlterarRegraArmazenagem._defaults(this);
  }

  AlterarRegraArmazenagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _peso = $v.peso;
      _ativa = $v.ativa;
      _parametros = $v.parametros.toBuilder();
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AlterarRegraArmazenagem other) {
    _$v = other as _$AlterarRegraArmazenagem;
  }

  @override
  void update(void Function(AlterarRegraArmazenagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlterarRegraArmazenagem build() => _build();

  _$AlterarRegraArmazenagem _build() {
    _$AlterarRegraArmazenagem _$result;
    try {
      _$result = _$v ??
          _$AlterarRegraArmazenagem._(
            peso: peso,
            ativa: ativa,
            parametros: parametros.build(),
            versao: versao,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parametros';
        parametros.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AlterarRegraArmazenagem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
