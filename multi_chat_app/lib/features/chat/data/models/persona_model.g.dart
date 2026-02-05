// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonaAdapter extends TypeAdapter<_$PersonaImpl> {
  @override
  final int typeId = 0;

  @override
  _$PersonaImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PersonaImpl(
      id: fields[0] as String,
      name: fields[1] as String,
      systemInstruction: fields[2] as String,
      tone: fields[3] as String,
      colorValue: fields[4] as int,
      iconAsset: fields[5] as String,
      iconCode: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, _$PersonaImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.systemInstruction)
      ..writeByte(3)
      ..write(obj.tone)
      ..writeByte(4)
      ..write(obj.colorValue)
      ..writeByte(5)
      ..write(obj.iconAsset)
      ..writeByte(6)
      ..write(obj.iconCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaImpl _$$PersonaImplFromJson(Map<String, dynamic> json) =>
    _$PersonaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      systemInstruction: json['systemInstruction'] as String,
      tone: json['tone'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      iconAsset: json['iconAsset'] as String,
      iconCode: (json['iconCode'] as num?)?.toInt() ?? 57941,
    );

Map<String, dynamic> _$$PersonaImplToJson(_$PersonaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'systemInstruction': instance.systemInstruction,
      'tone': instance.tone,
      'colorValue': instance.colorValue,
      'iconAsset': instance.iconAsset,
      'iconCode': instance.iconCode,
    };
