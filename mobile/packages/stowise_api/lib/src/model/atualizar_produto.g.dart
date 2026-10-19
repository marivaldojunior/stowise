// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AtualizarProduto extends AtualizarProduto {
  @override
  final String? descricao;
  @override
  final String? unidadeBase;
  @override
  final ClasseArmazenagem? classeArmazenagem;
  @override
  final bool controlaLote;
  @override
  final bool controlaValidade;
  @override
  final String? ncm;
  @override
  final String? cest;
  @override
  final String? categoriaId;
  @override
  final int? versao;

  factory _$AtualizarProduto([void Function(AtualizarProdutoBuilder)? updates]) =>
      (AtualizarProdutoBuilder()..update(updates))._build();

  _$AtualizarProduto._(
      {this.descricao,
      this.unidadeBase,
      this.classeArmazenagem,
      required this.controlaLote,
      required this.controlaValidade,
      this.ncm,
      this.cest,
      this.categoriaId,
      this.versao})
      : super._();
  @override
  AtualizarProduto rebuild(void Function(AtualizarProdutoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  AtualizarProdutoBuilder toBuilder() => AtualizarProdutoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AtualizarProduto &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        classeArmazenagem == other.classeArmazenagem &&
        controlaLote == other.controlaLote &&
        controlaValidade == other.controlaValidade &&
        ncm == other.ncm &&
        cest == other.cest &&
        categoriaId == other.categoriaId &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, controlaLote.hashCode);
    _$hash = $jc(_$hash, controlaValidade.hashCode);
    _$hash = $jc(_$hash, ncm.hashCode);
    _$hash = $jc(_$hash, cest.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AtualizarProduto')
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('controlaLote', controlaLote)
          ..add('controlaValidade', controlaValidade)
          ..add('ncm', ncm)
          ..add('cest', cest)
          ..add('categoriaId', categoriaId)
          ..add('versao', versao))
        .toString();
  }
}

class AtualizarProdutoBuilder implements Builder<AtualizarProduto, AtualizarProdutoBuilder> {
  _$AtualizarProduto? _$v;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  bool? _controlaLote;
  bool? get controlaLote => _$this._controlaLote;
  set controlaLote(bool? controlaLote) => _$this._controlaLote = controlaLote;

  bool? _controlaValidade;
  bool? get controlaValidade => _$this._controlaValidade;
  set controlaValidade(bool? controlaValidade) => _$this._controlaValidade = controlaValidade;

  String? _ncm;
  String? get ncm => _$this._ncm;
  set ncm(String? ncm) => _$this._ncm = ncm;

  String? _cest;
  String? get cest => _$this._cest;
  set cest(String? cest) => _$this._cest = cest;

  String? _categoriaId;
  String? get categoriaId => _$this._categoriaId;
  set categoriaId(String? categoriaId) => _$this._categoriaId = categoriaId;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  AtualizarProdutoBuilder() {
    AtualizarProduto._defaults(this);
  }

  AtualizarProdutoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _classeArmazenagem = $v.classeArmazenagem;
      _controlaLote = $v.controlaLote;
      _controlaValidade = $v.controlaValidade;
      _ncm = $v.ncm;
      _cest = $v.cest;
      _categoriaId = $v.categoriaId;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AtualizarProduto other) {
    _$v = other as _$AtualizarProduto;
  }

  @override
  void update(void Function(AtualizarProdutoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AtualizarProduto build() => _build();

  _$AtualizarProduto _build() {
    final _$result = _$v ??
        _$AtualizarProduto._(
          descricao: descricao,
          unidadeBase: unidadeBase,
          classeArmazenagem: classeArmazenagem,
          controlaLote: BuiltValueNullFieldError.checkNotNull(controlaLote, r'AtualizarProduto', 'controlaLote'),
          controlaValidade:
              BuiltValueNullFieldError.checkNotNull(controlaValidade, r'AtualizarProduto', 'controlaValidade'),
          ncm: ncm,
          cest: cest,
          categoriaId: categoriaId,
          versao: versao,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
