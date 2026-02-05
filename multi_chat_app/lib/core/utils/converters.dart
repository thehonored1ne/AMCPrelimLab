import 'package:flutter/material.dart';

class Converters {
  static Color intToColor(int value) => Color(value);
  static int colorToInt(Color color) => color.value;

  static String formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
