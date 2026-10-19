// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_validation_problem_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HttpValidationProblemDetails extends HttpValidationProblemDetails {
  @override
  final String? type;
  @override
  final String? title;
  @override
  final int? status;
  @override
  final String? detail;
  @override
  final String? instance;
  @override
  final BuiltMap<String, BuiltList<String>>? errors;

  factory _$HttpValidationProblemDetails([void Function(HttpValidationProblemDetailsBuilder)? updates]) =>
      (HttpValidationProblemDetailsBuilder()..update(updates))._build();

  _$HttpValidationProblemDetails._({this.type, this.title, this.status, this.detail, this.instance, this.errors})
      : super._();
  @override
  HttpValidationProblemDetails rebuild(void Function(HttpValidationProblemDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HttpValidationProblemDetailsBuilder toBuilder() => HttpValidationProblemDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HttpValidationProblemDetails &&
        type == other.type &&
        title == other.title &&
        status == other.status &&
        detail == other.detail &&
        instance == other.instance &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jc(_$hash, instance.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HttpValidationProblemDetails')
          ..add('type', type)
          ..add('title', title)
          ..add('status', status)
          ..add('detail', detail)
          ..add('instance', instance)
          ..add('errors', errors))
        .toString();
  }
}

class HttpValidationProblemDetailsBuilder
    implements Builder<HttpValidationProblemDetails, HttpValidationProblemDetailsBuilder> {
  _$HttpValidationProblemDetails? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  String? _instance;
  String? get instance => _$this._instance;
  set instance(String? instance) => _$this._instance = instance;

  MapBuilder<String, BuiltList<String>>? _errors;
  MapBuilder<String, BuiltList<String>> get errors => _$this._errors ??= MapBuilder<String, BuiltList<String>>();
  set errors(MapBuilder<String, BuiltList<String>>? errors) => _$this._errors = errors;

  HttpValidationProblemDetailsBuilder() {
    HttpValidationProblemDetails._defaults(this);
  }

  HttpValidationProblemDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _title = $v.title;
      _status = $v.status;
      _detail = $v.detail;
      _instance = $v.instance;
      _errors = $v.errors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HttpValidationProblemDetails other) {
    _$v = other as _$HttpValidationProblemDetails;
  }

  @override
  void update(void Function(HttpValidationProblemDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HttpValidationProblemDetails build() => _build();

  _$HttpValidationProblemDetails _build() {
    _$HttpValidationProblemDetails _$result;
    try {
      _$result = _$v ??
          _$HttpValidationProblemDetails._(
            type: type,
            title: title,
            status: status,
            detail: detail,
            instance: instance,
            errors: _errors?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errors';
        _errors?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'HttpValidationProblemDetails', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
