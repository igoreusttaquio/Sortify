// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 AppThemePreference get theme; String get languageCode; bool get startWithSystem; bool get startMinimized; bool get confirmFileOperations; int get scanIntervalSeconds; bool get watchSubfolders; bool get ignoreHiddenFiles; List<String> get ignoredExtensions; ConflictPolicy get defaultConflictPolicy; DeleteBehavior get deleteBehavior;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.startWithSystem, _this.startWithSystem) || other.startWithSystem == _this.startWithSystem)&&(identical(other.startMinimized, _this.startMinimized) || other.startMinimized == _this.startMinimized)&&(identical(other.confirmFileOperations, _this.confirmFileOperations) || other.confirmFileOperations == _this.confirmFileOperations)&&(identical(other.scanIntervalSeconds, _this.scanIntervalSeconds) || other.scanIntervalSeconds == _this.scanIntervalSeconds)&&(identical(other.watchSubfolders, _this.watchSubfolders) || other.watchSubfolders == _this.watchSubfolders)&&(identical(other.ignoreHiddenFiles, _this.ignoreHiddenFiles) || other.ignoreHiddenFiles == _this.ignoreHiddenFiles)&&const DeepCollectionEquality().equals(other.ignoredExtensions, _this.ignoredExtensions)&&(identical(other.defaultConflictPolicy, _this.defaultConflictPolicy) || other.defaultConflictPolicy == _this.defaultConflictPolicy)&&(identical(other.deleteBehavior, _this.deleteBehavior) || other.deleteBehavior == _this.deleteBehavior));
}


@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.theme,_this.languageCode,_this.startWithSystem,_this.startMinimized,_this.confirmFileOperations,_this.scanIntervalSeconds,_this.watchSubfolders,_this.ignoreHiddenFiles,const DeepCollectionEquality().hash(_this.ignoredExtensions),_this.defaultConflictPolicy,_this.deleteBehavior);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(theme: ${_this.theme}, languageCode: ${_this.languageCode}, startWithSystem: ${_this.startWithSystem}, startMinimized: ${_this.startMinimized}, confirmFileOperations: ${_this.confirmFileOperations}, scanIntervalSeconds: ${_this.scanIntervalSeconds}, watchSubfolders: ${_this.watchSubfolders}, ignoreHiddenFiles: ${_this.ignoreHiddenFiles}, ignoredExtensions: ${_this.ignoredExtensions}, defaultConflictPolicy: ${_this.defaultConflictPolicy}, deleteBehavior: ${_this.deleteBehavior})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 AppThemePreference theme, String languageCode, bool startWithSystem, bool startMinimized, bool confirmFileOperations, int scanIntervalSeconds, bool watchSubfolders, bool ignoreHiddenFiles, List<String> ignoredExtensions, ConflictPolicy defaultConflictPolicy, DeleteBehavior deleteBehavior
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? languageCode = null,Object? startWithSystem = null,Object? startMinimized = null,Object? confirmFileOperations = null,Object? scanIntervalSeconds = null,Object? watchSubfolders = null,Object? ignoreHiddenFiles = null,Object? ignoredExtensions = null,Object? defaultConflictPolicy = null,Object? deleteBehavior = null,}) {
  return _then(AppSettings(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemePreference,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,startWithSystem: null == startWithSystem ? _self.startWithSystem : startWithSystem // ignore: cast_nullable_to_non_nullable
as bool,startMinimized: null == startMinimized ? _self.startMinimized : startMinimized // ignore: cast_nullable_to_non_nullable
as bool,confirmFileOperations: null == confirmFileOperations ? _self.confirmFileOperations : confirmFileOperations // ignore: cast_nullable_to_non_nullable
as bool,scanIntervalSeconds: null == scanIntervalSeconds ? _self.scanIntervalSeconds : scanIntervalSeconds // ignore: cast_nullable_to_non_nullable
as int,watchSubfolders: null == watchSubfolders ? _self.watchSubfolders : watchSubfolders // ignore: cast_nullable_to_non_nullable
as bool,ignoreHiddenFiles: null == ignoreHiddenFiles ? _self.ignoreHiddenFiles : ignoreHiddenFiles // ignore: cast_nullable_to_non_nullable
as bool,ignoredExtensions: null == ignoredExtensions ? _self.ignoredExtensions : ignoredExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,defaultConflictPolicy: null == defaultConflictPolicy ? _self.defaultConflictPolicy : defaultConflictPolicy // ignore: cast_nullable_to_non_nullable
as ConflictPolicy,deleteBehavior: null == deleteBehavior ? _self.deleteBehavior : deleteBehavior // ignore: cast_nullable_to_non_nullable
as DeleteBehavior,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemePreference theme,  String languageCode,  bool startWithSystem,  bool startMinimized,  bool confirmFileOperations,  int scanIntervalSeconds,  bool watchSubfolders,  bool ignoreHiddenFiles,  List<String> ignoredExtensions,  ConflictPolicy defaultConflictPolicy,  DeleteBehavior deleteBehavior)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.theme,_that.languageCode,_that.startWithSystem,_that.startMinimized,_that.confirmFileOperations,_that.scanIntervalSeconds,_that.watchSubfolders,_that.ignoreHiddenFiles,_that.ignoredExtensions,_that.defaultConflictPolicy,_that.deleteBehavior);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemePreference theme,  String languageCode,  bool startWithSystem,  bool startMinimized,  bool confirmFileOperations,  int scanIntervalSeconds,  bool watchSubfolders,  bool ignoreHiddenFiles,  List<String> ignoredExtensions,  ConflictPolicy defaultConflictPolicy,  DeleteBehavior deleteBehavior)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.theme,_that.languageCode,_that.startWithSystem,_that.startMinimized,_that.confirmFileOperations,_that.scanIntervalSeconds,_that.watchSubfolders,_that.ignoreHiddenFiles,_that.ignoredExtensions,_that.defaultConflictPolicy,_that.deleteBehavior);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemePreference theme,  String languageCode,  bool startWithSystem,  bool startMinimized,  bool confirmFileOperations,  int scanIntervalSeconds,  bool watchSubfolders,  bool ignoreHiddenFiles,  List<String> ignoredExtensions,  ConflictPolicy defaultConflictPolicy,  DeleteBehavior deleteBehavior)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.theme,_that.languageCode,_that.startWithSystem,_that.startMinimized,_that.confirmFileOperations,_that.scanIntervalSeconds,_that.watchSubfolders,_that.ignoreHiddenFiles,_that.ignoredExtensions,_that.defaultConflictPolicy,_that.deleteBehavior);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.theme = AppThemePreference.dark, this.languageCode = 'en', this.startWithSystem = false, this.startMinimized = false, this.confirmFileOperations = true, this.scanIntervalSeconds = 5, this.watchSubfolders = true, this.ignoreHiddenFiles = true,  List<String> ignoredExtensions = const <String>[], this.defaultConflictPolicy = ConflictPolicy.askEveryTime, this.deleteBehavior = DeleteBehavior.permanent}): _ignoredExtensions = ignoredExtensions;
  

@override@JsonKey() final  AppThemePreference theme;
@override@JsonKey() final  String languageCode;
@override@JsonKey() final  bool startWithSystem;
@override@JsonKey() final  bool startMinimized;
@override@JsonKey() final  bool confirmFileOperations;
@override@JsonKey() final  int scanIntervalSeconds;
@override@JsonKey() final  bool watchSubfolders;
@override@JsonKey() final  bool ignoreHiddenFiles;
 final  List<String> _ignoredExtensions;
@override@JsonKey() List<String> get ignoredExtensions {
  if (_ignoredExtensions is EqualUnmodifiableListView) return _ignoredExtensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ignoredExtensions);
}

@override@JsonKey() final  ConflictPolicy defaultConflictPolicy;
@override@JsonKey() final  DeleteBehavior deleteBehavior;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.startWithSystem, startWithSystem) || other.startWithSystem == startWithSystem)&&(identical(other.startMinimized, startMinimized) || other.startMinimized == startMinimized)&&(identical(other.confirmFileOperations, confirmFileOperations) || other.confirmFileOperations == confirmFileOperations)&&(identical(other.scanIntervalSeconds, scanIntervalSeconds) || other.scanIntervalSeconds == scanIntervalSeconds)&&(identical(other.watchSubfolders, watchSubfolders) || other.watchSubfolders == watchSubfolders)&&(identical(other.ignoreHiddenFiles, ignoreHiddenFiles) || other.ignoreHiddenFiles == ignoreHiddenFiles)&&const DeepCollectionEquality().equals(other.ignoredExtensions, _ignoredExtensions)&&(identical(other.defaultConflictPolicy, defaultConflictPolicy) || other.defaultConflictPolicy == defaultConflictPolicy)&&(identical(other.deleteBehavior, deleteBehavior) || other.deleteBehavior == deleteBehavior));
}


@override
int get hashCode {
    return Object.hash(runtimeType,theme,languageCode,startWithSystem,startMinimized,confirmFileOperations,scanIntervalSeconds,watchSubfolders,ignoreHiddenFiles,const DeepCollectionEquality().hash(_ignoredExtensions),defaultConflictPolicy,deleteBehavior);
}

@override
String toString() {
    return 'AppSettings(theme: $theme, languageCode: $languageCode, startWithSystem: $startWithSystem, startMinimized: $startMinimized, confirmFileOperations: $confirmFileOperations, scanIntervalSeconds: $scanIntervalSeconds, watchSubfolders: $watchSubfolders, ignoreHiddenFiles: $ignoreHiddenFiles, ignoredExtensions: $ignoredExtensions, defaultConflictPolicy: $defaultConflictPolicy, deleteBehavior: $deleteBehavior)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 AppThemePreference theme, String languageCode, bool startWithSystem, bool startMinimized, bool confirmFileOperations, int scanIntervalSeconds, bool watchSubfolders, bool ignoreHiddenFiles, List<String> ignoredExtensions, ConflictPolicy defaultConflictPolicy, DeleteBehavior deleteBehavior
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? languageCode = null,Object? startWithSystem = null,Object? startMinimized = null,Object? confirmFileOperations = null,Object? scanIntervalSeconds = null,Object? watchSubfolders = null,Object? ignoreHiddenFiles = null,Object? ignoredExtensions = null,Object? defaultConflictPolicy = null,Object? deleteBehavior = null,}) {
  return _then(_AppSettings(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemePreference,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,startWithSystem: null == startWithSystem ? _self.startWithSystem : startWithSystem // ignore: cast_nullable_to_non_nullable
as bool,startMinimized: null == startMinimized ? _self.startMinimized : startMinimized // ignore: cast_nullable_to_non_nullable
as bool,confirmFileOperations: null == confirmFileOperations ? _self.confirmFileOperations : confirmFileOperations // ignore: cast_nullable_to_non_nullable
as bool,scanIntervalSeconds: null == scanIntervalSeconds ? _self.scanIntervalSeconds : scanIntervalSeconds // ignore: cast_nullable_to_non_nullable
as int,watchSubfolders: null == watchSubfolders ? _self.watchSubfolders : watchSubfolders // ignore: cast_nullable_to_non_nullable
as bool,ignoreHiddenFiles: null == ignoreHiddenFiles ? _self.ignoreHiddenFiles : ignoreHiddenFiles // ignore: cast_nullable_to_non_nullable
as bool,ignoredExtensions: null == ignoredExtensions ? _self._ignoredExtensions : ignoredExtensions // ignore: cast_nullable_to_non_nullable
as List<String>,defaultConflictPolicy: null == defaultConflictPolicy ? _self.defaultConflictPolicy : defaultConflictPolicy // ignore: cast_nullable_to_non_nullable
as ConflictPolicy,deleteBehavior: null == deleteBehavior ? _self.deleteBehavior : deleteBehavior // ignore: cast_nullable_to_non_nullable
as DeleteBehavior,
  ));
}


}

// dart format on
