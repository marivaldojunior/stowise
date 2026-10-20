// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leituras_rfid_resolvidas.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LeiturasRfidResolvidas extends LeiturasRfidResolvidas {
  @override
  final BuiltList<LeituraRfid> leituras;
  @override
  final BuiltList<ContagemRfid> produtos;
  @override
  final int naoReconhecidas;

  factory _$LeiturasRfidResolvidas([void Function(LeiturasRfidResolvidasBuilder)? updates]) =>
      (LeiturasRfidResolvidasBuilder()..update(updates))._build();

  _$LeiturasRfidResolvidas._({required this.leituras, required this.produtos, required this.naoReconhecidas})
      : super._();
  @override
  LeiturasRfidResolvidas rebuild(void Function(LeiturasRfidResolvidasBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LeiturasRfidResolvidasBuilder toBuilder() => LeiturasRfidResolvidasBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LeiturasRfidResolvidas &&
        leituras == other.leituras &&
        produtos == other.produtos &&
        naoReconhecidas == other.naoReconhecidas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, leituras.hashCode);
    _$hash = $jc(_$hash, produtos.hashCode);
    _$hash = $jc(_$hash, naoReconhecidas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LeiturasRfidResolvidas')
          ..add('leituras', leituras)
          ..add('produtos', produtos)
          ..add('naoReconhecidas', naoReconhecidas))
        .toString();
  }
}

class LeiturasRfidResolvidasBuilder implements Builder<LeiturasRfidResolvidas, LeiturasRfidResolvidasBuilder> {
  _$LeiturasRfidResolvidas? _$v;

  ListBuilder<LeituraRfid>? _leituras;
  ListBuilder<LeituraRfid> get leituras => _$this._leituras ??= ListBuilder<LeituraRfid>();
  set leituras(ListBuilder<LeituraRfid>? leituras) => _$this._leituras = leituras;

  ListBuilder<ContagemRfid>? _produtos;
  ListBuilder<ContagemRfid> get produtos => _$this._produtos ??= ListBuilder<ContagemRfid>();
  set produtos(ListBuilder<ContagemRfid>? produtos) => _$this._produtos = produtos;

  int? _naoReconhecidas;
  int? get naoReconhecidas => _$this._naoReconhecidas;
  set naoReconhecidas(int? naoReconhecidas) => _$this._naoReconhecidas = naoReconhecidas;

  LeiturasRfidResolvidasBuilder() {
    LeiturasRfidResolvidas._defaults(this);
  }

  LeiturasRfidResolvidasBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _leituras = $v.leituras.toBuilder();
      _produtos = $v.produtos.toBuilder();
      _naoReconhecidas = $v.naoReconhecidas;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LeiturasRfidResolvidas other) {
    _$v = other as _$LeiturasRfidResolvidas;
  }

  @override
  void update(void Function(LeiturasRfidResolvidasBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LeiturasRfidResolvidas build() => _build();

  _$LeiturasRfidResolvidas _build() {
    _$LeiturasRfidResolvidas _$result;
    try {
      _$result = _$v ??
          _$LeiturasRfidResolvidas._(
            leituras: leituras.build(),
            produtos: produtos.build(),
            naoReconhecidas:
                BuiltValueNullFieldError.checkNotNull(naoReconhecidas, r'LeiturasRfidResolvidas', 'naoReconhecidas'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'leituras';
        leituras.build();
        _$failedField = 'produtos';
        produtos.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'LeiturasRfidResolvidas', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
