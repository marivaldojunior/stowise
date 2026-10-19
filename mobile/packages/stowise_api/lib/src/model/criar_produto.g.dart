// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_produto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarProduto extends CriarProduto {
  @override
  final String? sku;
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
  final EmbalagemMedidas? embalagemBase;

  factory _$CriarProduto([void Function(CriarProdutoBuilder)? updates]) =>
      (CriarProdutoBuilder()..update(updates))._build();

  _$CriarProduto._(
      {this.sku,
      this.descricao,
      this.unidadeBase,
      this.classeArmazenagem,
      required this.controlaLote,
      required this.controlaValidade,
      this.ncm,
      this.cest,
      this.categoriaId,
      this.embalagemBase})
      : super._();
  @override
  CriarProduto rebuild(void Function(CriarProdutoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CriarProdutoBuilder toBuilder() => CriarProdutoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarProduto &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        classeArmazenagem == other.classeArmazenagem &&
        controlaLote == other.controlaLote &&
        controlaValidade == other.controlaValidade &&
        ncm == other.ncm &&
        cest == other.cest &&
        categoriaId == other.categoriaId &&
        embalagemBase == other.embalagemBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, controlaLote.hashCode);
    _$hash = $jc(_$hash, controlaValidade.hashCode);
    _$hash = $jc(_$hash, ncm.hashCode);
    _$hash = $jc(_$hash, cest.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, embalagemBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarProduto')
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('controlaLote', controlaLote)
          ..add('controlaValidade', controlaValidade)
          ..add('ncm', ncm)
          ..add('cest', cest)
          ..add('categoriaId', categoriaId)
          ..add('embalagemBase', embalagemBase))
        .toString();
  }
}

class CriarProdutoBuilder implements Builder<CriarProduto, CriarProdutoBuilder> {
  _$CriarProduto? _$v;

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

  EmbalagemMedidasBuilder? _embalagemBase;
  EmbalagemMedidasBuilder get embalagemBase => _$this._embalagemBase ??= EmbalagemMedidasBuilder();
  set embalagemBase(EmbalagemMedidasBuilder? embalagemBase) => _$this._embalagemBase = embalagemBase;

  CriarProdutoBuilder() {
    CriarProduto._defaults(this);
  }

  CriarProdutoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _classeArmazenagem = $v.classeArmazenagem;
      _controlaLote = $v.controlaLote;
      _controlaValidade = $v.controlaValidade;
      _ncm = $v.ncm;
      _cest = $v.cest;
      _categoriaId = $v.categoriaId;
      _embalagemBase = $v.embalagemBase?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarProduto other) {
    _$v = other as _$CriarProduto;
  }

  @override
  void update(void Function(CriarProdutoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarProduto build() => _build();

  _$CriarProduto _build() {
    _$CriarProduto _$result;
    try {
      _$result = _$v ??
          _$CriarProduto._(
            sku: sku,
            descricao: descricao,
            unidadeBase: unidadeBase,
            classeArmazenagem: classeArmazenagem,
            controlaLote: BuiltValueNullFieldError.checkNotNull(controlaLote, r'CriarProduto', 'controlaLote'),
            controlaValidade:
                BuiltValueNullFieldError.checkNotNull(controlaValidade, r'CriarProduto', 'controlaValidade'),
            ncm: ncm,
            cest: cest,
            categoriaId: categoriaId,
            embalagemBase: _embalagemBase?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'embalagemBase';
        _embalagemBase?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'CriarProduto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
