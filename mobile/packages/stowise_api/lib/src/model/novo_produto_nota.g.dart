// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novo_produto_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NovoProdutoNota extends NovoProdutoNota {
  @override
  final String? sku;
  @override
  final String? descricao;
  @override
  final String? categoriaId;
  @override
  final ClasseArmazenagem? classeArmazenagem;

  factory _$NovoProdutoNota([void Function(NovoProdutoNotaBuilder)? updates]) =>
      (NovoProdutoNotaBuilder()..update(updates))._build();

  _$NovoProdutoNota._({this.sku, this.descricao, this.categoriaId, this.classeArmazenagem}) : super._();
  @override
  NovoProdutoNota rebuild(void Function(NovoProdutoNotaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  NovoProdutoNotaBuilder toBuilder() => NovoProdutoNotaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NovoProdutoNota &&
        sku == other.sku &&
        descricao == other.descricao &&
        categoriaId == other.categoriaId &&
        classeArmazenagem == other.classeArmazenagem;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NovoProdutoNota')
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('categoriaId', categoriaId)
          ..add('classeArmazenagem', classeArmazenagem))
        .toString();
  }
}

class NovoProdutoNotaBuilder implements Builder<NovoProdutoNota, NovoProdutoNotaBuilder> {
  _$NovoProdutoNota? _$v;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _categoriaId;
  String? get categoriaId => _$this._categoriaId;
  set categoriaId(String? categoriaId) => _$this._categoriaId = categoriaId;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  NovoProdutoNotaBuilder() {
    NovoProdutoNota._defaults(this);
  }

  NovoProdutoNotaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sku = $v.sku;
      _descricao = $v.descricao;
      _categoriaId = $v.categoriaId;
      _classeArmazenagem = $v.classeArmazenagem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NovoProdutoNota other) {
    _$v = other as _$NovoProdutoNota;
  }

  @override
  void update(void Function(NovoProdutoNotaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NovoProdutoNota build() => _build();

  _$NovoProdutoNota _build() {
    final _$result = _$v ??
        _$NovoProdutoNota._(
          sku: sku,
          descricao: descricao,
          categoriaId: categoriaId,
          classeArmazenagem: classeArmazenagem,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
