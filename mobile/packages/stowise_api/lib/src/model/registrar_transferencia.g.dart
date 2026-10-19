// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrar_transferencia.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrarTransferencia extends RegistrarTransferencia {
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final String? enderecoOrigemId;
  @override
  final String? enderecoDestinoId;
  @override
  final double? quantidade;
  @override
  final String? lote;
  @override
  final String? documentoReferencia;
  @override
  final String? dispositivoId;
  @override
  final DateTime? ocorridoEm;
  @override
  final String? idempotencyKey;

  factory _$RegistrarTransferencia([void Function(RegistrarTransferenciaBuilder)? updates]) =>
      (RegistrarTransferenciaBuilder()..update(updates))._build();

  _$RegistrarTransferencia._(
      {this.produtoId,
      this.embalagemId,
      this.enderecoOrigemId,
      this.enderecoDestinoId,
      this.quantidade,
      this.lote,
      this.documentoReferencia,
      this.dispositivoId,
      this.ocorridoEm,
      this.idempotencyKey})
      : super._();
  @override
  RegistrarTransferencia rebuild(void Function(RegistrarTransferenciaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrarTransferenciaBuilder toBuilder() => RegistrarTransferenciaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrarTransferencia &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        enderecoOrigemId == other.enderecoOrigemId &&
        enderecoDestinoId == other.enderecoDestinoId &&
        quantidade == other.quantidade &&
        lote == other.lote &&
        documentoReferencia == other.documentoReferencia &&
        dispositivoId == other.dispositivoId &&
        ocorridoEm == other.ocorridoEm &&
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, enderecoOrigemId.hashCode);
    _$hash = $jc(_$hash, enderecoDestinoId.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, lote.hashCode);
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jc(_$hash, dispositivoId.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrarTransferencia')
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('enderecoOrigemId', enderecoOrigemId)
          ..add('enderecoDestinoId', enderecoDestinoId)
          ..add('quantidade', quantidade)
          ..add('lote', lote)
          ..add('documentoReferencia', documentoReferencia)
          ..add('dispositivoId', dispositivoId)
          ..add('ocorridoEm', ocorridoEm)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class RegistrarTransferenciaBuilder implements Builder<RegistrarTransferencia, RegistrarTransferenciaBuilder> {
  _$RegistrarTransferencia? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _enderecoOrigemId;
  String? get enderecoOrigemId => _$this._enderecoOrigemId;
  set enderecoOrigemId(String? enderecoOrigemId) => _$this._enderecoOrigemId = enderecoOrigemId;

  String? _enderecoDestinoId;
  String? get enderecoDestinoId => _$this._enderecoDestinoId;
  set enderecoDestinoId(String? enderecoDestinoId) => _$this._enderecoDestinoId = enderecoDestinoId;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _lote;
  String? get lote => _$this._lote;
  set lote(String? lote) => _$this._lote = lote;

  String? _documentoReferencia;
  String? get documentoReferencia => _$this._documentoReferencia;
  set documentoReferencia(String? documentoReferencia) => _$this._documentoReferencia = documentoReferencia;

  String? _dispositivoId;
  String? get dispositivoId => _$this._dispositivoId;
  set dispositivoId(String? dispositivoId) => _$this._dispositivoId = dispositivoId;

  DateTime? _ocorridoEm;
  DateTime? get ocorridoEm => _$this._ocorridoEm;
  set ocorridoEm(DateTime? ocorridoEm) => _$this._ocorridoEm = ocorridoEm;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) => _$this._idempotencyKey = idempotencyKey;

  RegistrarTransferenciaBuilder() {
    RegistrarTransferencia._defaults(this);
  }

  RegistrarTransferenciaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _enderecoOrigemId = $v.enderecoOrigemId;
      _enderecoDestinoId = $v.enderecoDestinoId;
      _quantidade = $v.quantidade;
      _lote = $v.lote;
      _documentoReferencia = $v.documentoReferencia;
      _dispositivoId = $v.dispositivoId;
      _ocorridoEm = $v.ocorridoEm;
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrarTransferencia other) {
    _$v = other as _$RegistrarTransferencia;
  }

  @override
  void update(void Function(RegistrarTransferenciaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrarTransferencia build() => _build();

  _$RegistrarTransferencia _build() {
    final _$result = _$v ??
        _$RegistrarTransferencia._(
          produtoId: produtoId,
          embalagemId: embalagemId,
          enderecoOrigemId: enderecoOrigemId,
          enderecoDestinoId: enderecoDestinoId,
          quantidade: quantidade,
          lote: lote,
          documentoReferencia: documentoReferencia,
          dispositivoId: dispositivoId,
          ocorridoEm: ocorridoEm,
          idempotencyKey: idempotencyKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
