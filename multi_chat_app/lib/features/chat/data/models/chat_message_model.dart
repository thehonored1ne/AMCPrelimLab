import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  @HiveType(typeId: 1, adapterName: 'ChatMessageAdapter')
  const factory ChatMessage({
    @HiveField(0) required String id,
    @HiveField(1) required String text,
    @HiveField(2) required bool isUser,
    @HiveField(3) required DateTime timestamp,
    @HiveField(4) @Default([]) List<String> imagePaths,
    @HiveField(5) String? replyToId,
    @HiveField(6) String? replyToText,
    @HiveField(7) @Default([]) List<String> reactions,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
