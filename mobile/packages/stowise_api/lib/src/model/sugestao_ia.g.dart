// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sugestao_ia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SugestaoIa extends SugestaoIa {
  @override
  final BuiltList<ColunaSugerida> colunas;
  @override
  final RegrasNormalizacao regras;
  @override
  final String? observacao;
  @override
  final String? chamadaIaId;

  factory _$SugestaoIa([void Function(SugestaoIaBuilder)? updates]) => (SugestaoIaBuilder()..update(updates))._build();

  _$SugestaoIa._({required this.colunas, required this.regras, this.observacao, this.chamadaIaId}) : super._();
  @override
  SugestaoIa rebuild(void Function(SugestaoIaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SugestaoIaBuilder toBuilder() => SugestaoIaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SugestaoIa &&
        colunas == other.colunas &&
        regras == other.regras &&
        observacao == other.observacao &&
        chamadaIaId == other.chamadaIaId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, colunas.hashCode);
    _$hash = $jc(_$hash, regras.hashCode);
    _$hash = $jc(_$hash, observacao.hashCode);
    _$hash = $jc(_$hash, chamadaIaId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SugestaoIa')
          ..add('colunas', colunas)
          ..add('regras', regras)
          ..add('observacao', observacao)
          ..add('chamadaIaId', chamadaIaId))
        .toString();
  }
}

class SugestaoIaBuilder implements Builder<SugestaoIa, SugestaoIaBuilder> {
  _$SugestaoIa? _$v;

  ListBuilder<ColunaSugerida>? _colunas;
  ListBuilder<ColunaSugerida> get colunas => _$this._colunas ??= ListBuilder<ColunaSugerida>();
  set colunas(ListBuilder<ColunaSugerida>? colunas) => _$this._colunas = colunas;

  RegrasNormalizacaoBuilder? _regras;
  RegrasNormalizacaoBuilder get regras => _$this._regras ??= RegrasNormalizacaoBuilder();
  set regras(RegrasNormalizacaoBuilder? regras) => _$this._regras = regras;

  String? _observacao;
  String? get observacao => _$this._observacao;
  set observacao(String? observacao) => _$this._observacao = observacao;

  String? _chamadaIaId;
  String? get chamadaIaId => _$this._chamadaIaId;
  set chamadaIaId(String? chamadaIaId) => _$this._chamadaIaId = chamadaIaId;

  SugestaoIaBuilder() {
    SugestaoIa._defaults(this);
  }

  SugestaoIaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _colunas = $v.colunas.toBuilder();
      _regras = $v.regras.toBuilder();
      _observacao = $v.observacao;
      _chamadaIaId = $v.chamadaIaId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SugestaoIa other) {
    _$v = other as _$SugestaoIa;
  }

  @override
  void update(void Function(SugestaoIaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SugestaoIa build() => _build();

  _$SugestaoIa _build() {
    _$SugestaoIa _$result;
    try {
      _$result = _$v ??
          _$SugestaoIa._(
            colunas: colunas.build(),
            regras: regras.build(),
            observacao: observacao,
            chamadaIaId: chamadaIaId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'colunas';
        colunas.build();
        _$failedField = 'regras';
        regras.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'SugestaoIa', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
