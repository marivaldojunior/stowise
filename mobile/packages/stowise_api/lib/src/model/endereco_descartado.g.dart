// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endereco_descartado.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnderecoDescartado extends EnderecoDescartado {
  @override
  final String enderecoId;
  @override
  final String codigo;
  @override
  final BuiltList<String> motivos;

  factory _$EnderecoDescartado([void Function(EnderecoDescartadoBuilder)? updates]) =>
      (EnderecoDescartadoBuilder()..update(updates))._build();

  _$EnderecoDescartado._({required this.enderecoId, required this.codigo, required this.motivos}) : super._();
  @override
  EnderecoDescartado rebuild(void Function(EnderecoDescartadoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnderecoDescartadoBuilder toBuilder() => EnderecoDescartadoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnderecoDescartado &&
        enderecoId == other.enderecoId &&
        codigo == other.codigo &&
        motivos == other.motivos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enderecoId.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, motivos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnderecoDescartado')
          ..add('enderecoId', enderecoId)
          ..add('codigo', codigo)
          ..add('motivos', motivos))
        .toString();
  }
}

class EnderecoDescartadoBuilder implements Builder<EnderecoDescartado, EnderecoDescartadoBuilder> {
  _$EnderecoDescartado? _$v;

  String? _enderecoId;
  String? get enderecoId => _$this._enderecoId;
  set enderecoId(String? enderecoId) => _$this._enderecoId = enderecoId;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  ListBuilder<String>? _motivos;
  ListBuilder<String> get motivos => _$this._motivos ??= ListBuilder<String>();
  set motivos(ListBuilder<String>? motivos) => _$this._motivos = motivos;

  EnderecoDescartadoBuilder() {
    EnderecoDescartado._defaults(this);
  }

  EnderecoDescartadoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enderecoId = $v.enderecoId;
      _codigo = $v.codigo;
      _motivos = $v.motivos.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnderecoDescartado other) {
    _$v = other as _$EnderecoDescartado;
  }

  @override
  void update(void Function(EnderecoDescartadoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnderecoDescartado build() => _build();

  _$EnderecoDescartado _build() {
    _$EnderecoDescartado _$result;
    try {
      _$result = _$v ??
          _$EnderecoDescartado._(
            enderecoId: BuiltValueNullFieldError.checkNotNull(enderecoId, r'EnderecoDescartado', 'enderecoId'),
            codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'EnderecoDescartado', 'codigo'),
            motivos: motivos.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'motivos';
        motivos.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'EnderecoDescartado', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
