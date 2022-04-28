import 'dart:math';
import 'package:flutter/material.dart';

class CompanyColors {
  static const Color _blackPrimaryValue = Color.fromRGBO(0, 0, 0, 60);
  static MaterialColor black = generateMaterialColor(_blackPrimaryValue);
  static Color red = hexToColor("#BB0000");
  static final Color _bluePrimaryValue = hexToColor("#202A44");

  static MaterialColor blue = generateMaterialColor(_bluePrimaryValue);

  static final Color yellowPrimaryValue = hexToColor("#ef7c00");
  static MaterialColor yellow = generateMaterialColor(yellowPrimaryValue);
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) {
  return max(0, min((value + ((255 - value) * factor)).round(), 255));
}

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
