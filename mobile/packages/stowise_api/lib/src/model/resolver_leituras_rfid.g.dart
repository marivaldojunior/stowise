// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolver_leituras_rfid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResolverLeiturasRfid extends ResolverLeiturasRfid {
  @override
  final BuiltList<String>? epcs;

  factory _$ResolverLeiturasRfid([void Function(ResolverLeiturasRfidBuilder)? updates]) =>
      (ResolverLeiturasRfidBuilder()..update(updates))._build();

  _$ResolverLeiturasRfid._({this.epcs}) : super._();
  @override
  ResolverLeiturasRfid rebuild(void Function(ResolverLeiturasRfidBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResolverLeiturasRfidBuilder toBuilder() => ResolverLeiturasRfidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResolverLeiturasRfid && epcs == other.epcs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, epcs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResolverLeiturasRfid')..add('epcs', epcs)).toString();
  }
}

class ResolverLeiturasRfidBuilder implements Builder<ResolverLeiturasRfid, ResolverLeiturasRfidBuilder> {
  _$ResolverLeiturasRfid? _$v;

  ListBuilder<String>? _epcs;
  ListBuilder<String> get epcs => _$this._epcs ??= ListBuilder<String>();
  set epcs(ListBuilder<String>? epcs) => _$this._epcs = epcs;

  ResolverLeiturasRfidBuilder() {
    ResolverLeiturasRfid._defaults(this);
  }

  ResolverLeiturasRfidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _epcs = $v.epcs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResolverLeiturasRfid other) {
    _$v = other as _$ResolverLeiturasRfid;
  }

  @override
  void update(void Function(ResolverLeiturasRfidBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResolverLeiturasRfid build() => _build();

  _$ResolverLeiturasRfid _build() {
    _$ResolverLeiturasRfid _$result;
    try {
      _$result = _$v ??
          _$ResolverLeiturasRfid._(
            epcs: _epcs?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'epcs';
        _epcs?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ResolverLeiturasRfid', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
