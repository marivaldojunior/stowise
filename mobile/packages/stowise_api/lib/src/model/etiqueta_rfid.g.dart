// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etiqueta_rfid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EtiquetaRfid extends EtiquetaRfid {
  @override
  final String epc;
  @override
  final String epcUri;
  @override
  final int serie;

  factory _$EtiquetaRfid([void Function(EtiquetaRfidBuilder)? updates]) =>
      (EtiquetaRfidBuilder()..update(updates))._build();

  _$EtiquetaRfid._({required this.epc, required this.epcUri, required this.serie}) : super._();
  @override
  EtiquetaRfid rebuild(void Function(EtiquetaRfidBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EtiquetaRfidBuilder toBuilder() => EtiquetaRfidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EtiquetaRfid && epc == other.epc && epcUri == other.epcUri && serie == other.serie;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, epc.hashCode);
    _$hash = $jc(_$hash, epcUri.hashCode);
    _$hash = $jc(_$hash, serie.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EtiquetaRfid')
          ..add('epc', epc)
          ..add('epcUri', epcUri)
          ..add('serie', serie))
        .toString();
  }
}

class EtiquetaRfidBuilder implements Builder<EtiquetaRfid, EtiquetaRfidBuilder> {
  _$EtiquetaRfid? _$v;

  String? _epc;
  String? get epc => _$this._epc;
  set epc(String? epc) => _$this._epc = epc;

  String? _epcUri;
  String? get epcUri => _$this._epcUri;
  set epcUri(String? epcUri) => _$this._epcUri = epcUri;

  int? _serie;
  int? get serie => _$this._serie;
  set serie(int? serie) => _$this._serie = serie;

  EtiquetaRfidBuilder() {
    EtiquetaRfid._defaults(this);
  }

  EtiquetaRfidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _epc = $v.epc;
      _epcUri = $v.epcUri;
      _serie = $v.serie;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EtiquetaRfid other) {
    _$v = other as _$EtiquetaRfid;
  }

  @override
  void update(void Function(EtiquetaRfidBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EtiquetaRfid build() => _build();

  _$EtiquetaRfid _build() {
    final _$result = _$v ??
        _$EtiquetaRfid._(
          epc: BuiltValueNullFieldError.checkNotNull(epc, r'EtiquetaRfid', 'epc'),
          epcUri: BuiltValueNullFieldError.checkNotNull(epcUri, r'EtiquetaRfid', 'epcUri'),
          serie: BuiltValueNullFieldError.checkNotNull(serie, r'EtiquetaRfid', 'serie'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
