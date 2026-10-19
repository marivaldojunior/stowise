// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UsuarioResumo extends UsuarioResumo {
  @override
  final String id;
  @override
  final String nome;
  @override
  final String email;
  @override
  final BuiltList<String> perfis;

  factory _$UsuarioResumo([void Function(UsuarioResumoBuilder)? updates]) =>
      (UsuarioResumoBuilder()..update(updates))._build();

  _$UsuarioResumo._({required this.id, required this.nome, required this.email, required this.perfis}) : super._();
  @override
  UsuarioResumo rebuild(void Function(UsuarioResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  UsuarioResumoBuilder toBuilder() => UsuarioResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsuarioResumo &&
        id == other.id &&
        nome == other.nome &&
        email == other.email &&
        perfis == other.perfis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, perfis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsuarioResumo')
          ..add('id', id)
          ..add('nome', nome)
          ..add('email', email)
          ..add('perfis', perfis))
        .toString();
  }
}

class UsuarioResumoBuilder implements Builder<UsuarioResumo, UsuarioResumoBuilder> {
  _$UsuarioResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ListBuilder<String>? _perfis;
  ListBuilder<String> get perfis => _$this._perfis ??= ListBuilder<String>();
  set perfis(ListBuilder<String>? perfis) => _$this._perfis = perfis;

  UsuarioResumoBuilder() {
    UsuarioResumo._defaults(this);
  }

  UsuarioResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nome = $v.nome;
      _email = $v.email;
      _perfis = $v.perfis.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsuarioResumo other) {
    _$v = other as _$UsuarioResumo;
  }

  @override
  void update(void Function(UsuarioResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsuarioResumo build() => _build();

  _$UsuarioResumo _build() {
    _$UsuarioResumo _$result;
    try {
      _$result = _$v ??
          _$UsuarioResumo._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'UsuarioResumo', 'id'),
            nome: BuiltValueNullFieldError.checkNotNull(nome, r'UsuarioResumo', 'nome'),
            email: BuiltValueNullFieldError.checkNotNull(email, r'UsuarioResumo', 'email'),
            perfis: perfis.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'perfis';
        perfis.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UsuarioResumo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
