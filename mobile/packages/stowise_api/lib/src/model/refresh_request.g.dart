// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefreshRequest extends RefreshRequest {
  @override
  final String? refreshToken;
  @override
  final bool? useCookie;

  factory _$RefreshRequest([void Function(RefreshRequestBuilder)? updates]) =>
      (RefreshRequestBuilder()..update(updates))._build();

  _$RefreshRequest._({this.refreshToken, this.useCookie}) : super._();
  @override
  RefreshRequest rebuild(void Function(RefreshRequestBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RefreshRequestBuilder toBuilder() => RefreshRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefreshRequest && refreshToken == other.refreshToken && useCookie == other.useCookie;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, useCookie.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefreshRequest')
          ..add('refreshToken', refreshToken)
          ..add('useCookie', useCookie))
        .toString();
  }
}

class RefreshRequestBuilder implements Builder<RefreshRequest, RefreshRequestBuilder> {
  _$RefreshRequest? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  bool? _useCookie;
  bool? get useCookie => _$this._useCookie;
  set useCookie(bool? useCookie) => _$this._useCookie = useCookie;

  RefreshRequestBuilder() {
    RefreshRequest._defaults(this);
  }

  RefreshRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _useCookie = $v.useCookie;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefreshRequest other) {
    _$v = other as _$RefreshRequest;
  }

  @override
  void update(void Function(RefreshRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefreshRequest build() => _build();

  _$RefreshRequest _build() {
    final _$result = _$v ??
        _$RefreshRequest._(
          refreshToken: refreshToken,
          useCookie: useCookie,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
