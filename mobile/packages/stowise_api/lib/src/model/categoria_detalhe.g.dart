// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CategoriaDetalhe extends CategoriaDetalhe {
  @override
  final String id;
  @override
  final String nome;
  @override
  final String? parentId;
  @override
  final String caminho;

  factory _$CategoriaDetalhe([void Function(CategoriaDetalheBuilder)? updates]) =>
      (CategoriaDetalheBuilder()..update(updates))._build();

  _$CategoriaDetalhe._({required this.id, required this.nome, this.parentId, required this.caminho}) : super._();
  @override
  CategoriaDetalhe rebuild(void Function(CategoriaDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CategoriaDetalheBuilder toBuilder() => CategoriaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoriaDetalhe &&
        id == other.id &&
        nome == other.nome &&
        parentId == other.parentId &&
        caminho == other.caminho;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, caminho.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CategoriaDetalhe')
          ..add('id', id)
          ..add('nome', nome)
          ..add('parentId', parentId)
          ..add('caminho', caminho))
        .toString();
  }
}

class CategoriaDetalheBuilder implements Builder<CategoriaDetalhe, CategoriaDetalheBuilder> {
  _$CategoriaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  String? _caminho;
  String? get caminho => _$this._caminho;
  set caminho(String? caminho) => _$this._caminho = caminho;

  CategoriaDetalheBuilder() {
    CategoriaDetalhe._defaults(this);
  }

  CategoriaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nome = $v.nome;
      _parentId = $v.parentId;
      _caminho = $v.caminho;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoriaDetalhe other) {
    _$v = other as _$CategoriaDetalhe;
  }

  @override
  void update(void Function(CategoriaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoriaDetalhe build() => _build();

  _$CategoriaDetalhe _build() {
    final _$result = _$v ??
        _$CategoriaDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CategoriaDetalhe', 'id'),
          nome: BuiltValueNullFieldError.checkNotNull(nome, r'CategoriaDetalhe', 'nome'),
          parentId: parentId,
          caminho: BuiltValueNullFieldError.checkNotNull(caminho, r'CategoriaDetalhe', 'caminho'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
