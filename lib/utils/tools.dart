import 'dart:math';

import 'package:compound/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class Tools {
  static bool checkIfTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static String getTruncatedString(int length, String str) {
    return str.length <= length ? str : '${str.substring(0, length)}...';
  }

  static Color getColorAccordingToRattings(num rattings) {
    switch (rattings) {
      case 5:
        return Color.fromRGBO(0, 100, 0, 1);
      case 4:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.orange;
      default:
        return logoRed;
    }
  }
}
