// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversao_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConversaoItem extends ConversaoItem {
  @override
  final double? fator;
  @override
  final OrigemFator origem;
  @override
  final double? quantidadeBase;

  factory _$ConversaoItem([void Function(ConversaoItemBuilder)? updates]) =>
      (ConversaoItemBuilder()..update(updates))._build();

  _$ConversaoItem._({this.fator, required this.origem, this.quantidadeBase}) : super._();
  @override
  ConversaoItem rebuild(void Function(ConversaoItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ConversaoItemBuilder toBuilder() => ConversaoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversaoItem &&
        fator == other.fator &&
        origem == other.origem &&
        quantidadeBase == other.quantidadeBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fator.hashCode);
    _$hash = $jc(_$hash, origem.hashCode);
    _$hash = $jc(_$hash, quantidadeBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversaoItem')
          ..add('fator', fator)
          ..add('origem', origem)
          ..add('quantidadeBase', quantidadeBase))
        .toString();
  }
}

class ConversaoItemBuilder implements Builder<ConversaoItem, ConversaoItemBuilder> {
  _$ConversaoItem? _$v;

  double? _fator;
  double? get fator => _$this._fator;
  set fator(double? fator) => _$this._fator = fator;

  OrigemFator? _origem;
  OrigemFator? get origem => _$this._origem;
  set origem(OrigemFator? origem) => _$this._origem = origem;

  double? _quantidadeBase;
  double? get quantidadeBase => _$this._quantidadeBase;
  set quantidadeBase(double? quantidadeBase) => _$this._quantidadeBase = quantidadeBase;

  ConversaoItemBuilder() {
    ConversaoItem._defaults(this);
  }

  ConversaoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fator = $v.fator;
      _origem = $v.origem;
      _quantidadeBase = $v.quantidadeBase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversaoItem other) {
    _$v = other as _$ConversaoItem;
  }

  @override
  void update(void Function(ConversaoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversaoItem build() => _build();

  _$ConversaoItem _build() {
    final _$result = _$v ??
        _$ConversaoItem._(
          fator: fator,
          origem: BuiltValueNullFieldError.checkNotNull(origem, r'ConversaoItem', 'origem'),
          quantidadeBase: quantidadeBase,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
