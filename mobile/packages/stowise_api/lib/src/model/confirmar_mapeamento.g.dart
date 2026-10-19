// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmar_mapeamento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConfirmarMapeamento extends ConfirmarMapeamento {
  @override
  final BuiltList<MapeamentoColuna>? colunas;
  @override
  final int? versao;
  @override
  final bool? salvarTemplate;
  @override
  final String? nomeTemplate;
  @override
  final RegrasNormalizacao? regras;

  factory _$ConfirmarMapeamento([void Function(ConfirmarMapeamentoBuilder)? updates]) =>
      (ConfirmarMapeamentoBuilder()..update(updates))._build();

  _$ConfirmarMapeamento._({this.colunas, this.versao, this.salvarTemplate, this.nomeTemplate, this.regras}) : super._();
  @override
  ConfirmarMapeamento rebuild(void Function(ConfirmarMapeamentoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConfirmarMapeamentoBuilder toBuilder() => ConfirmarMapeamentoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConfirmarMapeamento &&
        colunas == other.colunas &&
        versao == other.versao &&
        salvarTemplate == other.salvarTemplate &&
        nomeTemplate == other.nomeTemplate &&
        regras == other.regras;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, colunas.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jc(_$hash, salvarTemplate.hashCode);
    _$hash = $jc(_$hash, nomeTemplate.hashCode);
    _$hash = $jc(_$hash, regras.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConfirmarMapeamento')
          ..add('colunas', colunas)
          ..add('versao', versao)
          ..add('salvarTemplate', salvarTemplate)
          ..add('nomeTemplate', nomeTemplate)
          ..add('regras', regras))
        .toString();
  }
}

class ConfirmarMapeamentoBuilder implements Builder<ConfirmarMapeamento, ConfirmarMapeamentoBuilder> {
  _$ConfirmarMapeamento? _$v;

  ListBuilder<MapeamentoColuna>? _colunas;
  ListBuilder<MapeamentoColuna> get colunas => _$this._colunas ??= ListBuilder<MapeamentoColuna>();
  set colunas(ListBuilder<MapeamentoColuna>? colunas) => _$this._colunas = colunas;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  bool? _salvarTemplate;
  bool? get salvarTemplate => _$this._salvarTemplate;
  set salvarTemplate(bool? salvarTemplate) => _$this._salvarTemplate = salvarTemplate;

  String? _nomeTemplate;
  String? get nomeTemplate => _$this._nomeTemplate;
  set nomeTemplate(String? nomeTemplate) => _$this._nomeTemplate = nomeTemplate;

  RegrasNormalizacaoBuilder? _regras;
  RegrasNormalizacaoBuilder get regras => _$this._regras ??= RegrasNormalizacaoBuilder();
  set regras(RegrasNormalizacaoBuilder? regras) => _$this._regras = regras;

  ConfirmarMapeamentoBuilder() {
    ConfirmarMapeamento._defaults(this);
  }

  ConfirmarMapeamentoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _colunas = $v.colunas?.toBuilder();
      _versao = $v.versao;
      _salvarTemplate = $v.salvarTemplate;
      _nomeTemplate = $v.nomeTemplate;
      _regras = $v.regras?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConfirmarMapeamento other) {
    _$v = other as _$ConfirmarMapeamento;
  }

  @override
  void update(void Function(ConfirmarMapeamentoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConfirmarMapeamento build() => _build();

  _$ConfirmarMapeamento _build() {
    _$ConfirmarMapeamento _$result;
    try {
      _$result = _$v ??
          _$ConfirmarMapeamento._(
            colunas: _colunas?.build(),
            versao: versao,
            salvarTemplate: salvarTemplate,
            nomeTemplate: nomeTemplate,
            regras: _regras?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'colunas';
        _colunas?.build();

        _$failedField = 'regras';
        _regras?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ConfirmarMapeamento', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
