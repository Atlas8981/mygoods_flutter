import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mygoods_flutter/language/en_kh.dart';
import 'package:mygoods_flutter/language/en_us.dart';

class LocalizationService extends Translations {
  // static const locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static final langs = ['English', 'ខ្មែរ'];

  // Supported locales
  // Needs to be same order with langs
  static const locales = [
    Locale('en', 'US'),
    Locale('kh', 'KM'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS, // lang/en_us.dart
        'kh_KM': kmKH,
      };

  void getLocale() {
    final GetStorage getStorage = GetStorage();
    String lang = getStorage.read("language") ?? "English";
    changeLocale(lang);
  }

  // Gets locale from language, and updates the locale
  Future<void> changeLocale(String lang) async {
    final locale = _getLocaleFromLanguage(lang);
    await Get.updateLocale(locale!);
    final storage = GetStorage();
    storage.write("language", lang);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) {
        return locales[i];
      }
    }
    return Get.locale;
  }

  String getCurrentLang() {
    if (Get.locale == const Locale('en', 'US')) {
      return langs[0];
    } else {
      return langs[1];
    }
  }


}
