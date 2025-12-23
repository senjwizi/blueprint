import 'package:flutter/material.dart';

// Тип темы
enum AppThemeType {
  dark,
  light,
}

// Класс для хранения цветовой палитры
class AppColorPalette {
  final Color backgroundColor;
  final Color panelBackground;
  final Color cardBackground;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  const AppColorPalette({
    required this.backgroundColor,
    required this.panelBackground,
    required this.cardBackground,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });
}

// Темная тема
class DarkTheme {
  static const AppColorPalette palette = AppColorPalette(
    backgroundColor: Color(0xFF121212),
    panelBackground: Color(0xFF1E1E1E),
    cardBackground: Color(0xFF2D2D2D),
    primaryText: Colors.white,
    secondaryText: Color(0xFFB0B0B0),
    accent: Color(0xFF29B6F6),
    border: Color(0xFF3A3A3A),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    danger: Color(0xFFF44336),
    info: Color(0xFF2196F3),
  );

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.panelBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: TextStyle(
          color: palette.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: palette.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.accent, width: 2),
        ),
        labelStyle: TextStyle(color: palette.secondaryText),
        hintStyle: TextStyle(color: palette.secondaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: palette.secondaryText,
      ),
      colorScheme: ColorScheme.dark(
        primary: palette.accent,
        secondary: palette.accent,
        surface: palette.panelBackground,
        background: palette.backgroundColor,
        error: palette.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: palette.primaryText,
        onBackground: palette.primaryText,
        onError: Colors.white,
      ),
    );
  }
}

// Светлая тема
class LightTheme {
  static const AppColorPalette palette = AppColorPalette(
    backgroundColor: Color(0xFFF8F9FA),
    panelBackground: Color(0xFFFFFFFF),
    cardBackground: Color(0xFFFFFFFF),
    primaryText: Color(0xFF212529),
    secondaryText: Color(0xFF6C757D),
    accent: Color(0xFF0D6EFD),
    border: Color(0xFFDEE2E6),
    success: Color(0xFF198754),
    warning: Color(0xFFFD7E14),
    danger: Color(0xFFDC3545),
    info: Color(0xFF0DCAF0),
  );

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.panelBackground,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        titleTextStyle: TextStyle(
          color: palette.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: palette.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.accent, width: 2),
        ),
        labelStyle: TextStyle(color: palette.secondaryText),
        hintStyle: TextStyle(color: palette.secondaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 1,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: palette.secondaryText,
      ),
      colorScheme: ColorScheme.light(
        primary: palette.accent,
        secondary: palette.accent,
        surface: palette.panelBackground,
        background: palette.backgroundColor,
        error: palette.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: palette.primaryText,
        onBackground: palette.primaryText,
        onError: Colors.white,
      ),
    );
  }
}

// Класс для управления темами
class AppThemeManager {
  static ThemeData getTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.dark:
        return DarkTheme.themeData;
      case AppThemeType.light:
        return LightTheme.themeData;
    }
  }

  static AppColorPalette getPalette(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.dark:
        return DarkTheme.palette;
      case AppThemeType.light:
        return LightTheme.palette;
    }
  }

  static Color getColorFromPalette(AppThemeType themeType, String colorType) {
    final palette = getPalette(themeType);
    switch (colorType) {
      case 'backgroundColor':
        return palette.backgroundColor;
      case 'panelBackground':
        return palette.panelBackground;
      case 'cardBackground':
        return palette.cardBackground;
      case 'primaryText':
        return palette.primaryText;
      case 'secondaryText':
        return palette.secondaryText;
      case 'accent':
        return palette.accent;
      case 'border':
        return palette.border;
      case 'success':
        return palette.success;
      case 'warning':
        return palette.warning;
      case 'danger':
        return palette.danger;
      case 'info':
        return palette.info;
      default:
        return palette.accent;
    }
  }
}