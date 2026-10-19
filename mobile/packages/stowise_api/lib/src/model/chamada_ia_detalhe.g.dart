// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chamada_ia_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChamadaIaDetalhe extends ChamadaIaDetalhe {
  @override
  final String id;
  @override
  final FuncionalidadeIa funcionalidade;
  @override
  final String? usuarioId;
  @override
  final String provedor;
  @override
  final String modelo;
  @override
  final String promptVersao;
  @override
  final int? tokensEntrada;
  @override
  final int? tokensSaida;
  @override
  final double? custoEstimado;
  @override
  final int latenciaMs;
  @override
  final int tentativas;
  @override
  final bool usouFallback;
  @override
  final bool sucesso;
  @override
  final String? erro;
  @override
  final String? correlacaoId;
  @override
  final DateTime criadaEm;

  factory _$ChamadaIaDetalhe([void Function(ChamadaIaDetalheBuilder)? updates]) =>
      (ChamadaIaDetalheBuilder()..update(updates))._build();

  _$ChamadaIaDetalhe._(
      {required this.id,
      required this.funcionalidade,
      this.usuarioId,
      required this.provedor,
      required this.modelo,
      required this.promptVersao,
      this.tokensEntrada,
      this.tokensSaida,
      this.custoEstimado,
      required this.latenciaMs,
      required this.tentativas,
      required this.usouFallback,
      required this.sucesso,
      this.erro,
      this.correlacaoId,
      required this.criadaEm})
      : super._();
  @override
  ChamadaIaDetalhe rebuild(void Function(ChamadaIaDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ChamadaIaDetalheBuilder toBuilder() => ChamadaIaDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChamadaIaDetalhe &&
        id == other.id &&
        funcionalidade == other.funcionalidade &&
        usuarioId == other.usuarioId &&
        provedor == other.provedor &&
        modelo == other.modelo &&
        promptVersao == other.promptVersao &&
        tokensEntrada == other.tokensEntrada &&
        tokensSaida == other.tokensSaida &&
        custoEstimado == other.custoEstimado &&
        latenciaMs == other.latenciaMs &&
        tentativas == other.tentativas &&
        usouFallback == other.usouFallback &&
        sucesso == other.sucesso &&
        erro == other.erro &&
        correlacaoId == other.correlacaoId &&
        criadaEm == other.criadaEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, funcionalidade.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, provedor.hashCode);
    _$hash = $jc(_$hash, modelo.hashCode);
    _$hash = $jc(_$hash, promptVersao.hashCode);
    _$hash = $jc(_$hash, tokensEntrada.hashCode);
    _$hash = $jc(_$hash, tokensSaida.hashCode);
    _$hash = $jc(_$hash, custoEstimado.hashCode);
    _$hash = $jc(_$hash, latenciaMs.hashCode);
    _$hash = $jc(_$hash, tentativas.hashCode);
    _$hash = $jc(_$hash, usouFallback.hashCode);
    _$hash = $jc(_$hash, sucesso.hashCode);
    _$hash = $jc(_$hash, erro.hashCode);
    _$hash = $jc(_$hash, correlacaoId.hashCode);
    _$hash = $jc(_$hash, criadaEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChamadaIaDetalhe')
          ..add('id', id)
          ..add('funcionalidade', funcionalidade)
          ..add('usuarioId', usuarioId)
          ..add('provedor', provedor)
          ..add('modelo', modelo)
          ..add('promptVersao', promptVersao)
          ..add('tokensEntrada', tokensEntrada)
          ..add('tokensSaida', tokensSaida)
          ..add('custoEstimado', custoEstimado)
          ..add('latenciaMs', latenciaMs)
          ..add('tentativas', tentativas)
          ..add('usouFallback', usouFallback)
          ..add('sucesso', sucesso)
          ..add('erro', erro)
          ..add('correlacaoId', correlacaoId)
          ..add('criadaEm', criadaEm))
        .toString();
  }
}

class ChamadaIaDetalheBuilder implements Builder<ChamadaIaDetalhe, ChamadaIaDetalheBuilder> {
  _$ChamadaIaDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  FuncionalidadeIa? _funcionalidade;
  FuncionalidadeIa? get funcionalidade => _$this._funcionalidade;
  set funcionalidade(FuncionalidadeIa? funcionalidade) => _$this._funcionalidade = funcionalidade;

  String? _usuarioId;
  String? get usuarioId => _$this._usuarioId;
  set usuarioId(String? usuarioId) => _$this._usuarioId = usuarioId;

  String? _provedor;
  String? get provedor => _$this._provedor;
  set provedor(String? provedor) => _$this._provedor = provedor;

  String? _modelo;
  String? get modelo => _$this._modelo;
  set modelo(String? modelo) => _$this._modelo = modelo;

  String? _promptVersao;
  String? get promptVersao => _$this._promptVersao;
  set promptVersao(String? promptVersao) => _$this._promptVersao = promptVersao;

  int? _tokensEntrada;
  int? get tokensEntrada => _$this._tokensEntrada;
  set tokensEntrada(int? tokensEntrada) => _$this._tokensEntrada = tokensEntrada;

  int? _tokensSaida;
  int? get tokensSaida => _$this._tokensSaida;
  set tokensSaida(int? tokensSaida) => _$this._tokensSaida = tokensSaida;

  double? _custoEstimado;
  double? get custoEstimado => _$this._custoEstimado;
  set custoEstimado(double? custoEstimado) => _$this._custoEstimado = custoEstimado;

  int? _latenciaMs;
  int? get latenciaMs => _$this._latenciaMs;
  set latenciaMs(int? latenciaMs) => _$this._latenciaMs = latenciaMs;

  int? _tentativas;
  int? get tentativas => _$this._tentativas;
  set tentativas(int? tentativas) => _$this._tentativas = tentativas;

  bool? _usouFallback;
  bool? get usouFallback => _$this._usouFallback;
  set usouFallback(bool? usouFallback) => _$this._usouFallback = usouFallback;

  bool? _sucesso;
  bool? get sucesso => _$this._sucesso;
  set sucesso(bool? sucesso) => _$this._sucesso = sucesso;

  String? _erro;
  String? get erro => _$this._erro;
  set erro(String? erro) => _$this._erro = erro;

  String? _correlacaoId;
  String? get correlacaoId => _$this._correlacaoId;
  set correlacaoId(String? correlacaoId) => _$this._correlacaoId = correlacaoId;

  DateTime? _criadaEm;
  DateTime? get criadaEm => _$this._criadaEm;
  set criadaEm(DateTime? criadaEm) => _$this._criadaEm = criadaEm;

  ChamadaIaDetalheBuilder() {
    ChamadaIaDetalhe._defaults(this);
  }

  ChamadaIaDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _funcionalidade = $v.funcionalidade;
      _usuarioId = $v.usuarioId;
      _provedor = $v.provedor;
      _modelo = $v.modelo;
      _promptVersao = $v.promptVersao;
      _tokensEntrada = $v.tokensEntrada;
      _tokensSaida = $v.tokensSaida;
      _custoEstimado = $v.custoEstimado;
      _latenciaMs = $v.latenciaMs;
      _tentativas = $v.tentativas;
      _usouFallback = $v.usouFallback;
      _sucesso = $v.sucesso;
      _erro = $v.erro;
      _correlacaoId = $v.correlacaoId;
      _criadaEm = $v.criadaEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChamadaIaDetalhe other) {
    _$v = other as _$ChamadaIaDetalhe;
  }

  @override
  void update(void Function(ChamadaIaDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChamadaIaDetalhe build() => _build();

  _$ChamadaIaDetalhe _build() {
    final _$result = _$v ??
        _$ChamadaIaDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ChamadaIaDetalhe', 'id'),
          funcionalidade: BuiltValueNullFieldError.checkNotNull(funcionalidade, r'ChamadaIaDetalhe', 'funcionalidade'),
          usuarioId: usuarioId,
          provedor: BuiltValueNullFieldError.checkNotNull(provedor, r'ChamadaIaDetalhe', 'provedor'),
          modelo: BuiltValueNullFieldError.checkNotNull(modelo, r'ChamadaIaDetalhe', 'modelo'),
          promptVersao: BuiltValueNullFieldError.checkNotNull(promptVersao, r'ChamadaIaDetalhe', 'promptVersao'),
          tokensEntrada: tokensEntrada,
          tokensSaida: tokensSaida,
          custoEstimado: custoEstimado,
          latenciaMs: BuiltValueNullFieldError.checkNotNull(latenciaMs, r'ChamadaIaDetalhe', 'latenciaMs'),
          tentativas: BuiltValueNullFieldError.checkNotNull(tentativas, r'ChamadaIaDetalhe', 'tentativas'),
          usouFallback: BuiltValueNullFieldError.checkNotNull(usouFallback, r'ChamadaIaDetalhe', 'usouFallback'),
          sucesso: BuiltValueNullFieldError.checkNotNull(sucesso, r'ChamadaIaDetalhe', 'sucesso'),
          erro: erro,
          correlacaoId: correlacaoId,
          criadaEm: BuiltValueNullFieldError.checkNotNull(criadaEm, r'ChamadaIaDetalhe', 'criadaEm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
