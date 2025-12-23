import 'package:blueprint/pages/KanbanPage.dart';
import 'package:blueprint/pages/dashboard_page.dart';
import 'package:blueprint/pages/files_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blueprint/pages/settings_page.dart';
import 'package:blueprint/models/theme_data.dart';
import 'package:blueprint/models/locale_manager.dart';
import 'package:blueprint/models/app_localizations.dart';
import 'package:blueprint/preferences/settings_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blueprint/pages/settings_page.dart';
import 'package:blueprint/preferences/settings_manager.dart';
import 'package:blueprint/providers/app_state_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:blueprint/pages/settings_page.dart';
import 'package:blueprint/preferences/settings_manager.dart';
import 'package:blueprint/providers/app_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settingsManager = SettingsManager();
  await settingsManager.initialize();
  
  runApp(MyApp(settingsManager: settingsManager));
}

class MyApp extends StatefulWidget {
  final SettingsManager settingsManager;
  
  const MyApp({super.key, required this.settingsManager});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppState _appState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _appState = AppState();
    
    // Загружаем сохраненные настройки
    final theme = widget.settingsManager.getTheme();
    final language = widget.settingsManager.getLanguage();
    
    _appState.updateAll(theme: theme, language: language);
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'BluePrint Kanban',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Загрузка настроек...',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppStateProvider(
      appState: _appState,
      child: Builder(
        builder: (context) {
          final appState = AppStateProvider.getState(context)!;
          
          return MaterialApp(
            title: 'Канбан-доска',
            debugShowCheckedModeBanner: false,
            theme: AppThemeManager.getTheme(appState.theme),
            locale: Locale(appState.language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentPageIndex = 1; // Начинаем с Канбан-доски
  
  // Обновляем список страниц - добавляем FilesPage
  final List<Widget> _pages = [
    const DashboardPage(),
    const KanbanPage(),
    _buildPlaceholderPage('Мессенджер', Icons.message, Colors.green),
    const FilesPage(),
    const SettingsPage(),
  ];

  static Widget _buildPlaceholderPage(String title, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        // Получаем текущую тему
        final appState = AppStateProvider.getState(context);
        final currentTheme = appState?.theme ?? AppThemeType.dark;
        final palette = AppThemeManager.getPalette(currentTheme);
        
        return Scaffold(
          backgroundColor: palette.backgroundColor,
          appBar: AppBar(
            backgroundColor: palette.panelBackground,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.3),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: palette.border.withOpacity(0.5),
                height: 1.0,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: palette.panelBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: palette.border, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 64,
                        color: color,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: TextStyle(
                          color: palette.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Эта страница находится в разработке',
                        style: TextStyle(
                          color: palette.secondaryText,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(
                          'Скоро здесь появится контент',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Вернитесь к Канбан-доске для работы с задачами',
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Обновляем список элементов меню - добавляем файловый менеджер
 final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Главная',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      color: Colors.blue,
    ),
    NavigationItem(
      title: 'Канбан-доска',
      icon: Icons.view_kanban_outlined,
      activeIcon: Icons.view_kanban,
      color: Colors.lightBlue,
    ),
    NavigationItem(
      title: 'Мессенджер',
      icon: Icons.message_outlined,
      activeIcon: Icons.message,
      color: Colors.green,
    ),
    NavigationItem(
      title: 'Файлы',
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      color: Colors.teal,
    ),
    NavigationItem(
      title: 'Настройки',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Получаем текущую тему
    final appState = AppStateProvider.getState(context);
    final currentTheme = appState?.theme ?? AppThemeType.dark;
    final palette = AppThemeManager.getPalette(currentTheme);
    
    return Scaffold(
      backgroundColor: palette.backgroundColor,
      drawer: _buildNavigationDrawer(),
      body: Row(
        children: [
          // Боковое меню для десктопов
          if (MediaQuery.of(context).size.width > 768) _buildDesktopSidebar(),
          // Основной контент
          Expanded(
            child: _pages[_currentPageIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    // Получаем текущую тему
    final appState = AppStateProvider.getState(context);
    final currentTheme = appState?.theme ?? AppThemeType.dark;
    final palette = AppThemeManager.getPalette(currentTheme);
    
    return Drawer(
      backgroundColor: palette.panelBackground,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.lightBlue, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'BluePrint',
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            
            // Разделитель
            Divider(
              color: palette.border,
              height: 1,
              thickness: 1,
              indent: 24,
              endIndent: 24,
            ),
            
            const SizedBox(height: 8),
            
            // Элементы навигации
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _navigationItems.length,
                itemBuilder: (context, index) {
                  final item = _navigationItems[index];
                  final isActive = index == _currentPageIndex;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Material(
                      color: isActive
                          ? item.color.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentPageIndex = index;
                          });
                          Navigator.pop(context); // Закрываем drawer
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: isActive
                                ? Border.all(
                                    color: item.color.withOpacity(0.3),
                                    width: 1,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? item.color.withOpacity(0.2)
                                      : palette.cardBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  color: isActive ? item.color : palette.secondaryText,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: isActive ? palette.primaryText : palette.secondaryText,
                                    fontSize: 16,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isActive)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Нижняя часть
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Текущий пользователь
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://tapback.co/api/avatar/admin'),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Администратор',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'admin@blueprint.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Выход из аккаунта
                        },
                        icon: Icon(
                          Icons.logout,
                          color: palette.secondaryText,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Статус системы
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Система активна',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    // Получаем текущую тему
    final appState = AppStateProvider.getState(context);
    final currentTheme = appState?.theme ?? AppThemeType.dark;
    final palette = AppThemeManager.getPalette(currentTheme);
    
    return Container(
      width: 80,
      color: palette.panelBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Логотип
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Элементы навигации
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _navigationItems
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isActive = index == _currentPageIndex;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Tooltip(
                          message: item.title,
                          preferBelow: false,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _currentPageIndex = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 52,
                                height: 52,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? item.color.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isActive
                                      ? Border.all(
                                          color: item.color.withOpacity(0.3),
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isActive ? item.activeIcon : item.icon,
                                      color: isActive ? item.color : palette.secondaryText,
                                      size: 22,
                                    ),
                                    if (isActive) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: item.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            
            // Кнопка профиля (внизу)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Tooltip(
                message: 'Профиль',
                preferBelow: false,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _currentPageIndex = _navigationItems.length - 1; // Переход к настройкам
                    });
                  },
                  icon: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://tapback.co/api/avatar/admin'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Модель для элемента навигации
class NavigationItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Color color;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.color,
  });
}