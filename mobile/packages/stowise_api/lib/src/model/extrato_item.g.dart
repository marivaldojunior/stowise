// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extrato_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExtratoItem extends ExtratoItem {
  @override
  final String id;
  @override
  final TipoMovimentacao tipo;
  @override
  final DateTime ocorridoEm;
  @override
  final DateTime recebidoEm;
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String? loteNumero;
  @override
  final String? enderecoOrigemCodigo;
  @override
  final String? enderecoDestinoCodigo;
  @override
  final double quantidade;
  @override
  final String? documentoReferencia;
  @override
  final String? observacao;
  @override
  final String usuarioId;

  factory _$ExtratoItem([void Function(ExtratoItemBuilder)? updates]) =>
      (ExtratoItemBuilder()..update(updates))._build();

  _$ExtratoItem._(
      {required this.id,
      required this.tipo,
      required this.ocorridoEm,
      required this.recebidoEm,
      required this.produtoId,
      required this.sku,
      this.loteNumero,
      this.enderecoOrigemCodigo,
      this.enderecoDestinoCodigo,
      required this.quantidade,
      this.documentoReferencia,
      this.observacao,
      required this.usuarioId})
      : super._();
  @override
  ExtratoItem rebuild(void Function(ExtratoItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ExtratoItemBuilder toBuilder() => ExtratoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExtratoItem &&
        id == other.id &&
        tipo == other.tipo &&
        ocorridoEm == other.ocorridoEm &&
        recebidoEm == other.recebidoEm &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        loteNumero == other.loteNumero &&
        enderecoOrigemCodigo == other.enderecoOrigemCodigo &&
        enderecoDestinoCodigo == other.enderecoDestinoCodigo &&
        quantidade == other.quantidade &&
        documentoReferencia == other.documentoReferencia &&
        observacao == other.observacao &&
        usuarioId == other.usuarioId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jc(_$hash, recebidoEm.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, enderecoOrigemCodigo.hashCode);
    _$hash = $jc(_$hash, enderecoDestinoCodigo.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jc(_$hash, observacao.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExtratoItem')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('ocorridoEm', ocorridoEm)
          ..add('recebidoEm', recebidoEm)
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('loteNumero', loteNumero)
          ..add('enderecoOrigemCodigo', enderecoOrigemCodigo)
          ..add('enderecoDestinoCodigo', enderecoDestinoCodigo)
          ..add('quantidade', quantidade)
          ..add('documentoReferencia', documentoReferencia)
          ..add('observacao', observacao)
          ..add('usuarioId', usuarioId))
        .toString();
  }
}

class ExtratoItemBuilder implements Builder<ExtratoItem, ExtratoItemBuilder> {
  _$ExtratoItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoMovimentacao? _tipo;
  TipoMovimentacao? get tipo => _$this._tipo;
  set tipo(TipoMovimentacao? tipo) => _$this._tipo = tipo;

  DateTime? _ocorridoEm;
  DateTime? get ocorridoEm => _$this._ocorridoEm;
  set ocorridoEm(DateTime? ocorridoEm) => _$this._ocorridoEm = ocorridoEm;

  DateTime? _recebidoEm;
  DateTime? get recebidoEm => _$this._recebidoEm;
  set recebidoEm(DateTime? recebidoEm) => _$this._recebidoEm = recebidoEm;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  String? _enderecoOrigemCodigo;
  String? get enderecoOrigemCodigo => _$this._enderecoOrigemCodigo;
  set enderecoOrigemCodigo(String? enderecoOrigemCodigo) => _$this._enderecoOrigemCodigo = enderecoOrigemCodigo;

  String? _enderecoDestinoCodigo;
  String? get enderecoDestinoCodigo => _$this._enderecoDestinoCodigo;
  set enderecoDestinoCodigo(String? enderecoDestinoCodigo) => _$this._enderecoDestinoCodigo = enderecoDestinoCodigo;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _documentoReferencia;
  String? get documentoReferencia => _$this._documentoReferencia;
  set documentoReferencia(String? documentoReferencia) => _$this._documentoReferencia = documentoReferencia;

  String? _observacao;
  String? get observacao => _$this._observacao;
  set observacao(String? observacao) => _$this._observacao = observacao;

  String? _usuarioId;
  String? get usuarioId => _$this._usuarioId;
  set usuarioId(String? usuarioId) => _$this._usuarioId = usuarioId;

  ExtratoItemBuilder() {
    ExtratoItem._defaults(this);
  }

  ExtratoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _ocorridoEm = $v.ocorridoEm;
      _recebidoEm = $v.recebidoEm;
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _loteNumero = $v.loteNumero;
      _enderecoOrigemCodigo = $v.enderecoOrigemCodigo;
      _enderecoDestinoCodigo = $v.enderecoDestinoCodigo;
      _quantidade = $v.quantidade;
      _documentoReferencia = $v.documentoReferencia;
      _observacao = $v.observacao;
      _usuarioId = $v.usuarioId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExtratoItem other) {
    _$v = other as _$ExtratoItem;
  }

  @override
  void update(void Function(ExtratoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExtratoItem build() => _build();

  _$ExtratoItem _build() {
    final _$result = _$v ??
        _$ExtratoItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ExtratoItem', 'id'),
          tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'ExtratoItem', 'tipo'),
          ocorridoEm: BuiltValueNullFieldError.checkNotNull(ocorridoEm, r'ExtratoItem', 'ocorridoEm'),
          recebidoEm: BuiltValueNullFieldError.checkNotNull(recebidoEm, r'ExtratoItem', 'recebidoEm'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'ExtratoItem', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'ExtratoItem', 'sku'),
          loteNumero: loteNumero,
          enderecoOrigemCodigo: enderecoOrigemCodigo,
          enderecoDestinoCodigo: enderecoDestinoCodigo,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'ExtratoItem', 'quantidade'),
          documentoReferencia: documentoReferencia,
          observacao: observacao,
          usuarioId: BuiltValueNullFieldError.checkNotNull(usuarioId, r'ExtratoItem', 'usuarioId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
