// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sugestao_endereco.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SugestaoEndereco extends SugestaoEndereco {
  @override
  final String enderecoId;
  @override
  final String codigo;
  @override
  final double pontuacao;
  @override
  final BuiltList<NotaRegra> notas;

  factory _$SugestaoEndereco([void Function(SugestaoEnderecoBuilder)? updates]) =>
      (SugestaoEnderecoBuilder()..update(updates))._build();

  _$SugestaoEndereco._({required this.enderecoId, required this.codigo, required this.pontuacao, required this.notas})
      : super._();
  @override
  SugestaoEndereco rebuild(void Function(SugestaoEnderecoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SugestaoEnderecoBuilder toBuilder() => SugestaoEnderecoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SugestaoEndereco &&
        enderecoId == other.enderecoId &&
        codigo == other.codigo &&
        pontuacao == other.pontuacao &&
        notas == other.notas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, pontuacao.hashCode);
    _$hash = $jc(_$hash, notas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SugestaoEndereco')
          ..add('enderecoId', enderecoId)
          ..add('codigo', codigo)
          ..add('pontuacao', pontuacao)
          ..add('notas', notas))
        .toString();
  }
}

class SugestaoEnderecoBuilder implements Builder<SugestaoEndereco, SugestaoEnderecoBuilder> {
  _$SugestaoEndereco? _$v;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  double? _pontuacao;
  double? get pontuacao => _$this._pontuacao;
  set pontuacao(double? pontuacao) => _$this._pontuacao = pontuacao;

  ListBuilder<NotaRegra>? _notas;
  ListBuilder<NotaRegra> get notas => _$this._notas ??= ListBuilder<NotaRegra>();
  set notas(ListBuilder<NotaRegra>? notas) => _$this._notas = notas;

  SugestaoEnderecoBuilder() {
    SugestaoEndereco._defaults(this);
  }

  SugestaoEnderecoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enderecoId = $v.enderecoId;
      _codigo = $v.codigo;
      _pontuacao = $v.pontuacao;
      _notas = $v.notas.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SugestaoEndereco other) {
    _$v = other as _$SugestaoEndereco;
  }

  @override
  void update(void Function(SugestaoEnderecoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SugestaoEndereco build() => _build();

  _$SugestaoEndereco _build() {
    _$SugestaoEndereco _$result;
    try {
      _$result = _$v ??
          _$SugestaoEndereco._(
            enderecoId: BuiltValueNullFieldError.checkNotNull(enderecoId, r'SugestaoEndereco', 'enderecoId'),
            codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'SugestaoEndereco', 'codigo'),
            pontuacao: BuiltValueNullFieldError.checkNotNull(pontuacao, r'SugestaoEndereco', 'pontuacao'),
            notas: notas.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notas';
        notas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'SugestaoEndereco', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
