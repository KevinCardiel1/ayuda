// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occasion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Occasion _$OccasionFromJson(Map<String, dynamic> json) {
  return _Occasion.fromJson(json);
}

/// @nodoc
mixin _$Occasion {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  List<String> get applicableCategories => throw _privateConstructorUsedError;

  /// Serializes this Occasion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Occasion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccasionCopyWith<Occasion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccasionCopyWith<$Res> {
  factory $OccasionCopyWith(Occasion value, $Res Function(Occasion) then) =
      _$OccasionCopyWithImpl<$Res, Occasion>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String imageUrl,
      List<String> applicableCategories});
}

/// @nodoc
class _$OccasionCopyWithImpl<$Res, $Val extends Occasion>
    implements $OccasionCopyWith<$Res> {
  _$OccasionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Occasion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? applicableCategories = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      applicableCategories: null == applicableCategories
          ? _value.applicableCategories
          : applicableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OccasionImplCopyWith<$Res>
    implements $OccasionCopyWith<$Res> {
  factory _$$OccasionImplCopyWith(
          _$OccasionImpl value, $Res Function(_$OccasionImpl) then) =
      __$$OccasionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String imageUrl,
      List<String> applicableCategories});
}

/// @nodoc
class __$$OccasionImplCopyWithImpl<$Res>
    extends _$OccasionCopyWithImpl<$Res, _$OccasionImpl>
    implements _$$OccasionImplCopyWith<$Res> {
  __$$OccasionImplCopyWithImpl(
      _$OccasionImpl _value, $Res Function(_$OccasionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Occasion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? applicableCategories = null,
  }) {
    return _then(_$OccasionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      applicableCategories: null == applicableCategories
          ? _value._applicableCategories
          : applicableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OccasionImpl extends _Occasion {
  const _$OccasionImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      final List<String> applicableCategories = const []})
      : _applicableCategories = applicableCategories,
        super._();

  factory _$OccasionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccasionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String imageUrl;
  final List<String> _applicableCategories;
  @override
  @JsonKey()
  List<String> get applicableCategories {
    if (_applicableCategories is EqualUnmodifiableListView)
      return _applicableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableCategories);
  }

  @override
  String toString() {
    return 'Occasion(id: $id, name: $name, description: $description, imageUrl: $imageUrl, applicableCategories: $applicableCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccasionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._applicableCategories, _applicableCategories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, imageUrl,
      const DeepCollectionEquality().hash(_applicableCategories));

  /// Create a copy of Occasion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccasionImplCopyWith<_$OccasionImpl> get copyWith =>
      __$$OccasionImplCopyWithImpl<_$OccasionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccasionImplToJson(
      this,
    );
  }
}

abstract class _Occasion extends Occasion {
  const factory _Occasion(
      {required final String id,
      required final String name,
      required final String description,
      required final String imageUrl,
      final List<String> applicableCategories}) = _$OccasionImpl;
  const _Occasion._() : super._();

  factory _Occasion.fromJson(Map<String, dynamic> json) =
      _$OccasionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  List<String> get applicableCategories;

  /// Create a copy of Occasion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccasionImplCopyWith<_$OccasionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
