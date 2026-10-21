// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sugestao_armazenagem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SugestaoArmazenagem extends SugestaoArmazenagem {
  @override
  final String produtoId;
  @override
  final String sku;
  @override
  final ClasseArmazenagem classeArmazenagem;
  @override
  final ClasseAbc classeAbc;
  @override
  final double quantidade;
  @override
  final Date? validade;
  @override
  final double? pesoKg;
  @override
  final double? volumeCm3;
  @override
  final int totalCandidatos;
  @override
  final BuiltList<SugestaoEndereco> sugestoes;
  @override
  final int totalDescartados;
  @override
  final BuiltList<EnderecoDescartado> descartados;

  factory _$SugestaoArmazenagem([void Function(SugestaoArmazenagemBuilder)? updates]) =>
      (SugestaoArmazenagemBuilder()..update(updates))._build();

  _$SugestaoArmazenagem._(
      {required this.produtoId,
      required this.sku,
      required this.classeArmazenagem,
      required this.classeAbc,
      required this.quantidade,
      this.validade,
      this.pesoKg,
      this.volumeCm3,
      required this.totalCandidatos,
      required this.sugestoes,
      required this.totalDescartados,
      required this.descartados})
      : super._();
  @override
  SugestaoArmazenagem rebuild(void Function(SugestaoArmazenagemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SugestaoArmazenagemBuilder toBuilder() => SugestaoArmazenagemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SugestaoArmazenagem &&
        produtoId == other.produtoId &&
        sku == other.sku &&
        classeArmazenagem == other.classeArmazenagem &&
        classeAbc == other.classeAbc &&
        quantidade == other.quantidade &&
        validade == other.validade &&
        pesoKg == other.pesoKg &&
        volumeCm3 == other.volumeCm3 &&
        totalCandidatos == other.totalCandidatos &&
        sugestoes == other.sugestoes &&
        totalDescartados == other.totalDescartados &&
        descartados == other.descartados;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, produtoId.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, classeArmazenagem.hashCode);
    _$hash = $jc(_$hash, classeAbc.hashCode);
    _$hash = $jc(_$hash, quantidade.hashCode);
    _$hash = $jc(_$hash, validade.hashCode);
    _$hash = $jc(_$hash, pesoKg.hashCode);
    _$hash = $jc(_$hash, volumeCm3.hashCode);
    _$hash = $jc(_$hash, totalCandidatos.hashCode);
    _$hash = $jc(_$hash, sugestoes.hashCode);
    _$hash = $jc(_$hash, totalDescartados.hashCode);
    _$hash = $jc(_$hash, descartados.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SugestaoArmazenagem')
          ..add('produtoId', produtoId)
          ..add('sku', sku)
          ..add('classeArmazenagem', classeArmazenagem)
          ..add('classeAbc', classeAbc)
          ..add('quantidade', quantidade)
          ..add('validade', validade)
          ..add('pesoKg', pesoKg)
          ..add('volumeCm3', volumeCm3)
          ..add('totalCandidatos', totalCandidatos)
          ..add('sugestoes', sugestoes)
          ..add('totalDescartados', totalDescartados)
          ..add('descartados', descartados))
        .toString();
  }
}

class SugestaoArmazenagemBuilder implements Builder<SugestaoArmazenagem, SugestaoArmazenagemBuilder> {
  _$SugestaoArmazenagem? _$v;

  String? _produtoId;
  String? get produtoId => _$this._produtoId;
  set produtoId(String? produtoId) => _$this._produtoId = produtoId;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  ClasseArmazenagem? _classeArmazenagem;
  ClasseArmazenagem? get classeArmazenagem => _$this._classeArmazenagem;
  set classeArmazenagem(ClasseArmazenagem? classeArmazenagem) => _$this._classeArmazenagem = classeArmazenagem;

  ClasseAbc? _classeAbc;
  ClasseAbc? get classeAbc => _$this._classeAbc;
  set classeAbc(ClasseAbc? classeAbc) => _$this._classeAbc = classeAbc;

  double? _quantidade;
  double? get quantidade => _$this._quantidade;
  set quantidade(double? quantidade) => _$this._quantidade = quantidade;

  Date? _validade;
  Date? get validade => _$this._validade;
  set validade(Date? validade) => _$this._validade = validade;

  double? _pesoKg;
  double? get pesoKg => _$this._pesoKg;
  set pesoKg(double? pesoKg) => _$this._pesoKg = pesoKg;

  double? _volumeCm3;
  double? get volumeCm3 => _$this._volumeCm3;
  set volumeCm3(double? volumeCm3) => _$this._volumeCm3 = volumeCm3;

  int? _totalCandidatos;
  int? get totalCandidatos => _$this._totalCandidatos;
  set totalCandidatos(int? totalCandidatos) => _$this._totalCandidatos = totalCandidatos;

  ListBuilder<SugestaoEndereco>? _sugestoes;
  ListBuilder<SugestaoEndereco> get sugestoes => _$this._sugestoes ??= ListBuilder<SugestaoEndereco>();
  set sugestoes(ListBuilder<SugestaoEndereco>? sugestoes) => _$this._sugestoes = sugestoes;

  int? _totalDescartados;
  int? get totalDescartados => _$this._totalDescartados;
  set totalDescartados(int? totalDescartados) => _$this._totalDescartados = totalDescartados;

  ListBuilder<EnderecoDescartado>? _descartados;
  ListBuilder<EnderecoDescartado> get descartados => _$this._descartados ??= ListBuilder<EnderecoDescartado>();
  set descartados(ListBuilder<EnderecoDescartado>? descartados) => _$this._descartados = descartados;

  SugestaoArmazenagemBuilder() {
    SugestaoArmazenagem._defaults(this);
  }

  SugestaoArmazenagemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _produtoId = $v.produtoId;
      _sku = $v.sku;
      _classeArmazenagem = $v.classeArmazenagem;
      _classeAbc = $v.classeAbc;
      _quantidade = $v.quantidade;
      _validade = $v.validade;
      _pesoKg = $v.pesoKg;
      _volumeCm3 = $v.volumeCm3;
      _totalCandidatos = $v.totalCandidatos;
      _sugestoes = $v.sugestoes.toBuilder();
      _totalDescartados = $v.totalDescartados;
      _descartados = $v.descartados.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SugestaoArmazenagem other) {
    _$v = other as _$SugestaoArmazenagem;
  }

  @override
  void update(void Function(SugestaoArmazenagemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SugestaoArmazenagem build() => _build();

  _$SugestaoArmazenagem _build() {
    _$SugestaoArmazenagem _$result;
    try {
      _$result = _$v ??
          _$SugestaoArmazenagem._(
            produtoId: BuiltValueNullFieldError.checkNotNull(produtoId, r'SugestaoArmazenagem', 'produtoId'),
            sku: BuiltValueNullFieldError.checkNotNull(sku, r'SugestaoArmazenagem', 'sku'),
            classeArmazenagem:
                BuiltValueNullFieldError.checkNotNull(classeArmazenagem, r'SugestaoArmazenagem', 'classeArmazenagem'),
            classeAbc: BuiltValueNullFieldError.checkNotNull(classeAbc, r'SugestaoArmazenagem', 'classeAbc'),
            quantidade: BuiltValueNullFieldError.checkNotNull(quantidade, r'SugestaoArmazenagem', 'quantidade'),
            validade: validade,
            pesoKg: pesoKg,
            volumeCm3: volumeCm3,
            totalCandidatos:
                BuiltValueNullFieldError.checkNotNull(totalCandidatos, r'SugestaoArmazenagem', 'totalCandidatos'),
            sugestoes: sugestoes.build(),
            totalDescartados:
                BuiltValueNullFieldError.checkNotNull(totalDescartados, r'SugestaoArmazenagem', 'totalDescartados'),
            descartados: descartados.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sugestoes';
        sugestoes.build();

        _$failedField = 'descartados';
        descartados.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'SugestaoArmazenagem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
