// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redefinir_senha_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RedefinirSenhaRequest extends RedefinirSenhaRequest {
  @override
  final String? novaSenha;

  factory _$RedefinirSenhaRequest([void Function(RedefinirSenhaRequestBuilder)? updates]) =>
      (RedefinirSenhaRequestBuilder()..update(updates))._build();

  _$RedefinirSenhaRequest._({this.novaSenha}) : super._();
  @override
  RedefinirSenhaRequest rebuild(void Function(RedefinirSenhaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RedefinirSenhaRequestBuilder toBuilder() => RedefinirSenhaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RedefinirSenhaRequest && novaSenha == other.novaSenha;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, novaSenha.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RedefinirSenhaRequest')..add('novaSenha', novaSenha)).toString();
  }
}

class RedefinirSenhaRequestBuilder implements Builder<RedefinirSenhaRequest, RedefinirSenhaRequestBuilder> {
  _$RedefinirSenhaRequest? _$v;

  String? _novaSenha;
  String? get novaSenha => _$this._novaSenha;
  set novaSenha(String? novaSenha) => _$this._novaSenha = novaSenha;

  RedefinirSenhaRequestBuilder() {
    RedefinirSenhaRequest._defaults(this);
  }

  RedefinirSenhaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _novaSenha = $v.novaSenha;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RedefinirSenhaRequest other) {
    _$v = other as _$RedefinirSenhaRequest;
  }

  @override
  void update(void Function(RedefinirSenhaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RedefinirSenhaRequest build() => _build();

  _$RedefinirSenhaRequest _build() {
    final _$result = _$v ??
        _$RedefinirSenhaRequest._(
          novaSenha: novaSenha,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
