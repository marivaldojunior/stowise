// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conferir_item_recebimento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConferirItemRecebimento extends ConferirItemRecebimento {
  @override
  final double? quantidade;
  @override
  final BuiltList<LoteConferido>? lotes;

  factory _$ConferirItemRecebimento([void Function(ConferirItemRecebimentoBuilder)? updates]) =>
      (ConferirItemRecebimentoBuilder()..update(updates))._build();

  _$ConferirItemRecebimento._({this.quantidade, this.lotes}) : super._();
  @override
  ConferirItemRecebimento rebuild(void Function(ConferirItemRecebimentoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConferirItemRecebimentoBuilder toBuilder() => ConferirItemRecebimentoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConferirItemRecebimento && quantidade == other.quantidade && lotes == other.lotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, lotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConferirItemRecebimento')
          ..add('quantidade', quantidade)
          ..add('lotes', lotes))
        .toString();
  }
}

class ConferirItemRecebimentoBuilder implements Builder<ConferirItemRecebimento, ConferirItemRecebimentoBuilder> {
  _$ConferirItemRecebimento? _$v;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  ListBuilder<LoteConferido>? _lotes;
  ListBuilder<LoteConferido> get lotes => _$this._lotes ??= ListBuilder<LoteConferido>();
  set lotes(ListBuilder<LoteConferido>? lotes) => _$this._lotes = lotes;

  ConferirItemRecebimentoBuilder() {
    ConferirItemRecebimento._defaults(this);
  }

  ConferirItemRecebimentoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantidade = $v.quantidade;
      _lotes = $v.lotes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConferirItemRecebimento other) {
    _$v = other as _$ConferirItemRecebimento;
  }

  @override
  void update(void Function(ConferirItemRecebimentoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConferirItemRecebimento build() => _build();

  _$ConferirItemRecebimento _build() {
    _$ConferirItemRecebimento _$result;
    try {
      _$result = _$v ??
          _$ConferirItemRecebimento._(
            quantidade: quantidade,
            lotes: _lotes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lotes';
        _lotes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ConferirItemRecebimento', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
