// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endereco_detalhe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnderecoDetalhe extends EnderecoDetalhe {
  @override
  final String id;
  @override
  final String armazemId;
  @override
  final String zonaId;
  @override
  final String codigo;
  @override
  final String rua;
  @override
  final int modulo;
  @override
  final int nivel;
  @override
  final int posicao;
  @override
  final double capacidadePesoKg;
  @override
  final double alturaCm;
  @override
  final double larguraCm;
  @override
  final double profundidadeCm;
  @override
  final double distanciaExpedicao;
  @override
  final StatusEndereco status;
  @override
  final String? motivoBloqueio;
  @override
  final DateTime? bloqueadoEm;
  @override
  final String? bloqueadoPor;

  factory _$EnderecoDetalhe([void Function(EnderecoDetalheBuilder)? updates]) =>
      (EnderecoDetalheBuilder()..update(updates))._build();

  _$EnderecoDetalhe._(
      {required this.id,
      required this.armazemId,
      required this.zonaId,
      required this.codigo,
      required this.rua,
      required this.modulo,
      required this.nivel,
      required this.posicao,
      required this.capacidadePesoKg,
      required this.alturaCm,
      required this.larguraCm,
      required this.profundidadeCm,
      required this.distanciaExpedicao,
      required this.status,
      this.motivoBloqueio,
      this.bloqueadoEm,
      this.bloqueadoPor})
      : super._();
  @override
  EnderecoDetalhe rebuild(void Function(EnderecoDetalheBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EnderecoDetalheBuilder toBuilder() => EnderecoDetalheBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnderecoDetalhe &&
        id == other.id &&
        armazemId == other.armazemId &&
        zonaId == other.zonaId &&
        codigo == other.codigo &&
        rua == other.rua &&
        modulo == other.modulo &&
        nivel == other.nivel &&
        posicao == other.posicao &&
        capacidadePesoKg == other.capacidadePesoKg &&
        alturaCm == other.alturaCm &&
        larguraCm == other.larguraCm &&
        profundidadeCm == other.profundidadeCm &&
        distanciaExpedicao == other.distanciaExpedicao &&
        status == other.status &&
        motivoBloqueio == other.motivoBloqueio &&
        bloqueadoEm == other.bloqueadoEm &&
        bloqueadoPor == other.bloqueadoPor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, armazemId.hashCode);
    _$hash = $jc(_$hash, zonaId.hashCode);
    _$hash = $jc(_$hash, codigo.hashCode);
    _$hash = $jc(_$hash, rua.hashCode);
    _$hash = $jc(_$hash, modulo.hashCode);
    _$hash = $jc(_$hash, nivel.hashCode);
    _$hash = $jc(_$hash, posicao.hashCode);
    _$hash = $jc(_$hash, capacidadePesoKg.hashCode);
    _$hash = $jc(_$hash, alturaCm.hashCode);
    _$hash = $jc(_$hash, larguraCm.hashCode);
    _$hash = $jc(_$hash, profundidadeCm.hashCode);
    _$hash = $jc(_$hash, distanciaExpedicao.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, motivoBloqueio.hashCode);
    _$hash = $jc(_$hash, bloqueadoEm.hashCode);
    _$hash = $jc(_$hash, bloqueadoPor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnderecoDetalhe')
          ..add('id', id)
          ..add('armazemId', armazemId)
          ..add('zonaId', zonaId)
          ..add('codigo', codigo)
          ..add('rua', rua)
          ..add('modulo', modulo)
          ..add('nivel', nivel)
          ..add('posicao', posicao)
          ..add('capacidadePesoKg', capacidadePesoKg)
          ..add('alturaCm', alturaCm)
          ..add('larguraCm', larguraCm)
          ..add('profundidadeCm', profundidadeCm)
          ..add('distanciaExpedicao', distanciaExpedicao)
          ..add('status', status)
          ..add('motivoBloqueio', motivoBloqueio)
          ..add('bloqueadoEm', bloqueadoEm)
          ..add('bloqueadoPor', bloqueadoPor))
        .toString();
  }
}

class EnderecoDetalheBuilder implements Builder<EnderecoDetalhe, EnderecoDetalheBuilder> {
  _$EnderecoDetalhe? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _armazemId;
  String? get armazemId => _$this._armazemId;
  set armazemId(String? armazemId) => _$this._armazemId = armazemId;

  String? _zonaId;
  String? get zonaId => _$this._zonaId;
  set zonaId(String? zonaId) => _$this._zonaId = zonaId;

  String? _codigo;
  String? get codigo => _$this._codigo;
  set codigo(String? codigo) => _$this._codigo = codigo;

  String? _rua;
  String? get rua => _$this._rua;
  set rua(String? rua) => _$this._rua = rua;

  int? _modulo;
  int? get modulo => _$this._modulo;
  set modulo(int? modulo) => _$this._modulo = modulo;

  int? _nivel;
  int? get nivel => _$this._nivel;
  set nivel(int? nivel) => _$this._nivel = nivel;

  int? _posicao;
  int? get posicao => _$this._posicao;
  set posicao(int? posicao) => _$this._posicao = posicao;

  double? _capacidadePesoKg;
  double? get capacidadePesoKg => _$this._capacidadePesoKg;
  set capacidadePesoKg(double? capacidadePesoKg) => _$this._capacidadePesoKg = capacidadePesoKg;

  double? _alturaCm;
  double? get alturaCm => _$this._alturaCm;
  set alturaCm(double? alturaCm) => _$this._alturaCm = alturaCm;

  double? _larguraCm;
  double? get larguraCm => _$this._larguraCm;
  set larguraCm(double? larguraCm) => _$this._larguraCm = larguraCm;

  double? _profundidadeCm;
  double? get profundidadeCm => _$this._profundidadeCm;
  set profundidadeCm(double? profundidadeCm) => _$this._profundidadeCm = profundidadeCm;

  double? _distanciaExpedicao;
  double? get distanciaExpedicao => _$this._distanciaExpedicao;
  set distanciaExpedicao(double? distanciaExpedicao) => _$this._distanciaExpedicao = distanciaExpedicao;

  StatusEndereco? _status;
  StatusEndereco? get status => _$this._status;
  set status(StatusEndereco? status) => _$this._status = status;

  String? _motivoBloqueio;
  String? get motivoBloqueio => _$this._motivoBloqueio;
  set motivoBloqueio(String? motivoBloqueio) => _$this._motivoBloqueio = motivoBloqueio;

  DateTime? _bloqueadoEm;
  DateTime? get bloqueadoEm => _$this._bloqueadoEm;
  set bloqueadoEm(DateTime? bloqueadoEm) => _$this._bloqueadoEm = bloqueadoEm;

  String? _bloqueadoPor;
  String? get bloqueadoPor => _$this._bloqueadoPor;
  set bloqueadoPor(String? bloqueadoPor) => _$this._bloqueadoPor = bloqueadoPor;

  EnderecoDetalheBuilder() {
    EnderecoDetalhe._defaults(this);
  }

  EnderecoDetalheBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _armazemId = $v.armazemId;
      _zonaId = $v.zonaId;
      _codigo = $v.codigo;
      _rua = $v.rua;
      _modulo = $v.modulo;
      _nivel = $v.nivel;
      _posicao = $v.posicao;
      _capacidadePesoKg = $v.capacidadePesoKg;
      _alturaCm = $v.alturaCm;
      _larguraCm = $v.larguraCm;
      _profundidadeCm = $v.profundidadeCm;
      _distanciaExpedicao = $v.distanciaExpedicao;
      _status = $v.status;
      _motivoBloqueio = $v.motivoBloqueio;
      _bloqueadoEm = $v.bloqueadoEm;
      _bloqueadoPor = $v.bloqueadoPor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnderecoDetalhe other) {
    _$v = other as _$EnderecoDetalhe;
  }

  @override
  void update(void Function(EnderecoDetalheBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnderecoDetalhe build() => _build();

  _$EnderecoDetalhe _build() {
    final _$result = _$v ??
        _$EnderecoDetalhe._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'EnderecoDetalhe', 'id'),
          armazemId: BuiltValueNullFieldError.checkNotNull(armazemId, r'EnderecoDetalhe', 'armazemId'),
          zonaId: BuiltValueNullFieldError.checkNotNull(zonaId, r'EnderecoDetalhe', 'zonaId'),
          codigo: BuiltValueNullFieldError.checkNotNull(codigo, r'EnderecoDetalhe', 'codigo'),
          rua: BuiltValueNullFieldError.checkNotNull(rua, r'EnderecoDetalhe', 'rua'),
          modulo: BuiltValueNullFieldError.checkNotNull(modulo, r'EnderecoDetalhe', 'modulo'),
          nivel: BuiltValueNullFieldError.checkNotNull(nivel, r'EnderecoDetalhe', 'nivel'),
          posicao: BuiltValueNullFieldError.checkNotNull(posicao, r'EnderecoDetalhe', 'posicao'),
          capacidadePesoKg:
              BuiltValueNullFieldError.checkNotNull(capacidadePesoKg, r'EnderecoDetalhe', 'capacidadePesoKg'),
          alturaCm: BuiltValueNullFieldError.checkNotNull(alturaCm, r'EnderecoDetalhe', 'alturaCm'),
          larguraCm: BuiltValueNullFieldError.checkNotNull(larguraCm, r'EnderecoDetalhe', 'larguraCm'),
          profundidadeCm: BuiltValueNullFieldError.checkNotNull(profundidadeCm, r'EnderecoDetalhe', 'profundidadeCm'),
          distanciaExpedicao:
              BuiltValueNullFieldError.checkNotNull(distanciaExpedicao, r'EnderecoDetalhe', 'distanciaExpedicao'),
          status: BuiltValueNullFieldError.checkNotNull(status, r'EnderecoDetalhe', 'status'),
          motivoBloqueio: motivoBloqueio,
          bloqueadoEm: bloqueadoEm,
          bloqueadoPor: bloqueadoPor,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
