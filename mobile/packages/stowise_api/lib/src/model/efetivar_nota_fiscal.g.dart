// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efetivar_nota_fiscal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EfetivarNotaFiscal extends EfetivarNotaFiscal {
  @override
  final String? xml;
  @override
  final BuiltList<DecisaoItemNota>? itens;

  factory _$EfetivarNotaFiscal([void Function(EfetivarNotaFiscalBuilder)? updates]) =>
      (EfetivarNotaFiscalBuilder()..update(updates))._build();

  _$EfetivarNotaFiscal._({this.xml, this.itens}) : super._();
  @override
  EfetivarNotaFiscal rebuild(void Function(EfetivarNotaFiscalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EfetivarNotaFiscalBuilder toBuilder() => EfetivarNotaFiscalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EfetivarNotaFiscal && xml == other.xml && itens == other.itens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, xml.hashCode);
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EfetivarNotaFiscal')
          ..add('xml', xml)
          ..add('itens', itens))
        .toString();
  }
}

class EfetivarNotaFiscalBuilder implements Builder<EfetivarNotaFiscal, EfetivarNotaFiscalBuilder> {
  _$EfetivarNotaFiscal? _$v;

  String? _xml;
  String? get xml => _$this._xml;
  set xml(String? xml) => _$this._xml = xml;

  ListBuilder<DecisaoItemNota>? _itens;
  ListBuilder<DecisaoItemNota> get itens => _$this._itens ??= ListBuilder<DecisaoItemNota>();
  set itens(ListBuilder<DecisaoItemNota>? itens) => _$this._itens = itens;

  EfetivarNotaFiscalBuilder() {
    EfetivarNotaFiscal._defaults(this);
  }

  EfetivarNotaFiscalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _xml = $v.xml;
      _itens = $v.itens?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EfetivarNotaFiscal other) {
    _$v = other as _$EfetivarNotaFiscal;
  }

  @override
  void update(void Function(EfetivarNotaFiscalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EfetivarNotaFiscal build() => _build();

  _$EfetivarNotaFiscal _build() {
    _$EfetivarNotaFiscal _$result;
    try {
      _$result = _$v ??
          _$EfetivarNotaFiscal._(
            xml: xml,
            itens: _itens?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        _itens?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'EfetivarNotaFiscal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
