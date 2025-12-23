import 'package:flutter/material.dart';
import 'package:blueprint/models/theme_data.dart';
import 'package:blueprint/models/locale_manager.dart';

class AppStateManager extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.dark;
  Locale _currentLocale = const Locale('ru', 'RU');
  
  AppThemeType get currentTheme => _currentTheme;
  Locale get currentLocale => _currentLocale;
  
  void updateTheme(AppThemeType newTheme) {
    if (_currentTheme != newTheme) {
      _currentTheme = newTheme;
      notifyListeners();
    }
  }
  
  void updateLocale(Locale newLocale) {
    if (_currentLocale.languageCode != newLocale.languageCode) {
      _currentLocale = newLocale;
      notifyListeners();
    }
  }
  
  void updateFromSettings({
    required AppThemeType theme,
    required String languageCode,
  }) {
    bool hasChanges = false;
    
    if (_currentTheme != theme) {
      _currentTheme = theme;
      hasChanges = true;
    }
    
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      hasChanges = true;
    }
    
    if (hasChanges) {
      notifyListeners();
    }
  }
}