// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_arquivo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LayoutArquivo extends LayoutArquivo {
  @override
  final FormatoArquivo formato;
  @override
  final String? encoding;
  @override
  final String? delimitador;
  @override
  final String separadorDecimal;
  @override
  final bool temCabecalho;
  @override
  final BuiltList<ColunaArquivo> colunas;
  @override
  final String? planilha;

  factory _$LayoutArquivo([void Function(LayoutArquivoBuilder)? updates]) =>
      (LayoutArquivoBuilder()..update(updates))._build();

  _$LayoutArquivo._(
      {required this.formato,
      this.encoding,
      this.delimitador,
      required this.separadorDecimal,
      required this.temCabecalho,
      required this.colunas,
      this.planilha})
      : super._();
  @override
  LayoutArquivo rebuild(void Function(LayoutArquivoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LayoutArquivoBuilder toBuilder() => LayoutArquivoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LayoutArquivo &&
        formato == other.formato &&
        encoding == other.encoding &&
        delimitador == other.delimitador &&
        separadorDecimal == other.separadorDecimal &&
        temCabecalho == other.temCabecalho &&
        colunas == other.colunas &&
        planilha == other.planilha;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, formato.hashCode);
    _$hash = $jc(_$hash, encoding.hashCode);
    _$hash = $jc(_$hash, delimitador.hashCode);
    _$hash = $jc(_$hash, separadorDecimal.hashCode);
    _$hash = $jc(_$hash, temCabecalho.hashCode);
    _$hash = $jc(_$hash, colunas.hashCode);
    _$hash = $jc(_$hash, planilha.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LayoutArquivo')
          ..add('formato', formato)
          ..add('encoding', encoding)
          ..add('delimitador', delimitador)
          ..add('separadorDecimal', separadorDecimal)
          ..add('temCabecalho', temCabecalho)
          ..add('colunas', colunas)
          ..add('planilha', planilha))
        .toString();
  }
}

class LayoutArquivoBuilder implements Builder<LayoutArquivo, LayoutArquivoBuilder> {
  _$LayoutArquivo? _$v;

  FormatoArquivo? _formato;
  FormatoArquivo? get formato => _$this._formato;
  set formato(FormatoArquivo? formato) => _$this._formato = formato;

  String? _encoding;
  String? get encoding => _$this._encoding;
  set encoding(String? encoding) => _$this._encoding = encoding;

  String? _delimitador;
  String? get delimitador => _$this._delimitador;
  set delimitador(String? delimitador) => _$this._delimitador = delimitador;

  String? _separadorDecimal;
  String? get separadorDecimal => _$this._separadorDecimal;
  set separadorDecimal(String? separadorDecimal) => _$this._separadorDecimal = separadorDecimal;

  bool? _temCabecalho;
  bool? get temCabecalho => _$this._temCabecalho;
  set temCabecalho(bool? temCabecalho) => _$this._temCabecalho = temCabecalho;

  ListBuilder<ColunaArquivo>? _colunas;
  ListBuilder<ColunaArquivo> get colunas => _$this._colunas ??= ListBuilder<ColunaArquivo>();
  set colunas(ListBuilder<ColunaArquivo>? colunas) => _$this._colunas = colunas;

  String? _planilha;
  String? get planilha => _$this._planilha;
  set planilha(String? planilha) => _$this._planilha = planilha;

  LayoutArquivoBuilder() {
    LayoutArquivo._defaults(this);
  }

  LayoutArquivoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formato = $v.formato;
      _encoding = $v.encoding;
      _delimitador = $v.delimitador;
      _separadorDecimal = $v.separadorDecimal;
      _temCabecalho = $v.temCabecalho;
      _colunas = $v.colunas.toBuilder();
      _planilha = $v.planilha;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LayoutArquivo other) {
    _$v = other as _$LayoutArquivo;
  }

  @override
  void update(void Function(LayoutArquivoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LayoutArquivo build() => _build();

  _$LayoutArquivo _build() {
    _$LayoutArquivo _$result;
    try {
      _$result = _$v ??
          _$LayoutArquivo._(
            formato: BuiltValueNullFieldError.checkNotNull(formato, r'LayoutArquivo', 'formato'),
            encoding: encoding,
            delimitador: delimitador,
            separadorDecimal:
                BuiltValueNullFieldError.checkNotNull(separadorDecimal, r'LayoutArquivo', 'separadorDecimal'),
            temCabecalho: BuiltValueNullFieldError.checkNotNull(temCabecalho, r'LayoutArquivo', 'temCabecalho'),
            colunas: colunas.build(),
            planilha: planilha,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'colunas';
        colunas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'LayoutArquivo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
