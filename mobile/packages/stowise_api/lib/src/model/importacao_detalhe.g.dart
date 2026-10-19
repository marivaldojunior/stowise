// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importacao_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportacaoDetalhe extends ImportacaoDetalhe {
  @override
  final String id;
  @override
  final TipoImportacao tipo;
  @override
  final StatusImportacao status;
  @override
  final String nomeArquivo;
  @override
  final String hashArquivo;
  @override
  final int tamanhoBytes;
  @override
  final LayoutArquivo layout;
  @override
  final BuiltList<BuiltList<String>> amostra;
  @override
  final int totalLinhas;
  @override
  final String usuarioId;
  @override
  final DateTime iniciadoEm;
  @override
  final DateTime? concluidoEm;
  @override
  final String? fingerprint;
  @override
  final String? templateId;
  @override
  final BuiltList<MapeamentoColuna>? mapeamento;
  @override
  final String? mapeamentoConfirmadoPor;
  @override
  final DateTime? mapeamentoConfirmadoEm;
  @override
  final int linhasValidas;
  @override
  final int linhasComErro;
  @override
  final int linhasPossivelDuplicata;
  @override
  final int linhasProcessadas;
  @override
  final int produtosCriados;
  @override
  final int produtosAtualizados;
  @override
  final String? motivoFalha;
  @override
  final RegrasNormalizacao? regras;
  @override
  final SugestaoIa? sugestaoIa;
  @override
  final bool mapeamentoSugeridoPorIa;
  @override
  final String? motivoSemSugestao;
  @override
  final int versao;

  factory _$ImportacaoDetalhe([void Function(ImportacaoDetalheBuilder)? updates]) =>
      (ImportacaoDetalheBuilder()..update(updates))._build();

  _$ImportacaoDetalhe._(
      {required this.id,
      required this.tipo,
      required this.status,
      required this.nomeArquivo,
      required this.hashArquivo,
      required this.tamanhoBytes,
      required this.layout,
      required this.amostra,
      required this.totalLinhas,
      required this.usuarioId,
      required this.iniciadoEm,
      this.concluidoEm,
      this.fingerprint,
      this.templateId,
      this.mapeamento,
      this.mapeamentoConfirmadoPor,
      this.mapeamentoConfirmadoEm,
      required this.linhasValidas,
      required this.linhasComErro,
      required this.linhasPossivelDuplicata,
      required this.linhasProcessadas,
      required this.produtosCriados,
      required this.produtosAtualizados,
      this.motivoFalha,
      this.regras,
      this.sugestaoIa,
      required this.mapeamentoSugeridoPorIa,
      this.motivoSemSugestao,
      required this.versao})
      : super._();
  @override
  ImportacaoDetalhe rebuild(void Function(ImportacaoDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ImportacaoDetalheBuilder toBuilder() => ImportacaoDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportacaoDetalhe &&
        id == other.id &&
        tipo == other.tipo &&
        status == other.status &&
        nomeArquivo == other.nomeArquivo &&
        hashArquivo == other.hashArquivo &&
        tamanhoBytes == other.tamanhoBytes &&
        layout == other.layout &&
        amostra == other.amostra &&
        totalLinhas == other.totalLinhas &&
        usuarioId == other.usuarioId &&
        iniciadoEm == other.iniciadoEm &&
        concluidoEm == other.concluidoEm &&
        fingerprint == other.fingerprint &&
        templateId == other.templateId &&
        mapeamento == other.mapeamento &&
        mapeamentoConfirmadoPor == other.mapeamentoConfirmadoPor &&
        mapeamentoConfirmadoEm == other.mapeamentoConfirmadoEm &&
        linhasValidas == other.linhasValidas &&
        linhasComErro == other.linhasComErro &&
        linhasPossivelDuplicata == other.linhasPossivelDuplicata &&
        linhasProcessadas == other.linhasProcessadas &&
        produtosCriados == other.produtosCriados &&
        produtosAtualizados == other.produtosAtualizados &&
        motivoFalha == other.motivoFalha &&
        regras == other.regras &&
        sugestaoIa == other.sugestaoIa &&
        mapeamentoSugeridoPorIa == other.mapeamentoSugeridoPorIa &&
        motivoSemSugestao == other.motivoSemSugestao &&
        versao == other.versao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, nomeArquivo.hashCode);
    _$hash = $jc(_$hash, hashArquivo.hashCode);
    _$hash = $jc(_$hash, tamanhoBytes.hashCode);
    _$hash = $jc(_$hash, layout.hashCode);
    _$hash = $jc(_$hash, amostra.hashCode);
    _$hash = $jc(_$hash, totalLinhas.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, iniciadoEm.hashCode);
    _$hash = $jc(_$hash, concluidoEm.hashCode);
    _$hash = $jc(_$hash, fingerprint.hashCode);
    _$hash = $jc(_$hash, templateId.hashCode);
    _$hash = $jc(_$hash, mapeamento.hashCode);
    _$hash = $jc(_$hash, mapeamentoConfirmadoPor.hashCode);
    _$hash = $jc(_$hash, mapeamentoConfirmadoEm.hashCode);
    _$hash = $jc(_$hash, linhasValidas.hashCode);
    _$hash = $jc(_$hash, linhasComErro.hashCode);
    _$hash = $jc(_$hash, linhasPossivelDuplicata.hashCode);
    _$hash = $jc(_$hash, linhasProcessadas.hashCode);
    _$hash = $jc(_$hash, produtosCriados.hashCode);
    _$hash = $jc(_$hash, produtosAtualizados.hashCode);
    _$hash = $jc(_$hash, motivoFalha.hashCode);
    _$hash = $jc(_$hash, regras.hashCode);
    _$hash = $jc(_$hash, sugestaoIa.hashCode);
    _$hash = $jc(_$hash, mapeamentoSugeridoPorIa.hashCode);
    _$hash = $jc(_$hash, motivoSemSugestao.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportacaoDetalhe')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('status', status)
          ..add('nomeArquivo', nomeArquivo)
          ..add('hashArquivo', hashArquivo)
          ..add('tamanhoBytes', tamanhoBytes)
          ..add('layout', layout)
          ..add('amostra', amostra)
          ..add('totalLinhas', totalLinhas)
          ..add('usuarioId', usuarioId)
          ..add('iniciadoEm', iniciadoEm)
          ..add('concluidoEm', concluidoEm)
          ..add('fingerprint', fingerprint)
          ..add('templateId', templateId)
          ..add('mapeamento', mapeamento)
          ..add('mapeamentoConfirmadoPor', mapeamentoConfirmadoPor)
          ..add('mapeamentoConfirmadoEm', mapeamentoConfirmadoEm)
          ..add('linhasValidas', linhasValidas)
          ..add('linhasComErro', linhasComErro)
          ..add('linhasPossivelDuplicata', linhasPossivelDuplicata)
          ..add('linhasProcessadas', linhasProcessadas)
          ..add('produtosCriados', produtosCriados)
          ..add('produtosAtualizados', produtosAtualizados)
          ..add('motivoFalha', motivoFalha)
          ..add('regras', regras)
          ..add('sugestaoIa', sugestaoIa)
          ..add('mapeamentoSugeridoPorIa', mapeamentoSugeridoPorIa)
          ..add('motivoSemSugestao', motivoSemSugestao)
          ..add('versao', versao))
        .toString();
  }
}

class ImportacaoDetalheBuilder implements Builder<ImportacaoDetalhe, ImportacaoDetalheBuilder> {
  _$ImportacaoDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoImportacao? _tipo;
  TipoImportacao? get tipo => _$this._tipo;
  set tipo(TipoImportacao? tipo) => _$this._tipo = tipo;

  StatusImportacao? _status;
  StatusImportacao? get status => _$this._status;
  set status(StatusImportacao? status) => _$this._status = status;

  String? _nomeArquivo;
  String? get nomeArquivo => _$this._nomeArquivo;
  set nomeArquivo(String? nomeArquivo) => _$this._nomeArquivo = nomeArquivo;

  String? _hashArquivo;
  String? get hashArquivo => _$this._hashArquivo;
  set hashArquivo(String? hashArquivo) => _$this._hashArquivo = hashArquivo;

  int? _tamanhoBytes;
  int? get tamanhoBytes => _$this._tamanhoBytes;
  set tamanhoBytes(int? tamanhoBytes) => _$this._tamanhoBytes = tamanhoBytes;

  LayoutArquivoBuilder? _layout;
  LayoutArquivoBuilder get layout => _$this._layout ??= LayoutArquivoBuilder();
  set layout(LayoutArquivoBuilder? layout) => _$this._layout = layout;

  ListBuilder<BuiltList<String>>? _amostra;
  ListBuilder<BuiltList<String>> get amostra => _$this._amostra ??= ListBuilder<BuiltList<String>>();
  set amostra(ListBuilder<BuiltList<String>>? amostra) => _$this._amostra = amostra;

  int? _totalLinhas;
  int? get totalLinhas => _$this._totalLinhas;
  set totalLinhas(int? totalLinhas) => _$this._totalLinhas = totalLinhas;

  String? _usuarioId;
  String? get usuarioId => _$this._usuarioId;
  set usuarioId(String? usuarioId) => _$this._usuarioId = usuarioId;

  DateTime? _iniciadoEm;
  DateTime? get iniciadoEm => _$this._iniciadoEm;
  set iniciadoEm(DateTime? iniciadoEm) => _$this._iniciadoEm = iniciadoEm;

  DateTime? _concluidoEm;
  DateTime? get concluidoEm => _$this._concluidoEm;
  set concluidoEm(DateTime? concluidoEm) => _$this._concluidoEm = concluidoEm;

  String? _fingerprint;
  String? get fingerprint => _$this._fingerprint;
  set fingerprint(String? fingerprint) => _$this._fingerprint = fingerprint;

  String? _templateId;
  String? get templateId => _$this._templateId;
  set templateId(String? templateId) => _$this._templateId = templateId;

  ListBuilder<MapeamentoColuna>? _mapeamento;
  ListBuilder<MapeamentoColuna> get mapeamento => _$this._mapeamento ??= ListBuilder<MapeamentoColuna>();
  set mapeamento(ListBuilder<MapeamentoColuna>? mapeamento) => _$this._mapeamento = mapeamento;

  String? _mapeamentoConfirmadoPor;
  String? get mapeamentoConfirmadoPor => _$this._mapeamentoConfirmadoPor;
  set mapeamentoConfirmadoPor(String? mapeamentoConfirmadoPor) =>
      _$this._mapeamentoConfirmadoPor = mapeamentoConfirmadoPor;

  DateTime? _mapeamentoConfirmadoEm;
  DateTime? get mapeamentoConfirmadoEm => _$this._mapeamentoConfirmadoEm;
  set mapeamentoConfirmadoEm(DateTime? mapeamentoConfirmadoEm) =>
      _$this._mapeamentoConfirmadoEm = mapeamentoConfirmadoEm;

  int? _linhasValidas;
  int? get linhasValidas => _$this._linhasValidas;
  set linhasValidas(int? linhasValidas) => _$this._linhasValidas = linhasValidas;

  int? _linhasComErro;
  int? get linhasComErro => _$this._linhasComErro;
  set linhasComErro(int? linhasComErro) => _$this._linhasComErro = linhasComErro;

  int? _linhasPossivelDuplicata;
  int? get linhasPossivelDuplicata => _$this._linhasPossivelDuplicata;
  set linhasPossivelDuplicata(int? linhasPossivelDuplicata) =>
      _$this._linhasPossivelDuplicata = linhasPossivelDuplicata;

  int? _linhasProcessadas;
  int? get linhasProcessadas => _$this._linhasProcessadas;
  set linhasProcessadas(int? linhasProcessadas) => _$this._linhasProcessadas = linhasProcessadas;

  int? _produtosCriados;
  int? get produtosCriados => _$this._produtosCriados;
  set produtosCriados(int? produtosCriados) => _$this._produtosCriados = produtosCriados;

  int? _produtosAtualizados;
  int? get produtosAtualizados => _$this._produtosAtualizados;
  set produtosAtualizados(int? produtosAtualizados) => _$this._produtosAtualizados = produtosAtualizados;

  String? _motivoFalha;
  String? get motivoFalha => _$this._motivoFalha;
  set motivoFalha(String? motivoFalha) => _$this._motivoFalha = motivoFalha;

  RegrasNormalizacaoBuilder? _regras;
  RegrasNormalizacaoBuilder get regras => _$this._regras ??= RegrasNormalizacaoBuilder();
  set regras(RegrasNormalizacaoBuilder? regras) => _$this._regras = regras;

  SugestaoIaBuilder? _sugestaoIa;
  SugestaoIaBuilder get sugestaoIa => _$this._sugestaoIa ??= SugestaoIaBuilder();
  set sugestaoIa(SugestaoIaBuilder? sugestaoIa) => _$this._sugestaoIa = sugestaoIa;

  bool? _mapeamentoSugeridoPorIa;
  bool? get mapeamentoSugeridoPorIa => _$this._mapeamentoSugeridoPorIa;
  set mapeamentoSugeridoPorIa(bool? mapeamentoSugeridoPorIa) =>
      _$this._mapeamentoSugeridoPorIa = mapeamentoSugeridoPorIa;

  String? _motivoSemSugestao;
  String? get motivoSemSugestao => _$this._motivoSemSugestao;
  set motivoSemSugestao(String? motivoSemSugestao) => _$this._motivoSemSugestao = motivoSemSugestao;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  ImportacaoDetalheBuilder() {
    ImportacaoDetalhe._defaults(this);
  }

  ImportacaoDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _status = $v.status;
      _nomeArquivo = $v.nomeArquivo;
      _hashArquivo = $v.hashArquivo;
      _tamanhoBytes = $v.tamanhoBytes;
      _layout = $v.layout.toBuilder();
      _amostra = $v.amostra.toBuilder();
      _totalLinhas = $v.totalLinhas;
      _usuarioId = $v.usuarioId;
      _iniciadoEm = $v.iniciadoEm;
      _concluidoEm = $v.concluidoEm;
      _fingerprint = $v.fingerprint;
      _templateId = $v.templateId;
      _mapeamento = $v.mapeamento?.toBuilder();
      _mapeamentoConfirmadoPor = $v.mapeamentoConfirmadoPor;
      _mapeamentoConfirmadoEm = $v.mapeamentoConfirmadoEm;
      _linhasValidas = $v.linhasValidas;
      _linhasComErro = $v.linhasComErro;
      _linhasPossivelDuplicata = $v.linhasPossivelDuplicata;
      _linhasProcessadas = $v.linhasProcessadas;
      _produtosCriados = $v.produtosCriados;
      _produtosAtualizados = $v.produtosAtualizados;
      _motivoFalha = $v.motivoFalha;
      _regras = $v.regras?.toBuilder();
      _sugestaoIa = $v.sugestaoIa?.toBuilder();
      _mapeamentoSugeridoPorIa = $v.mapeamentoSugeridoPorIa;
      _motivoSemSugestao = $v.motivoSemSugestao;
      _versao = $v.versao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportacaoDetalhe other) {
    _$v = other as _$ImportacaoDetalhe;
  }

  @override
  void update(void Function(ImportacaoDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportacaoDetalhe build() => _build();

  _$ImportacaoDetalhe _build() {
    _$ImportacaoDetalhe _$result;
    try {
      _$result = _$v ??
          _$ImportacaoDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ImportacaoDetalhe', 'id'),
            tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'ImportacaoDetalhe', 'tipo'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'ImportacaoDetalhe', 'status'),
            nomeArquivo: BuiltValueNullFieldError.checkNotNull(nomeArquivo, r'ImportacaoDetalhe', 'nomeArquivo'),
            hashArquivo: BuiltValueNullFieldError.checkNotNull(hashArquivo, r'ImportacaoDetalhe', 'hashArquivo'),
            tamanhoBytes: BuiltValueNullFieldError.checkNotNull(tamanhoBytes, r'ImportacaoDetalhe', 'tamanhoBytes'),
            layout: layout.build(),
            amostra: amostra.build(),
            totalLinhas: BuiltValueNullFieldError.checkNotNull(totalLinhas, r'ImportacaoDetalhe', 'totalLinhas'),
            usuarioId: BuiltValueNullFieldError.checkNotNull(usuarioId, r'ImportacaoDetalhe', 'usuarioId'),
            iniciadoEm: BuiltValueNullFieldError.checkNotNull(iniciadoEm, r'ImportacaoDetalhe', 'iniciadoEm'),
            concluidoEm: concluidoEm,
            fingerprint: fingerprint,
            templateId: templateId,
            mapeamento: _mapeamento?.build(),
            mapeamentoConfirmadoPor: mapeamentoConfirmadoPor,
            mapeamentoConfirmadoEm: mapeamentoConfirmadoEm,
            linhasValidas: BuiltValueNullFieldError.checkNotNull(linhasValidas, r'ImportacaoDetalhe', 'linhasValidas'),
            linhasComErro: BuiltValueNullFieldError.checkNotNull(linhasComErro, r'ImportacaoDetalhe', 'linhasComErro'),
            linhasPossivelDuplicata: BuiltValueNullFieldError.checkNotNull(
                linhasPossivelDuplicata, r'ImportacaoDetalhe', 'linhasPossivelDuplicata'),
            linhasProcessadas:
                BuiltValueNullFieldError.checkNotNull(linhasProcessadas, r'ImportacaoDetalhe', 'linhasProcessadas'),
            produtosCriados:
                BuiltValueNullFieldError.checkNotNull(produtosCriados, r'ImportacaoDetalhe', 'produtosCriados'),
            produtosAtualizados:
                BuiltValueNullFieldError.checkNotNull(produtosAtualizados, r'ImportacaoDetalhe', 'produtosAtualizados'),
            motivoFalha: motivoFalha,
            regras: _regras?.build(),
            sugestaoIa: _sugestaoIa?.build(),
            mapeamentoSugeridoPorIa: BuiltValueNullFieldError.checkNotNull(
                mapeamentoSugeridoPorIa, r'ImportacaoDetalhe', 'mapeamentoSugeridoPorIa'),
            motivoSemSugestao: motivoSemSugestao,
            versao: BuiltValueNullFieldError.checkNotNull(versao, r'ImportacaoDetalhe', 'versao'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'layout';
        layout.build();
        _$failedField = 'amostra';
        amostra.build();

        _$failedField = 'mapeamento';
        _mapeamento?.build();

        _$failedField = 'regras';
        _regras?.build();
        _$failedField = 'sugestaoIa';
        _sugestaoIa?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ImportacaoDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
