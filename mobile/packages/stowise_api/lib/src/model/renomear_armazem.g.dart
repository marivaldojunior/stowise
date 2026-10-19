// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renomear_armazem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RenomearArmazem extends RenomearArmazem {
  @override
  final String? nome;

  factory _$RenomearArmazem([void Function(RenomearArmazemBuilder)? updates]) =>
      (RenomearArmazemBuilder()..update(updates))._build();

  _$RenomearArmazem._({this.nome}) : super._();
  @override
  RenomearArmazem rebuild(void Function(RenomearArmazemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RenomearArmazemBuilder toBuilder() => RenomearArmazemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RenomearArmazem && nome == other.nome;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RenomearArmazem')..add('nome', nome)).toString();
  }
}

class RenomearArmazemBuilder implements Builder<RenomearArmazem, RenomearArmazemBuilder> {
  _$RenomearArmazem? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  RenomearArmazemBuilder() {
    RenomearArmazem._defaults(this);
  }

  RenomearArmazemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RenomearArmazem other) {
    _$v = other as _$RenomearArmazem;
  }

  @override
  void update(void Function(RenomearArmazemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RenomearArmazem build() => _build();

  _$RenomearArmazem _build() {
    final _$result = _$v ??
        _$RenomearArmazem._(
          nome: nome,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
