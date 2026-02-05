// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<_$ChatMessageImpl> {
  @override
  final int typeId = 1;

  @override
  _$ChatMessageImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$ChatMessageImpl(
      id: fields[0] as String,
      text: fields[1] as String,
      isUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      imagePaths: (fields[4] as List).cast<String>(),
      replyToId: fields[5] as String?,
      replyToText: fields[6] as String?,
      reactions: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$ChatMessageImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.replyToId)
      ..writeByte(6)
      ..write(obj.replyToText)
      ..writeByte(4)
      ..write(obj.imagePaths)
      ..writeByte(7)
      ..write(obj.reactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePaths: (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      replyToId: json['replyToId'] as String?,
      replyToText: json['replyToText'] as String?,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isUser': instance.isUser,
      'timestamp': instance.timestamp.toIso8601String(),
      'imagePaths': instance.imagePaths,
      'replyToId': instance.replyToId,
      'replyToText': instance.replyToText,
      'reactions': instance.reactions,
    };
