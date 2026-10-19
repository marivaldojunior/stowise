// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zona_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZonaDetalhe extends ZonaDetalhe {
  @override
  final String id;
  @override
  final String codigo;
  @override
  final ClasseArmazenagem classeArmazenagem;
  @override
  final int enderecos;

  factory _$ZonaDetalhe([void Function(ZonaDetalheBuilder)? updates]) =>
      (ZonaDetalheBuilder()..update(updates))._build();

  _$ZonaDetalhe._({required this.id, required this.codigo, required this.classeArmazenagem, required this.enderecos})
      : super._();
  @override
  ZonaDetalhe rebuild(void Function(ZonaDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ZonaDetalheBuilder toBuilder() => ZonaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZonaDetalhe &&
        id == other.id &&
        codigo == other.codigo &&
        classeArmazenagem == other.classeArmazenagem &&
        enderecos == other.enderecos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, enderecos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZonaDetalhe')
          ..add('id', id)
          ..add('codigo', codigo)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('enderecos', enderecos))
        .toString();
  }
}

class ZonaDetalheBuilder implements Builder<ZonaDetalhe, ZonaDetalheBuilder> {
  _$ZonaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  int? _enderecos;
  int? get enderecos => _$this._enderecos;
  set enderecos(int? enderecos) => _$this._enderecos = enderecos;

  ZonaDetalheBuilder() {
    ZonaDetalhe._defaults(this);
  }

  ZonaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _codigo = $v.codigo;
      _classeArmazenagem = $v.classeArmazenagem;
      _enderecos = $v.enderecos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZonaDetalhe other) {
    _$v = other as _$ZonaDetalhe;
  }

  @override
  void update(void Function(ZonaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZonaDetalhe build() => _build();

  _$ZonaDetalhe _build() {
    final _$result = _$v ??
        _$ZonaDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ZonaDetalhe', 'id'),
          codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'ZonaDetalhe', 'codigo'),
          classeArmazenagem:
              BuiltValueNullFieldError.checkNotNull(classeArmazenagem, r'ZonaDetalhe', 'classeArmazenagem'),
          enderecos: BuiltValueNullFieldError.checkNotNull(enderecos, r'ZonaDetalhe', 'enderecos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
