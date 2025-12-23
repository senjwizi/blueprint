import 'package:blueprint/models/theme_data.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppThemeType _theme = AppThemeType.dark;
  String _language = 'ru';
  
  AppThemeType get theme => _theme;
  String get language => _language;
  
  void updateTheme(AppThemeType newTheme) {
    _theme = newTheme;
    notifyListeners();
  }
  
  void updateLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }
  
  void updateAll({required AppThemeType theme, required String language}) {
    _theme = theme;
    _language = language;
    notifyListeners();
  }
}

class AppStateProvider extends InheritedWidget {
  final AppState appState;
  final Widget child;
  
  AppStateProvider({
    Key? key,
    required this.appState,
    required this.child,
  }) : super(key: key, child: child);
  
  static AppStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
  }
  
  static AppState? getState(BuildContext context) {
    return of(context)?.appState;
  }
  
  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return appState != oldWidget.appState;
  }
}