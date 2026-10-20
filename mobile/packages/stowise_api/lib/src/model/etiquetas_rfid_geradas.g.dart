// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etiquetas_rfid_geradas.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EtiquetasRfidGeradas extends EtiquetasRfidGeradas {
  @override
  final String produtoId;
  @override
  final String embalagemId;
  @override
  final String gtin;
  @override
  final BuiltList<EtiquetaRfid> etiquetas;

  factory _$EtiquetasRfidGeradas([void Function(EtiquetasRfidGeradasBuilder)? updates]) =>
      (EtiquetasRfidGeradasBuilder()..update(updates))._build();

  _$EtiquetasRfidGeradas._(
      {required this.produtoId, required this.embalagemId, required this.gtin, required this.etiquetas})
      : super._();
  @override
  EtiquetasRfidGeradas rebuild(void Function(EtiquetasRfidGeradasBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EtiquetasRfidGeradasBuilder toBuilder() => EtiquetasRfidGeradasBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EtiquetasRfidGeradas &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        gtin == other.gtin &&
        etiquetas == other.etiquetas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, gtin.hashCode);
    _$hash = $jc(_$hash, etiquetas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EtiquetasRfidGeradas')
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('gtin', gtin)
          ..add('etiquetas', etiquetas))
        .toString();
  }
}

class EtiquetasRfidGeradasBuilder implements Builder<EtiquetasRfidGeradas, EtiquetasRfidGeradasBuilder> {
  _$EtiquetasRfidGeradas? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  String? _gtin;
  String? get gtin => _$this._gtin;
  set gtin(String? gtin) => _$this._gtin = gtin;

  ListBuilder<EtiquetaRfid>? _etiquetas;
  ListBuilder<EtiquetaRfid> get etiquetas => _$this._etiquetas ??= ListBuilder<EtiquetaRfid>();
  set etiquetas(ListBuilder<EtiquetaRfid>? etiquetas) => _$this._etiquetas = etiquetas;

  EtiquetasRfidGeradasBuilder() {
    EtiquetasRfidGeradas._defaults(this);
  }

  EtiquetasRfidGeradasBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _gtin = $v.gtin;
      _etiquetas = $v.etiquetas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EtiquetasRfidGeradas other) {
    _$v = other as _$EtiquetasRfidGeradas;
  }

  @override
  void update(void Function(EtiquetasRfidGeradasBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EtiquetasRfidGeradas build() => _build();

  _$EtiquetasRfidGeradas _build() {
    _$EtiquetasRfidGeradas _$result;
    try {
      _$result = _$v ??
          _$EtiquetasRfidGeradas._(
            produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'EtiquetasRfidGeradas', 'produtoId'),
            embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'EtiquetasRfidGeradas', 'embalagemId'),
            gtin: BuiltValueNullFieldError.checkNotNull(gtin, r'EtiquetasRfidGeradas', 'gtin'),
            etiquetas: etiquetas.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'etiquetas';
        etiquetas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'EtiquetasRfidGeradas', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
