// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserva_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReservaDetalhe extends ReservaDetalhe {
  @override
  final String id;
  @override
  final String enderecoId;
  @override
  final String produtoId;
  @override
  final String? loteId;
  @override
  final String? loteNumero;
  @override
  final double quantidade;
  @override
  final String? documentoReferencia;
  @override
  final StatusReserva status;
  @override
  final String criadaPor;
  @override
  final DateTime criadaEm;
  @override
  final String? encerradaPor;
  @override
  final DateTime? encerradaEm;
  @override
  final String? movimentacaoId;

  factory _$ReservaDetalhe([void Function(ReservaDetalheBuilder)? updates]) =>
      (ReservaDetalheBuilder()..update(updates))._build();

  _$ReservaDetalhe._(
      {required this.id,
      required this.enderecoId,
      required this.produtoId,
      this.loteId,
      this.loteNumero,
      required this.quantidade,
      this.documentoReferencia,
      required this.status,
      required this.criadaPor,
      required this.criadaEm,
      this.encerradaPor,
      this.encerradaEm,
      this.movimentacaoId})
      : super._();
  @override
  ReservaDetalhe rebuild(void Function(ReservaDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ReservaDetalheBuilder toBuilder() => ReservaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReservaDetalhe &&
        id == other.id &&
        enderecoId == other.enderecoId &&
        produtoId == other.produtoId &&
        loteId == other.loteId &&
        loteNumero == other.loteNumero &&
        quantidade == other.quantidade &&
        documentoReferencia == other.documentoReferencia &&
        status == other.status &&
        criadaPor == other.criadaPor &&
        criadaEm == other.criadaEm &&
        encerradaPor == other.encerradaPor &&
        encerradaEm == other.encerradaEm &&
        movimentacaoId == other.movimentacaoId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, criadaPor.hashCode);
    _$hash = $jc(_$hash, criadaEm.hashCode);
    _$hash = $jc(_$hash, encerradaPor.hashCode);
    _$hash = $jc(_$hash, encerradaEm.hashCode);
    _$hash = $jc(_$hash, movimentacaoId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReservaDetalhe')
          ..add('id', id)
          ..add('enderecoId', enderecoId)
          ..add('produtoId', produtoId)
          ..add('loteId', loteId)
          ..add('loteNumero', loteNumero)
          ..add('quantidade', quantidade)
          ..add('documentoReferencia', documentoReferencia)
          ..add('status', status)
          ..add('criadaPor', criadaPor)
          ..add('criadaEm', criadaEm)
          ..add('encerradaPor', encerradaPor)
          ..add('encerradaEm', encerradaEm)
          ..add('movimentacaoId', movimentacaoId))
        .toString();
  }
}

class ReservaDetalheBuilder implements Builder<ReservaDetalhe, ReservaDetalheBuilder> {
  _$ReservaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _documentoReferencia;
  String? get documentoReferencia => _$this._documentoReferencia;
  set documentoReferencia(String? documentoReferencia) => _$this._documentoReferencia = documentoReferencia;

  StatusReserva? _status;
  StatusReserva? get status => _$this._status;
  set status(StatusReserva? status) => _$this._status = status;

  String? _criadaPor;
  String? get criadaPor => _$this._criadaPor;
  set criadaPor(String? criadaPor) => _$this._criadaPor = criadaPor;

  DateTime? _criadaEm;
  DateTime? get criadaEm => _$this._criadaEm;
  set criadaEm(DateTime? criadaEm) => _$this._criadaEm = criadaEm;

  String? _encerradaPor;
  String? get encerradaPor => _$this._encerradaPor;
  set encerradaPor(String? encerradaPor) => _$this._encerradaPor = encerradaPor;

  DateTime? _encerradaEm;
  DateTime? get encerradaEm => _$this._encerradaEm;
  set encerradaEm(DateTime? encerradaEm) => _$this._encerradaEm = encerradaEm;

  String? _movimentacaoId;
  String? get movimentacaoId => _$this._movimentacaoId;
  set movimentacaoId(String? movimentacaoId) => _$this._movimentacaoId = movimentacaoId;

  ReservaDetalheBuilder() {
    ReservaDetalhe._defaults(this);
  }

  ReservaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _enderecoId = $v.enderecoId;
      _produtoId = $v.produtoId;
      _loteId = $v.loteId;
      _loteNumero = $v.loteNumero;
      _quantidade = $v.quantidade;
      _documentoReferencia = $v.documentoReferencia;
      _status = $v.status;
      _criadaPor = $v.criadaPor;
      _criadaEm = $v.criadaEm;
      _encerradaPor = $v.encerradaPor;
      _encerradaEm = $v.encerradaEm;
      _movimentacaoId = $v.movimentacaoId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReservaDetalhe other) {
    _$v = other as _$ReservaDetalhe;
  }

  @override
  void update(void Function(ReservaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReservaDetalhe build() => _build();

  _$ReservaDetalhe _build() {
    final _$result = _$v ??
        _$ReservaDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ReservaDetalhe', 'id'),
          enderecoId: BuiltValueNullFieldError.checkNotNull(enderecoId, r'ReservaDetalhe', 'enderecoId'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'ReservaDetalhe', 'produtoId'),
          loteId: loteId,
          loteNumero: loteNumero,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'ReservaDetalhe', 'quantidade'),
          documentoReferencia: documentoReferencia,
          status: BuiltValueNullFieldError.checkNotNull(status, r'ReservaDetalhe', 'status'),
          criadaPor: BuiltValueNullFieldError.checkNotNull(criadaPor, r'ReservaDetalhe', 'criadaPor'),
          criadaEm: BuiltValueNullFieldError.checkNotNull(criadaEm, r'ReservaDetalhe', 'criadaEm'),
          encerradaPor: encerradaPor,
          encerradaEm: encerradaEm,
          movimentacaoId: movimentacaoId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
