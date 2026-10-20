// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analise_nota_fiscal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnaliseNotaFiscal extends AnaliseNotaFiscal {
  @override
  final String chaveAcesso;
  @override
  final int numero;
  @override
  final int serie;
  @override
  final DateTime dataEmissao;
  @override
  final bool autorizada;
  @override
  final FornecedorDaNota fornecedor;
  @override
  final BuiltList<ItemAnalisado> itens;

  factory _$AnaliseNotaFiscal([void Function(AnaliseNotaFiscalBuilder)? updates]) =>
      (AnaliseNotaFiscalBuilder()..update(updates))._build();

  _$AnaliseNotaFiscal._(
      {required this.chaveAcesso,
      required this.numero,
      required this.serie,
      required this.dataEmissao,
      required this.autorizada,
      required this.fornecedor,
      required this.itens})
      : super._();
  @override
  AnaliseNotaFiscal rebuild(void Function(AnaliseNotaFiscalBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  AnaliseNotaFiscalBuilder toBuilder() => AnaliseNotaFiscalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnaliseNotaFiscal &&
        chaveAcesso == other.chaveAcesso &&
        numero == other.numero &&
        serie == other.serie &&
        dataEmissao == other.dataEmissao &&
        autorizada == other.autorizada &&
        fornecedor == other.fornecedor &&
        itens == other.itens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, chaveAcesso.hashCode);
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, serie.hashCode);
    _$hash = $jc(_$hash, dataEmissao.hashCode);
    _$hash = $jc(_$hash, autorizada.hashCode);
    _$hash = $jc(_$hash, fornecedor.hashCode);
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnaliseNotaFiscal')
          ..add('chaveAcesso', chaveAcesso)
          ..add('numero', numero)
          ..add('serie', serie)
          ..add('dataEmissao', dataEmissao)
          ..add('autorizada', autorizada)
          ..add('fornecedor', fornecedor)
          ..add('itens', itens))
        .toString();
  }
}

class AnaliseNotaFiscalBuilder implements Builder<AnaliseNotaFiscal, AnaliseNotaFiscalBuilder> {
  _$AnaliseNotaFiscal? _$v;

  String? _chaveAcesso;
  String? get chaveAcesso => _$this._chaveAcesso;
  set chaveAcesso(String? chaveAcesso) => _$this._chaveAcesso = chaveAcesso;

  int? _numero;
  int? get numero => _$this._numero;
  set numero(int? numero) => _$this._numero = numero;

  int? _serie;
  int? get serie => _$this._serie;
  set serie(int? serie) => _$this._serie = serie;

  DateTime? _dataEmissao;
  DateTime? get dataEmissao => _$this._dataEmissao;
  set dataEmissao(DateTime? dataEmissao) => _$this._dataEmissao = dataEmissao;

  bool? _autorizada;
  bool? get autorizada => _$this._autorizada;
  set autorizada(bool? autorizada) => _$this._autorizada = autorizada;

  FornecedorDaNotaBuilder? _fornecedor;
  FornecedorDaNotaBuilder get fornecedor => _$this._fornecedor ??= FornecedorDaNotaBuilder();
  set fornecedor(FornecedorDaNotaBuilder? fornecedor) => _$this._fornecedor = fornecedor;

  ListBuilder<ItemAnalisado>? _itens;
  ListBuilder<ItemAnalisado> get itens => _$this._itens ??= ListBuilder<ItemAnalisado>();
  set itens(ListBuilder<ItemAnalisado>? itens) => _$this._itens = itens;

  AnaliseNotaFiscalBuilder() {
    AnaliseNotaFiscal._defaults(this);
  }

  AnaliseNotaFiscalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chaveAcesso = $v.chaveAcesso;
      _numero = $v.numero;
      _serie = $v.serie;
      _dataEmissao = $v.dataEmissao;
      _autorizada = $v.autorizada;
      _fornecedor = $v.fornecedor.toBuilder();
      _itens = $v.itens.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnaliseNotaFiscal other) {
    _$v = other as _$AnaliseNotaFiscal;
  }

  @override
  void update(void Function(AnaliseNotaFiscalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnaliseNotaFiscal build() => _build();

  _$AnaliseNotaFiscal _build() {
    _$AnaliseNotaFiscal _$result;
    try {
      _$result = _$v ??
          _$AnaliseNotaFiscal._(
            chaveAcesso: BuiltValueNullFieldError.checkNotNull(chaveAcesso, r'AnaliseNotaFiscal', 'chaveAcesso'),
            numero: BuiltValueNullFieldError.checkNotNull(numero, r'AnaliseNotaFiscal', 'numero'),
            serie: BuiltValueNullFieldError.checkNotNull(serie, r'AnaliseNotaFiscal', 'serie'),
            dataEmissao: BuiltValueNullFieldError.checkNotNull(dataEmissao, r'AnaliseNotaFiscal', 'dataEmissao'),
            autorizada: BuiltValueNullFieldError.checkNotNull(autorizada, r'AnaliseNotaFiscal', 'autorizada'),
            fornecedor: fornecedor.build(),
            itens: itens.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fornecedor';
        fornecedor.build();
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'AnaliseNotaFiscal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
