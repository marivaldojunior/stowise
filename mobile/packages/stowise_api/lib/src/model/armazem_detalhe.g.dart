// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armazem_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArmazemDetalhe extends ArmazemDetalhe {
  @override
  final String id;
  @override
  final String codigo;
  @override
  final String nome;
  @override
  final BuiltList<ZonaDetalhe> zonas;

  factory _$ArmazemDetalhe([void Function(ArmazemDetalheBuilder)? updates]) =>
      (ArmazemDetalheBuilder()..update(updates))._build();

  _$ArmazemDetalhe._({required this.id, required this.codigo, required this.nome, required this.zonas}) : super._();
  @override
  ArmazemDetalhe rebuild(void Function(ArmazemDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ArmazemDetalheBuilder toBuilder() => ArmazemDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArmazemDetalhe &&
        id == other.id &&
        codigo == other.codigo &&
        nome == other.nome &&
        zonas == other.zonas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, zonas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ArmazemDetalhe')
          ..add('id', id)
          ..add('codigo', codigo)
          ..add('nome', nome)
          ..add('zonas', zonas))
        .toString();
  }
}

class ArmazemDetalheBuilder implements Builder<ArmazemDetalhe, ArmazemDetalheBuilder> {
  _$ArmazemDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  ListBuilder<ZonaDetalhe>? _zonas;
  ListBuilder<ZonaDetalhe> get zonas => _$this._zonas ??= ListBuilder<ZonaDetalhe>();
  set zonas(ListBuilder<ZonaDetalhe>? zonas) => _$this._zonas = zonas;

  ArmazemDetalheBuilder() {
    ArmazemDetalhe._defaults(this);
  }

  ArmazemDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _codigo = $v.codigo;
      _nome = $v.nome;
      _zonas = $v.zonas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArmazemDetalhe other) {
    _$v = other as _$ArmazemDetalhe;
  }

  @override
  void update(void Function(ArmazemDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArmazemDetalhe build() => _build();

  _$ArmazemDetalhe _build() {
    _$ArmazemDetalhe _$result;
    try {
      _$result = _$v ??
          _$ArmazemDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ArmazemDetalhe', 'id'),
            codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'ArmazemDetalhe', 'codigo'),
            nome: BuiltValueNullFieldError.checkNotNull(nome, r'ArmazemDetalhe', 'nome'),
            zonas: zonas.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zonas';
        zonas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ArmazemDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
