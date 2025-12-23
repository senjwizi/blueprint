import 'package:blueprint/models/theme_data.dart';
import 'package:flutter/material.dart';

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

// Прокси-провайдер
class AppStateProvider extends StatefulWidget {
  final AppStateManager appStateManager;
  final Widget child;
  
  const AppStateProvider({
    super.key,
    required this.appStateManager,
    required this.child,
  });
  
  static AppStateManager of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_InheritedAppStateProvider>();
    if (provider == null) {
      throw FlutterError('AppStateProvider.of() called with context that does not contain AppStateManager');
    }
    return provider.appStateManager;
  }
  
  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider> {
  @override
  void initState() {
    super.initState();
    widget.appStateManager.addListener(_onStateChanged);
  }
  
  @override
  void didUpdateWidget(covariant AppStateProvider oldWidget) {
    if (oldWidget.appStateManager != widget.appStateManager) {
      oldWidget.appStateManager.removeListener(_onStateChanged);
      widget.appStateManager.addListener(_onStateChanged);
    }
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void dispose() {
    widget.appStateManager.removeListener(_onStateChanged);
    super.dispose();
  }
  
  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _InheritedAppStateProvider(
      appStateManager: widget.appStateManager,
      child: widget.child,
    );
  }
}

class _InheritedAppStateProvider extends InheritedWidget {
  final AppStateManager appStateManager;
  
  const _InheritedAppStateProvider({
    required this.appStateManager,
    required super.child,
  });
  
  @override
  bool updateShouldNotify(_InheritedAppStateProvider oldWidget) {
    return appStateManager != oldWidget.appStateManager;
  }
}