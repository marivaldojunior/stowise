// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido_sugestao_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PedidoSugestaoArmazenagem extends PedidoSugestaoArmazenagem {
  @override
  final String? produtoId;
  @override
  final String? embalagemId;
  @override
  final double? quantidade;
  @override
  final String? loteId;
  @override
  final Date? validade;
  @override
  final String? armazemId;
  @override
  final int? limite;

  factory _$PedidoSugestaoArmazenagem([void Function(PedidoSugestaoArmazenagemBuilder)? updates]) =>
      (PedidoSugestaoArmazenagemBuilder()..update(updates))._build();

  _$PedidoSugestaoArmazenagem._(
      {this.produtoId, this.embalagemId, this.quantidade, this.loteId, this.validade, this.armazemId, this.limite})
      : super._();
  @override
  PedidoSugestaoArmazenagem rebuild(void Function(PedidoSugestaoArmazenagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PedidoSugestaoArmazenagemBuilder toBuilder() => PedidoSugestaoArmazenagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PedidoSugestaoArmazenagem &&
        produtoId == other.produtoId &&
        embalagemId == other.embalagemId &&
        quantidade == other.quantidade &&
        loteId == other.loteId &&
        validade == other.validade &&
        armazemId == other.armazemId &&
        limite == other.limite;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, embalagemId.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, loteId.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jc(_$hash, armazemId.hashCode);
    _$hash = $jc(_$hash, limite.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PedidoSugestaoArmazenagem')
          ..add('produtoId', produtoId)
          ..add('embalagemId', embalagemId)
          ..add('quantidade', quantidade)
          ..add('loteId', loteId)
          ..add('validade', validade)
          ..add('armazemId', armazemId)
          ..add('limite', limite))
        .toString();
  }
}

class PedidoSugestaoArmazenagemBuilder implements Builder<PedidoSugestaoArmazenagem, PedidoSugestaoArmazenagemBuilder> {
  _$PedidoSugestaoArmazenagem? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _embalagemId;
  String? get embalagemId => _$this._embalagemId;
  set embalagemId(String? embalagemId) => _$this._embalagemId = embalagemId;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  String? _loteId;
  String? get loteId => _$this._loteId;
  set loteId(String? loteId) => _$this._loteId = loteId;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  String? _armazemId;
  String? get armazemId => _$this._armazemId;
  set armazemId(String? armazemId) => _$this._armazemId = armazemId;

  int? _limite;
  int? get limite => _$this._limite;
  set limite(int? limite) => _$this._limite = limite;

  PedidoSugestaoArmazenagemBuilder() {
    PedidoSugestaoArmazenagem._defaults(this);
  }

  PedidoSugestaoArmazenagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _embalagemId = $v.embalagemId;
      _quantidade = $v.quantidade;
      _loteId = $v.loteId;
      _validade = $v.validade;
      _armazemId = $v.armazemId;
      _limite = $v.limite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PedidoSugestaoArmazenagem other) {
    _$v = other as _$PedidoSugestaoArmazenagem;
  }

  @override
  void update(void Function(PedidoSugestaoArmazenagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PedidoSugestaoArmazenagem build() => _build();

  _$PedidoSugestaoArmazenagem _build() {
    final _$result = _$v ??
        _$PedidoSugestaoArmazenagem._(
          produtoId: produtoId,
          embalagemId: embalagemId,
          quantidade: quantidade,
          loteId: loteId,
          validade: validade,
          armazemId: armazemId,
          limite: limite,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
