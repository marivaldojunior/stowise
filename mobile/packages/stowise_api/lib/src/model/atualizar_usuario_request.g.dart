// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_usuario_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AtualizarUsuarioRequest extends AtualizarUsuarioRequest {
  @override
  final String? nome;
  @override
  final BuiltList<String>? perfis;

  factory _$AtualizarUsuarioRequest([void Function(AtualizarUsuarioRequestBuilder)? updates]) =>
      (AtualizarUsuarioRequestBuilder()..update(updates))._build();

  _$AtualizarUsuarioRequest._({this.nome, this.perfis}) : super._();
  @override
  AtualizarUsuarioRequest rebuild(void Function(AtualizarUsuarioRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AtualizarUsuarioRequestBuilder toBuilder() => AtualizarUsuarioRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AtualizarUsuarioRequest && nome == other.nome && perfis == other.perfis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, perfis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AtualizarUsuarioRequest')
          ..add('nome', nome)
          ..add('perfis', perfis))
        .toString();
  }
}

class AtualizarUsuarioRequestBuilder implements Builder<AtualizarUsuarioRequest, AtualizarUsuarioRequestBuilder> {
  _$AtualizarUsuarioRequest? _$v;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  ListBuilder<String>? _perfis;
  ListBuilder<String> get perfis => _$this._perfis ??= ListBuilder<String>();
  set perfis(ListBuilder<String>? perfis) => _$this._perfis = perfis;

  AtualizarUsuarioRequestBuilder() {
    AtualizarUsuarioRequest._defaults(this);
  }

  AtualizarUsuarioRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nome = $v.nome;
      _perfis = $v.perfis?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AtualizarUsuarioRequest other) {
    _$v = other as _$AtualizarUsuarioRequest;
  }

  @override
  void update(void Function(AtualizarUsuarioRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AtualizarUsuarioRequest build() => _build();

  _$AtualizarUsuarioRequest _build() {
    _$AtualizarUsuarioRequest _$result;
    try {
      _$result = _$v ??
          _$AtualizarUsuarioRequest._(
            nome: nome,
            perfis: _perfis?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'perfis';
        _perfis?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AtualizarUsuarioRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
