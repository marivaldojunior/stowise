// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_usuario_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarUsuarioRequest extends CriarUsuarioRequest {
  @override
  final String? nome;
  @override
  final String? email;
  @override
  final String? senha;
  @override
  final BuiltList<String>? perfis;

  factory _$CriarUsuarioRequest([void Function(CriarUsuarioRequestBuilder)? updates]) =>
      (CriarUsuarioRequestBuilder()..update(updates))._build();

  _$CriarUsuarioRequest._({this.nome, this.email, this.senha, this.perfis}) : super._();
  @override
  CriarUsuarioRequest rebuild(void Function(CriarUsuarioRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CriarUsuarioRequestBuilder toBuilder() => CriarUsuarioRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarUsuarioRequest &&
        nome == other.nome &&
        email == other.email &&
        senha == other.senha &&
        perfis == other.perfis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, senha.hashCode);
    _$hash = $jc(_$hash, perfis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarUsuarioRequest')
          ..add('nome', nome)
          ..add('email', email)
          ..add('senha', senha)
          ..add('perfis', perfis))
        .toString();
  }
}

class CriarUsuarioRequestBuilder implements Builder<CriarUsuarioRequest, CriarUsuarioRequestBuilder> {
  _$CriarUsuarioRequest? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _senha;
  String? get senha => _$this._senha;
  set senha(String? senha) => _$this._senha = senha;

  ListBuilder<String>? _perfis;
  ListBuilder<String> get perfis => _$this._perfis ??= ListBuilder<String>();
  set perfis(ListBuilder<String>? perfis) => _$this._perfis = perfis;

  CriarUsuarioRequestBuilder() {
    CriarUsuarioRequest._defaults(this);
  }

  CriarUsuarioRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _email = $v.email;
      _senha = $v.senha;
      _perfis = $v.perfis?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarUsuarioRequest other) {
    _$v = other as _$CriarUsuarioRequest;
  }

  @override
  void update(void Function(CriarUsuarioRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarUsuarioRequest build() => _build();

  _$CriarUsuarioRequest _build() {
    _$CriarUsuarioRequest _$result;
    try {
      _$result = _$v ??
          _$CriarUsuarioRequest._(
            nome: nome,
            email: email,
            senha: senha,
            perfis: _perfis?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'perfis';
        _perfis?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'CriarUsuarioRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
