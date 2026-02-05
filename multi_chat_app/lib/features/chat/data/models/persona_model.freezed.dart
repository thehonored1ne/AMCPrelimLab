// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persona_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Persona _$PersonaFromJson(Map<String, dynamic> json) {
  return _Persona.fromJson(json);
}

/// @nodoc
mixin _$Persona {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get systemInstruction => throw _privateConstructorUsedError;
  @HiveField(3)
  String get tone => throw _privateConstructorUsedError;
  @HiveField(4)
  int get colorValue => throw _privateConstructorUsedError;
  @HiveField(5)
  String get iconAsset =>
      throw _privateConstructorUsedError; // Keeping for backward compat, but we'll use iconCode
  @HiveField(6)
  int get iconCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PersonaCopyWith<Persona> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaCopyWith<$Res> {
  factory $PersonaCopyWith(Persona value, $Res Function(Persona) then) =
      _$PersonaCopyWithImpl<$Res, Persona>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String systemInstruction,
      @HiveField(3) String tone,
      @HiveField(4) int colorValue,
      @HiveField(5) String iconAsset,
      @HiveField(6) int iconCode});
}

/// @nodoc
class _$PersonaCopyWithImpl<$Res, $Val extends Persona>
    implements $PersonaCopyWith<$Res> {
  _$PersonaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemInstruction = null,
    Object? tone = null,
    Object? colorValue = null,
    Object? iconAsset = null,
    Object? iconCode = null,
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
      systemInstruction: null == systemInstruction
          ? _value.systemInstruction
          : systemInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _value.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaImplCopyWith<$Res> implements $PersonaCopyWith<$Res> {
  factory _$$PersonaImplCopyWith(
          _$PersonaImpl value, $Res Function(_$PersonaImpl) then) =
      __$$PersonaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String systemInstruction,
      @HiveField(3) String tone,
      @HiveField(4) int colorValue,
      @HiveField(5) String iconAsset,
      @HiveField(6) int iconCode});
}

/// @nodoc
class __$$PersonaImplCopyWithImpl<$Res>
    extends _$PersonaCopyWithImpl<$Res, _$PersonaImpl>
    implements _$$PersonaImplCopyWith<$Res> {
  __$$PersonaImplCopyWithImpl(
      _$PersonaImpl _value, $Res Function(_$PersonaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemInstruction = null,
    Object? tone = null,
    Object? colorValue = null,
    Object? iconAsset = null,
    Object? iconCode = null,
  }) {
    return _then(_$PersonaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemInstruction: null == systemInstruction
          ? _value.systemInstruction
          : systemInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _value.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'PersonaAdapter')
class _$PersonaImpl extends _Persona {
  const _$PersonaImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.systemInstruction,
      @HiveField(3) required this.tone,
      @HiveField(4) required this.colorValue,
      @HiveField(5) required this.iconAsset,
      @HiveField(6) this.iconCode = 57941})
      : super._();

  factory _$PersonaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String systemInstruction;
  @override
  @HiveField(3)
  final String tone;
  @override
  @HiveField(4)
  final int colorValue;
  @override
  @HiveField(5)
  final String iconAsset;
// Keeping for backward compat, but we'll use iconCode
  @override
  @JsonKey()
  @HiveField(6)
  final int iconCode;

  @override
  String toString() {
    return 'Persona(id: $id, name: $name, systemInstruction: $systemInstruction, tone: $tone, colorValue: $colorValue, iconAsset: $iconAsset, iconCode: $iconCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemInstruction, systemInstruction) ||
                other.systemInstruction == systemInstruction) &&
            (identical(other.tone, tone) || other.tone == tone) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, systemInstruction,
      tone, colorValue, iconAsset, iconCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      __$$PersonaImplCopyWithImpl<_$PersonaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaImplToJson(
      this,
    );
  }
}

abstract class _Persona extends Persona {
  const factory _Persona(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String systemInstruction,
      @HiveField(3) required final String tone,
      @HiveField(4) required final int colorValue,
      @HiveField(5) required final String iconAsset,
      @HiveField(6) final int iconCode}) = _$PersonaImpl;
  const _Persona._() : super._();

  factory _Persona.fromJson(Map<String, dynamic> json) = _$PersonaImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get systemInstruction;
  @override
  @HiveField(3)
  String get tone;
  @override
  @HiveField(4)
  int get colorValue;
  @override
  @HiveField(5)
  String get iconAsset;
  @override // Keeping for backward compat, but we'll use iconCode
  @HiveField(6)
  int get iconCode;
  @override
  @JsonKey(ignore: true)
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
