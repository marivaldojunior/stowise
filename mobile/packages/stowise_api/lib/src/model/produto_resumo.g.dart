// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProdutoResumo extends ProdutoResumo {
  @override
  final String id;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final ClasseArmazenagem classeArmazenagem;
  @override
  final String? categoriaId;
  @override
  final bool ativo;
  @override
  final StatusCadastro statusCadastro;

  factory _$ProdutoResumo([void Function(ProdutoResumoBuilder)? updates]) =>
      (ProdutoResumoBuilder()..update(updates))._build();

  _$ProdutoResumo._(
      {required this.id,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.classeArmazenagem,
      this.categoriaId,
      required this.ativo,
      required this.statusCadastro})
      : super._();
  @override
  ProdutoResumo rebuild(void Function(ProdutoResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ProdutoResumoBuilder toBuilder() => ProdutoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProdutoResumo &&
        id == other.id &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        classeArmazenagem == other.classeArmazenagem &&
        categoriaId == other.categoriaId &&
        ativo == other.ativo &&
        statusCadastro == other.statusCadastro;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, ativo.hashCode);
    _$hash = $jc(_$hash, statusCadastro.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProdutoResumo')
          ..add('id', id)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('categoriaId', categoriaId)
          ..add('ativo', ativo)
          ..add('statusCadastro', statusCadastro))
        .toString();
  }
}

class ProdutoResumoBuilder implements Builder<ProdutoResumo, ProdutoResumoBuilder> {
  _$ProdutoResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  String? _categoriaId;
  String? get categoriaId => _$this._categoriaId;
  set categoriaId(String? categoriaId) => _$this._categoriaId = categoriaId;

  bool? _ativo;
  bool? get ativo => _$this._ativo;
  set ativo(bool? ativo) => _$this._ativo = ativo;

  StatusCadastro? _statusCadastro;
  StatusCadastro? get statusCadastro => _$this._statusCadastro;
  set statusCadastro(StatusCadastro? statusCadastro) => _$this._statusCadastro = statusCadastro;

  ProdutoResumoBuilder() {
    ProdutoResumo._defaults(this);
  }

  ProdutoResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _classeArmazenagem = $v.classeArmazenagem;
      _categoriaId = $v.categoriaId;
      _ativo = $v.ativo;
      _statusCadastro = $v.statusCadastro;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProdutoResumo other) {
    _$v = other as _$ProdutoResumo;
  }

  @override
  void update(void Function(ProdutoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProdutoResumo build() => _build();

  _$ProdutoResumo _build() {
    final _$result = _$v ??
        _$ProdutoResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProdutoResumo', 'id'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'ProdutoResumo', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ProdutoResumo', 'descricao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'ProdutoResumo', 'unidadeBase'),
          classeArmazenagem:
              BuiltValueNullFieldError.checkNotNull(classeArmazenagem, r'ProdutoResumo', 'classeArmazenagem'),
          categoriaId: categoriaId,
          ativo: BuiltValueNullFieldError.checkNotNull(ativo, r'ProdutoResumo', 'ativo'),
          statusCadastro: BuiltValueNullFieldError.checkNotNull(statusCadastro, r'ProdutoResumo', 'statusCadastro'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
