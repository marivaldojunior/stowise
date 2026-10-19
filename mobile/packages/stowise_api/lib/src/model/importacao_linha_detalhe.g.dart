// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importacao_linha_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportacaoLinhaDetalhe extends ImportacaoLinhaDetalhe {
  @override
  final String id;
  @override
  final int numeroLinha;
  @override
  final BuiltList<String> dadosBrutos;
  @override
  final BuiltMap<String, String> dadosNormalizados;
  @override
  final StatusLinha status;
  @override
  final AcaoLinha acao;
  @override
  final String? produtoCorrespondenteId;
  @override
  final double? similaridade;
  @override
  final BuiltList<ErroLinha> erros;
  @override
  final DateTime? efetivadaEm;

  factory _$ImportacaoLinhaDetalhe([void Function(ImportacaoLinhaDetalheBuilder)? updates]) =>
      (ImportacaoLinhaDetalheBuilder()..update(updates))._build();

  _$ImportacaoLinhaDetalhe._(
      {required this.id,
      required this.numeroLinha,
      required this.dadosBrutos,
      required this.dadosNormalizados,
      required this.status,
      required this.acao,
      this.produtoCorrespondenteId,
      this.similaridade,
      required this.erros,
      this.efetivadaEm})
      : super._();
  @override
  ImportacaoLinhaDetalhe rebuild(void Function(ImportacaoLinhaDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImportacaoLinhaDetalheBuilder toBuilder() => ImportacaoLinhaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportacaoLinhaDetalhe &&
        id == other.id &&
        numeroLinha == other.numeroLinha &&
        dadosBrutos == other.dadosBrutos &&
        dadosNormalizados == other.dadosNormalizados &&
        status == other.status &&
        acao == other.acao &&
        produtoCorrespondenteId == other.produtoCorrespondenteId &&
        similaridade == other.similaridade &&
        erros == other.erros &&
        efetivadaEm == other.efetivadaEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, numeroLinha.hashCode);
    _$hash = $jc(_$hash, dadosBrutos.hashCode);
    _$hash = $jc(_$hash, dadosNormalizados.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, acao.hashCode);
    _$hash = $jc(_$hash, produtoCorrespondenteId.hashCode);
    _$hash = $jc(_$hash, similaridade.hashCode);
    _$hash = $jc(_$hash, erros.hashCode);
    _$hash = $jc(_$hash, efetivadaEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportacaoLinhaDetalhe')
          ..add('id', id)
          ..add('numeroLinha', numeroLinha)
          ..add('dadosBrutos', dadosBrutos)
          ..add('dadosNormalizados', dadosNormalizados)
          ..add('status', status)
          ..add('acao', acao)
          ..add('produtoCorrespondenteId', produtoCorrespondenteId)
          ..add('similaridade', similaridade)
          ..add('erros', erros)
          ..add('efetivadaEm', efetivadaEm))
        .toString();
  }
}

class ImportacaoLinhaDetalheBuilder implements Builder<ImportacaoLinhaDetalhe, ImportacaoLinhaDetalheBuilder> {
  _$ImportacaoLinhaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _numeroLinha;
  int? get numeroLinha => _$this._numeroLinha;
  set numeroLinha(int? numeroLinha) => _$this._numeroLinha = numeroLinha;

  ListBuilder<String>? _dadosBrutos;
  ListBuilder<String> get dadosBrutos => _$this._dadosBrutos ??= ListBuilder<String>();
  set dadosBrutos(ListBuilder<String>? dadosBrutos) => _$this._dadosBrutos = dadosBrutos;

  MapBuilder<String, String>? _dadosNormalizados;
  MapBuilder<String, String> get dadosNormalizados => _$this._dadosNormalizados ??= MapBuilder<String, String>();
  set dadosNormalizados(MapBuilder<String, String>? dadosNormalizados) => _$this._dadosNormalizados = dadosNormalizados;

  StatusLinha? _status;
  StatusLinha? get status => _$this._status;
  set status(StatusLinha? status) => _$this._status = status;

  AcaoLinha? _acao;
  AcaoLinha? get acao => _$this._acao;
  set acao(AcaoLinha? acao) => _$this._acao = acao;

  String? _produtoCorrespondenteId;
  String? get produtoCorrespondenteId => _$this._produtoCorrespondenteId;
  set produtoCorrespondenteId(String? produtoCorrespondenteId) =>
      _$this._produtoCorrespondenteId = produtoCorrespondenteId;

  double? _similaridade;
  double? get similaridade => _$this._similaridade;
  set similaridade(double? similaridade) => _$this._similaridade = similaridade;

  ListBuilder<ErroLinha>? _erros;
  ListBuilder<ErroLinha> get erros => _$this._erros ??= ListBuilder<ErroLinha>();
  set erros(ListBuilder<ErroLinha>? erros) => _$this._erros = erros;

  DateTime? _efetivadaEm;
  DateTime? get efetivadaEm => _$this._efetivadaEm;
  set efetivadaEm(DateTime? efetivadaEm) => _$this._efetivadaEm = efetivadaEm;

  ImportacaoLinhaDetalheBuilder() {
    ImportacaoLinhaDetalhe._defaults(this);
  }

  ImportacaoLinhaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _numeroLinha = $v.numeroLinha;
      _dadosBrutos = $v.dadosBrutos.toBuilder();
      _dadosNormalizados = $v.dadosNormalizados.toBuilder();
      _status = $v.status;
      _acao = $v.acao;
      _produtoCorrespondenteId = $v.produtoCorrespondenteId;
      _similaridade = $v.similaridade;
      _erros = $v.erros.toBuilder();
      _efetivadaEm = $v.efetivadaEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportacaoLinhaDetalhe other) {
    _$v = other as _$ImportacaoLinhaDetalhe;
  }

  @override
  void update(void Function(ImportacaoLinhaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportacaoLinhaDetalhe build() => _build();

  _$ImportacaoLinhaDetalhe _build() {
    _$ImportacaoLinhaDetalhe _$result;
    try {
      _$result = _$v ??
          _$ImportacaoLinhaDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ImportacaoLinhaDetalhe', 'id'),
            numeroLinha: BuiltValueNullFieldError.checkNotNull(numeroLinha, r'ImportacaoLinhaDetalhe', 'numeroLinha'),
            dadosBrutos: dadosBrutos.build(),
            dadosNormalizados: dadosNormalizados.build(),
            status: BuiltValueNullFieldError.checkNotNull(status, r'ImportacaoLinhaDetalhe', 'status'),
            acao: BuiltValueNullFieldError.checkNotNull(acao, r'ImportacaoLinhaDetalhe', 'acao'),
            produtoCorrespondenteId: produtoCorrespondenteId,
            similaridade: similaridade,
            erros: erros.build(),
            efetivadaEm: efetivadaEm,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dadosBrutos';
        dadosBrutos.build();
        _$failedField = 'dadosNormalizados';
        dadosNormalizados.build();

        _$failedField = 'erros';
        erros.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ImportacaoLinhaDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
