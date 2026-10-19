// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importacao_resumo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportacaoResumo extends ImportacaoResumo {
  @override
  final String id;
  @override
  final TipoImportacao tipo;
  @override
  final FormatoArquivo formato;
  @override
  final StatusImportacao status;
  @override
  final String nomeArquivo;
  @override
  final int totalLinhas;
  @override
  final int linhasValidas;
  @override
  final int linhasComErro;
  @override
  final String usuarioId;
  @override
  final DateTime iniciadoEm;
  @override
  final DateTime? concluidoEm;

  factory _$ImportacaoResumo([void Function(ImportacaoResumoBuilder)? updates]) =>
      (ImportacaoResumoBuilder()..update(updates))._build();

  _$ImportacaoResumo._(
      {required this.id,
      required this.tipo,
      required this.formato,
      required this.status,
      required this.nomeArquivo,
      required this.totalLinhas,
      required this.linhasValidas,
      required this.linhasComErro,
      required this.usuarioId,
      required this.iniciadoEm,
      this.concluidoEm})
      : super._();
  @override
  ImportacaoResumo rebuild(void Function(ImportacaoResumoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ImportacaoResumoBuilder toBuilder() => ImportacaoResumoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportacaoResumo &&
        id == other.id &&
        tipo == other.tipo &&
        formato == other.formato &&
        status == other.status &&
        nomeArquivo == other.nomeArquivo &&
        totalLinhas == other.totalLinhas &&
        linhasValidas == other.linhasValidas &&
        linhasComErro == other.linhasComErro &&
        usuarioId == other.usuarioId &&
        iniciadoEm == other.iniciadoEm &&
        concluidoEm == other.concluidoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, formato.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, nomeArquivo.hashCode);
    _$hash = $jc(_$hash, totalLinhas.hashCode);
    _$hash = $jc(_$hash, linhasValidas.hashCode);
    _$hash = $jc(_$hash, linhasComErro.hashCode);
    _$hash = $jc(_$hash, usuarioId.hashCode);
    _$hash = $jc(_$hash, iniciadoEm.hashCode);
    _$hash = $jc(_$hash, concluidoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportacaoResumo')
          ..add('id', id)
          ..add('tipo', tipo)
          ..add('formato', formato)
          ..add('status', status)
          ..add('nomeArquivo', nomeArquivo)
          ..add('totalLinhas', totalLinhas)
          ..add('linhasValidas', linhasValidas)
          ..add('linhasComErro', linhasComErro)
          ..add('usuarioId', usuarioId)
          ..add('iniciadoEm', iniciadoEm)
          ..add('concluidoEm', concluidoEm))
        .toString();
  }
}

class ImportacaoResumoBuilder implements Builder<ImportacaoResumo, ImportacaoResumoBuilder> {
  _$ImportacaoResumo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TipoImportacao? _tipo;
  TipoImportacao? get tipo => _$this._tipo;
  set tipo(TipoImportacao? tipo) => _$this._tipo = tipo;

  FormatoArquivo? _formato;
  FormatoArquivo? get formato => _$this._formato;
  set formato(FormatoArquivo? formato) => _$this._formato = formato;

  StatusImportacao? _status;
  StatusImportacao? get status => _$this._status;
  set status(StatusImportacao? status) => _$this._status = status;

  String? _nomeArquivo;
  String? get nomeArquivo => _$this._nomeArquivo;
  set nomeArquivo(String? nomeArquivo) => _$this._nomeArquivo = nomeArquivo;

  int? _totalLinhas;
  int? get totalLinhas => _$this._totalLinhas;
  set totalLinhas(int? totalLinhas) => _$this._totalLinhas = totalLinhas;

  int? _linhasValidas;
  int? get linhasValidas => _$this._linhasValidas;
  set linhasValidas(int? linhasValidas) => _$this._linhasValidas = linhasValidas;

  int? _linhasComErro;
  int? get linhasComErro => _$this._linhasComErro;
  set linhasComErro(int? linhasComErro) => _$this._linhasComErro = linhasComErro;

  String? _usuarioId;
  String? get usuarioId => _$this._usuarioId;
  set usuarioId(String? usuarioId) => _$this._usuarioId = usuarioId;

  DateTime? _iniciadoEm;
  DateTime? get iniciadoEm => _$this._iniciadoEm;
  set iniciadoEm(DateTime? iniciadoEm) => _$this._iniciadoEm = iniciadoEm;

  DateTime? _concluidoEm;
  DateTime? get concluidoEm => _$this._concluidoEm;
  set concluidoEm(DateTime? concluidoEm) => _$this._concluidoEm = concluidoEm;

  ImportacaoResumoBuilder() {
    ImportacaoResumo._defaults(this);
  }

  ImportacaoResumoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _tipo = $v.tipo;
      _formato = $v.formato;
      _status = $v.status;
      _nomeArquivo = $v.nomeArquivo;
      _totalLinhas = $v.totalLinhas;
      _linhasValidas = $v.linhasValidas;
      _linhasComErro = $v.linhasComErro;
      _usuarioId = $v.usuarioId;
      _iniciadoEm = $v.iniciadoEm;
      _concluidoEm = $v.concluidoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportacaoResumo other) {
    _$v = other as _$ImportacaoResumo;
  }

  @override
  void update(void Function(ImportacaoResumoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportacaoResumo build() => _build();

  _$ImportacaoResumo _build() {
    final _$result = _$v ??
        _$ImportacaoResumo._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ImportacaoResumo', 'id'),
          tipo: BuiltValueNullFieldError.checkNotNull(tipo, r'ImportacaoResumo', 'tipo'),
          formato: BuiltValueNullFieldError.checkNotNull(formato, r'ImportacaoResumo', 'formato'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'ImportacaoResumo', 'status'),
          nomeArquivo: BuiltValueNullFieldError.checkNotNull(nomeArquivo, r'ImportacaoResumo', 'nomeArquivo'),
          totalLinhas: BuiltValueNullFieldError.checkNotNull(totalLinhas, r'ImportacaoResumo', 'totalLinhas'),
          linhasValidas: BuiltValueNullFieldError.checkNotNull(linhasValidas, r'ImportacaoResumo', 'linhasValidas'),
          linhasComErro: BuiltValueNullFieldError.checkNotNull(linhasComErro, r'ImportacaoResumo', 'linhasComErro'),
          usuarioId: BuiltValueNullFieldError.checkNotNull(usuarioId, r'ImportacaoResumo', 'usuarioId'),
          iniciadoEm: BuiltValueNullFieldError.checkNotNull(iniciadoEm, r'ImportacaoResumo', 'iniciadoEm'),
          concluidoEm: concluidoEm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
