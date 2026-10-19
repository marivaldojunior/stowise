// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salvar_zona.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalvarZona extends SalvarZona {
  @override
  final String? codigo;
  @override
  final ClasseArmazenagem? classeArmazenagem;

  factory _$SalvarZona([void Function(SalvarZonaBuilder)? updates]) => (SalvarZonaBuilder()..update(updates))._build();

  _$SalvarZona._({this.codigo, this.classeArmazenagem}) : super._();
  @override
  SalvarZona rebuild(void Function(SalvarZonaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SalvarZonaBuilder toBuilder() => SalvarZonaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalvarZona && codigo == other.codigo && classeArmazenagem == other.classeArmazenagem;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalvarZona')
          ..add('codigo', codigo)
          ..add('classeArmazenagem', classeArmazenagem))
        .toString();
  }
}

class SalvarZonaBuilder implements Builder<SalvarZona, SalvarZonaBuilder> {
  _$SalvarZona? _$v;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  SalvarZonaBuilder() {
    SalvarZona._defaults(this);
  }

  SalvarZonaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codigo = $v.codigo;
      _classeArmazenagem = $v.classeArmazenagem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalvarZona other) {
    _$v = other as _$SalvarZona;
  }

  @override
  void update(void Function(SalvarZonaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalvarZona build() => _build();

  _$SalvarZona _build() {
    final _$result = _$v ??
        _$SalvarZona._(
          codigo: codigo,
          classeArmazenagem: classeArmazenagem,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
