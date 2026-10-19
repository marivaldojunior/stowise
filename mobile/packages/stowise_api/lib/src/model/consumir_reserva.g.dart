// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumir_reserva.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConsumirReserva extends ConsumirReserva {
  @override
  final String? documentoReferencia;
  @override
  final String? dispositivoId;
  @override
  final DateTime? ocorridoEm;
  @override
  final String? idempotencyKey;

  factory _$ConsumirReserva([void Function(ConsumirReservaBuilder)? updates]) =>
      (ConsumirReservaBuilder()..update(updates))._build();

  _$ConsumirReserva._({this.documentoReferencia, this.dispositivoId, this.ocorridoEm, this.idempotencyKey}) : super._();
  @override
  ConsumirReserva rebuild(void Function(ConsumirReservaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ConsumirReservaBuilder toBuilder() => ConsumirReservaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsumirReserva &&
        documentoReferencia == other.documentoReferencia &&
        dispositivoId == other.dispositivoId &&
        ocorridoEm == other.ocorridoEm &&
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jc(_$hash, dispositivoId.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConsumirReserva')
          ..add('documentoReferencia', documentoReferencia)
          ..add('dispositivoId', dispositivoId)
          ..add('ocorridoEm', ocorridoEm)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class ConsumirReservaBuilder implements Builder<ConsumirReserva, ConsumirReservaBuilder> {
  _$ConsumirReserva? _$v;

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

  ConsumirReservaBuilder() {
    ConsumirReserva._defaults(this);
  }

  ConsumirReservaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentoReferencia = $v.documentoReferencia;
      _dispositivoId = $v.dispositivoId;
      _ocorridoEm = $v.ocorridoEm;
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConsumirReserva other) {
    _$v = other as _$ConsumirReserva;
  }

  @override
  void update(void Function(ConsumirReservaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConsumirReserva build() => _build();

  _$ConsumirReserva _build() {
    final _$result = _$v ??
        _$ConsumirReserva._(
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
