// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'importar_produtos_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportarProdutosRequest extends ImportarProdutosRequest {
  @override
  final Uint8List? arquivo;

  factory _$ImportarProdutosRequest([void Function(ImportarProdutosRequestBuilder)? updates]) =>
      (ImportarProdutosRequestBuilder()..update(updates))._build();

  _$ImportarProdutosRequest._({this.arquivo}) : super._();
  @override
  ImportarProdutosRequest rebuild(void Function(ImportarProdutosRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImportarProdutosRequestBuilder toBuilder() => ImportarProdutosRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportarProdutosRequest && arquivo == other.arquivo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, arquivo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportarProdutosRequest')..add('arquivo', arquivo)).toString();
  }
}

class ImportarProdutosRequestBuilder implements Builder<ImportarProdutosRequest, ImportarProdutosRequestBuilder> {
  _$ImportarProdutosRequest? _$v;

  Uint8List? _arquivo;
  Uint8List? get arquivo => _$this._arquivo;
  set arquivo(Uint8List? arquivo) => _$this._arquivo = arquivo;

  ImportarProdutosRequestBuilder() {
    ImportarProdutosRequest._defaults(this);
  }

  ImportarProdutosRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _arquivo = $v.arquivo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportarProdutosRequest other) {
    _$v = other as _$ImportarProdutosRequest;
  }

  @override
  void update(void Function(ImportarProdutosRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportarProdutosRequest build() => _build();

  _$ImportarProdutosRequest _build() {
    final _$result = _$v ??
        _$ImportarProdutosRequest._(
          arquivo: arquivo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
