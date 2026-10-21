// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmar_tarefa_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConfirmarTarefaArmazenagem extends ConfirmarTarefaArmazenagem {
  @override
  final String? enderecoId;
  @override
  final String? motivoDivergencia;
  @override
  final String? dispositivoId;
  @override
  final DateTime? ocorridoEm;

  factory _$ConfirmarTarefaArmazenagem([void Function(ConfirmarTarefaArmazenagemBuilder)? updates]) =>
      (ConfirmarTarefaArmazenagemBuilder()..update(updates))._build();

  _$ConfirmarTarefaArmazenagem._({this.enderecoId, this.motivoDivergencia, this.dispositivoId, this.ocorridoEm})
      : super._();
  @override
  ConfirmarTarefaArmazenagem rebuild(void Function(ConfirmarTarefaArmazenagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConfirmarTarefaArmazenagemBuilder toBuilder() => ConfirmarTarefaArmazenagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConfirmarTarefaArmazenagem &&
        enderecoId == other.enderecoId &&
        motivoDivergencia == other.motivoDivergencia &&
        dispositivoId == other.dispositivoId &&
        ocorridoEm == other.ocorridoEm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, motivoDivergencia.hashCode);
    _$hash = $jc(_$hash, dispositivoId.hashCode);
    _$hash = $jc(_$hash, ocorridoEm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConfirmarTarefaArmazenagem')
          ..add('enderecoId', enderecoId)
          ..add('motivoDivergencia', motivoDivergencia)
          ..add('dispositivoId', dispositivoId)
          ..add('ocorridoEm', ocorridoEm))
        .toString();
  }
}

class ConfirmarTarefaArmazenagemBuilder
    implements Builder<ConfirmarTarefaArmazenagem, ConfirmarTarefaArmazenagemBuilder> {
  _$ConfirmarTarefaArmazenagem? _$v;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _motivoDivergencia;
  String? get motivoDivergencia => _$this._motivoDivergencia;
  set motivoDivergencia(String? motivoDivergencia) => _$this._motivoDivergencia = motivoDivergencia;

  String? _dispositivoId;
  String? get dispositivoId => _$this._dispositivoId;
  set dispositivoId(String? dispositivoId) => _$this._dispositivoId = dispositivoId;

  DateTime? _ocorridoEm;
  DateTime? get ocorridoEm => _$this._ocorridoEm;
  set ocorridoEm(DateTime? ocorridoEm) => _$this._ocorridoEm = ocorridoEm;

  ConfirmarTarefaArmazenagemBuilder() {
    ConfirmarTarefaArmazenagem._defaults(this);
  }

  ConfirmarTarefaArmazenagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enderecoId = $v.enderecoId;
      _motivoDivergencia = $v.motivoDivergencia;
      _dispositivoId = $v.dispositivoId;
      _ocorridoEm = $v.ocorridoEm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConfirmarTarefaArmazenagem other) {
    _$v = other as _$ConfirmarTarefaArmazenagem;
  }

  @override
  void update(void Function(ConfirmarTarefaArmazenagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConfirmarTarefaArmazenagem build() => _build();

  _$ConfirmarTarefaArmazenagem _build() {
    final _$result = _$v ??
        _$ConfirmarTarefaArmazenagem._(
          enderecoId: enderecoId,
          motivoDivergencia: motivoDivergencia,
          dispositivoId: dispositivoId,
          ocorridoEm: ocorridoEm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
