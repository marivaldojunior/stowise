// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarefa_armazenagem_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TarefaArmazenagemResumo extends TarefaArmazenagemResumo {
  @override
  final String id;
  @override
  final String recebimentoId;
  @override
  final int numeroNota;
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final String? loteNumero;
  @override
  final Date? loteValidade;
  @override
  final double quantidade;
  @override
  final String? enderecoSugeridoId;
  @override
  final String? enderecoSugerido;
  @override
  final double? pontuacao;
  @override
  final StatusTarefaArmazenagem status;
  @override
  final String? enderecoConfirmado;
  @override
  final String? motivoDivergencia;
  @override
  final DateTime criadoEm;
  @override
  final DateTime? concluidoEm;

  factory _$TarefaArmazenagemResumo([void Function(TarefaArmazenagemResumoBuilder)? updates]) =>
      (TarefaArmazenagemResumoBuilder()..update(updates))._build();

  _$TarefaArmazenagemResumo._(
      {required this.id,
      required this.recebimentoId,
      required this.numeroNota,
      required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      this.loteNumero,
      this.loteValidade,
      required this.quantidade,
      this.enderecoSugeridoId,
      this.enderecoSugerido,
      this.pontuacao,
      required this.status,
      this.enderecoConfirmado,
      this.motivoDivergencia,
      required this.criadoEm,
      this.concluidoEm})
      : super._();
  @override
  TarefaArmazenagemResumo rebuild(void Function(TarefaArmazenagemResumoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TarefaArmazenagemResumoBuilder toBuilder() => TarefaArmazenagemResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TarefaArmazenagemResumo &&
        id == other.id &&
        recebimentoId == other.recebimentoId &&
        numeroNota == other.numeroNota &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        loteNumero == other.loteNumero &&
        loteValidade == other.loteValidade &&
        quantidade == other.quantidade &&
        enderecoSugeridoId == other.enderecoSugeridoId &&
        enderecoSugerido == other.enderecoSugerido &&
        pontuacao == other.pontuacao &&
        status == other.status &&
        enderecoConfirmado == other.enderecoConfirmado &&
        motivoDivergencia == other.motivoDivergencia &&
        criadoEm == other.criadoEm &&
        concluidoEm == other.concluidoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, recebimentoId.hashCode);
    _$hash = $jc(_$hash, numeroNota.hashCode);
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, loteNumero.hashCode);
    _$hash = $jc(_$hash, loteValidade.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, enderecoSugeridoId.hashCode);
    _$hash = $jc(_$hash, enderecoSugerido.hashCode);
    _$hash = $jc(_$hash, pontuacao.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, enderecoConfirmado.hashCode);
    _$hash = $jc(_$hash, motivoDivergencia.hashCode);
    _$hash = $jc(_$hash, criadoEm.hashCode);
    _$hash = $jc(_$hash, concluidoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TarefaArmazenagemResumo')
          ..add('id', id)
          ..add('recebimentoId', recebimentoId)
          ..add('numeroNota', numeroNota)
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('loteNumero', loteNumero)
          ..add('loteValidade', loteValidade)
          ..add('quantidade', quantidade)
          ..add('enderecoSugeridoId', enderecoSugeridoId)
          ..add('enderecoSugerido', enderecoSugerido)
          ..add('pontuacao', pontuacao)
          ..add('status', status)
          ..add('enderecoConfirmado', enderecoConfirmado)
          ..add('motivoDivergencia', motivoDivergencia)
          ..add('criadoEm', criadoEm)
          ..add('concluidoEm', concluidoEm))
        .toString();
  }
}

class TarefaArmazenagemResumoBuilder implements Builder<TarefaArmazenagemResumo, TarefaArmazenagemResumoBuilder> {
  _$TarefaArmazenagemResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _recebimentoId;
  String? get recebimentoId => _$this._recebimentoId;
  set recebimentoId(String? recebimentoId) => _$this._recebimentoId = recebimentoId;

  int? _numeroNota;
  int? get numeroNota => _$this._numeroNota;
  set numeroNota(int? numeroNota) => _$this._numeroNota = numeroNota;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  String? _loteNumero;
  String? get loteNumero => _$this._loteNumero;
  set loteNumero(String? loteNumero) => _$this._loteNumero = loteNumero;

  Date? _loteValidade;
  Date? get loteValidade => _$this._loteValidade;
  set loteValidade(Date? loteValidade) => _$this._loteValidade = loteValidade;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _enderecoSugeridoId;
  String? get enderecoSugeridoId => _$this._enderecoSugeridoId;
  set enderecoSugeridoId(String? enderecoSugeridoId) => _$this._enderecoSugeridoId = enderecoSugeridoId;

  String? _enderecoSugerido;
  String? get enderecoSugerido => _$this._enderecoSugerido;
  set enderecoSugerido(String? enderecoSugerido) => _$this._enderecoSugerido = enderecoSugerido;

  double? _pontuacao;
  double? get pontuacao => _$this._pontuacao;
  set pontuacao(double? pontuacao) => _$this._pontuacao = pontuacao;

  StatusTarefaArmazenagem? _status;
  StatusTarefaArmazenagem? get status => _$this._status;
  set status(StatusTarefaArmazenagem? status) => _$this._status = status;

  String? _enderecoConfirmado;
  String? get enderecoConfirmado => _$this._enderecoConfirmado;
  set enderecoConfirmado(String? enderecoConfirmado) => _$this._enderecoConfirmado = enderecoConfirmado;

  String? _motivoDivergencia;
  String? get motivoDivergencia => _$this._motivoDivergencia;
  set motivoDivergencia(String? motivoDivergencia) => _$this._motivoDivergencia = motivoDivergencia;

  DateTime? _criadoEm;
  DateTime? get criadoEm => _$this._criadoEm;
  set criadoEm(DateTime? criadoEm) => _$this._criadoEm = criadoEm;

  DateTime? _concluidoEm;
  DateTime? get concluidoEm => _$this._concluidoEm;
  set concluidoEm(DateTime? concluidoEm) => _$this._concluidoEm = concluidoEm;

  TarefaArmazenagemResumoBuilder() {
    TarefaArmazenagemResumo._defaults(this);
  }

  TarefaArmazenagemResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _recebimentoId = $v.recebimentoId;
      _numeroNota = $v.numeroNota;
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _loteNumero = $v.loteNumero;
      _loteValidade = $v.loteValidade;
      _quantidade = $v.quantidade;
      _enderecoSugeridoId = $v.enderecoSugeridoId;
      _enderecoSugerido = $v.enderecoSugerido;
      _pontuacao = $v.pontuacao;
      _status = $v.status;
      _enderecoConfirmado = $v.enderecoConfirmado;
      _motivoDivergencia = $v.motivoDivergencia;
      _criadoEm = $v.criadoEm;
      _concluidoEm = $v.concluidoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TarefaArmazenagemResumo other) {
    _$v = other as _$TarefaArmazenagemResumo;
  }

  @override
  void update(void Function(TarefaArmazenagemResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TarefaArmazenagemResumo build() => _build();

  _$TarefaArmazenagemResumo _build() {
    final _$result = _$v ??
        _$TarefaArmazenagemResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'TarefaArmazenagemResumo', 'id'),
          recebimentoId:
              BuiltValueNullFieldError.checkNotNull(recebimentoId, r'TarefaArmazenagemResumo', 'recebimentoId'),
          numeroNota: BuiltValueNullFieldError.checkNotNull(numeroNota, r'TarefaArmazenagemResumo', 'numeroNota'),
          produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'TarefaArmazenagemResumo', 'produtoId'),
          sku: BuiltValueNullFieldError.checkNotNull(sku, r'TarefaArmazenagemResumo', 'sku'),
          descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'TarefaArmazenagemResumo', 'descricao'),
          unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'TarefaArmazenagemResumo', 'unidadeBase'),
          loteNumero: loteNumero,
          loteValidade: loteValidade,
          quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'TarefaArmazenagemResumo', 'quantidade'),
          enderecoSugeridoId: enderecoSugeridoId,
          enderecoSugerido: enderecoSugerido,
          pontuacao: pontuacao,
          status: BuiltValueNullFieldError.checkNotNull(status, r'TarefaArmazenagemResumo', 'status'),
          enderecoConfirmado: enderecoConfirmado,
          motivoDivergencia: motivoDivergencia,
          criadoEm: BuiltValueNullFieldError.checkNotNull(criadoEm, r'TarefaArmazenagemResumo', 'criadoEm'),
          concluidoEm: concluidoEm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
