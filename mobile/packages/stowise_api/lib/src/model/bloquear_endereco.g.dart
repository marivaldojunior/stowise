// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloquear_endereco.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BloquearEndereco extends BloquearEndereco {
  @override
  final String? motivo;

  factory _$BloquearEndereco([void Function(BloquearEnderecoBuilder)? updates]) =>
      (BloquearEnderecoBuilder()..update(updates))._build();

  _$BloquearEndereco._({this.motivo}) : super._();
  @override
  BloquearEndereco rebuild(void Function(BloquearEnderecoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BloquearEnderecoBuilder toBuilder() => BloquearEnderecoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BloquearEndereco && motivo == other.motivo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, motivo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BloquearEndereco')..add('motivo', motivo)).toString();
  }
}

class BloquearEnderecoBuilder implements Builder<BloquearEndereco, BloquearEnderecoBuilder> {
  _$BloquearEndereco? _$v;

  String? _motivo;
  String? get motivo => _$this._motivo;
  set motivo(String? motivo) => _$this._motivo = motivo;

  BloquearEnderecoBuilder() {
    BloquearEndereco._defaults(this);
  }

  BloquearEnderecoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _motivo = $v.motivo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BloquearEndereco other) {
    _$v = other as _$BloquearEndereco;
  }

  @override
  void update(void Function(BloquearEnderecoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BloquearEndereco build() => _build();

  _$BloquearEndereco _build() {
    final _$result = _$v ??
        _$BloquearEndereco._(
          motivo: motivo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
