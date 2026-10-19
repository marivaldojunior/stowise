// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_reserva.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CriarReserva extends CriarReserva {
  @override
  final String? produtoId;
  @override
  final String? enderecoId;
  @override
  final String? lote;
  @override
  final double? quantidade;
  @override
  final String? documentoReferencia;

  factory _$CriarReserva([void Function(CriarReservaBuilder)? updates]) =>
      (CriarReservaBuilder()..update(updates))._build();

  _$CriarReserva._({this.produtoId, this.enderecoId, this.lote, this.quantidade, this.documentoReferencia}) : super._();
  @override
  CriarReserva rebuild(void Function(CriarReservaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CriarReservaBuilder toBuilder() => CriarReservaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CriarReserva &&
        produtoId == other.produtoId &&
        enderecoId == other.enderecoId &&
        lote == other.lote &&
        quantidade == other.quantidade &&
        documentoReferencia == other.documentoReferencia;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, lote.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, documentoReferencia.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CriarReserva')
          ..add('produtoId', produtoId)
          ..add('enderecoId', enderecoId)
          ..add('lote', lote)
          ..add('quantidade', quantidade)
          ..add('documentoReferencia', documentoReferencia))
        .toString();
  }
}

class CriarReservaBuilder implements Builder<CriarReserva, CriarReservaBuilder> {
  _$CriarReserva? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _lote;
  String? get lote => _$this._lote;
  set lote(String? lote) => _$this._lote = lote;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _documentoReferencia;
  String? get documentoReferencia => _$this._documentoReferencia;
  set documentoReferencia(String? documentoReferencia) => _$this._documentoReferencia = documentoReferencia;

  CriarReservaBuilder() {
    CriarReserva._defaults(this);
  }

  CriarReservaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _enderecoId = $v.enderecoId;
      _lote = $v.lote;
      _quantidade = $v.quantidade;
      _documentoReferencia = $v.documentoReferencia;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CriarReserva other) {
    _$v = other as _$CriarReserva;
  }

  @override
  void update(void Function(CriarReservaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CriarReserva build() => _build();

  _$CriarReserva _build() {
    final _$result = _$v ??
        _$CriarReserva._(
          produtoId: produtoId,
          enderecoId: enderecoId,
          lote: lote,
          quantidade: quantidade,
          documentoReferencia: documentoReferencia,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
