import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:blueprint/models/theme_data.dart';
import 'package:blueprint/models/locale_manager.dart';

class SettingsManager {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _firstLaunchKey = 'first_launch';
  
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();
  
  late SharedPreferences _prefs;
  
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Если это первый запуск, устанавливаем настройки по умолчанию
    if (!_prefs.containsKey(_firstLaunchKey)) {
      await _setDefaults();
      await _prefs.setBool(_firstLaunchKey, true);
    }
  }
  
  Future<void> _setDefaults() async {
    await _prefs.setString(_themeKey, AppThemeType.dark.toString());
    await _prefs.setString(_languageKey, 'ru');
  }
  
  // Методы для темы
  Future<void> saveTheme(AppThemeType theme) async {
    await _prefs.setString(_themeKey, theme.toString());
  }
  
  AppThemeType getTheme() {
    final themeString = _prefs.getString(_themeKey) ?? AppThemeType.dark.toString();
    
    // Преобразуем строку в enum
    for (var theme in AppThemeType.values) {
      if (theme.toString() == themeString) {
        return theme;
      }
    }
    
    return AppThemeType.dark; // По умолчанию темная тема
  }
  
  // Методы для языка
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }
  
  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'ru';
  }
  
  Locale getLocale() {
    final languageCode = getLanguage();
    return Locale(languageCode);
  }
  
  // Метод для получения всех настроек
  Map<String, dynamic> getAllSettings() {
    return {
      'theme': getTheme(),
      'language': getLanguage(),
    };
  }
  
  // Метод для сброса настроек
  Future<void> resetSettings() async {
    await _prefs.remove(_themeKey);
    await _prefs.remove(_languageKey);
    await _setDefaults();
  }
  
  // Проверка первого запуска
  bool isFirstLaunch() {
    return !_prefs.containsKey(_firstLaunchKey);
  }
  
  // Метод для тестирования (очистка всех настроек)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}