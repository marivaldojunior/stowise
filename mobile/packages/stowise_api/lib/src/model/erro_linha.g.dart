// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erro_linha.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErroLinha extends ErroLinha {
  @override
  final String campo;
  @override
  final String mensagem;

  factory _$ErroLinha([void Function(ErroLinhaBuilder)? updates]) => (ErroLinhaBuilder()..update(updates))._build();

  _$ErroLinha._({required this.campo, required this.mensagem}) : super._();
  @override
  ErroLinha rebuild(void Function(ErroLinhaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ErroLinhaBuilder toBuilder() => ErroLinhaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErroLinha && campo == other.campo && mensagem == other.mensagem;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, campo.hashCode);
    _$hash = $jc(_$hash, mensagem.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErroLinha')
          ..add('campo', campo)
          ..add('mensagem', mensagem))
        .toString();
  }
}

class ErroLinhaBuilder implements Builder<ErroLinha, ErroLinhaBuilder> {
  _$ErroLinha? _$v;

  String? _campo;
  String? get campo => _$this._campo;
  set campo(String? campo) => _$this._campo = campo;

  String? _mensagem;
  String? get mensagem => _$this._mensagem;
  set mensagem(String? mensagem) => _$this._mensagem = mensagem;

  ErroLinhaBuilder() {
    ErroLinha._defaults(this);
  }

  ErroLinhaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _campo = $v.campo;
      _mensagem = $v.mensagem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErroLinha other) {
    _$v = other as _$ErroLinha;
  }

  @override
  void update(void Function(ErroLinhaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErroLinha build() => _build();

  _$ErroLinha _build() {
    final _$result = _$v ??
        _$ErroLinha._(
          campo: BuiltValueNullFieldError.checkNotNull(campo, r'ErroLinha', 'campo'),
          mensagem: BuiltValueNullFieldError.checkNotNull(mensagem, r'ErroLinha', 'mensagem'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
