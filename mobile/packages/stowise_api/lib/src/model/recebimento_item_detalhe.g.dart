// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recebimento_item_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecebimentoItemDetalhe extends RecebimentoItemDetalhe {
  @override
  final String id;
  @override
  final int numeroItem;
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final bool controlaLote;
  @override
  final bool controlaValidade;
  @override
  final String embalagemId;
  @override
  final String codigoFornecedor;
  @override
  final String descricaoNota;
  @override
  final String unidadeNota;
  @override
  final double quantidadeNota;
  @override
  final double fatorConversao;
  @override
  final double quantidade;
  @override
  final BuiltList<LoteRecebido> lotes;
  @override
  final double? quantidadeConferida;
  @override
  final BuiltList<LoteRecebido> lotesConferidos;
  @override
  final bool divergente;
  @override
  final String? conferidoPor;
  @override
  final DateTime? conferidoEm;

  factory _$RecebimentoItemDetalhe([void Function(RecebimentoItemDetalheBuilder)? updates]) =>
      (RecebimentoItemDetalheBuilder()..update(updates))._build();

  _$RecebimentoItemDetalhe._(
      {required this.id,
      required this.numeroItem,
      required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.controlaLote,
      required this.controlaValidade,
      required this.embalagemId,
      required this.codigoFornecedor,
      required this.descricaoNota,
      required this.unidadeNota,
      required this.quantidadeNota,
      required this.fatorConversao,
      required this.quantidade,
      required this.lotes,
      this.quantidadeConferida,
      required this.lotesConferidos,
      required this.divergente,
      this.conferidoPor,
      this.conferidoEm})
      : super._();
  @override
  RecebimentoItemDetalhe rebuild(void Function(RecebimentoItemDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecebimentoItemDetalheBuilder toBuilder() => RecebimentoItemDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecebimentoItemDetalhe &&
        id == other.id &&
        numeroItem == other.numeroItem &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        controlaLote == other.controlaLote &&
        controlaValidade == other.controlaValidade &&
        embalagemId == other.embalagemId &&
        codigoFornecedor == other.codigoFornecedor &&
        descricaoNota == other.descricaoNota &&
        unidadeNota == other.unidadeNota &&
        quantidadeNota == other.quantidadeNota &&
        fatorConversao == other.fatorConversao &&
        quantidade == other.quantidade &&
        lotes == other.lotes &&
        quantidadeConferida == other.quantidadeConferida &&
        lotesConferidos == other.lotesConferidos &&
        divergente == other.divergente &&
        conferidoPor == other.conferidoPor &&
        conferidoEm == other.conferidoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, numeroItem.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, controlaLote.hashCode);
    _$hash = $jc(_$hash, controlaValidade.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, codigoFornecedor.hashCode);
    _$hash = $jc(_$hash, descricaoNota.hashCode);
    _$hash = $jc(_$hash, unidadeNota.hashCode);
    _$hash = $jc(_$hash, quantidadeNota.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, lotes.hashCode);
    _$hash = $jc(_$hash, quantidadeConferida.hashCode);
    _$hash = $jc(_$hash, lotesConferidos.hashCode);
    _$hash = $jc(_$hash, divergente.hashCode);
    _$hash = $jc(_$hash, conferidoPor.hashCode);
    _$hash = $jc(_$hash, conferidoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecebimentoItemDetalhe')
          ..add('id', id)
          ..add('numeroItem', numeroItem)
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('controlaLote', controlaLote)
          ..add('controlaValidade', controlaValidade)
          ..add('embalagemId', embalagemId)
          ..add('codigoFornecedor', codigoFornecedor)
          ..add('descricaoNota', descricaoNota)
          ..add('unidadeNota', unidadeNota)
          ..add('quantidadeNota', quantidadeNota)
          ..add('fatorConversao', fatorConversao)
          ..add('quantidade', quantidade)
          ..add('lotes', lotes)
          ..add('quantidadeConferida', quantidadeConferida)
          ..add('lotesConferidos', lotesConferidos)
          ..add('divergente', divergente)
          ..add('conferidoPor', conferidoPor)
          ..add('conferidoEm', conferidoEm))
        .toString();
  }
}

class RecebimentoItemDetalheBuilder implements Builder<RecebimentoItemDetalhe, RecebimentoItemDetalheBuilder> {
  _$RecebimentoItemDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _numeroItem;
  int? get numeroItem => _$this._numeroItem;
  set numeroItem(int? numeroItem) => _$this._numeroItem = numeroItem;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  bool? _controlaLote;
  bool? get controlaLote => _$this._controlaLote;
  set controlaLote(bool? controlaLote) => _$this._controlaLote = controlaLote;

  bool? _controlaValidade;
  bool? get controlaValidade => _$this._controlaValidade;
  set controlaValidade(bool? controlaValidade) => _$this._controlaValidade = controlaValidade;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _codigoFornecedor;
  String? get codigoFornecedor => _$this._codigoFornecedor;
  set codigoFornecedor(String? codigoFornecedor) => _$this._codigoFornecedor = codigoFornecedor;

  String? _descricaoNota;
  String? get descricaoNota => _$this._descricaoNota;
  set descricaoNota(String? descricaoNota) => _$this._descricaoNota = descricaoNota;

  String? _unidadeNota;
  String? get unidadeNota => _$this._unidadeNota;
  set unidadeNota(String? unidadeNota) => _$this._unidadeNota = unidadeNota;

  double? _quantidadeNota;
  double? get quantidadeNota => _$this._quantidadeNota;
  set quantidadeNota(double? quantidadeNota) => _$this._quantidadeNota = quantidadeNota;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  ListBuilder<LoteRecebido>? _lotes;
  ListBuilder<LoteRecebido> get lotes => _$this._lotes ??= ListBuilder<LoteRecebido>();
  set lotes(ListBuilder<LoteRecebido>? lotes) => _$this._lotes = lotes;

  double? _quantidadeConferida;
  double? get quantidadeConferida => _$this._quantidadeConferida;
  set quantidadeConferida(double? quantidadeConferida) => _$this._quantidadeConferida = quantidadeConferida;

  ListBuilder<LoteRecebido>? _lotesConferidos;
  ListBuilder<LoteRecebido> get lotesConferidos => _$this._lotesConferidos ??= ListBuilder<LoteRecebido>();
  set lotesConferidos(ListBuilder<LoteRecebido>? lotesConferidos) => _$this._lotesConferidos = lotesConferidos;

  bool? _divergente;
  bool? get divergente => _$this._divergente;
  set divergente(bool? divergente) => _$this._divergente = divergente;

  String? _conferidoPor;
  String? get conferidoPor => _$this._conferidoPor;
  set conferidoPor(String? conferidoPor) => _$this._conferidoPor = conferidoPor;

  DateTime? _conferidoEm;
  DateTime? get conferidoEm => _$this._conferidoEm;
  set conferidoEm(DateTime? conferidoEm) => _$this._conferidoEm = conferidoEm;

  RecebimentoItemDetalheBuilder() {
    RecebimentoItemDetalhe._defaults(this);
  }

  RecebimentoItemDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _numeroItem = $v.numeroItem;
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _controlaLote = $v.controlaLote;
      _controlaValidade = $v.controlaValidade;
      _embalagemId = $v.embalagemId;
      _codigoFornecedor = $v.codigoFornecedor;
      _descricaoNota = $v.descricaoNota;
      _unidadeNota = $v.unidadeNota;
      _quantidadeNota = $v.quantidadeNota;
      _fatorConversao = $v.fatorConversao;
      _quantidade = $v.quantidade;
      _lotes = $v.lotes.toBuilder();
      _quantidadeConferida = $v.quantidadeConferida;
      _lotesConferidos = $v.lotesConferidos.toBuilder();
      _divergente = $v.divergente;
      _conferidoPor = $v.conferidoPor;
      _conferidoEm = $v.conferidoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecebimentoItemDetalhe other) {
    _$v = other as _$RecebimentoItemDetalhe;
  }

  @override
  void update(void Function(RecebimentoItemDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecebimentoItemDetalhe build() => _build();

  _$RecebimentoItemDetalhe _build() {
    _$RecebimentoItemDetalhe _$result;
    try {
      _$result = _$v ??
          _$RecebimentoItemDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'RecebimentoItemDetalhe', 'id'),
            numeroItem: BuiltValueNullFieldError.checkNotNull(numeroItem, r'RecebimentoItemDetalhe', 'numeroItem'),
            produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'RecebimentoItemDetalhe', 'produtoId'),
            sku: BuiltValueNullFieldError.checkNotNull(sku, r'RecebimentoItemDetalhe', 'sku'),
            descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'RecebimentoItemDetalhe', 'descricao'),
            unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'RecebimentoItemDetalhe', 'unidadeBase'),
            controlaLote:
                BuiltValueNullFieldError.checkNotNull(controlaLote, r'RecebimentoItemDetalhe', 'controlaLote'),
            controlaValidade:
                BuiltValueNullFieldError.checkNotNull(controlaValidade, r'RecebimentoItemDetalhe', 'controlaValidade'),
            embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'RecebimentoItemDetalhe', 'embalagemId'),
            codigoFornecedor:
                BuiltValueNullFieldError.checkNotNull(codigoFornecedor, r'RecebimentoItemDetalhe', 'codigoFornecedor'),
            descricaoNota:
                BuiltValueNullFieldError.checkNotNull(descricaoNota, r'RecebimentoItemDetalhe', 'descricaoNota'),
            unidadeNota: BuiltValueNullFieldError.checkNotNull(unidadeNota, r'RecebimentoItemDetalhe', 'unidadeNota'),
            quantidadeNota:
                BuiltValueNullFieldError.checkNotNull(quantidadeNota, r'RecebimentoItemDetalhe', 'quantidadeNota'),
            fatorConversao:
                BuiltValueNullFieldError.checkNotNull(fatorConversao, r'RecebimentoItemDetalhe', 'fatorConversao'),
            quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'RecebimentoItemDetalhe', 'quantidade'),
            lotes: lotes.build(),
            quantidadeConferida: quantidadeConferida,
            lotesConferidos: lotesConferidos.build(),
            divergente: BuiltValueNullFieldError.checkNotNull(divergente, r'RecebimentoItemDetalhe', 'divergente'),
            conferidoPor: conferidoPor,
            conferidoEm: conferidoEm,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lotes';
        lotes.build();

        _$failedField = 'lotesConferidos';
        lotesConferidos.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RecebimentoItemDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
