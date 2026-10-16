// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Rule {

 String get id; String get name; String? get description; bool get enabled; List<RuleCondition> get conditions; List<RuleAction> get actions; ConflictPolicy get conflictPolicy; int get processedCount; DateTime? get lastRunAt;/// When set, the rule only applies to files inside this watched folder.
/// `null` (default) means it applies to every watched folder.
 String? get scopeFolderPath; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Rule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleCopyWith<Rule> get copyWith => _$RuleCopyWithImpl<Rule>(this as Rule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Rule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&const DeepCollectionEquality().equals(other.conditions, _this.conditions)&&const DeepCollectionEquality().equals(other.actions, _this.actions)&&(identical(other.conflictPolicy, _this.conflictPolicy) || other.conflictPolicy == _this.conflictPolicy)&&(identical(other.processedCount, _this.processedCount) || other.processedCount == _this.processedCount)&&(identical(other.lastRunAt, _this.lastRunAt) || other.lastRunAt == _this.lastRunAt)&&(identical(other.scopeFolderPath, _this.scopeFolderPath) || other.scopeFolderPath == _this.scopeFolderPath)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Rule;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.enabled,const DeepCollectionEquality().hash(_this.conditions),const DeepCollectionEquality().hash(_this.actions),_this.conflictPolicy,_this.processedCount,_this.lastRunAt,_this.scopeFolderPath,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Rule;
  return 'Rule(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, enabled: ${_this.enabled}, conditions: ${_this.conditions}, actions: ${_this.actions}, conflictPolicy: ${_this.conflictPolicy}, processedCount: ${_this.processedCount}, lastRunAt: ${_this.lastRunAt}, scopeFolderPath: ${_this.scopeFolderPath}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RuleCopyWith<$Res>  {
  factory $RuleCopyWith(Rule value, $Res Function(Rule) _then) = _$RuleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, bool enabled, List<RuleCondition> conditions, List<RuleAction> actions, ConflictPolicy conflictPolicy, int processedCount, DateTime? lastRunAt, String? scopeFolderPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$RuleCopyWithImpl<$Res>
    implements $RuleCopyWith<$Res> {
  _$RuleCopyWithImpl(this._self, this._then);

  final Rule _self;
  final $Res Function(Rule) _then;

/// Create a copy of Rule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? enabled = null,Object? conditions = null,Object? actions = null,Object? conflictPolicy = null,Object? processedCount = null,Object? lastRunAt = freezed,Object? scopeFolderPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Rule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<RuleCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<RuleAction>,conflictPolicy: null == conflictPolicy ? _self.conflictPolicy : conflictPolicy // ignore: cast_nullable_to_non_nullable
as ConflictPolicy,processedCount: null == processedCount ? _self.processedCount : processedCount // ignore: cast_nullable_to_non_nullable
as int,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scopeFolderPath: freezed == scopeFolderPath ? _self.scopeFolderPath : scopeFolderPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Rule].
extension RulePatterns on Rule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rule value)  $default,){
final _that = this;
switch (_that) {
case _Rule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rule value)?  $default,){
final _that = this;
switch (_that) {
case _Rule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool enabled,  List<RuleCondition> conditions,  List<RuleAction> actions,  ConflictPolicy conflictPolicy,  int processedCount,  DateTime? lastRunAt,  String? scopeFolderPath,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rule() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.enabled,_that.conditions,_that.actions,_that.conflictPolicy,_that.processedCount,_that.lastRunAt,_that.scopeFolderPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  bool enabled,  List<RuleCondition> conditions,  List<RuleAction> actions,  ConflictPolicy conflictPolicy,  int processedCount,  DateTime? lastRunAt,  String? scopeFolderPath,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Rule():
return $default(_that.id,_that.name,_that.description,_that.enabled,_that.conditions,_that.actions,_that.conflictPolicy,_that.processedCount,_that.lastRunAt,_that.scopeFolderPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  bool enabled,  List<RuleCondition> conditions,  List<RuleAction> actions,  ConflictPolicy conflictPolicy,  int processedCount,  DateTime? lastRunAt,  String? scopeFolderPath,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Rule() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.enabled,_that.conditions,_that.actions,_that.conflictPolicy,_that.processedCount,_that.lastRunAt,_that.scopeFolderPath,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Rule extends Rule {
  const _Rule({required this.id, required this.name, this.description, this.enabled = true,  List<RuleCondition> conditions = const <RuleCondition>[],  List<RuleAction> actions = const <RuleAction>[], this.conflictPolicy = ConflictPolicy.askEveryTime, this.processedCount = 0, this.lastRunAt, this.scopeFolderPath, required this.createdAt, required this.updatedAt}): _conditions = conditions,_actions = actions,super._();
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  bool enabled;
 final  List<RuleCondition> _conditions;
@override@JsonKey() List<RuleCondition> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

 final  List<RuleAction> _actions;
@override@JsonKey() List<RuleAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override@JsonKey() final  ConflictPolicy conflictPolicy;
@override@JsonKey() final  int processedCount;
@override final  DateTime? lastRunAt;
/// When set, the rule only applies to files inside this watched folder.
/// `null` (default) means it applies to every watched folder.
@override final  String? scopeFolderPath;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Rule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleCopyWith<_Rule> get copyWith => __$RuleCopyWithImpl<_Rule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.conditions, _conditions)&&const DeepCollectionEquality().equals(other.actions, _actions)&&(identical(other.conflictPolicy, conflictPolicy) || other.conflictPolicy == conflictPolicy)&&(identical(other.processedCount, processedCount) || other.processedCount == processedCount)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.scopeFolderPath, scopeFolderPath) || other.scopeFolderPath == scopeFolderPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,enabled,const DeepCollectionEquality().hash(_conditions),const DeepCollectionEquality().hash(_actions),conflictPolicy,processedCount,lastRunAt,scopeFolderPath,createdAt,updatedAt);
}

@override
String toString() {
    return 'Rule(id: $id, name: $name, description: $description, enabled: $enabled, conditions: $conditions, actions: $actions, conflictPolicy: $conflictPolicy, processedCount: $processedCount, lastRunAt: $lastRunAt, scopeFolderPath: $scopeFolderPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RuleCopyWith<$Res> implements $RuleCopyWith<$Res> {
  factory _$RuleCopyWith(_Rule value, $Res Function(_Rule) _then) = __$RuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, bool enabled, List<RuleCondition> conditions, List<RuleAction> actions, ConflictPolicy conflictPolicy, int processedCount, DateTime? lastRunAt, String? scopeFolderPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$RuleCopyWithImpl<$Res>
    implements _$RuleCopyWith<$Res> {
  __$RuleCopyWithImpl(this._self, this._then);

  final _Rule _self;
  final $Res Function(_Rule) _then;

/// Create a copy of Rule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? enabled = null,Object? conditions = null,Object? actions = null,Object? conflictPolicy = null,Object? processedCount = null,Object? lastRunAt = freezed,Object? scopeFolderPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Rule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<RuleCondition>,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<RuleAction>,conflictPolicy: null == conflictPolicy ? _self.conflictPolicy : conflictPolicy // ignore: cast_nullable_to_non_nullable
as ConflictPolicy,processedCount: null == processedCount ? _self.processedCount : processedCount // ignore: cast_nullable_to_non_nullable
as int,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scopeFolderPath: freezed == scopeFolderPath ? _self.scopeFolderPath : scopeFolderPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
