// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salvar_categoria.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalvarCategoria extends SalvarCategoria {
  @override
  final String? nome;
  @override
  final String? parentId;

  factory _$SalvarCategoria([void Function(SalvarCategoriaBuilder)? updates]) =>
      (SalvarCategoriaBuilder()..update(updates))._build();

  _$SalvarCategoria._({this.nome, this.parentId}) : super._();
  @override
  SalvarCategoria rebuild(void Function(SalvarCategoriaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SalvarCategoriaBuilder toBuilder() => SalvarCategoriaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalvarCategoria && nome == other.nome && parentId == other.parentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalvarCategoria')
          ..add('nome', nome)
          ..add('parentId', parentId))
        .toString();
  }
}

class SalvarCategoriaBuilder implements Builder<SalvarCategoria, SalvarCategoriaBuilder> {
  _$SalvarCategoria? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  SalvarCategoriaBuilder() {
    SalvarCategoria._defaults(this);
  }

  SalvarCategoriaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _parentId = $v.parentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalvarCategoria other) {
    _$v = other as _$SalvarCategoria;
  }

  @override
  void update(void Function(SalvarCategoriaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalvarCategoria build() => _build();

  _$SalvarCategoria _build() {
    final _$result = _$v ??
        _$SalvarCategoria._(
          nome: nome,
          parentId: parentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
