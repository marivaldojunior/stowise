// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProdutoDetalhe extends ProdutoDetalhe {
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
  final bool ativo;
  @override
  final int versao;
  @override
  final BuiltList<EmbalagemDetalhe> embalagens;

  factory _$ProdutoDetalhe([void Function(ProdutoDetalheBuilder)? updates]) =>
      (ProdutoDetalheBuilder()..update(updates))._build();

  _$ProdutoDetalhe._(
      {required this.id,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.classeArmazenagem,
      required this.controlaLote,
      required this.controlaValidade,
      this.ncm,
      this.cest,
      this.categoriaId,
      required this.ativo,
      required this.versao,
      required this.embalagens})
      : super._();
  @override
  ProdutoDetalhe rebuild(void Function(ProdutoDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ProdutoDetalheBuilder toBuilder() => ProdutoDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProdutoDetalhe &&
        id == other.id &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        classeArmazenagem == other.classeArmazenagem &&
        controlaLote == other.controlaLote &&
        controlaValidade == other.controlaValidade &&
        ncm == other.ncm &&
        cest == other.cest &&
        categoriaId == other.categoriaId &&
        ativo == other.ativo &&
        versao == other.versao &&
        embalagens == other.embalagens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, controlaLote.hashCode);
    _$hash = $jc(_$hash, controlaValidade.hashCode);
    _$hash = $jc(_$hash, ncm.hashCode);
    _$hash = $jc(_$hash, cest.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, ativo.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jc(_$hash, embalagens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProdutoDetalhe')
          ..add('id', id)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('controlaLote', controlaLote)
          ..add('controlaValidade', controlaValidade)
          ..add('ncm', ncm)
          ..add('cest', cest)
          ..add('categoriaId', categoriaId)
          ..add('ativo', ativo)
          ..add('versao', versao)
          ..add('embalagens', embalagens))
        .toString();
  }
}

class ProdutoDetalheBuilder implements Builder<ProdutoDetalhe, ProdutoDetalheBuilder> {
  _$ProdutoDetalhe? _$v;

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

  bool? _ativo;
  bool? get ativo => _$this._ativo;
  set ativo(bool? ativo) => _$this._ativo = ativo;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  ListBuilder<EmbalagemDetalhe>? _embalagens;
  ListBuilder<EmbalagemDetalhe> get embalagens => _$this._embalagens ??= ListBuilder<EmbalagemDetalhe>();
  set embalagens(ListBuilder<EmbalagemDetalhe>? embalagens) => _$this._embalagens = embalagens;

  ProdutoDetalheBuilder() {
    ProdutoDetalhe._defaults(this);
  }

  ProdutoDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _classeArmazenagem = $v.classeArmazenagem;
      _controlaLote = $v.controlaLote;
      _controlaValidade = $v.controlaValidade;
      _ncm = $v.ncm;
      _cest = $v.cest;
      _categoriaId = $v.categoriaId;
      _ativo = $v.ativo;
      _versao = $v.versao;
      _embalagens = $v.embalagens.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProdutoDetalhe other) {
    _$v = other as _$ProdutoDetalhe;
  }

  @override
  void update(void Function(ProdutoDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProdutoDetalhe build() => _build();

  _$ProdutoDetalhe _build() {
    _$ProdutoDetalhe _$result;
    try {
      _$result = _$v ??
          _$ProdutoDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ProdutoDetalhe', 'id'),
            sku: BuiltValueNullFieldError.checkNotNull(sku, r'ProdutoDetalhe', 'sku'),
            descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ProdutoDetalhe', 'descricao'),
            unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'ProdutoDetalhe', 'unidadeBase'),
            classeArmazenagem:
                BuiltValueNullFieldError.checkNotNull(classeArmazenagem, r'ProdutoDetalhe', 'classeArmazenagem'),
            controlaLote: BuiltValueNullFieldError.checkNotNull(controlaLote, r'ProdutoDetalhe', 'controlaLote'),
            controlaValidade:
                BuiltValueNullFieldError.checkNotNull(controlaValidade, r'ProdutoDetalhe', 'controlaValidade'),
            ncm: ncm,
            cest: cest,
            categoriaId: categoriaId,
            ativo: BuiltValueNullFieldError.checkNotNull(ativo, r'ProdutoDetalhe', 'ativo'),
            versao: BuiltValueNullFieldError.checkNotNull(versao, r'ProdutoDetalhe', 'versao'),
            embalagens: embalagens.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'embalagens';
        embalagens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ProdutoDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
