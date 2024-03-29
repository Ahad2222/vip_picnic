import 'dart:ui';
import 'package:get/get.dart';
import 'package:vip_picnic/translations/en_US.dart';
import 'package:vip_picnic/translations/es_SP.dart';
import 'package:vip_picnic/translations/pt_PO.dart';

class Localization extends Translations {
  static Locale locale = Locale('en', 'US');
  static final fallBackLocale = Locale('en', 'US');

  static final languages = [
    'English',
    'Spanish',
    'Portuguese',
  ];

  static final locales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'PO'),
  ];

  void selectedLocale(
    String lang,
  ) {
    final currentLocale = _getLocalFromLanguages(lang);
    locale = currentLocale;
    Get.updateLocale(currentLocale);
  }

  Locale _getLocalFromLanguages(String lang) {
    for (int i = 0; i < languages.length; i++) {
      if (lang == languages[i]) {
        return locales[i];
      }
    }
    return Get.locale!;
  }

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': english,
        'es_SP': spanish,
        'pt_PO': portuguese,
      };
}
