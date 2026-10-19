// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimentacao_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MovimentacaoDetalhe extends MovimentacaoDetalhe {
  @override
  final String id;
  @override
  final TipoMovimentacao tipo;
  @override
  final String produtoId;
  @override
  final String? loteId;
  @override
  final String? loteNumero;
  @override
  final String? enderecoOrigemId;
  @override
  final String? enderecoDestinoId;
  @override
  final double quantidade;
  @override
  final String? documentoReferencia;
  @override
  final String? observacao;
  @override
  final String usuarioId;
  @override
  final String? dispositivoId;
  @override
  final DateTime ocorridoEm;
  @override
  final DateTime recebidoEm;
  @override
  final String? idempotencyKey;

  factory _$MovimentacaoDetalhe([void Function(MovimentacaoDetalheBuilder)? updates]) =>
      (MovimentacaoDetalheBuilder()..update(updates))._build();

  _$MovimentacaoDetalhe._(
      {required this.id,
      required this.tipo,
      required this.produtoId,
      this.loteId,
      this.loteNumero,
      this.enderecoOrigemId,
      this.enderecoDestinoId,
      required this.quantidade,
      this.documentoReferencia,
      this.observacao,
      required this.usuarioId,
      this.dispositivoId,
      required this.ocorridoEm,
      required this.recebidoEm,
      this.idempotencyKey})
      : super._();
  @override
  MovimentacaoDetalhe rebuild(void Function(MovimentacaoDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MovimentacaoDetalheBuilder toBuilder() => MovimentacaoDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MovimentacaoDetalhe &&
        id == other.id &&
        tipo == other.tipo &&
        produtoId == other.produtoId &&
        loteId == other.loteId &&
        loteNumero == other.loteNumero &&
        enderecoOrigemId == other.enderecoOrigemId &&
        enderecoDestinoId == other.enderecoDestinoId &&
        quantidade == other.quantidade &&
        documentoReferencia == other.documentoReferencia &&
        observacao == other.observacao &&
        usuarioId == other.usuarioId &&
        dispositivoId == other.dispositivoId &&
        ocorridoEm == other.ocorridoEm &&
        recebidoEm == other.recebidoEm &&
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, enderecoOrigemId.hashCode);
    _$hash = $jc(_$hash, enderecoDestinoId.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jc(_$hash, observacao.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, dispositivoId.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jc(_$hash, recebidoEm.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MovimentacaoDetalhe')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('produtoId', produtoId)
          ..add('loteId', loteId)
          ..add('loteNumero', loteNumero)
          ..add('enderecoOrigemId', enderecoOrigemId)
          ..add('enderecoDestinoId', enderecoDestinoId)
          ..add('quantidade', quantidade)
          ..add('documentoReferencia', documentoReferencia)
          ..add('observacao', observacao)
          ..add('usuarioId', usuarioId)
          ..add('dispositivoId', dispositivoId)
          ..add('ocorridoEm', ocorridoEm)
          ..add('recebidoEm', recebidoEm)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class MovimentacaoDetalheBuilder implements Builder<MovimentacaoDetalhe, MovimentacaoDetalheBuilder> {
  _$MovimentacaoDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoMovimentacao? _tipo;
  TipoMovimentacao? get tipo => _$this._tipo;
  set tipo(TipoMovimentacao? tipo) => _$this._tipo = tipo;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  String? _enderecoOrigemId;
  String? get enderecoOrigemId => _$this._enderecoOrigemId;
  set enderecoOrigemId(String? enderecoOrigemId) => _$this._enderecoOrigemId = enderecoOrigemId;

  String? _enderecoDestinoId;
  String? get enderecoDestinoId => _$this._enderecoDestinoId;
  set enderecoDestinoId(String? enderecoDestinoId) => _$this._enderecoDestinoId = enderecoDestinoId;

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

  String? _dispositivoId;
  String? get dispositivoId => _$this._dispositivoId;
  set dispositivoId(String? dispositivoId) => _$this._dispositivoId = dispositivoId;

  DateTime? _ocorridoEm;
  DateTime? get ocorridoEm => _$this._ocorridoEm;
  set ocorridoEm(DateTime? ocorridoEm) => _$this._ocorridoEm = ocorridoEm;

  DateTime? _recebidoEm;
  DateTime? get recebidoEm => _$this._recebidoEm;
  set recebidoEm(DateTime? recebidoEm) => _$this._recebidoEm = recebidoEm;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) => _$this._idempotencyKey = idempotencyKey;

  MovimentacaoDetalheBuilder() {
    MovimentacaoDetalhe._defaults(this);
  }

  MovimentacaoDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _produtoId = $v.produtoId;
      _loteId = $v.loteId;
      _loteNumero = $v.loteNumero;
      _enderecoOrigemId = $v.enderecoOrigemId;
      _enderecoDestinoId = $v.enderecoDestinoId;
      _quantidade = $v.quantidade;
      _documentoReferencia = $v.documentoReferencia;
      _observacao = $v.observacao;
      _usuarioId = $v.usuarioId;
      _dispositivoId = $v.dispositivoId;
      _ocorridoEm = $v.ocorridoEm;
      _recebidoEm = $v.recebidoEm;
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MovimentacaoDetalhe other) {
    _$v = other as _$MovimentacaoDetalhe;
  }

  @override
  void update(void Function(MovimentacaoDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MovimentacaoDetalhe build() => _build();

  _$MovimentacaoDetalhe _build() {
    final _$result = _$v ??
        _$MovimentacaoDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MovimentacaoDetalhe', 'id'),
          tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'MovimentacaoDetalhe', 'tipo'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'MovimentacaoDetalhe', 'produtoId'),
          loteId: loteId,
          loteNumero: loteNumero,
          enderecoOrigemId: enderecoOrigemId,
          enderecoDestinoId: enderecoDestinoId,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'MovimentacaoDetalhe', 'quantidade'),
          documentoReferencia: documentoReferencia,
          observacao: observacao,
          usuarioId: BuiltValueNullFieldError.checkNotNull(usuarioId, r'MovimentacaoDetalhe', 'usuarioId'),
          dispositivoId: dispositivoId,
          ocorridoEm: BuiltValueNullFieldError.checkNotNull(ocorridoEm, r'MovimentacaoDetalhe', 'ocorridoEm'),
          recebidoEm: BuiltValueNullFieldError.checkNotNull(recebidoEm, r'MovimentacaoDetalhe', 'recebidoEm'),
          idempotencyKey: idempotencyKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
