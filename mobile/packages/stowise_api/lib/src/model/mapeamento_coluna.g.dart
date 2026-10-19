// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapeamento_coluna.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MapeamentoColuna extends MapeamentoColuna {
  @override
  final String campo;
  @override
  final int coluna;

  factory _$MapeamentoColuna([void Function(MapeamentoColunaBuilder)? updates]) =>
      (MapeamentoColunaBuilder()..update(updates))._build();

  _$MapeamentoColuna._({required this.campo, required this.coluna}) : super._();
  @override
  MapeamentoColuna rebuild(void Function(MapeamentoColunaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  MapeamentoColunaBuilder toBuilder() => MapeamentoColunaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MapeamentoColuna && campo == other.campo && coluna == other.coluna;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, campo.hashCode);
    _$hash = $jc(_$hash, coluna.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MapeamentoColuna')
          ..add('campo', campo)
          ..add('coluna', coluna))
        .toString();
  }
}

class MapeamentoColunaBuilder implements Builder<MapeamentoColuna, MapeamentoColunaBuilder> {
  _$MapeamentoColuna? _$v;

  String? _campo;
  String? get campo => _$this._campo;
  set campo(String? campo) => _$this._campo = campo;

  int? _coluna;
  int? get coluna => _$this._coluna;
  set coluna(int? coluna) => _$this._coluna = coluna;

  MapeamentoColunaBuilder() {
    MapeamentoColuna._defaults(this);
  }

  MapeamentoColunaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _campo = $v.campo;
      _coluna = $v.coluna;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MapeamentoColuna other) {
    _$v = other as _$MapeamentoColuna;
  }

  @override
  void update(void Function(MapeamentoColunaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MapeamentoColuna build() => _build();

  _$MapeamentoColuna _build() {
    final _$result = _$v ??
        _$MapeamentoColuna._(
          campo: BuiltValueNullFieldError.checkNotNull(campo, r'MapeamentoColuna', 'campo'),
          coluna: BuiltValueNullFieldError.checkNotNull(coluna, r'MapeamentoColuna', 'coluna'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
