import 'package:flutter/material.dart';
import 'app_localizations.dart';

enum AppLocale {
  russian(Locale('ru', 'RU'), 'Русский', '🇷🇺'),
  english(Locale('en', 'US'), 'English', '🇺🇸'),
  japanese(Locale('ja', 'JP'), '日本語', '🇯🇵'),
  system(Locale('system'), 'System', '🌐');

  const AppLocale(this.locale, this.displayName, this.flag);
  final Locale locale;
  final String displayName;
  final String flag;
}

class LocaleManager {
  static Locale getLocale(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return AppLocale.russian.locale;
      case 'en':
        return AppLocale.english.locale;
      case 'ja':
        return AppLocale.japanese.locale;
      default:
        return AppLocale.english.locale;
    }
  }

  static String getDisplayName(String languageCode, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    switch (languageCode) {
      case 'ru':
        return localizations?.russian ?? 'Русский';
      case 'en':
        return localizations?.english ?? 'English';
      case 'ja':
        return localizations?.japanese ?? '日本語';
      default:
        return localizations?.english ?? 'English';
    }
  }

  static String getFlag(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return AppLocale.russian.flag;
      case 'en':
        return AppLocale.english.flag;
      case 'ja':
        return AppLocale.japanese.flag;
      default:
        return AppLocale.english.flag;
    }
  }

  static List<AppLocale> getAvailableLocales() {
    return [AppLocale.russian, AppLocale.english, AppLocale.japanese];
  }
}