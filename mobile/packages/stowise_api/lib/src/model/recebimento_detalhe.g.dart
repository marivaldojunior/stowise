// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recebimento_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecebimentoDetalhe extends RecebimentoDetalhe {
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
  final DateTime? dataChegada;
  @override
  final String? conferidoPor;
  @override
  final DateTime? conferidoEm;
  @override
  final bool temDivergencia;
  @override
  final int versao;
  @override
  final BuiltList<RecebimentoItemDetalhe> itens;

  factory _$RecebimentoDetalhe([void Function(RecebimentoDetalheBuilder)? updates]) =>
      (RecebimentoDetalheBuilder()..update(updates))._build();

  _$RecebimentoDetalhe._(
      {required this.id,
      required this.numero,
      required this.serie,
      required this.chaveAcesso,
      required this.fornecedorId,
      required this.fornecedor,
      required this.dataEmissao,
      required this.status,
      this.dataChegada,
      this.conferidoPor,
      this.conferidoEm,
      required this.temDivergencia,
      required this.versao,
      required this.itens})
      : super._();
  @override
  RecebimentoDetalhe rebuild(void Function(RecebimentoDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecebimentoDetalheBuilder toBuilder() => RecebimentoDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecebimentoDetalhe &&
        id == other.id &&
        numero == other.numero &&
        serie == other.serie &&
        chaveAcesso == other.chaveAcesso &&
        fornecedorId == other.fornecedorId &&
        fornecedor == other.fornecedor &&
        dataEmissao == other.dataEmissao &&
        status == other.status &&
        dataChegada == other.dataChegada &&
        conferidoPor == other.conferidoPor &&
        conferidoEm == other.conferidoEm &&
        temDivergencia == other.temDivergencia &&
        versao == other.versao &&
        itens == other.itens;
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
    _$hash = $jc(_$hash, dataChegada.hashCode);
    _$hash = $jc(_$hash, conferidoPor.hashCode);
    _$hash = $jc(_$hash, conferidoEm.hashCode);
    _$hash = $jc(_$hash, temDivergencia.hashCode);
    _$hash = $jc(_$hash, versao.hashCode);
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecebimentoDetalhe')
          ..add('id', id)
          ..add('numero', numero)
          ..add('serie', serie)
          ..add('chaveAcesso', chaveAcesso)
          ..add('fornecedorId', fornecedorId)
          ..add('fornecedor', fornecedor)
          ..add('dataEmissao', dataEmissao)
          ..add('status', status)
          ..add('dataChegada', dataChegada)
          ..add('conferidoPor', conferidoPor)
          ..add('conferidoEm', conferidoEm)
          ..add('temDivergencia', temDivergencia)
          ..add('versao', versao)
          ..add('itens', itens))
        .toString();
  }
}

class RecebimentoDetalheBuilder implements Builder<RecebimentoDetalhe, RecebimentoDetalheBuilder> {
  _$RecebimentoDetalhe? _$v;

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

  DateTime? _dataChegada;
  DateTime? get dataChegada => _$this._dataChegada;
  set dataChegada(DateTime? dataChegada) => _$this._dataChegada = dataChegada;

  String? _conferidoPor;
  String? get conferidoPor => _$this._conferidoPor;
  set conferidoPor(String? conferidoPor) => _$this._conferidoPor = conferidoPor;

  DateTime? _conferidoEm;
  DateTime? get conferidoEm => _$this._conferidoEm;
  set conferidoEm(DateTime? conferidoEm) => _$this._conferidoEm = conferidoEm;

  bool? _temDivergencia;
  bool? get temDivergencia => _$this._temDivergencia;
  set temDivergencia(bool? temDivergencia) => _$this._temDivergencia = temDivergencia;

  int? _versao;
  int? get versao => _$this._versao;
  set versao(int? versao) => _$this._versao = versao;

  ListBuilder<RecebimentoItemDetalhe>? _itens;
  ListBuilder<RecebimentoItemDetalhe> get itens => _$this._itens ??= ListBuilder<RecebimentoItemDetalhe>();
  set itens(ListBuilder<RecebimentoItemDetalhe>? itens) => _$this._itens = itens;

  RecebimentoDetalheBuilder() {
    RecebimentoDetalhe._defaults(this);
  }

  RecebimentoDetalheBuilder get _$this {
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
      _dataChegada = $v.dataChegada;
      _conferidoPor = $v.conferidoPor;
      _conferidoEm = $v.conferidoEm;
      _temDivergencia = $v.temDivergencia;
      _versao = $v.versao;
      _itens = $v.itens.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecebimentoDetalhe other) {
    _$v = other as _$RecebimentoDetalhe;
  }

  @override
  void update(void Function(RecebimentoDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecebimentoDetalhe build() => _build();

  _$RecebimentoDetalhe _build() {
    _$RecebimentoDetalhe _$result;
    try {
      _$result = _$v ??
          _$RecebimentoDetalhe._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'RecebimentoDetalhe', 'id'),
            numero: BuiltValueNullFieldError.checkNotNull(numero, r'RecebimentoDetalhe', 'numero'),
            serie: BuiltValueNullFieldError.checkNotNull(serie, r'RecebimentoDetalhe', 'serie'),
            chaveAcesso: BuiltValueNullFieldError.checkNotNull(chaveAcesso, r'RecebimentoDetalhe', 'chaveAcesso'),
            fornecedorId: BuiltValueNullFieldError.checkNotNull(fornecedorId, r'RecebimentoDetalhe', 'fornecedorId'),
            fornecedor: BuiltValueNullFieldError.checkNotNull(fornecedor, r'RecebimentoDetalhe', 'fornecedor'),
            dataEmissao: BuiltValueNullFieldError.checkNotNull(dataEmissao, r'RecebimentoDetalhe', 'dataEmissao'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'RecebimentoDetalhe', 'status'),
            dataChegada: dataChegada,
            conferidoPor: conferidoPor,
            conferidoEm: conferidoEm,
            temDivergencia:
                BuiltValueNullFieldError.checkNotNull(temDivergencia, r'RecebimentoDetalhe', 'temDivergencia'),
            versao: BuiltValueNullFieldError.checkNotNull(versao, r'RecebimentoDetalhe', 'versao'),
            itens: itens.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RecebimentoDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
