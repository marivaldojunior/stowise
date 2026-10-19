// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campo_importacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampoImportacao extends CampoImportacao {
  @override
  final String nome;
  @override
  final String descricao;
  @override
  final bool obrigatorio;

  factory _$CampoImportacao([void Function(CampoImportacaoBuilder)? updates]) =>
      (CampoImportacaoBuilder()..update(updates))._build();

  _$CampoImportacao._({required this.nome, required this.descricao, required this.obrigatorio}) : super._();
  @override
  CampoImportacao rebuild(void Function(CampoImportacaoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CampoImportacaoBuilder toBuilder() => CampoImportacaoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampoImportacao &&
        nome == other.nome &&
        descricao == other.descricao &&
        obrigatorio == other.obrigatorio;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, obrigatorio.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampoImportacao')
          ..add('nome', nome)
          ..add('descricao', descricao)
          ..add('obrigatorio', obrigatorio))
        .toString();
  }
}

class CampoImportacaoBuilder implements Builder<CampoImportacao, CampoImportacaoBuilder> {
  _$CampoImportacao? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  bool? _obrigatorio;
  bool? get obrigatorio => _$this._obrigatorio;
  set obrigatorio(bool? obrigatorio) => _$this._obrigatorio = obrigatorio;

  CampoImportacaoBuilder() {
    CampoImportacao._defaults(this);
  }

  CampoImportacaoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _descricao = $v.descricao;
      _obrigatorio = $v.obrigatorio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampoImportacao other) {
    _$v = other as _$CampoImportacao;
  }

  @override
  void update(void Function(CampoImportacaoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampoImportacao build() => _build();

  _$CampoImportacao _build() {
    final _$result = _$v ??
        _$CampoImportacao._(
          nome: BuiltValueNullFieldError.checkNotNull(nome, r'CampoImportacao', 'nome'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'CampoImportacao', 'descricao'),
          obrigatorio: BuiltValueNullFieldError.checkNotNull(obrigatorio, r'CampoImportacao', 'obrigatorio'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
