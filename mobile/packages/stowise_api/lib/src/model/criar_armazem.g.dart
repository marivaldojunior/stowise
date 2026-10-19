// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_armazem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarArmazem extends CriarArmazem {
  @override
  final String? codigo;
  @override
  final String? nome;

  factory _$CriarArmazem([void Function(CriarArmazemBuilder)? updates]) =>
      (CriarArmazemBuilder()..update(updates))._build();

  _$CriarArmazem._({this.codigo, this.nome}) : super._();
  @override
  CriarArmazem rebuild(void Function(CriarArmazemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CriarArmazemBuilder toBuilder() => CriarArmazemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarArmazem && codigo == other.codigo && nome == other.nome;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarArmazem')
          ..add('codigo', codigo)
          ..add('nome', nome))
        .toString();
  }
}

class CriarArmazemBuilder implements Builder<CriarArmazem, CriarArmazemBuilder> {
  _$CriarArmazem? _$v;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  CriarArmazemBuilder() {
    CriarArmazem._defaults(this);
  }

  CriarArmazemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codigo = $v.codigo;
      _nome = $v.nome;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarArmazem other) {
    _$v = other as _$CriarArmazem;
  }

  @override
  void update(void Function(CriarArmazemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarArmazem build() => _build();

  _$CriarArmazem _build() {
    final _$result = _$v ??
        _$CriarArmazem._(
          codigo: codigo,
          nome: nome,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
