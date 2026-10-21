// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarefa_armazenagem_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TarefaArmazenagemDetalhe extends TarefaArmazenagemDetalhe {
  @override
  final TarefaArmazenagemResumo tarefa;
  @override
  final BuiltList<NotaRegra> notas;
  @override
  final String regrasVersao;
  @override
  final String? enderecoConfirmadoId;
  @override
  final String? movimentacaoId;
  @override
  final String? concluidoPor;

  factory _$TarefaArmazenagemDetalhe([void Function(TarefaArmazenagemDetalheBuilder)? updates]) =>
      (TarefaArmazenagemDetalheBuilder()..update(updates))._build();

  _$TarefaArmazenagemDetalhe._(
      {required this.tarefa,
      required this.notas,
      required this.regrasVersao,
      this.enderecoConfirmadoId,
      this.movimentacaoId,
      this.concluidoPor})
      : super._();
  @override
  TarefaArmazenagemDetalhe rebuild(void Function(TarefaArmazenagemDetalheBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TarefaArmazenagemDetalheBuilder toBuilder() => TarefaArmazenagemDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TarefaArmazenagemDetalhe &&
        tarefa == other.tarefa &&
        notas == other.notas &&
        regrasVersao == other.regrasVersao &&
        enderecoConfirmadoId == other.enderecoConfirmadoId &&
        movimentacaoId == other.movimentacaoId &&
        concluidoPor == other.concluidoPor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tarefa.hashCode);
    _$hash = $jc(_$hash, notas.hashCode);
    _$hash = $jc(_$hash, regrasVersao.hashCode);
    _$hash = $jc(_$hash, enderecoConfirmadoId.hashCode);
    _$hash = $jc(_$hash, movimentacaoId.hashCode);
    _$hash = $jc(_$hash, concluidoPor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TarefaArmazenagemDetalhe')
          ..add('tarefa', tarefa)
          ..add('notas', notas)
          ..add('regrasVersao', regrasVersao)
          ..add('enderecoConfirmadoId', enderecoConfirmadoId)
          ..add('movimentacaoId', movimentacaoId)
          ..add('concluidoPor', concluidoPor))
        .toString();
  }
}

class TarefaArmazenagemDetalheBuilder implements Builder<TarefaArmazenagemDetalhe, TarefaArmazenagemDetalheBuilder> {
  _$TarefaArmazenagemDetalhe? _$v;

  TarefaArmazenagemResumoBuilder? _tarefa;
  TarefaArmazenagemResumoBuilder get tarefa => _$this._tarefa ??= TarefaArmazenagemResumoBuilder();
  set tarefa(TarefaArmazenagemResumoBuilder? tarefa) => _$this._tarefa = tarefa;

  ListBuilder<NotaRegra>? _notas;
  ListBuilder<NotaRegra> get notas => _$this._notas ??= ListBuilder<NotaRegra>();
  set notas(ListBuilder<NotaRegra>? notas) => _$this._notas = notas;

  String? _regrasVersao;
  String? get regrasVersao => _$this._regrasVersao;
  set regrasVersao(String? regrasVersao) => _$this._regrasVersao = regrasVersao;

  String? _enderecoConfirmadoId;
  String? get enderecoConfirmadoId => _$this._enderecoConfirmadoId;
  set enderecoConfirmadoId(String? enderecoConfirmadoId) => _$this._enderecoConfirmadoId = enderecoConfirmadoId;

  String? _movimentacaoId;
  String? get movimentacaoId => _$this._movimentacaoId;
  set movimentacaoId(String? movimentacaoId) => _$this._movimentacaoId = movimentacaoId;

  String? _concluidoPor;
  String? get concluidoPor => _$this._concluidoPor;
  set concluidoPor(String? concluidoPor) => _$this._concluidoPor = concluidoPor;

  TarefaArmazenagemDetalheBuilder() {
    TarefaArmazenagemDetalhe._defaults(this);
  }

  TarefaArmazenagemDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tarefa = $v.tarefa.toBuilder();
      _notas = $v.notas.toBuilder();
      _regrasVersao = $v.regrasVersao;
      _enderecoConfirmadoId = $v.enderecoConfirmadoId;
      _movimentacaoId = $v.movimentacaoId;
      _concluidoPor = $v.concluidoPor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TarefaArmazenagemDetalhe other) {
    _$v = other as _$TarefaArmazenagemDetalhe;
  }

  @override
  void update(void Function(TarefaArmazenagemDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TarefaArmazenagemDetalhe build() => _build();

  _$TarefaArmazenagemDetalhe _build() {
    _$TarefaArmazenagemDetalhe _$result;
    try {
      _$result = _$v ??
          _$TarefaArmazenagemDetalhe._(
            tarefa: tarefa.build(),
            notas: notas.build(),
            regrasVersao:
                BuiltValueNullFieldError.checkNotNull(regrasVersao, r'TarefaArmazenagemDetalhe', 'regrasVersao'),
            enderecoConfirmadoId: enderecoConfirmadoId,
            movimentacaoId: movimentacaoId,
            concluidoPor: concluidoPor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tarefa';
        tarefa.build();
        _$failedField = 'notas';
        notas.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'TarefaArmazenagemDetalhe', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
