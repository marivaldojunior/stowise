// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumo_curva_abc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResumoCurvaAbc extends ResumoCurvaAbc {
  @override
  final DateTime desde;
  @override
  final int classeA;
  @override
  final int classeB;
  @override
  final int classeC;
  @override
  final int alterados;

  factory _$ResumoCurvaAbc([void Function(ResumoCurvaAbcBuilder)? updates]) =>
      (ResumoCurvaAbcBuilder()..update(updates))._build();

  _$ResumoCurvaAbc._(
      {required this.desde,
      required this.classeA,
      required this.classeB,
      required this.classeC,
      required this.alterados})
      : super._();
  @override
  ResumoCurvaAbc rebuild(void Function(ResumoCurvaAbcBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ResumoCurvaAbcBuilder toBuilder() => ResumoCurvaAbcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResumoCurvaAbc &&
        desde == other.desde &&
        classeA == other.classeA &&
        classeB == other.classeB &&
        classeC == other.classeC &&
        alterados == other.alterados;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, desde.hashCode);
    _$hash = $jc(_$hash, classeA.hashCode);
    _$hash = $jc(_$hash, classeB.hashCode);
    _$hash = $jc(_$hash, classeC.hashCode);
    _$hash = $jc(_$hash, alterados.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResumoCurvaAbc')
          ..add('desde', desde)
          ..add('classeA', classeA)
          ..add('classeB', classeB)
          ..add('classeC', classeC)
          ..add('alterados', alterados))
        .toString();
  }
}

class ResumoCurvaAbcBuilder implements Builder<ResumoCurvaAbc, ResumoCurvaAbcBuilder> {
  _$ResumoCurvaAbc? _$v;

  DateTime? _desde;
  DateTime? get desde => _$this._desde;
  set desde(DateTime? desde) => _$this._desde = desde;

  int? _classeA;
  int? get classeA => _$this._classeA;
  set classeA(int? classeA) => _$this._classeA = classeA;

  int? _classeB;
  int? get classeB => _$this._classeB;
  set classeB(int? classeB) => _$this._classeB = classeB;

  int? _classeC;
  int? get classeC => _$this._classeC;
  set classeC(int? classeC) => _$this._classeC = classeC;

  int? _alterados;
  int? get alterados => _$this._alterados;
  set alterados(int? alterados) => _$this._alterados = alterados;

  ResumoCurvaAbcBuilder() {
    ResumoCurvaAbc._defaults(this);
  }

  ResumoCurvaAbcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _desde = $v.desde;
      _classeA = $v.classeA;
      _classeB = $v.classeB;
      _classeC = $v.classeC;
      _alterados = $v.alterados;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResumoCurvaAbc other) {
    _$v = other as _$ResumoCurvaAbc;
  }

  @override
  void update(void Function(ResumoCurvaAbcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResumoCurvaAbc build() => _build();

  _$ResumoCurvaAbc _build() {
    final _$result = _$v ??
        _$ResumoCurvaAbc._(
          desde: BuiltValueNullFieldError.checkNotNull(desde, r'ResumoCurvaAbc', 'desde'),
          classeA: BuiltValueNullFieldError.checkNotNull(classeA, r'ResumoCurvaAbc', 'classeA'),
          classeB: BuiltValueNullFieldError.checkNotNull(classeB, r'ResumoCurvaAbc', 'classeB'),
          classeC: BuiltValueNullFieldError.checkNotNull(classeC, r'ResumoCurvaAbc', 'classeC'),
          alterados: BuiltValueNullFieldError.checkNotNull(alterados, r'ResumoCurvaAbc', 'alterados'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
