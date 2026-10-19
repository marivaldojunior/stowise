// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginRequest extends LoginRequest {
  @override
  final String? email;
  @override
  final String? senha;
  @override
  final bool? useCookie;

  factory _$LoginRequest([void Function(LoginRequestBuilder)? updates]) =>
      (LoginRequestBuilder()..update(updates))._build();

  _$LoginRequest._({this.email, this.senha, this.useCookie}) : super._();
  @override
  LoginRequest rebuild(void Function(LoginRequestBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LoginRequestBuilder toBuilder() => LoginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginRequest && email == other.email && senha == other.senha && useCookie == other.useCookie;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, senha.hashCode);
    _$hash = $jc(_$hash, useCookie.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginRequest')
          ..add('email', email)
          ..add('senha', senha)
          ..add('useCookie', useCookie))
        .toString();
  }
}

class LoginRequestBuilder implements Builder<LoginRequest, LoginRequestBuilder> {
  _$LoginRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _senha;
  String? get senha => _$this._senha;
  set senha(String? senha) => _$this._senha = senha;

  bool? _useCookie;
  bool? get useCookie => _$this._useCookie;
  set useCookie(bool? useCookie) => _$this._useCookie = useCookie;

  LoginRequestBuilder() {
    LoginRequest._defaults(this);
  }

  LoginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _senha = $v.senha;
      _useCookie = $v.useCookie;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginRequest other) {
    _$v = other as _$LoginRequest;
  }

  @override
  void update(void Function(LoginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginRequest build() => _build();

  _$LoginRequest _build() {
    final _$result = _$v ??
        _$LoginRequest._(
          email: email,
          senha: senha,
          useCookie: useCookie,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
