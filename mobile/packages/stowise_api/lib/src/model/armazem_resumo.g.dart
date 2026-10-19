// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armazem_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArmazemResumo extends ArmazemResumo {
  @override
  final String id;
  @override
  final String codigo;
  @override
  final String nome;
  @override
  final int zonas;
  @override
  final int enderecos;

  factory _$ArmazemResumo([void Function(ArmazemResumoBuilder)? updates]) =>
      (ArmazemResumoBuilder()..update(updates))._build();

  _$ArmazemResumo._(
      {required this.id, required this.codigo, required this.nome, required this.zonas, required this.enderecos})
      : super._();
  @override
  ArmazemResumo rebuild(void Function(ArmazemResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ArmazemResumoBuilder toBuilder() => ArmazemResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArmazemResumo &&
        id == other.id &&
        codigo == other.codigo &&
        nome == other.nome &&
        zonas == other.zonas &&
        enderecos == other.enderecos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, zonas.hashCode);
    _$hash = $jc(_$hash, enderecos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ArmazemResumo')
          ..add('id', id)
          ..add('codigo', codigo)
          ..add('nome', nome)
          ..add('zonas', zonas)
          ..add('enderecos', enderecos))
        .toString();
  }
}

class ArmazemResumoBuilder implements Builder<ArmazemResumo, ArmazemResumoBuilder> {
  _$ArmazemResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  int? _zonas;
  int? get zonas => _$this._zonas;
  set zonas(int? zonas) => _$this._zonas = zonas;

  int? _enderecos;
  int? get enderecos => _$this._enderecos;
  set enderecos(int? enderecos) => _$this._enderecos = enderecos;

  ArmazemResumoBuilder() {
    ArmazemResumo._defaults(this);
  }

  ArmazemResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _codigo = $v.codigo;
      _nome = $v.nome;
      _zonas = $v.zonas;
      _enderecos = $v.enderecos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArmazemResumo other) {
    _$v = other as _$ArmazemResumo;
  }

  @override
  void update(void Function(ArmazemResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArmazemResumo build() => _build();

  _$ArmazemResumo _build() {
    final _$result = _$v ??
        _$ArmazemResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ArmazemResumo', 'id'),
          codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'ArmazemResumo', 'codigo'),
          nome: BuiltValueNullFieldError.checkNotNull(nome, r'ArmazemResumo', 'nome'),
          zonas: BuiltValueNullFieldError.checkNotNull(zonas, r'ArmazemResumo', 'zonas'),
          enderecos: BuiltValueNullFieldError.checkNotNull(enderecos, r'ArmazemResumo', 'enderecos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
