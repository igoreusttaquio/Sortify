// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RuleAction {

 String get id; ActionType get type; String get value; int get ordinal;
/// Create a copy of RuleAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleActionCopyWith<RuleAction> get copyWith => _$RuleActionCopyWithImpl<RuleAction>(this as RuleAction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RuleAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleAction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.ordinal, _this.ordinal) || other.ordinal == _this.ordinal));
}


@override
int get hashCode {
  final _this = this as RuleAction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.value,_this.ordinal);
}

@override
String toString() {
  final _this = this as RuleAction;
  return 'RuleAction(id: ${_this.id}, type: ${_this.type}, value: ${_this.value}, ordinal: ${_this.ordinal})';
}


}

/// @nodoc
abstract mixin class $RuleActionCopyWith<$Res>  {
  factory $RuleActionCopyWith(RuleAction value, $Res Function(RuleAction) _then) = _$RuleActionCopyWithImpl;
@useResult
$Res call({
 String id, ActionType type, String value, int ordinal
});




}
/// @nodoc
class _$RuleActionCopyWithImpl<$Res>
    implements $RuleActionCopyWith<$Res> {
  _$RuleActionCopyWithImpl(this._self, this._then);

  final RuleAction _self;
  final $Res Function(RuleAction) _then;

/// Create a copy of RuleAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? value = null,Object? ordinal = null,}) {
  return _then(RuleAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,ordinal: null == ordinal ? _self.ordinal : ordinal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleAction].
extension RuleActionPatterns on RuleAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleAction value)  $default,){
final _that = this;
switch (_that) {
case _RuleAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleAction value)?  $default,){
final _that = this;
switch (_that) {
case _RuleAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ActionType type,  String value,  int ordinal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleAction() when $default != null:
return $default(_that.id,_that.type,_that.value,_that.ordinal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ActionType type,  String value,  int ordinal)  $default,) {final _that = this;
switch (_that) {
case _RuleAction():
return $default(_that.id,_that.type,_that.value,_that.ordinal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ActionType type,  String value,  int ordinal)?  $default,) {final _that = this;
switch (_that) {
case _RuleAction() when $default != null:
return $default(_that.id,_that.type,_that.value,_that.ordinal);case _:
  return null;

}
}

}

/// @nodoc


class _RuleAction implements RuleAction {
  const _RuleAction({required this.id, required this.type, required this.value, this.ordinal = 0});
  

@override final  String id;
@override final  ActionType type;
@override final  String value;
@override@JsonKey() final  int ordinal;

/// Create a copy of RuleAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleActionCopyWith<_RuleAction> get copyWith => __$RuleActionCopyWithImpl<_RuleAction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleAction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.ordinal, ordinal) || other.ordinal == ordinal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,value,ordinal);
}

@override
String toString() {
    return 'RuleAction(id: $id, type: $type, value: $value, ordinal: $ordinal)';
}


}

/// @nodoc
abstract mixin class _$RuleActionCopyWith<$Res> implements $RuleActionCopyWith<$Res> {
  factory _$RuleActionCopyWith(_RuleAction value, $Res Function(_RuleAction) _then) = __$RuleActionCopyWithImpl;
@override @useResult
$Res call({
 String id, ActionType type, String value, int ordinal
});




}
/// @nodoc
class __$RuleActionCopyWithImpl<$Res>
    implements _$RuleActionCopyWith<$Res> {
  __$RuleActionCopyWithImpl(this._self, this._then);

  final _RuleAction _self;
  final $Res Function(_RuleAction) _then;

/// Create a copy of RuleAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? value = null,Object? ordinal = null,}) {
  return _then(_RuleAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,ordinal: null == ordinal ? _self.ordinal : ordinal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
