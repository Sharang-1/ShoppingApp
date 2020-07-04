import 'dart:math';

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
}
