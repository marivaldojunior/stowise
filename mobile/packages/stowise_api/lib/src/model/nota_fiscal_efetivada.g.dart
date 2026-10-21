// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nota_fiscal_efetivada.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotaFiscalEfetivada extends NotaFiscalEfetivada {
  @override
  final String recebimentoId;
  @override
  final String fornecedorId;
  @override
  final bool fornecedorCriado;
  @override
  final int produtosCriados;
  @override
  final int vinculosCriados;
  @override
  final int vinculosAtualizados;
  @override
  final BuiltList<ItemEfetivado> itens;

  factory _$NotaFiscalEfetivada([void Function(NotaFiscalEfetivadaBuilder)? updates]) =>
      (NotaFiscalEfetivadaBuilder()..update(updates))._build();

  _$NotaFiscalEfetivada._(
      {required this.recebimentoId,
      required this.fornecedorId,
      required this.fornecedorCriado,
      required this.produtosCriados,
      required this.vinculosCriados,
      required this.vinculosAtualizados,
      required this.itens})
      : super._();
  @override
  NotaFiscalEfetivada rebuild(void Function(NotaFiscalEfetivadaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotaFiscalEfetivadaBuilder toBuilder() => NotaFiscalEfetivadaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotaFiscalEfetivada &&
        recebimentoId == other.recebimentoId &&
        fornecedorId == other.fornecedorId &&
        fornecedorCriado == other.fornecedorCriado &&
        produtosCriados == other.produtosCriados &&
        vinculosCriados == other.vinculosCriados &&
        vinculosAtualizados == other.vinculosAtualizados &&
        itens == other.itens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recebimentoId.hashCode);
    _$hash = $jc(_$hash, fornecedorId.hashCode);
    _$hash = $jc(_$hash, fornecedorCriado.hashCode);
    _$hash = $jc(_$hash, produtosCriados.hashCode);
    _$hash = $jc(_$hash, vinculosCriados.hashCode);
    _$hash = $jc(_$hash, vinculosAtualizados.hashCode);
    _$hash = $jc(_$hash, itens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotaFiscalEfetivada')
          ..add('recebimentoId', recebimentoId)
          ..add('fornecedorId', fornecedorId)
          ..add('fornecedorCriado', fornecedorCriado)
          ..add('produtosCriados', produtosCriados)
          ..add('vinculosCriados', vinculosCriados)
          ..add('vinculosAtualizados', vinculosAtualizados)
          ..add('itens', itens))
        .toString();
  }
}

class NotaFiscalEfetivadaBuilder implements Builder<NotaFiscalEfetivada, NotaFiscalEfetivadaBuilder> {
  _$NotaFiscalEfetivada? _$v;

  String? _recebimentoId;
  String? get recebimentoId => _$this._recebimentoId;
  set recebimentoId(String? recebimentoId) => _$this._recebimentoId = recebimentoId;

  String? _fornecedorId;
  String? get fornecedorId => _$this._fornecedorId;
  set fornecedorId(String? fornecedorId) => _$this._fornecedorId = fornecedorId;

  bool? _fornecedorCriado;
  bool? get fornecedorCriado => _$this._fornecedorCriado;
  set fornecedorCriado(bool? fornecedorCriado) => _$this._fornecedorCriado = fornecedorCriado;

  int? _produtosCriados;
  int? get produtosCriados => _$this._produtosCriados;
  set produtosCriados(int? produtosCriados) => _$this._produtosCriados = produtosCriados;

  int? _vinculosCriados;
  int? get vinculosCriados => _$this._vinculosCriados;
  set vinculosCriados(int? vinculosCriados) => _$this._vinculosCriados = vinculosCriados;

  int? _vinculosAtualizados;
  int? get vinculosAtualizados => _$this._vinculosAtualizados;
  set vinculosAtualizados(int? vinculosAtualizados) => _$this._vinculosAtualizados = vinculosAtualizados;

  ListBuilder<ItemEfetivado>? _itens;
  ListBuilder<ItemEfetivado> get itens => _$this._itens ??= ListBuilder<ItemEfetivado>();
  set itens(ListBuilder<ItemEfetivado>? itens) => _$this._itens = itens;

  NotaFiscalEfetivadaBuilder() {
    NotaFiscalEfetivada._defaults(this);
  }

  NotaFiscalEfetivadaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recebimentoId = $v.recebimentoId;
      _fornecedorId = $v.fornecedorId;
      _fornecedorCriado = $v.fornecedorCriado;
      _produtosCriados = $v.produtosCriados;
      _vinculosCriados = $v.vinculosCriados;
      _vinculosAtualizados = $v.vinculosAtualizados;
      _itens = $v.itens.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotaFiscalEfetivada other) {
    _$v = other as _$NotaFiscalEfetivada;
  }

  @override
  void update(void Function(NotaFiscalEfetivadaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotaFiscalEfetivada build() => _build();

  _$NotaFiscalEfetivada _build() {
    _$NotaFiscalEfetivada _$result;
    try {
      _$result = _$v ??
          _$NotaFiscalEfetivada._(
            recebimentoId:
                BuiltValueNullFieldError.checkNotNull(recebimentoId, r'NotaFiscalEfetivada', 'recebimentoId'),
            fornecedorId: BuiltValueNullFieldError.checkNotNull(fornecedorId, r'NotaFiscalEfetivada', 'fornecedorId'),
            fornecedorCriado:
                BuiltValueNullFieldError.checkNotNull(fornecedorCriado, r'NotaFiscalEfetivada', 'fornecedorCriado'),
            produtosCriados:
                BuiltValueNullFieldError.checkNotNull(produtosCriados, r'NotaFiscalEfetivada', 'produtosCriados'),
            vinculosCriados:
                BuiltValueNullFieldError.checkNotNull(vinculosCriados, r'NotaFiscalEfetivada', 'vinculosCriados'),
            vinculosAtualizados: BuiltValueNullFieldError.checkNotNull(
                vinculosAtualizados, r'NotaFiscalEfetivada', 'vinculosAtualizados'),
            itens: itens.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itens';
        itens.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'NotaFiscalEfetivada', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
