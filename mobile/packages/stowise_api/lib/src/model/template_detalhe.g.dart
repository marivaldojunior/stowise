// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TemplateDetalhe extends TemplateDetalhe {
  @override
  final String id;
  @override
  final TipoImportacao tipo;
  @override
  final String nome;
  @override
  final String fingerprint;
  @override
  final FormatoArquivo formato;
  @override
  final String? encoding;
  @override
  final String? delimitador;
  @override
  final String separadorDecimal;
  @override
  final BuiltList<MapeamentoColuna> mapeamento;
  @override
  final RegrasNormalizacao regras;
  @override
  final bool sugeridoPorIa;
  @override
  final String confirmadoPor;
  @override
  final DateTime confirmadoEm;
  @override
  final int vezesUsado;
  @override
  final DateTime ultimoUsoEm;
  @override
  final int versao;

  factory _$TemplateDetalhe([void Function(TemplateDetalheBuilder)? updates]) =>
      (TemplateDetalheBuilder()..update(updates))._build();

  _$TemplateDetalhe._(
      {required this.id,
      required this.tipo,
      required this.nome,
      required this.fingerprint,
      required this.formato,
      this.encoding,
      this.delimitador,
      required this.separadorDecimal,
      required this.mapeamento,
      required this.regras,
      required this.sugeridoPorIa,
      required this.confirmadoPor,
      required this.confirmadoEm,
      required this.vezesUsado,
      required this.ultimoUsoEm,
      required this.versao})
      : super._();
  @override
  TemplateDetalhe rebuild(void Function(TemplateDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  TemplateDetalheBuilder toBuilder() => TemplateDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TemplateDetalhe &&
        id == other.id &&
        tipo == other.tipo &&
        nome == other.nome &&
        fingerprint == other.fingerprint &&
        formato == other.formato &&
        encoding == other.encoding &&
        delimitador == other.delimitador &&
        separadorDecimal == other.separadorDecimal &&
        mapeamento == other.mapeamento &&
        regras == other.regras &&
        sugeridoPorIa == other.sugeridoPorIa &&
        confirmadoPor == other.confirmadoPor &&
        confirmadoEm == other.confirmadoEm &&
        vezesUsado == other.vezesUsado &&
        ultimoUsoEm == other.ultimoUsoEm &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, nome.hashCode);
    _$hash = $jc(_$hash, fingerprint.hashCode);
    _$hash = $jc(_$hash, formato.hashCode);
    _$hash = $jc(_$hash, encoding.hashCode);
    _$hash = $jc(_$hash, delimitador.hashCode);
    _$hash = $jc(_$hash, separadorDecimal.hashCode);
    _$hash = $jc(_$hash, mapeamento.hashCode);
    _$hash = $jc(_$hash, regras.hashCode);
    _$hash = $jc(_$hash, sugeridoPorIa.hashCode);
    _$hash = $jc(_$hash, confirmadoPor.hashCode);
    _$hash = $jc(_$hash, confirmadoEm.hashCode);
    _$hash = $jc(_$hash, vezesUsado.hashCode);
    _$hash = $jc(_$hash, ultimoUsoEm.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TemplateDetalhe')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('nome', nome)
          ..add('fingerprint', fingerprint)
          ..add('formato', formato)
          ..add('encoding', encoding)
          ..add('delimitador', delimitador)
          ..add('separadorDecimal', separadorDecimal)
          ..add('mapeamento', mapeamento)
          ..add('regras', regras)
          ..add('sugeridoPorIa', sugeridoPorIa)
          ..add('confirmadoPor', confirmadoPor)
          ..add('confirmadoEm', confirmadoEm)
          ..add('vezesUsado', vezesUsado)
          ..add('ultimoUsoEm', ultimoUsoEm)
          ..add('versao', versao))
        .toString();
  }
}

class TemplateDetalheBuilder implements Builder<TemplateDetalhe, TemplateDetalheBuilder> {
  _$TemplateDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoImportacao? _tipo;
  TipoImportacao? get tipo => _$this._tipo;
  set tipo(TipoImportacao? tipo) => _$this._tipo = tipo;

  String? _nome;
  String? get nome => _$this._nome;
  set nome(String? nome) => _$this._nome = nome;

  String? _fingerprint;
  String? get fingerprint => _$this._fingerprint;
  set fingerprint(String? fingerprint) => _$this._fingerprint = fingerprint;

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

  ListBuilder<MapeamentoColuna>? _mapeamento;
  ListBuilder<MapeamentoColuna> get mapeamento => _$this._mapeamento ??= ListBuilder<MapeamentoColuna>();
  set mapeamento(ListBuilder<MapeamentoColuna>? mapeamento) => _$this._mapeamento = mapeamento;

  RegrasNormalizacaoBuilder? _regras;
  RegrasNormalizacaoBuilder get regras => _$this._regras ??= RegrasNormalizacaoBuilder();
  set regras(RegrasNormalizacaoBuilder? regras) => _$this._regras = regras;

  bool? _sugeridoPorIa;
  bool? get sugeridoPorIa => _$this._sugeridoPorIa;
  set sugeridoPorIa(bool? sugeridoPorIa) => _$this._sugeridoPorIa = sugeridoPorIa;

  String? _confirmadoPor;
  String? get confirmadoPor => _$this._confirmadoPor;
  set confirmadoPor(String? confirmadoPor) => _$this._confirmadoPor = confirmadoPor;

  DateTime? _confirmadoEm;
  DateTime? get confirmadoEm => _$this._confirmadoEm;
  set confirmadoEm(DateTime? confirmadoEm) => _$this._confirmadoEm = confirmadoEm;

  int? _vezesUsado;
  int? get vezesUsado => _$this._vezesUsado;
  set vezesUsado(int? vezesUsado) => _$this._vezesUsado = vezesUsado;

  DateTime? _ultimoUsoEm;
  DateTime? get ultimoUsoEm => _$this._ultimoUsoEm;
  set ultimoUsoEm(DateTime? ultimoUsoEm) => _$this._ultimoUsoEm = ultimoUsoEm;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  TemplateDetalheBuilder() {
    TemplateDetalhe._defaults(this);
  }

  TemplateDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _nome = $v.nome;
      _fingerprint = $v.fingerprint;
      _formato = $v.formato;
      _encoding = $v.encoding;
      _delimitador = $v.delimitador;
      _separadorDecimal = $v.separadorDecimal;
      _mapeamento = $v.mapeamento.toBuilder();
      _regras = $v.regras.toBuilder();
      _sugeridoPorIa = $v.sugeridoPorIa;
      _confirmadoPor = $v.confirmadoPor;
      _confirmadoEm = $v.confirmadoEm;
      _vezesUsado = $v.vezesUsado;
      _ultimoUsoEm = $v.ultimoUsoEm;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TemplateDetalhe other) {
    _$v = other as _$TemplateDetalhe;
  }

  @override
  void update(void Function(TemplateDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TemplateDetalhe build() => _build();

  _$TemplateDetalhe _build() {
    _$TemplateDetalhe _$result;
    try {
      _$result = _$v ??
          _$TemplateDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'TemplateDetalhe', 'id'),
            tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'TemplateDetalhe', 'tipo'),
            nome: BuiltValueNullFieldError.checkNotNull(nome, r'TemplateDetalhe', 'nome'),
            fingerprint: BuiltValueNullFieldError.checkNotNull(fingerprint, r'TemplateDetalhe', 'fingerprint'),
            formato: BuiltValueNullFieldError.checkNotNull(formato, r'TemplateDetalhe', 'formato'),
            encoding: encoding,
            delimitador: delimitador,
            separadorDecimal:
                BuiltValueNullFieldError.checkNotNull(separadorDecimal, r'TemplateDetalhe', 'separadorDecimal'),
            mapeamento: mapeamento.build(),
            regras: regras.build(),
            sugeridoPorIa: BuiltValueNullFieldError.checkNotNull(sugeridoPorIa, r'TemplateDetalhe', 'sugeridoPorIa'),
            confirmadoPor: BuiltValueNullFieldError.checkNotNull(confirmadoPor, r'TemplateDetalhe', 'confirmadoPor'),
            confirmadoEm: BuiltValueNullFieldError.checkNotNull(confirmadoEm, r'TemplateDetalhe', 'confirmadoEm'),
            vezesUsado: BuiltValueNullFieldError.checkNotNull(vezesUsado, r'TemplateDetalhe', 'vezesUsado'),
            ultimoUsoEm: BuiltValueNullFieldError.checkNotNull(ultimoUsoEm, r'TemplateDetalhe', 'ultimoUsoEm'),
            versao: BuiltValueNullFieldError.checkNotNull(versao, r'TemplateDetalhe', 'versao'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mapeamento';
        mapeamento.build();
        _$failedField = 'regras';
        regras.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'TemplateDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
