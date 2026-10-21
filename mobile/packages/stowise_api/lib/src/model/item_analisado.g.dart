// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_analisado.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemAnalisado extends ItemAnalisado {
  @override
  final ItemNota item;
  @override
  final OrigemCasamento origem;
  @override
  final CasamentoItem? casamento;
  @override
  final MetodoSimilaridade? metodoSugestoes;
  @override
  final BuiltList<ProdutoSimilar> sugestoes;
  @override
  final bool requerConfirmacao;
  @override
  final ConversaoItem conversao;
  @override
  final BuiltList<LoteInferido> lotes;
  @override
  final BuiltList<AlertaItemNota> alertas;

  factory _$ItemAnalisado([void Function(ItemAnalisadoBuilder)? updates]) =>
      (ItemAnalisadoBuilder()..update(updates))._build();

  _$ItemAnalisado._(
      {required this.item,
      required this.origem,
      this.casamento,
      this.metodoSugestoes,
      required this.sugestoes,
      required this.requerConfirmacao,
      required this.conversao,
      required this.lotes,
      required this.alertas})
      : super._();
  @override
  ItemAnalisado rebuild(void Function(ItemAnalisadoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ItemAnalisadoBuilder toBuilder() => ItemAnalisadoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemAnalisado &&
        item == other.item &&
        origem == other.origem &&
        casamento == other.casamento &&
        metodoSugestoes == other.metodoSugestoes &&
        sugestoes == other.sugestoes &&
        requerConfirmacao == other.requerConfirmacao &&
        conversao == other.conversao &&
        lotes == other.lotes &&
        alertas == other.alertas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, origem.hashCode);
    _$hash = $jc(_$hash, casamento.hashCode);
    _$hash = $jc(_$hash, metodoSugestoes.hashCode);
    _$hash = $jc(_$hash, sugestoes.hashCode);
    _$hash = $jc(_$hash, requerConfirmacao.hashCode);
    _$hash = $jc(_$hash, conversao.hashCode);
    _$hash = $jc(_$hash, lotes.hashCode);
    _$hash = $jc(_$hash, alertas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemAnalisado')
          ..add('item', item)
          ..add('origem', origem)
          ..add('casamento', casamento)
          ..add('metodoSugestoes', metodoSugestoes)
          ..add('sugestoes', sugestoes)
          ..add('requerConfirmacao', requerConfirmacao)
          ..add('conversao', conversao)
          ..add('lotes', lotes)
          ..add('alertas', alertas))
        .toString();
  }
}

class ItemAnalisadoBuilder implements Builder<ItemAnalisado, ItemAnalisadoBuilder> {
  _$ItemAnalisado? _$v;

  ItemNotaBuilder? _item;
  ItemNotaBuilder get item => _$this._item ??= ItemNotaBuilder();
  set item(ItemNotaBuilder? item) => _$this._item = item;

  OrigemCasamento? _origem;
  OrigemCasamento? get origem => _$this._origem;
  set origem(OrigemCasamento? origem) => _$this._origem = origem;

  CasamentoItemBuilder? _casamento;
  CasamentoItemBuilder get casamento => _$this._casamento ??= CasamentoItemBuilder();
  set casamento(CasamentoItemBuilder? casamento) => _$this._casamento = casamento;

  MetodoSimilaridade? _metodoSugestoes;
  MetodoSimilaridade? get metodoSugestoes => _$this._metodoSugestoes;
  set metodoSugestoes(MetodoSimilaridade? metodoSugestoes) => _$this._metodoSugestoes = metodoSugestoes;

  ListBuilder<ProdutoSimilar>? _sugestoes;
  ListBuilder<ProdutoSimilar> get sugestoes => _$this._sugestoes ??= ListBuilder<ProdutoSimilar>();
  set sugestoes(ListBuilder<ProdutoSimilar>? sugestoes) => _$this._sugestoes = sugestoes;

  bool? _requerConfirmacao;
  bool? get requerConfirmacao => _$this._requerConfirmacao;
  set requerConfirmacao(bool? requerConfirmacao) => _$this._requerConfirmacao = requerConfirmacao;

  ConversaoItemBuilder? _conversao;
  ConversaoItemBuilder get conversao => _$this._conversao ??= ConversaoItemBuilder();
  set conversao(ConversaoItemBuilder? conversao) => _$this._conversao = conversao;

  ListBuilder<LoteInferido>? _lotes;
  ListBuilder<LoteInferido> get lotes => _$this._lotes ??= ListBuilder<LoteInferido>();
  set lotes(ListBuilder<LoteInferido>? lotes) => _$this._lotes = lotes;

  ListBuilder<AlertaItemNota>? _alertas;
  ListBuilder<AlertaItemNota> get alertas => _$this._alertas ??= ListBuilder<AlertaItemNota>();
  set alertas(ListBuilder<AlertaItemNota>? alertas) => _$this._alertas = alertas;

  ItemAnalisadoBuilder() {
    ItemAnalisado._defaults(this);
  }

  ItemAnalisadoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item.toBuilder();
      _origem = $v.origem;
      _casamento = $v.casamento?.toBuilder();
      _metodoSugestoes = $v.metodoSugestoes;
      _sugestoes = $v.sugestoes.toBuilder();
      _requerConfirmacao = $v.requerConfirmacao;
      _conversao = $v.conversao.toBuilder();
      _lotes = $v.lotes.toBuilder();
      _alertas = $v.alertas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemAnalisado other) {
    _$v = other as _$ItemAnalisado;
  }

  @override
  void update(void Function(ItemAnalisadoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemAnalisado build() => _build();

  _$ItemAnalisado _build() {
    _$ItemAnalisado _$result;
    try {
      _$result = _$v ??
          _$ItemAnalisado._(
            item: item.build(),
            origem: BuiltValueNullFieldError.checkNotNull(origem, r'ItemAnalisado', 'origem'),
            casamento: _casamento?.build(),
            metodoSugestoes: metodoSugestoes,
            sugestoes: sugestoes.build(),
            requerConfirmacao:
                BuiltValueNullFieldError.checkNotNull(requerConfirmacao, r'ItemAnalisado', 'requerConfirmacao'),
            conversao: conversao.build(),
            lotes: lotes.build(),
            alertas: alertas.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        item.build();

        _$failedField = 'casamento';
        _casamento?.build();

        _$failedField = 'sugestoes';
        sugestoes.build();

        _$failedField = 'conversao';
        conversao.build();
        _$failedField = 'lotes';
        lotes.build();
        _$failedField = 'alertas';
        alertas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ItemAnalisado', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
