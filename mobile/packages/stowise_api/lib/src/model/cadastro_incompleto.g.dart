// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_incompleto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CadastroIncompleto extends CadastroIncompleto {
  @override
  final String id;
  @override
  final String sku;
  @override
  final String descricao;
  @override
  final String unidadeBase;
  @override
  final String? categoriaId;
  @override
  final BuiltList<PendenciaEmbalagem> pendencias;

  factory _$CadastroIncompleto([void Function(CadastroIncompletoBuilder)? updates]) =>
      (CadastroIncompletoBuilder()..update(updates))._build();

  _$CadastroIncompleto._(
      {required this.id,
      required this.sku,
      required this.descricao,
      required this.unidadeBase,
      this.categoriaId,
      required this.pendencias})
      : super._();
  @override
  CadastroIncompleto rebuild(void Function(CadastroIncompletoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CadastroIncompletoBuilder toBuilder() => CadastroIncompletoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CadastroIncompleto &&
        id == other.id &&
        sku == other.sku &&
        descricao == other.descricao &&
        unidadeBase == other.unidadeBase &&
        categoriaId == other.categoriaId &&
        pendencias == other.pendencias;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, descricao.hashCode);
    _$hash = $jc(_$hash, unidadeBase.hashCode);
    _$hash = $jc(_$hash, categoriaId.hashCode);
    _$hash = $jc(_$hash, pendencias.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CadastroIncompleto')
          ..add('id', id)
          ..add('sku', sku)
          ..add('descricao', descricao)
          ..add('unidadeBase', unidadeBase)
          ..add('categoriaId', categoriaId)
          ..add('pendencias', pendencias))
        .toString();
  }
}

class CadastroIncompletoBuilder implements Builder<CadastroIncompleto, CadastroIncompletoBuilder> {
  _$CadastroIncompleto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _descricao;
  String? get descricao => _$this._descricao;
  set descricao(String? descricao) => _$this._descricao = descricao;

  String? _unidadeBase;
  String? get unidadeBase => _$this._unidadeBase;
  set unidadeBase(String? unidadeBase) => _$this._unidadeBase = unidadeBase;

  String? _categoriaId;
  String? get categoriaId => _$this._categoriaId;
  set categoriaId(String? categoriaId) => _$this._categoriaId = categoriaId;

  ListBuilder<PendenciaEmbalagem>? _pendencias;
  ListBuilder<PendenciaEmbalagem> get pendencias => _$this._pendencias ??= ListBuilder<PendenciaEmbalagem>();
  set pendencias(ListBuilder<PendenciaEmbalagem>? pendencias) => _$this._pendencias = pendencias;

  CadastroIncompletoBuilder() {
    CadastroIncompleto._defaults(this);
  }

  CadastroIncompletoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _descricao = $v.descricao;
      _unidadeBase = $v.unidadeBase;
      _categoriaId = $v.categoriaId;
      _pendencias = $v.pendencias.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CadastroIncompleto other) {
    _$v = other as _$CadastroIncompleto;
  }

  @override
  void update(void Function(CadastroIncompletoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CadastroIncompleto build() => _build();

  _$CadastroIncompleto _build() {
    _$CadastroIncompleto _$result;
    try {
      _$result = _$v ??
          _$CadastroIncompleto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'CadastroIncompleto', 'id'),
            sku: BuiltValueNullFieldError.checkNotNull(sku, r'CadastroIncompleto', 'sku'),
            descricao: BuiltValueNullFieldError.checkNotNull(descricao, r'CadastroIncompleto', 'descricao'),
            unidadeBase: BuiltValueNullFieldError.checkNotNull(unidadeBase, r'CadastroIncompleto', 'unidadeBase'),
            categoriaId: categoriaId,
            pendencias: pendencias.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pendencias';
        pendencias.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'CadastroIncompleto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
