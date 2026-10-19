// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unidade_de_para.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnidadeDePara extends UnidadeDePara {
  @override
  final String origem;
  @override
  final String destino;

  factory _$UnidadeDePara([void Function(UnidadeDeParaBuilder)? updates]) =>
      (UnidadeDeParaBuilder()..update(updates))._build();

  _$UnidadeDePara._({required this.origem, required this.destino}) : super._();
  @override
  UnidadeDePara rebuild(void Function(UnidadeDeParaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  UnidadeDeParaBuilder toBuilder() => UnidadeDeParaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnidadeDePara && origem == other.origem && destino == other.destino;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, origem.hashCode);
    _$hash = $jc(_$hash, destino.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnidadeDePara')
          ..add('origem', origem)
          ..add('destino', destino))
        .toString();
  }
}

class UnidadeDeParaBuilder implements Builder<UnidadeDePara, UnidadeDeParaBuilder> {
  _$UnidadeDePara? _$v;

  String? _origem;
  String? get origem => _$this._origem;
  set origem(String? origem) => _$this._origem = origem;

  String? _destino;
  String? get destino => _$this._destino;
  set destino(String? destino) => _$this._destino = destino;

  UnidadeDeParaBuilder() {
    UnidadeDePara._defaults(this);
  }

  UnidadeDeParaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _origem = $v.origem;
      _destino = $v.destino;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnidadeDePara other) {
    _$v = other as _$UnidadeDePara;
  }

  @override
  void update(void Function(UnidadeDeParaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnidadeDePara build() => _build();

  _$UnidadeDePara _build() {
    final _$result = _$v ??
        _$UnidadeDePara._(
          origem: BuiltValueNullFieldError.checkNotNull(origem, r'UnidadeDePara', 'origem'),
          destino: BuiltValueNullFieldError.checkNotNull(destino, r'UnidadeDePara', 'destino'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
