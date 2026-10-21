// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decisao_item_nota.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DecisaoItemNota extends DecisaoItemNota {
  @override
  final int numeroItem;
  @override
  final AcaoItemNota acao;
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final double? fatorConversao;
  @override
  final NovoProdutoNota? novoProduto;

  factory _$DecisaoItemNota([void Function(DecisaoItemNotaBuilder)? updates]) =>
      (DecisaoItemNotaBuilder()..update(updates))._build();

  _$DecisaoItemNota._(
      {required this.numeroItem,
      required this.acao,
      this.produtoId,
      this.embalagemId,
      this.fatorConversao,
      this.novoProduto})
      : super._();
  @override
  DecisaoItemNota rebuild(void Function(DecisaoItemNotaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  DecisaoItemNotaBuilder toBuilder() => DecisaoItemNotaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecisaoItemNota &&
        numeroItem == other.numeroItem &&
        acao == other.acao &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        fatorConversao == other.fatorConversao &&
        novoProduto == other.novoProduto;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numeroItem.hashCode);
    _$hash = $jc(_$hash, acao.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, novoProduto.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DecisaoItemNota')
          ..add('numeroItem', numeroItem)
          ..add('acao', acao)
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('fatorConversao', fatorConversao)
          ..add('novoProduto', novoProduto))
        .toString();
  }
}

class DecisaoItemNotaBuilder implements Builder<DecisaoItemNota, DecisaoItemNotaBuilder> {
  _$DecisaoItemNota? _$v;

  int? _numeroItem;
  int? get numeroItem => _$this._numeroItem;
  set numeroItem(int? numeroItem) => _$this._numeroItem = numeroItem;

  AcaoItemNota? _acao;
  AcaoItemNota? get acao => _$this._acao;
  set acao(AcaoItemNota? acao) => _$this._acao = acao;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  NovoProdutoNotaBuilder? _novoProduto;
  NovoProdutoNotaBuilder get novoProduto => _$this._novoProduto ??= NovoProdutoNotaBuilder();
  set novoProduto(NovoProdutoNotaBuilder? novoProduto) => _$this._novoProduto = novoProduto;

  DecisaoItemNotaBuilder() {
    DecisaoItemNota._defaults(this);
  }

  DecisaoItemNotaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numeroItem = $v.numeroItem;
      _acao = $v.acao;
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _fatorConversao = $v.fatorConversao;
      _novoProduto = $v.novoProduto?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecisaoItemNota other) {
    _$v = other as _$DecisaoItemNota;
  }

  @override
  void update(void Function(DecisaoItemNotaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecisaoItemNota build() => _build();

  _$DecisaoItemNota _build() {
    _$DecisaoItemNota _$result;
    try {
      _$result = _$v ??
          _$DecisaoItemNota._(
            numeroItem: BuiltValueNullFieldError.checkNotNull(numeroItem, r'DecisaoItemNota', 'numeroItem'),
            acao: BuiltValueNullFieldError.checkNotNull(acao, r'DecisaoItemNota', 'acao'),
            produtoId: produtoId,
            embalagemId: embalagemId,
            fatorConversao: fatorConversao,
            novoProduto: _novoProduto?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'novoProduto';
        _novoProduto?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'DecisaoItemNota', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
