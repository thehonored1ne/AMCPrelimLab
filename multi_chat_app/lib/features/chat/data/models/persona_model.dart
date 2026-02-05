import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'persona_model.freezed.dart';
part 'persona_model.g.dart';

@freezed
class Persona with _$Persona {
  const Persona._(); // Required for custom getters/methods

  @HiveType(typeId: 0, adapterName: 'PersonaAdapter')
  const factory Persona({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String systemInstruction,
    @HiveField(3) required String tone,
    @HiveField(4) required int colorValue,
    @HiveField(5) required String iconAsset, // Keeping for backward compat, but we'll use iconCode
    @HiveField(6) @Default(57941) int iconCode, // Default to Icons.person codePoint
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) => _$PersonaFromJson(json);

  Color get themeColor => Color(colorValue);
  IconData get iconData => IconData(iconCode, fontFamily: 'MaterialIcons');
}
