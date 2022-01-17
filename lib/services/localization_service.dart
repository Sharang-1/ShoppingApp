import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/lang/en_us.dart';
import '../utils/lang/gu_in.dart';
import '../utils/lang/hi_in.dart';

class LocalizationService extends Translations {
  //Supported languages
  static final langs = ['English', 'Hindi', 'Gujarati'];

  static final locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('gu', 'IN'),
  ];

  // Default locale
  static final locale = locales[0];
  static final fallbackLocale = locales[1];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'hi_IN': hiIN,
        'gu_IN': guIN,
      };

  static void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  static Locale? getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}
