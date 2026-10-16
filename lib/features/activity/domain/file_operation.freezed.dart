// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileOperation {

 String get id; String? get ruleId; String? get ruleName; String get fileName; String get source; String? get destination; OperationKind get operation; OperationStatus get status; String? get error; DateTime get createdAt;
/// Create a copy of FileOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileOperationCopyWith<FileOperation> get copyWith => _$FileOperationCopyWithImpl<FileOperation>(this as FileOperation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FileOperation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileOperation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ruleId, _this.ruleId) || other.ruleId == _this.ruleId)&&(identical(other.ruleName, _this.ruleName) || other.ruleName == _this.ruleName)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.operation, _this.operation) || other.operation == _this.operation)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as FileOperation;
  return Object.hash(runtimeType,_this.id,_this.ruleId,_this.ruleName,_this.fileName,_this.source,_this.destination,_this.operation,_this.status,_this.error,_this.createdAt);
}

@override
String toString() {
  final _this = this as FileOperation;
  return 'FileOperation(id: ${_this.id}, ruleId: ${_this.ruleId}, ruleName: ${_this.ruleName}, fileName: ${_this.fileName}, source: ${_this.source}, destination: ${_this.destination}, operation: ${_this.operation}, status: ${_this.status}, error: ${_this.error}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $FileOperationCopyWith<$Res>  {
  factory $FileOperationCopyWith(FileOperation value, $Res Function(FileOperation) _then) = _$FileOperationCopyWithImpl;
@useResult
$Res call({
 String id, String? ruleId, String? ruleName, String fileName, String source, String? destination, OperationKind operation, OperationStatus status, String? error, DateTime createdAt
});




}
/// @nodoc
class _$FileOperationCopyWithImpl<$Res>
    implements $FileOperationCopyWith<$Res> {
  _$FileOperationCopyWithImpl(this._self, this._then);

  final FileOperation _self;
  final $Res Function(FileOperation) _then;

/// Create a copy of FileOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ruleId = freezed,Object? ruleName = freezed,Object? fileName = null,Object? source = null,Object? destination = freezed,Object? operation = null,Object? status = null,Object? error = freezed,Object? createdAt = null,}) {
  return _then(FileOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ruleId: freezed == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String?,ruleName: freezed == ruleName ? _self.ruleName : ruleName // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as OperationKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OperationStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FileOperation].
extension FileOperationPatterns on FileOperation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileOperation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileOperation value)  $default,){
final _that = this;
switch (_that) {
case _FileOperation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileOperation value)?  $default,){
final _that = this;
switch (_that) {
case _FileOperation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? ruleId,  String? ruleName,  String fileName,  String source,  String? destination,  OperationKind operation,  OperationStatus status,  String? error,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileOperation() when $default != null:
return $default(_that.id,_that.ruleId,_that.ruleName,_that.fileName,_that.source,_that.destination,_that.operation,_that.status,_that.error,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? ruleId,  String? ruleName,  String fileName,  String source,  String? destination,  OperationKind operation,  OperationStatus status,  String? error,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FileOperation():
return $default(_that.id,_that.ruleId,_that.ruleName,_that.fileName,_that.source,_that.destination,_that.operation,_that.status,_that.error,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? ruleId,  String? ruleName,  String fileName,  String source,  String? destination,  OperationKind operation,  OperationStatus status,  String? error,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FileOperation() when $default != null:
return $default(_that.id,_that.ruleId,_that.ruleName,_that.fileName,_that.source,_that.destination,_that.operation,_that.status,_that.error,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FileOperation extends FileOperation {
  const _FileOperation({required this.id, this.ruleId, this.ruleName, required this.fileName, required this.source, this.destination, required this.operation, required this.status, this.error, required this.createdAt}): super._();
  

@override final  String id;
@override final  String? ruleId;
@override final  String? ruleName;
@override final  String fileName;
@override final  String source;
@override final  String? destination;
@override final  OperationKind operation;
@override final  OperationStatus status;
@override final  String? error;
@override final  DateTime createdAt;

/// Create a copy of FileOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileOperationCopyWith<_FileOperation> get copyWith => __$FileOperationCopyWithImpl<_FileOperation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.ruleName, ruleName) || other.ruleName == ruleName)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.source, source) || other.source == source)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,ruleId,ruleName,fileName,source,destination,operation,status,error,createdAt);
}

@override
String toString() {
    return 'FileOperation(id: $id, ruleId: $ruleId, ruleName: $ruleName, fileName: $fileName, source: $source, destination: $destination, operation: $operation, status: $status, error: $error, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FileOperationCopyWith<$Res> implements $FileOperationCopyWith<$Res> {
  factory _$FileOperationCopyWith(_FileOperation value, $Res Function(_FileOperation) _then) = __$FileOperationCopyWithImpl;
@override @useResult
$Res call({
 String id, String? ruleId, String? ruleName, String fileName, String source, String? destination, OperationKind operation, OperationStatus status, String? error, DateTime createdAt
});




}
/// @nodoc
class __$FileOperationCopyWithImpl<$Res>
    implements _$FileOperationCopyWith<$Res> {
  __$FileOperationCopyWithImpl(this._self, this._then);

  final _FileOperation _self;
  final $Res Function(_FileOperation) _then;

/// Create a copy of FileOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ruleId = freezed,Object? ruleName = freezed,Object? fileName = null,Object? source = null,Object? destination = freezed,Object? operation = null,Object? status = null,Object? error = freezed,Object? createdAt = null,}) {
  return _then(_FileOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ruleId: freezed == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String?,ruleName: freezed == ruleName ? _self.ruleName : ruleName // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as OperationKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OperationStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
