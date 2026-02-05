// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatState {
  Persona get activePersona => throw _privateConstructorUsedError;
  List<Persona> get availablePersonas => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String? get userIconAsset => throw _privateConstructorUsedError;
  ChatMessage? get replyingTo => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {Persona activePersona,
      List<Persona> availablePersonas,
      List<ChatMessage> messages,
      bool isLoading,
      ThemeMode themeMode,
      String language,
      String? userIconAsset,
      ChatMessage? replyingTo});

  $PersonaCopyWith<$Res> get activePersona;
  $ChatMessageCopyWith<$Res>? get replyingTo;
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activePersona = null,
    Object? availablePersonas = null,
    Object? messages = null,
    Object? isLoading = null,
    Object? themeMode = null,
    Object? language = null,
    Object? userIconAsset = freezed,
    Object? replyingTo = freezed,
  }) {
    return _then(_value.copyWith(
      activePersona: null == activePersona
          ? _value.activePersona
          : activePersona // ignore: cast_nullable_to_non_nullable
              as Persona,
      availablePersonas: null == availablePersonas
          ? _value.availablePersonas
          : availablePersonas // ignore: cast_nullable_to_non_nullable
              as List<Persona>,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      userIconAsset: freezed == userIconAsset
          ? _value.userIconAsset
          : userIconAsset // ignore: cast_nullable_to_non_nullable
              as String?,
      replyingTo: freezed == replyingTo
          ? _value.replyingTo
          : replyingTo // ignore: cast_nullable_to_non_nullable
              as ChatMessage?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PersonaCopyWith<$Res> get activePersona {
    return $PersonaCopyWith<$Res>(_value.activePersona, (value) {
      return _then(_value.copyWith(activePersona: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res>? get replyingTo {
    if (_value.replyingTo == null) {
      return null;
    }

    return $ChatMessageCopyWith<$Res>(_value.replyingTo!, (value) {
      return _then(_value.copyWith(replyingTo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatStateImplCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$ChatStateImplCopyWith(
          _$ChatStateImpl value, $Res Function(_$ChatStateImpl) then) =
      __$$ChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Persona activePersona,
      List<Persona> availablePersonas,
      List<ChatMessage> messages,
      bool isLoading,
      ThemeMode themeMode,
      String language,
      String? userIconAsset,
      ChatMessage? replyingTo});

  @override
  $PersonaCopyWith<$Res> get activePersona;
  @override
  $ChatMessageCopyWith<$Res>? get replyingTo;
}

/// @nodoc
class __$$ChatStateImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateImpl>
    implements _$$ChatStateImplCopyWith<$Res> {
  __$$ChatStateImplCopyWithImpl(
      _$ChatStateImpl _value, $Res Function(_$ChatStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activePersona = null,
    Object? availablePersonas = null,
    Object? messages = null,
    Object? isLoading = null,
    Object? themeMode = null,
    Object? language = null,
    Object? userIconAsset = freezed,
    Object? replyingTo = freezed,
  }) {
    return _then(_$ChatStateImpl(
      activePersona: null == activePersona
          ? _value.activePersona
          : activePersona // ignore: cast_nullable_to_non_nullable
              as Persona,
      availablePersonas: null == availablePersonas
          ? _value._availablePersonas
          : availablePersonas // ignore: cast_nullable_to_non_nullable
              as List<Persona>,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      userIconAsset: freezed == userIconAsset
          ? _value.userIconAsset
          : userIconAsset // ignore: cast_nullable_to_non_nullable
              as String?,
      replyingTo: freezed == replyingTo
          ? _value.replyingTo
          : replyingTo // ignore: cast_nullable_to_non_nullable
              as ChatMessage?,
    ));
  }
}

/// @nodoc

class _$ChatStateImpl implements _ChatState {
  const _$ChatStateImpl(
      {required this.activePersona,
      required final List<Persona> availablePersonas,
      required final List<ChatMessage> messages,
      required this.isLoading,
      this.themeMode = ThemeMode.light,
      this.language = 'English',
      this.userIconAsset,
      this.replyingTo})
      : _availablePersonas = availablePersonas,
        _messages = messages;

  @override
  final Persona activePersona;
  final List<Persona> _availablePersonas;
  @override
  List<Persona> get availablePersonas {
    if (_availablePersonas is EqualUnmodifiableListView)
      return _availablePersonas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availablePersonas);
  }

  final List<ChatMessage> _messages;
  @override
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final bool isLoading;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final String language;
  @override
  final String? userIconAsset;
  @override
  final ChatMessage? replyingTo;

  @override
  String toString() {
    return 'ChatState(activePersona: $activePersona, availablePersonas: $availablePersonas, messages: $messages, isLoading: $isLoading, themeMode: $themeMode, language: $language, userIconAsset: $userIconAsset, replyingTo: $replyingTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateImpl &&
            (identical(other.activePersona, activePersona) ||
                other.activePersona == activePersona) &&
            const DeepCollectionEquality()
                .equals(other._availablePersonas, _availablePersonas) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.userIconAsset, userIconAsset) ||
                other.userIconAsset == userIconAsset) &&
            (identical(other.replyingTo, replyingTo) ||
                other.replyingTo == replyingTo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      activePersona,
      const DeepCollectionEquality().hash(_availablePersonas),
      const DeepCollectionEquality().hash(_messages),
      isLoading,
      themeMode,
      language,
      userIconAsset,
      replyingTo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      __$$ChatStateImplCopyWithImpl<_$ChatStateImpl>(this, _$identity);
}

abstract class _ChatState implements ChatState {
  const factory _ChatState(
      {required final Persona activePersona,
      required final List<Persona> availablePersonas,
      required final List<ChatMessage> messages,
      required final bool isLoading,
      final ThemeMode themeMode,
      final String language,
      final String? userIconAsset,
      final ChatMessage? replyingTo}) = _$ChatStateImpl;

  @override
  Persona get activePersona;
  @override
  List<Persona> get availablePersonas;
  @override
  List<ChatMessage> get messages;
  @override
  bool get isLoading;
  @override
  ThemeMode get themeMode;
  @override
  String get language;
  @override
  String? get userIconAsset;
  @override
  ChatMessage? get replyingTo;
  @override
  @JsonKey(ignore: true)
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
