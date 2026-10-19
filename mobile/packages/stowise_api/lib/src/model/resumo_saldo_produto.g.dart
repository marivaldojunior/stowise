// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumo_saldo_produto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResumoSaldoProduto extends ResumoSaldoProduto {
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final double quantidade;
  @override
  final double quantidadeReservada;
  @override
  final double quantidadeDisponivel;
  @override
  final int enderecos;
  @override
  final BuiltList<ResumoSaldoLote> lotes;

  factory _$ResumoSaldoProduto([void Function(ResumoSaldoProdutoBuilder)? updates]) =>
      (ResumoSaldoProdutoBuilder()..update(updates))._build();

  _$ResumoSaldoProduto._(
      {required this.produtoId,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      required this.quantidade,
      required this.quantidadeReservada,
      required this.quantidadeDisponivel,
      required this.enderecos,
      required this.lotes})
      : super._();
  @override
  ResumoSaldoProduto rebuild(void Function(ResumoSaldoProdutoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResumoSaldoProdutoBuilder toBuilder() => ResumoSaldoProdutoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResumoSaldoProduto &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        quantidade == other.quantidade &&
        quantidadeReservada == other.quantidadeReservada &&
        quantidadeDisponivel == other.quantidadeDisponivel &&
        enderecos == other.enderecos &&
        lotes == other.lotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, quantidadeReservada.hashCode);
    _$hash = $jc(_$hash, quantidadeDisponivel.hashCode);
    _$hash = $jc(_$hash, enderecos.hashCode);
    _$hash = $jc(_$hash, lotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResumoSaldoProduto')
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('quantidade', quantidade)
          ..add('quantidadeReservada', quantidadeReservada)
          ..add('quantidadeDisponivel', quantidadeDisponivel)
          ..add('enderecos', enderecos)
          ..add('lotes', lotes))
        .toString();
  }
}

class ResumoSaldoProdutoBuilder implements Builder<ResumoSaldoProduto, ResumoSaldoProdutoBuilder> {
  _$ResumoSaldoProduto? _$v;

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

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  double? _quantidadeReservada;
  double? get quantidadeReservada => _$this._quantidadeReservada;
  set quantidadeReservada(double? quantidadeReservada) => _$this._quantidadeReservada = quantidadeReservada;

  double? _quantidadeDisponivel;
  double? get quantidadeDisponivel => _$this._quantidadeDisponivel;
  set quantidadeDisponivel(double? quantidadeDisponivel) => _$this._quantidadeDisponivel = quantidadeDisponivel;

  int? _enderecos;
  int? get enderecos => _$this._enderecos;
  set enderecos(int? enderecos) => _$this._enderecos = enderecos;

  ListBuilder<ResumoSaldoLote>? _lotes;
  ListBuilder<ResumoSaldoLote> get lotes => _$this._lotes ??= ListBuilder<ResumoSaldoLote>();
  set lotes(ListBuilder<ResumoSaldoLote>? lotes) => _$this._lotes = lotes;

  ResumoSaldoProdutoBuilder() {
    ResumoSaldoProduto._defaults(this);
  }

  ResumoSaldoProdutoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _quantidade = $v.quantidade;
      _quantidadeReservada = $v.quantidadeReservada;
      _quantidadeDisponivel = $v.quantidadeDisponivel;
      _enderecos = $v.enderecos;
      _lotes = $v.lotes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResumoSaldoProduto other) {
    _$v = other as _$ResumoSaldoProduto;
  }

  @override
  void update(void Function(ResumoSaldoProdutoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResumoSaldoProduto build() => _build();

  _$ResumoSaldoProduto _build() {
    _$ResumoSaldoProduto _$result;
    try {
      _$result = _$v ??
          _$ResumoSaldoProduto._(
            produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'ResumoSaldoProduto', 'produtoId'),
            sku: BuiltValueNullFieldError.checkNotNull(sku, r'ResumoSaldoProduto', 'sku'),
            descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'ResumoSaldoProduto', 'descricao'),
            unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'ResumoSaldoProduto', 'unidadeBase'),
            quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'ResumoSaldoProduto', 'quantidade'),
            quantidadeReservada: BuiltValueNullFieldError.checkNotNull(
                quantidadeReservada, r'ResumoSaldoProduto', 'quantidadeReservada'),
            quantidadeDisponivel: BuiltValueNullFieldError.checkNotNull(
                quantidadeDisponivel, r'ResumoSaldoProduto', 'quantidadeDisponivel'),
            enderecos: BuiltValueNullFieldError.checkNotNull(enderecos, r'ResumoSaldoProduto', 'enderecos'),
            lotes: lotes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lotes';
        lotes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ResumoSaldoProduto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
