// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchedFolder {

 String get id; String get path; bool get enabled; DateTime get createdAt;
/// Create a copy of WatchedFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedFolderCopyWith<WatchedFolder> get copyWith => _$WatchedFolderCopyWithImpl<WatchedFolder>(this as WatchedFolder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchedFolder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedFolder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as WatchedFolder;
  return Object.hash(runtimeType,_this.id,_this.path,_this.enabled,_this.createdAt);
}

@override
String toString() {
  final _this = this as WatchedFolder;
  return 'WatchedFolder(id: ${_this.id}, path: ${_this.path}, enabled: ${_this.enabled}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $WatchedFolderCopyWith<$Res>  {
  factory $WatchedFolderCopyWith(WatchedFolder value, $Res Function(WatchedFolder) _then) = _$WatchedFolderCopyWithImpl;
@useResult
$Res call({
 String id, String path, bool enabled, DateTime createdAt
});




}
/// @nodoc
class _$WatchedFolderCopyWithImpl<$Res>
    implements $WatchedFolderCopyWith<$Res> {
  _$WatchedFolderCopyWithImpl(this._self, this._then);

  final WatchedFolder _self;
  final $Res Function(WatchedFolder) _then;

/// Create a copy of WatchedFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? enabled = null,Object? createdAt = null,}) {
  return _then(WatchedFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchedFolder].
extension WatchedFolderPatterns on WatchedFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchedFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchedFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchedFolder value)  $default,){
final _that = this;
switch (_that) {
case _WatchedFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchedFolder value)?  $default,){
final _that = this;
switch (_that) {
case _WatchedFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String path,  bool enabled,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchedFolder() when $default != null:
return $default(_that.id,_that.path,_that.enabled,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String path,  bool enabled,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WatchedFolder():
return $default(_that.id,_that.path,_that.enabled,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String path,  bool enabled,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchedFolder() when $default != null:
return $default(_that.id,_that.path,_that.enabled,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _WatchedFolder extends WatchedFolder {
  const _WatchedFolder({required this.id, required this.path, this.enabled = true, required this.createdAt}): super._();
  

@override final  String id;
@override final  String path;
@override@JsonKey() final  bool enabled;
@override final  DateTime createdAt;

/// Create a copy of WatchedFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchedFolderCopyWith<_WatchedFolder> get copyWith => __$WatchedFolderCopyWithImpl<_WatchedFolder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchedFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,path,enabled,createdAt);
}

@override
String toString() {
    return 'WatchedFolder(id: $id, path: $path, enabled: $enabled, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WatchedFolderCopyWith<$Res> implements $WatchedFolderCopyWith<$Res> {
  factory _$WatchedFolderCopyWith(_WatchedFolder value, $Res Function(_WatchedFolder) _then) = __$WatchedFolderCopyWithImpl;
@override @useResult
$Res call({
 String id, String path, bool enabled, DateTime createdAt
});




}
/// @nodoc
class __$WatchedFolderCopyWithImpl<$Res>
    implements _$WatchedFolderCopyWith<$Res> {
  __$WatchedFolderCopyWithImpl(this._self, this._then);

  final _WatchedFolder _self;
  final $Res Function(_WatchedFolder) _then;

/// Create a copy of WatchedFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? enabled = null,Object? createdAt = null,}) {
  return _then(_WatchedFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
