// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerar_etiquetas_rfid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GerarEtiquetasRfid extends GerarEtiquetasRfid {
  @override
  final String? embalagemId;
  @override
  final int? quantidade;
  @override
  final int? tamanhoPrefixoEmpresa;

  factory _$GerarEtiquetasRfid([void Function(GerarEtiquetasRfidBuilder)? updates]) =>
      (GerarEtiquetasRfidBuilder()..update(updates))._build();

  _$GerarEtiquetasRfid._({this.embalagemId, this.quantidade, this.tamanhoPrefixoEmpresa}) : super._();
  @override
  GerarEtiquetasRfid rebuild(void Function(GerarEtiquetasRfidBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GerarEtiquetasRfidBuilder toBuilder() => GerarEtiquetasRfidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GerarEtiquetasRfid &&
        embalagemId == other.embalagemId &&
        quantidade == other.quantidade &&
        tamanhoPrefixoEmpresa == other.tamanhoPrefixoEmpresa;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, tamanhoPrefixoEmpresa.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GerarEtiquetasRfid')
          ..add('embalagemId', embalagemId)
          ..add('quantidade', quantidade)
          ..add('tamanhoPrefixoEmpresa', tamanhoPrefixoEmpresa))
        .toString();
  }
}

class GerarEtiquetasRfidBuilder implements Builder<GerarEtiquetasRfid, GerarEtiquetasRfidBuilder> {
  _$GerarEtiquetasRfid? _$v;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  int? _quantidade;
  int? get quantidade => _$this._quantidade;
  set quantidade(int? quantidade) => _$this._quantidade = quantidade;

  int? _tamanhoPrefixoEmpresa;
  int? get tamanhoPrefixoEmpresa => _$this._tamanhoPrefixoEmpresa;
  set tamanhoPrefixoEmpresa(int? tamanhoPrefixoEmpresa) => _$this._tamanhoPrefixoEmpresa = tamanhoPrefixoEmpresa;

  GerarEtiquetasRfidBuilder() {
    GerarEtiquetasRfid._defaults(this);
  }

  GerarEtiquetasRfidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _embalagemId = $v.embalagemId;
      _quantidade = $v.quantidade;
      _tamanhoPrefixoEmpresa = $v.tamanhoPrefixoEmpresa;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GerarEtiquetasRfid other) {
    _$v = other as _$GerarEtiquetasRfid;
  }

  @override
  void update(void Function(GerarEtiquetasRfidBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GerarEtiquetasRfid build() => _build();

  _$GerarEtiquetasRfid _build() {
    final _$result = _$v ??
        _$GerarEtiquetasRfid._(
          embalagemId: embalagemId,
          quantidade: quantidade,
          tamanhoPrefixoEmpresa: tamanhoPrefixoEmpresa,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
