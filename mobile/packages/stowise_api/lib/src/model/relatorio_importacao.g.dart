// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorio_importacao.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RelatorioImportacao extends RelatorioImportacao {
  @override
  final String id;
  @override
  final String nomeArquivo;
  @override
  final StatusImportacao status;
  @override
  final int totalLinhas;
  @override
  final int linhasValidas;
  @override
  final int linhasComErro;
  @override
  final int linhasPossivelDuplicata;
  @override
  final int produtosCriados;
  @override
  final int produtosAtualizados;
  @override
  final BuiltMap<String, int> errosPorCampo;
  @override
  final DateTime iniciadoEm;
  @override
  final DateTime? concluidoEm;
  @override
  final String? motivoFalha;

  factory _$RelatorioImportacao([void Function(RelatorioImportacaoBuilder)? updates]) =>
      (RelatorioImportacaoBuilder()..update(updates))._build();

  _$RelatorioImportacao._(
      {required this.id,
      required this.nomeArquivo,
      required this.status,
      required this.totalLinhas,
      required this.linhasValidas,
      required this.linhasComErro,
      required this.linhasPossivelDuplicata,
      required this.produtosCriados,
      required this.produtosAtualizados,
      required this.errosPorCampo,
      required this.iniciadoEm,
      this.concluidoEm,
      this.motivoFalha})
      : super._();
  @override
  RelatorioImportacao rebuild(void Function(RelatorioImportacaoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelatorioImportacaoBuilder toBuilder() => RelatorioImportacaoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelatorioImportacao &&
        id == other.id &&
        nomeArquivo == other.nomeArquivo &&
        status == other.status &&
        totalLinhas == other.totalLinhas &&
        linhasValidas == other.linhasValidas &&
        linhasComErro == other.linhasComErro &&
        linhasPossivelDuplicata == other.linhasPossivelDuplicata &&
        produtosCriados == other.produtosCriados &&
        produtosAtualizados == other.produtosAtualizados &&
        errosPorCampo == other.errosPorCampo &&
        iniciadoEm == other.iniciadoEm &&
        concluidoEm == other.concluidoEm &&
        motivoFalha == other.motivoFalha;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nomeArquivo.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, totalLinhas.hashCode);
    _$hash = $jc(_$hash, linhasValidas.hashCode);
    _$hash = $jc(_$hash, linhasComErro.hashCode);
    _$hash = $jc(_$hash, linhasPossivelDuplicata.hashCode);
    _$hash = $jc(_$hash, produtosCriados.hashCode);
    _$hash = $jc(_$hash, produtosAtualizados.hashCode);
    _$hash = $jc(_$hash, errosPorCampo.hashCode);
    _$hash = $jc(_$hash, iniciadoEm.hashCode);
    _$hash = $jc(_$hash, concluidoEm.hashCode);
    _$hash = $jc(_$hash, motivoFalha.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RelatorioImportacao')
          ..add('id', id)
          ..add('nomeArquivo', nomeArquivo)
          ..add('status', status)
          ..add('totalLinhas', totalLinhas)
          ..add('linhasValidas', linhasValidas)
          ..add('linhasComErro', linhasComErro)
          ..add('linhasPossivelDuplicata', linhasPossivelDuplicata)
          ..add('produtosCriados', produtosCriados)
          ..add('produtosAtualizados', produtosAtualizados)
          ..add('errosPorCampo', errosPorCampo)
          ..add('iniciadoEm', iniciadoEm)
          ..add('concluidoEm', concluidoEm)
          ..add('motivoFalha', motivoFalha))
        .toString();
  }
}

class RelatorioImportacaoBuilder implements Builder<RelatorioImportacao, RelatorioImportacaoBuilder> {
  _$RelatorioImportacao? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nomeArquivo;
  String? get nomeArquivo => _$this._nomeArquivo;
  set nomeArquivo(String? nomeArquivo) => _$this._nomeArquivo = nomeArquivo;

  StatusImportacao? _status;
  StatusImportacao? get status => _$this._status;
  set status(StatusImportacao? status) => _$this._status = status;

  int? _totalLinhas;
  int? get totalLinhas => _$this._totalLinhas;
  set totalLinhas(int? totalLinhas) => _$this._totalLinhas = totalLinhas;

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

  int? _produtosCriados;
  int? get produtosCriados => _$this._produtosCriados;
  set produtosCriados(int? produtosCriados) => _$this._produtosCriados = produtosCriados;

  int? _produtosAtualizados;
  int? get produtosAtualizados => _$this._produtosAtualizados;
  set produtosAtualizados(int? produtosAtualizados) => _$this._produtosAtualizados = produtosAtualizados;

  MapBuilder<String, int>? _errosPorCampo;
  MapBuilder<String, int> get errosPorCampo => _$this._errosPorCampo ??= MapBuilder<String, int>();
  set errosPorCampo(MapBuilder<String, int>? errosPorCampo) => _$this._errosPorCampo = errosPorCampo;

  DateTime? _iniciadoEm;
  DateTime? get iniciadoEm => _$this._iniciadoEm;
  set iniciadoEm(DateTime? iniciadoEm) => _$this._iniciadoEm = iniciadoEm;

  DateTime? _concluidoEm;
  DateTime? get concluidoEm => _$this._concluidoEm;
  set concluidoEm(DateTime? concluidoEm) => _$this._concluidoEm = concluidoEm;

  String? _motivoFalha;
  String? get motivoFalha => _$this._motivoFalha;
  set motivoFalha(String? motivoFalha) => _$this._motivoFalha = motivoFalha;

  RelatorioImportacaoBuilder() {
    RelatorioImportacao._defaults(this);
  }

  RelatorioImportacaoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nomeArquivo = $v.nomeArquivo;
      _status = $v.status;
      _totalLinhas = $v.totalLinhas;
      _linhasValidas = $v.linhasValidas;
      _linhasComErro = $v.linhasComErro;
      _linhasPossivelDuplicata = $v.linhasPossivelDuplicata;
      _produtosCriados = $v.produtosCriados;
      _produtosAtualizados = $v.produtosAtualizados;
      _errosPorCampo = $v.errosPorCampo.toBuilder();
      _iniciadoEm = $v.iniciadoEm;
      _concluidoEm = $v.concluidoEm;
      _motivoFalha = $v.motivoFalha;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelatorioImportacao other) {
    _$v = other as _$RelatorioImportacao;
  }

  @override
  void update(void Function(RelatorioImportacaoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RelatorioImportacao build() => _build();

  _$RelatorioImportacao _build() {
    _$RelatorioImportacao _$result;
    try {
      _$result = _$v ??
          _$RelatorioImportacao._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'RelatorioImportacao', 'id'),
            nomeArquivo: BuiltValueNullFieldError.checkNotNull(nomeArquivo, r'RelatorioImportacao', 'nomeArquivo'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'RelatorioImportacao', 'status'),
            totalLinhas: BuiltValueNullFieldError.checkNotNull(totalLinhas, r'RelatorioImportacao', 'totalLinhas'),
            linhasValidas:
                BuiltValueNullFieldError.checkNotNull(linhasValidas, r'RelatorioImportacao', 'linhasValidas'),
            linhasComErro:
                BuiltValueNullFieldError.checkNotNull(linhasComErro, r'RelatorioImportacao', 'linhasComErro'),
            linhasPossivelDuplicata: BuiltValueNullFieldError.checkNotNull(
                linhasPossivelDuplicata, r'RelatorioImportacao', 'linhasPossivelDuplicata'),
            produtosCriados:
                BuiltValueNullFieldError.checkNotNull(produtosCriados, r'RelatorioImportacao', 'produtosCriados'),
            produtosAtualizados: BuiltValueNullFieldError.checkNotNull(
                produtosAtualizados, r'RelatorioImportacao', 'produtosAtualizados'),
            errosPorCampo: errosPorCampo.build(),
            iniciadoEm: BuiltValueNullFieldError.checkNotNull(iniciadoEm, r'RelatorioImportacao', 'iniciadoEm'),
            concluidoEm: concluidoEm,
            motivoFalha: motivoFalha,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errosPorCampo';
        errosPorCampo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RelatorioImportacao', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
