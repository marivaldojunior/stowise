// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrar_saida.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrarSaida extends RegistrarSaida {
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final String? enderecoId;
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

  factory _$RegistrarSaida([void Function(RegistrarSaidaBuilder)? updates]) =>
      (RegistrarSaidaBuilder()..update(updates))._build();

  _$RegistrarSaida._(
      {this.produtoId,
      this.embalagemId,
      this.enderecoId,
      this.quantidade,
      this.lote,
      this.documentoReferencia,
      this.dispositivoId,
      this.ocorridoEm,
      this.idempotencyKey})
      : super._();
  @override
  RegistrarSaida rebuild(void Function(RegistrarSaidaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RegistrarSaidaBuilder toBuilder() => RegistrarSaidaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrarSaida &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        enderecoId == other.enderecoId &&
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
    _$hash = $jc(_$hash, enderecoId.hashCode);
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
    return (newBuiltValueToStringHelper(r'RegistrarSaida')
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('enderecoId', enderecoId)
          ..add('quantidade', quantidade)
          ..add('lote', lote)
          ..add('documentoReferencia', documentoReferencia)
          ..add('dispositivoId', dispositivoId)
          ..add('ocorridoEm', ocorridoEm)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class RegistrarSaidaBuilder implements Builder<RegistrarSaida, RegistrarSaidaBuilder> {
  _$RegistrarSaida? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

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

  RegistrarSaidaBuilder() {
    RegistrarSaida._defaults(this);
  }

  RegistrarSaidaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _enderecoId = $v.enderecoId;
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
  void replace(RegistrarSaida other) {
    _$v = other as _$RegistrarSaida;
  }

  @override
  void update(void Function(RegistrarSaidaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrarSaida build() => _build();

  _$RegistrarSaida _build() {
    final _$result = _$v ??
        _$RegistrarSaida._(
          produtoId: produtoId,
          embalagemId: embalagemId,
          enderecoId: enderecoId,
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
