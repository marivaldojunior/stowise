// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nota_regra.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotaRegra extends NotaRegra {
  @override
  final String codigo;
  @override
  final double peso;
  @override
  final bool ativa;
  @override
  final double? nota;
  @override
  final String explicacao;

  factory _$NotaRegra([void Function(NotaRegraBuilder)? updates]) => (NotaRegraBuilder()..update(updates))._build();

  _$NotaRegra._({required this.codigo, required this.peso, required this.ativa, this.nota, required this.explicacao})
      : super._();
  @override
  NotaRegra rebuild(void Function(NotaRegraBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  NotaRegraBuilder toBuilder() => NotaRegraBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotaRegra &&
        codigo == other.codigo &&
        peso == other.peso &&
        ativa == other.ativa &&
        nota == other.nota &&
        explicacao == other.explicacao;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, peso.hashCode);
    _$hash = $jc(_$hash, ativa.hashCode);
    _$hash = $jc(_$hash, nota.hashCode);
    _$hash = $jc(_$hash, explicacao.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotaRegra')
          ..add('codigo', codigo)
          ..add('peso', peso)
          ..add('ativa', ativa)
          ..add('nota', nota)
          ..add('explicacao', explicacao))
        .toString();
  }
}

class NotaRegraBuilder implements Builder<NotaRegra, NotaRegraBuilder> {
  _$NotaRegra? _$v;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  double? _peso;
  double? get peso => _$this._peso;
  set peso(double? peso) => _$this._peso = peso;

  bool? _ativa;
  bool? get ativa => _$this._ativa;
  set ativa(bool? ativa) => _$this._ativa = ativa;

  double? _nota;
  double? get nota => _$this._nota;
  set nota(double? nota) => _$this._nota = nota;

  String? _explicacao;
  String? get explicacao => _$this._explicacao;
  set explicacao(String? explicacao) => _$this._explicacao = explicacao;

  NotaRegraBuilder() {
    NotaRegra._defaults(this);
  }

  NotaRegraBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codigo = $v.codigo;
      _peso = $v.peso;
      _ativa = $v.ativa;
      _nota = $v.nota;
      _explicacao = $v.explicacao;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotaRegra other) {
    _$v = other as _$NotaRegra;
  }

  @override
  void update(void Function(NotaRegraBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotaRegra build() => _build();

  _$NotaRegra _build() {
    final _$result = _$v ??
        _$NotaRegra._(
          codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'NotaRegra', 'codigo'),
          peso: BuiltValueNullFieldError.checkNotNull(peso, r'NotaRegra', 'peso'),
          ativa: BuiltValueNullFieldError.checkNotNull(ativa, r'NotaRegra', 'ativa'),
          nota: nota,
          explicacao: BuiltValueNullFieldError.checkNotNull(explicacao, r'NotaRegra', 'explicacao'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
