// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UsuarioDetalhe extends UsuarioDetalhe {
  @override
  final String id;
  @override
  final String nome;
  @override
  final String email;
  @override
  final BuiltList<String> perfis;
  @override
  final bool ativo;
  @override
  final bool bloqueado;
  @override
  final DateTime criadoEm;

  factory _$UsuarioDetalhe([void Function(UsuarioDetalheBuilder)? updates]) =>
      (UsuarioDetalheBuilder()..update(updates))._build();

  _$UsuarioDetalhe._(
      {required this.id,
      required this.nome,
      required this.email,
      required this.perfis,
      required this.ativo,
      required this.bloqueado,
      required this.criadoEm})
      : super._();
  @override
  UsuarioDetalhe rebuild(void Function(UsuarioDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  UsuarioDetalheBuilder toBuilder() => UsuarioDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsuarioDetalhe &&
        id == other.id &&
        nome == other.nome &&
        email == other.email &&
        perfis == other.perfis &&
        ativo == other.ativo &&
        bloqueado == other.bloqueado &&
        criadoEm == other.criadoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, perfis.hashCode);
    _$hash = $jc(_$hash, ativo.hashCode);
    _$hash = $jc(_$hash, bloqueado.hashCode);
    _$hash = $jc(_$hash, criadoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsuarioDetalhe')
          ..add('id', id)
          ..add('nome', nome)
          ..add('email', email)
          ..add('perfis', perfis)
          ..add('ativo', ativo)
          ..add('bloqueado', bloqueado)
          ..add('criadoEm', criadoEm))
        .toString();
  }
}

class UsuarioDetalheBuilder implements Builder<UsuarioDetalhe, UsuarioDetalheBuilder> {
  _$UsuarioDetalhe? _$v;

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

  bool? _ativo;
  bool? get ativo => _$this._ativo;
  set ativo(bool? ativo) => _$this._ativo = ativo;

  bool? _bloqueado;
  bool? get bloqueado => _$this._bloqueado;
  set bloqueado(bool? bloqueado) => _$this._bloqueado = bloqueado;

  DateTime? _criadoEm;
  DateTime? get criadoEm => _$this._criadoEm;
  set criadoEm(DateTime? criadoEm) => _$this._criadoEm = criadoEm;

  UsuarioDetalheBuilder() {
    UsuarioDetalhe._defaults(this);
  }

  UsuarioDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nome = $v.nome;
      _email = $v.email;
      _perfis = $v.perfis.toBuilder();
      _ativo = $v.ativo;
      _bloqueado = $v.bloqueado;
      _criadoEm = $v.criadoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsuarioDetalhe other) {
    _$v = other as _$UsuarioDetalhe;
  }

  @override
  void update(void Function(UsuarioDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsuarioDetalhe build() => _build();

  _$UsuarioDetalhe _build() {
    _$UsuarioDetalhe _$result;
    try {
      _$result = _$v ??
          _$UsuarioDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'UsuarioDetalhe', 'id'),
            nome: BuiltValueNullFieldError.checkNotNull(nome, r'UsuarioDetalhe', 'nome'),
            email: BuiltValueNullFieldError.checkNotNull(email, r'UsuarioDetalhe', 'email'),
            perfis: perfis.build(),
            ativo: BuiltValueNullFieldError.checkNotNull(ativo, r'UsuarioDetalhe', 'ativo'),
            bloqueado: BuiltValueNullFieldError.checkNotNull(bloqueado, r'UsuarioDetalhe', 'bloqueado'),
            criadoEm: BuiltValueNullFieldError.checkNotNull(criadoEm, r'UsuarioDetalhe', 'criadoEm'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'perfis';
        perfis.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UsuarioDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
