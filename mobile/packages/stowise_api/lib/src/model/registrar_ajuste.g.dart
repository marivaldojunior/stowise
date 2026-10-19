// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrar_ajuste.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrarAjuste extends RegistrarAjuste {
  @override
  final String? produtoId;
  @override
  final String? enderecoId;
  @override
  final double? quantidade;
  @override
  final String? lote;
  @override
  final String? motivo;
  @override
  final DateTime? ocorridoEm;
  @override
  final String? idempotencyKey;

  factory _$RegistrarAjuste([void Function(RegistrarAjusteBuilder)? updates]) =>
      (RegistrarAjusteBuilder()..update(updates))._build();

  _$RegistrarAjuste._(
      {this.produtoId, this.enderecoId, this.quantidade, this.lote, this.motivo, this.ocorridoEm, this.idempotencyKey})
      : super._();
  @override
  RegistrarAjuste rebuild(void Function(RegistrarAjusteBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RegistrarAjusteBuilder toBuilder() => RegistrarAjusteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrarAjuste &&
        produtoId == other.produtoId &&
        enderecoId == other.enderecoId &&
        quantidade == other.quantidade &&
        lote == other.lote &&
        motivo == other.motivo &&
        ocorridoEm == other.ocorridoEm &&
        idempotencyKey == other.idempotencyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, lote.hashCode);
    _$hash = $jc(_$hash, motivo.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrarAjuste')
          ..add('produtoId', produtoId)
          ..add('enderecoId', enderecoId)
          ..add('quantidade', quantidade)
          ..add('lote', lote)
          ..add('motivo', motivo)
          ..add('ocorridoEm', ocorridoEm)
          ..add('idempotencyKey', idempotencyKey))
        .toString();
  }
}

class RegistrarAjusteBuilder implements Builder<RegistrarAjuste, RegistrarAjusteBuilder> {
  _$RegistrarAjuste? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _lote;
  String? get lote => _$this._lote;
  set lote(String? lote) => _$this._lote = lote;

  String? _motivo;
  String? get motivo => _$this._motivo;
  set motivo(String? motivo) => _$this._motivo = motivo;

  DateTime? _ocorridoEm;
  DateTime? get ocorridoEm => _$this._ocorridoEm;
  set ocorridoEm(DateTime? ocorridoEm) => _$this._ocorridoEm = ocorridoEm;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) => _$this._idempotencyKey = idempotencyKey;

  RegistrarAjusteBuilder() {
    RegistrarAjuste._defaults(this);
  }

  RegistrarAjusteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _enderecoId = $v.enderecoId;
      _quantidade = $v.quantidade;
      _lote = $v.lote;
      _motivo = $v.motivo;
      _ocorridoEm = $v.ocorridoEm;
      _idempotencyKey = $v.idempotencyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrarAjuste other) {
    _$v = other as _$RegistrarAjuste;
  }

  @override
  void update(void Function(RegistrarAjusteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrarAjuste build() => _build();

  _$RegistrarAjuste _build() {
    final _$result = _$v ??
        _$RegistrarAjuste._(
          produtoId: produtoId,
          enderecoId: enderecoId,
          quantidade: quantidade,
          lote: lote,
          motivo: motivo,
          ocorridoEm: ocorridoEm,
          idempotencyKey: idempotencyKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
