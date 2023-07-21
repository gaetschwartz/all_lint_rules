// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Diff _$DiffFromJson(Map<String, dynamic> json) {
  return _Diff.fromJson(json);
}

/// @nodoc
mixin _$Diff {
  List<String> get oldRules => throw _privateConstructorUsedError;
  List<String> get newRules => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiffCopyWith<Diff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiffCopyWith<$Res> {
  factory $DiffCopyWith(Diff value, $Res Function(Diff) then) =
      _$DiffCopyWithImpl<$Res, Diff>;
  @useResult
  $Res call({List<String> oldRules, List<String> newRules});
}

/// @nodoc
class _$DiffCopyWithImpl<$Res, $Val extends Diff>
    implements $DiffCopyWith<$Res> {
  _$DiffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldRules = null,
    Object? newRules = null,
  }) {
    return _then(_value.copyWith(
      oldRules: null == oldRules
          ? _value.oldRules
          : oldRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      newRules: null == newRules
          ? _value.newRules
          : newRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DiffCopyWith<$Res> implements $DiffCopyWith<$Res> {
  factory _$$_DiffCopyWith(_$_Diff value, $Res Function(_$_Diff) then) =
      __$$_DiffCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> oldRules, List<String> newRules});
}

/// @nodoc
class __$$_DiffCopyWithImpl<$Res> extends _$DiffCopyWithImpl<$Res, _$_Diff>
    implements _$$_DiffCopyWith<$Res> {
  __$$_DiffCopyWithImpl(_$_Diff _value, $Res Function(_$_Diff) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldRules = null,
    Object? newRules = null,
  }) {
    return _then(_$_Diff(
      null == oldRules
          ? _value._oldRules
          : oldRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      null == newRules
          ? _value._newRules
          : newRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Diff extends _Diff {
  const _$_Diff(final List<String> oldRules, final List<String> newRules)
      : _oldRules = oldRules,
        _newRules = newRules,
        super._();

  factory _$_Diff.fromJson(Map<String, dynamic> json) => _$$_DiffFromJson(json);

  final List<String> _oldRules;
  @override
  List<String> get oldRules {
    if (_oldRules is EqualUnmodifiableListView) return _oldRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_oldRules);
  }

  final List<String> _newRules;
  @override
  List<String> get newRules {
    if (_newRules is EqualUnmodifiableListView) return _newRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newRules);
  }

  @override
  String toString() {
    return 'Diff(oldRules: $oldRules, newRules: $newRules)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Diff &&
            const DeepCollectionEquality().equals(other._oldRules, _oldRules) &&
            const DeepCollectionEquality().equals(other._newRules, _newRules));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_oldRules),
      const DeepCollectionEquality().hash(_newRules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiffCopyWith<_$_Diff> get copyWith =>
      __$$_DiffCopyWithImpl<_$_Diff>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DiffToJson(
      this,
    );
  }
}

abstract class _Diff extends Diff {
  const factory _Diff(
      final List<String> oldRules, final List<String> newRules) = _$_Diff;
  const _Diff._() : super._();

  factory _Diff.fromJson(Map<String, dynamic> json) = _$_Diff.fromJson;

  @override
  List<String> get oldRules;
  @override
  List<String> get newRules;
  @override
  @JsonKey(ignore: true)
  _$$_DiffCopyWith<_$_Diff> get copyWith => throw _privateConstructorUsedError;
}

RulesDiff _$RulesDiffFromJson(Map<String, dynamic> json) {
  return _RulesDiff.fromJson(json);
}

/// @nodoc
mixin _$RulesDiff {
  List<String> get addedRules => throw _privateConstructorUsedError;
  List<String> get removedRules => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RulesDiffCopyWith<RulesDiff> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RulesDiffCopyWith<$Res> {
  factory $RulesDiffCopyWith(RulesDiff value, $Res Function(RulesDiff) then) =
      _$RulesDiffCopyWithImpl<$Res, RulesDiff>;
  @useResult
  $Res call({List<String> addedRules, List<String> removedRules});
}

/// @nodoc
class _$RulesDiffCopyWithImpl<$Res, $Val extends RulesDiff>
    implements $RulesDiffCopyWith<$Res> {
  _$RulesDiffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addedRules = null,
    Object? removedRules = null,
  }) {
    return _then(_value.copyWith(
      addedRules: null == addedRules
          ? _value.addedRules
          : addedRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedRules: null == removedRules
          ? _value.removedRules
          : removedRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RulesDiffCopyWith<$Res> implements $RulesDiffCopyWith<$Res> {
  factory _$$_RulesDiffCopyWith(
          _$_RulesDiff value, $Res Function(_$_RulesDiff) then) =
      __$$_RulesDiffCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> addedRules, List<String> removedRules});
}

/// @nodoc
class __$$_RulesDiffCopyWithImpl<$Res>
    extends _$RulesDiffCopyWithImpl<$Res, _$_RulesDiff>
    implements _$$_RulesDiffCopyWith<$Res> {
  __$$_RulesDiffCopyWithImpl(
      _$_RulesDiff _value, $Res Function(_$_RulesDiff) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addedRules = null,
    Object? removedRules = null,
  }) {
    return _then(_$_RulesDiff(
      addedRules: null == addedRules
          ? _value._addedRules
          : addedRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedRules: null == removedRules
          ? _value._removedRules
          : removedRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RulesDiff implements _RulesDiff {
  const _$_RulesDiff(
      {required final List<String> addedRules,
      required final List<String> removedRules})
      : _addedRules = addedRules,
        _removedRules = removedRules;

  factory _$_RulesDiff.fromJson(Map<String, dynamic> json) =>
      _$$_RulesDiffFromJson(json);

  final List<String> _addedRules;
  @override
  List<String> get addedRules {
    if (_addedRules is EqualUnmodifiableListView) return _addedRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addedRules);
  }

  final List<String> _removedRules;
  @override
  List<String> get removedRules {
    if (_removedRules is EqualUnmodifiableListView) return _removedRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedRules);
  }

  @override
  String toString() {
    return 'RulesDiff(addedRules: $addedRules, removedRules: $removedRules)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RulesDiff &&
            const DeepCollectionEquality()
                .equals(other._addedRules, _addedRules) &&
            const DeepCollectionEquality()
                .equals(other._removedRules, _removedRules));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_addedRules),
      const DeepCollectionEquality().hash(_removedRules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RulesDiffCopyWith<_$_RulesDiff> get copyWith =>
      __$$_RulesDiffCopyWithImpl<_$_RulesDiff>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RulesDiffToJson(
      this,
    );
  }
}

abstract class _RulesDiff implements RulesDiff {
  const factory _RulesDiff(
      {required final List<String> addedRules,
      required final List<String> removedRules}) = _$_RulesDiff;

  factory _RulesDiff.fromJson(Map<String, dynamic> json) =
      _$_RulesDiff.fromJson;

  @override
  List<String> get addedRules;
  @override
  List<String> get removedRules;
  @override
  @JsonKey(ignore: true)
  _$$_RulesDiffCopyWith<_$_RulesDiff> get copyWith =>
      throw _privateConstructorUsedError;
}
