// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recebimento_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecebimentoResumo extends RecebimentoResumo {
  @override
  final String id;
  @override
  final int numero;
  @override
  final int serie;
  @override
  final String chaveAcesso;
  @override
  final String fornecedorId;
  @override
  final String fornecedor;
  @override
  final DateTime dataEmissao;
  @override
  final StatusRecebimento status;
  @override
  final int itens;
  @override
  final int itensConferidos;
  @override
  final bool temDivergencia;
  @override
  final DateTime criadoEm;

  factory _$RecebimentoResumo([void Function(RecebimentoResumoBuilder)? updates]) =>
      (RecebimentoResumoBuilder()..update(updates))._build();

  _$RecebimentoResumo._(
      {required this.id,
      required this.numero,
      required this.serie,
      required this.chaveAcesso,
      required this.fornecedorId,
      required this.fornecedor,
      required this.dataEmissao,
      required this.status,
      required this.itens,
      required this.itensConferidos,
      required this.temDivergencia,
      required this.criadoEm})
      : super._();
  @override
  RecebimentoResumo rebuild(void Function(RecebimentoResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RecebimentoResumoBuilder toBuilder() => RecebimentoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecebimentoResumo &&
        id == other.id &&
        numero == other.numero &&
        serie == other.serie &&
        chaveAcesso == other.chaveAcesso &&
        fornecedorId == other.fornecedorId &&
        fornecedor == other.fornecedor &&
        dataEmissao == other.dataEmissao &&
        status == other.status &&
        itens == other.itens &&
        itensConferidos == other.itensConferidos &&
        temDivergencia == other.temDivergencia &&
        criadoEm == other.criadoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, serie.hashCode);
    _$hash = $jc(_$hash, chaveAcesso.hashCode);
    _$hash = $jc(_$hash, fornecedorId.hashCode);
    _$hash = $jc(_$hash, fornecedor.hashCode);
    _$hash = $jc(_$hash, dataEmissao.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jc(_$hash, itensConferidos.hashCode);
    _$hash = $jc(_$hash, temDivergencia.hashCode);
    _$hash = $jc(_$hash, criadoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecebimentoResumo')
          ..add('id', id)
          ..add('numero', numero)
          ..add('serie', serie)
          ..add('chaveAcesso', chaveAcesso)
          ..add('fornecedorId', fornecedorId)
          ..add('fornecedor', fornecedor)
          ..add('dataEmissao', dataEmissao)
          ..add('status', status)
          ..add('itens', itens)
          ..add('itensConferidos', itensConferidos)
          ..add('temDivergencia', temDivergencia)
          ..add('criadoEm', criadoEm))
        .toString();
  }
}

class RecebimentoResumoBuilder implements Builder<RecebimentoResumo, RecebimentoResumoBuilder> {
  _$RecebimentoResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _numero;
  int? get numero => _$this._numero;
  set numero(int? numero) => _$this._numero = numero;

  int? _serie;
  int? get serie => _$this._serie;
  set serie(int? serie) => _$this._serie = serie;

  String? _chaveAcesso;
  String? get chaveAcesso => _$this._chaveAcesso;
  set chaveAcesso(String? chaveAcesso) => _$this._chaveAcesso = chaveAcesso;

  String? _fornecedorId;
  String? get fornecedorId => _$this._fornecedorId;
  set fornecedorId(String? fornecedorId) => _$this._fornecedorId = fornecedorId;

  String? _fornecedor;
  String? get fornecedor => _$this._fornecedor;
  set fornecedor(String? fornecedor) => _$this._fornecedor = fornecedor;

  DateTime? _dataEmissao;
  DateTime? get dataEmissao => _$this._dataEmissao;
  set dataEmissao(DateTime? dataEmissao) => _$this._dataEmissao = dataEmissao;

  StatusRecebimento? _status;
  StatusRecebimento? get status => _$this._status;
  set status(StatusRecebimento? status) => _$this._status = status;

  int? _itens;
  int? get itens => _$this._itens;
  set itens(int? itens) => _$this._itens = itens;

  int? _itensConferidos;
  int? get itensConferidos => _$this._itensConferidos;
  set itensConferidos(int? itensConferidos) => _$this._itensConferidos = itensConferidos;

  bool? _temDivergencia;
  bool? get temDivergencia => _$this._temDivergencia;
  set temDivergencia(bool? temDivergencia) => _$this._temDivergencia = temDivergencia;

  DateTime? _criadoEm;
  DateTime? get criadoEm => _$this._criadoEm;
  set criadoEm(DateTime? criadoEm) => _$this._criadoEm = criadoEm;

  RecebimentoResumoBuilder() {
    RecebimentoResumo._defaults(this);
  }

  RecebimentoResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _numero = $v.numero;
      _serie = $v.serie;
      _chaveAcesso = $v.chaveAcesso;
      _fornecedorId = $v.fornecedorId;
      _fornecedor = $v.fornecedor;
      _dataEmissao = $v.dataEmissao;
      _status = $v.status;
      _itens = $v.itens;
      _itensConferidos = $v.itensConferidos;
      _temDivergencia = $v.temDivergencia;
      _criadoEm = $v.criadoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecebimentoResumo other) {
    _$v = other as _$RecebimentoResumo;
  }

  @override
  void update(void Function(RecebimentoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecebimentoResumo build() => _build();

  _$RecebimentoResumo _build() {
    final _$result = _$v ??
        _$RecebimentoResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RecebimentoResumo', 'id'),
          numero: BuiltValueNullFieldError.checkNotNull(numero, r'RecebimentoResumo', 'numero'),
          serie: BuiltValueNullFieldError.checkNotNull(serie, r'RecebimentoResumo', 'serie'),
          chaveAcesso: BuiltValueNullFieldError.checkNotNull(chaveAcesso, r'RecebimentoResumo', 'chaveAcesso'),
          fornecedorId: BuiltValueNullFieldError.checkNotNull(fornecedorId, r'RecebimentoResumo', 'fornecedorId'),
          fornecedor: BuiltValueNullFieldError.checkNotNull(fornecedor, r'RecebimentoResumo', 'fornecedor'),
          dataEmissao: BuiltValueNullFieldError.checkNotNull(dataEmissao, r'RecebimentoResumo', 'dataEmissao'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'RecebimentoResumo', 'status'),
          itens: BuiltValueNullFieldError.checkNotNull(itens, r'RecebimentoResumo', 'itens'),
          itensConferidos:
              BuiltValueNullFieldError.checkNotNull(itensConferidos, r'RecebimentoResumo', 'itensConferidos'),
          temDivergencia: BuiltValueNullFieldError.checkNotNull(temDivergencia, r'RecebimentoResumo', 'temDivergencia'),
          criadoEm: BuiltValueNullFieldError.checkNotNull(criadoEm, r'RecebimentoResumo', 'criadoEm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
