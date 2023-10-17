import 'package:flutter/material.dart';

class AppColors {
  static const Color white50 = Color(0xFFFFFFFF);

  static const Color black800 = Color(0xFF121212);
  static const Color black900 = Color(0xFF000000);

  static const Color blue50 = Color(0xFFEEF0F2);
  static const Color blue100 = Color(0xFFD2DBE0);
  static const Color blue200 = Color(0xFFADBBC4);
  static const Color blue300 = Color(0xFF8CA2AE);
  static const Color blue600 = Color(0xFF4A6572);
  static const Color blue700 = Color(0xFF344955);
  static const Color blue800 = Color(0xFF232F34);

  static const Color orange300 = Color(0xFFFBD790);
  static const Color orange400 = Color(0xFFF9BE64);
  static const Color orange500 = Color(0xFFF9AA33);

  static const Color red200 = Color(0xFFCF7779);
  static const Color red400 = Color(0xFFFF4C5D);

  static const Color white50Alpha060 = Color(0x99FFFFFF);

  static const Color blue50Alpha060 = Color(0x99EEF0F2);

  static const Color black900Alpha020 = Color(0x33000000);
  static const Color black900Alpha087 = Color(0xDE000000);
  static const Color black900Alpha060 = Color(0x99000000);

  static const Color greyLabel = Color(0xFFAEAEAE);
  static const Color darkBottomAppBarBackground = Color(0xFF2D2D2D);
  static const Color darkDrawerBackground = Color(0xFF353535);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkChipBackground = Color(0xFF2A2A2A);
  static const Color lightChipBackground = Color(0xFFE5E5E5);

  static const List<Color> accountColors = <Color>[
    Color(0xFF005D57),
    Color(0xFF04B97F),
    Color(0xFF37EFBA),
    Color(0xFF007D51),
  ];

  static const List<Color> billColors = <Color>[
    Color(0xFFFFDC78),
    Color(0xFFFF6951),
    Color(0xFFFFD7D0),
    Color(0xFFFFAC12),
  ];

  static const List<Color> budgetColors = <Color>[
    Color(0xFFB2F2FF),
    Color(0xFFB15DFF),
    Color(0xFF72DEFF),
    Color(0xFF0082FB),
  ];

  static const Color gray = Color(0xFFD8D8D8);
  static const Color gray60 = Color(0x99D8D8D8);
  static const Color gray25 = Color(0x40D8D8D8);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color primaryBackground = Color(0xFF33333D);
  static const Color inputBackground = Color(0xFF26282F);
  static const Color cardBackground = Color(0x03FEFEFE);
  static const Color buttonColor = Color(0xFF09AF79);
  static const Color focusColor = Color(0xCCFFFFFF);
  static const Color dividerColor = Color(0xAA282828);

  /// Convenience method to get a single account color with position i.
  static Color accountColor(int i) {
    return cycledColor(accountColors, i);
  }

  /// Convenience method to get a single bill color with position i.
  static Color billColor(int i) {
    return cycledColor(billColors, i);
  }

  /// Convenience method to get a single budget color with position i.
  static Color budgetColor(int i) {
    return cycledColor(budgetColors, i);
  }

  /// Gets a color from a list that is considered to be infinitely repeating.
  static Color cycledColor(List<Color> colors, int i) {
    return colors[i % colors.length];
  }
}
