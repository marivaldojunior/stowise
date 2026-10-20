// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pendencia_embalagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PendenciaEmbalagem extends PendenciaEmbalagem {
  @override
  final String embalagemId;
  @override
  final TipoEmbalagem tipo;
  @override
  final double fatorConversao;
  @override
  final String? gtin;
  @override
  final BuiltList<String> faltando;

  factory _$PendenciaEmbalagem([void Function(PendenciaEmbalagemBuilder)? updates]) =>
      (PendenciaEmbalagemBuilder()..update(updates))._build();

  _$PendenciaEmbalagem._(
      {required this.embalagemId, required this.tipo, required this.fatorConversao, this.gtin, required this.faltando})
      : super._();
  @override
  PendenciaEmbalagem rebuild(void Function(PendenciaEmbalagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PendenciaEmbalagemBuilder toBuilder() => PendenciaEmbalagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PendenciaEmbalagem &&
        embalagemId == other.embalagemId &&
        tipo == other.tipo &&
        fatorConversao == other.fatorConversao &&
        gtin == other.gtin &&
        faltando == other.faltando;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, fatorConversao.hashCode);
    _$hash = $jc(_$hash, gtin.hashCode);
    _$hash = $jc(_$hash, faltando.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PendenciaEmbalagem')
          ..add('embalagemId', embalagemId)
          ..add('tipo', tipo)
          ..add('fatorConversao', fatorConversao)
          ..add('gtin', gtin)
          ..add('faltando', faltando))
        .toString();
  }
}

class PendenciaEmbalagemBuilder implements Builder<PendenciaEmbalagem, PendenciaEmbalagemBuilder> {
  _$PendenciaEmbalagem? _$v;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  TipoEmbalagem? _tipo;
  TipoEmbalagem? get tipo => _$this._tipo;
  set tipo(TipoEmbalagem? tipo) => _$this._tipo = tipo;

  double? _fatorConversao;
  double? get fatorConversao => _$this._fatorConversao;
  set fatorConversao(double? fatorConversao) => _$this._fatorConversao = fatorConversao;

  String? _gtin;
  String? get gtin => _$this._gtin;
  set gtin(String? gtin) => _$this._gtin = gtin;

  ListBuilder<String>? _faltando;
  ListBuilder<String> get faltando => _$this._faltando ??= ListBuilder<String>();
  set faltando(ListBuilder<String>? faltando) => _$this._faltando = faltando;

  PendenciaEmbalagemBuilder() {
    PendenciaEmbalagem._defaults(this);
  }

  PendenciaEmbalagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _embalagemId = $v.embalagemId;
      _tipo = $v.tipo;
      _fatorConversao = $v.fatorConversao;
      _gtin = $v.gtin;
      _faltando = $v.faltando.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PendenciaEmbalagem other) {
    _$v = other as _$PendenciaEmbalagem;
  }

  @override
  void update(void Function(PendenciaEmbalagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PendenciaEmbalagem build() => _build();

  _$PendenciaEmbalagem _build() {
    _$PendenciaEmbalagem _$result;
    try {
      _$result = _$v ??
          _$PendenciaEmbalagem._(
            embalagemId: BuiltValueNullFieldError.checkNotNull(embalagemId, r'PendenciaEmbalagem', 'embalagemId'),
            tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'PendenciaEmbalagem', 'tipo'),
            fatorConversao:
                BuiltValueNullFieldError.checkNotNull(fatorConversao, r'PendenciaEmbalagem', 'fatorConversao'),
            gtin: gtin,
            faltando: faltando.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'faltando';
        faltando.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PendenciaEmbalagem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
