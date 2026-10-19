// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renomear_template.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RenomearTemplate extends RenomearTemplate {
  @override
  final String? nome;
  @override
  final int? versao;

  factory _$RenomearTemplate([void Function(RenomearTemplateBuilder)? updates]) =>
      (RenomearTemplateBuilder()..update(updates))._build();

  _$RenomearTemplate._({this.nome, this.versao}) : super._();
  @override
  RenomearTemplate rebuild(void Function(RenomearTemplateBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RenomearTemplateBuilder toBuilder() => RenomearTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RenomearTemplate && nome == other.nome && versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RenomearTemplate')
          ..add('nome', nome)
          ..add('versao', versao))
        .toString();
  }
}

class RenomearTemplateBuilder implements Builder<RenomearTemplate, RenomearTemplateBuilder> {
  _$RenomearTemplate? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  RenomearTemplateBuilder() {
    RenomearTemplate._defaults(this);
  }

  RenomearTemplateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RenomearTemplate other) {
    _$v = other as _$RenomearTemplate;
  }

  @override
  void update(void Function(RenomearTemplateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RenomearTemplate build() => _build();

  _$RenomearTemplate _build() {
    final _$result = _$v ??
        _$RenomearTemplate._(
          nome: nome,
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
