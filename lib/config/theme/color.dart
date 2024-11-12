import 'dart:math';

import 'package:flutter/material.dart';

abstract final class ColorPrimary {
  //Primary
  static const Color blue = Color(0xff748EFE);
  static const Color orange = Color(0xffFF6333);
  static const Color green = Color(0xff13AE85);
}

class ColorRandom {
  // Define a list of colors
  static const List<Color> colorList = [
    Color(0xFFFFEB69),
    Color(0xFF40DDB4),
    Color(0xFF7C95FF),
    Color(0xFFFF7247),
  ];

  // Method to get a random color
  static Color getRandomColor() {
    final random = Random();
    return colorList[random.nextInt(colorList.length)];
  }
}

abstract final class ColorNeutral {
  //Neutral
  static const Color gray = Color(0xff3A3A3A);
  static const Color black = Color(0xff141414);
  static const Color background = Color(0xffF2F2F2);
  static const Color white = Color(0xffFFFFFF);
}
