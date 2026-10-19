// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coluna_arquivo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ColunaArquivo extends ColunaArquivo {
  @override
  final int indice;
  @override
  final String nome;
  @override
  final int? inicio;
  @override
  final int? tamanho;

  factory _$ColunaArquivo([void Function(ColunaArquivoBuilder)? updates]) =>
      (ColunaArquivoBuilder()..update(updates))._build();

  _$ColunaArquivo._({required this.indice, required this.nome, this.inicio, this.tamanho}) : super._();
  @override
  ColunaArquivo rebuild(void Function(ColunaArquivoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ColunaArquivoBuilder toBuilder() => ColunaArquivoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ColunaArquivo &&
        indice == other.indice &&
        nome == other.nome &&
        inicio == other.inicio &&
        tamanho == other.tamanho;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, indice.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, inicio.hashCode);
    _$hash = $jc(_$hash, tamanho.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ColunaArquivo')
          ..add('indice', indice)
          ..add('nome', nome)
          ..add('inicio', inicio)
          ..add('tamanho', tamanho))
        .toString();
  }
}

class ColunaArquivoBuilder implements Builder<ColunaArquivo, ColunaArquivoBuilder> {
  _$ColunaArquivo? _$v;

  int? _indice;
  int? get indice => _$this._indice;
  set indice(int? indice) => _$this._indice = indice;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  int? _inicio;
  int? get inicio => _$this._inicio;
  set inicio(int? inicio) => _$this._inicio = inicio;

  int? _tamanho;
  int? get tamanho => _$this._tamanho;
  set tamanho(int? tamanho) => _$this._tamanho = tamanho;

  ColunaArquivoBuilder() {
    ColunaArquivo._defaults(this);
  }

  ColunaArquivoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _indice = $v.indice;
      _nome = $v.nome;
      _inicio = $v.inicio;
      _tamanho = $v.tamanho;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ColunaArquivo other) {
    _$v = other as _$ColunaArquivo;
  }

  @override
  void update(void Function(ColunaArquivoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ColunaArquivo build() => _build();

  _$ColunaArquivo _build() {
    final _$result = _$v ??
        _$ColunaArquivo._(
          indice: BuiltValueNullFieldError.checkNotNull(indice, r'ColunaArquivo', 'indice'),
          nome: BuiltValueNullFieldError.checkNotNull(nome, r'ColunaArquivo', 'nome'),
          inicio: inicio,
          tamanho: tamanho,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
