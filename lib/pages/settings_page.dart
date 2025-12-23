import 'package:blueprint/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:blueprint/models/theme_data.dart';
import 'package:blueprint/models/locale_manager.dart';
import 'package:blueprint/models/app_localizations.dart';
import 'package:blueprint/preferences/settings_manager.dart';

import 'package:blueprint/main.dart'; 



class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Используем нулабельные переменные или значения по умолчанию
  AppThemeType _selectedTheme = AppThemeType.dark; // Значение по умолчанию
  String _selectedLanguage = 'ru'; // Значение по умолчанию
  bool _isSaving = false;
  bool _hasChanges = false;
  bool _isLoading = true;
  
  final SettingsManager _settingsManager = SettingsManager();
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      await _settingsManager.initialize();
      
      setState(() {
        _selectedTheme = _settingsManager.getTheme();
        _selectedLanguage = _settingsManager.getLanguage();
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки настроек: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _handleThemeChange(AppThemeType theme) {
    if (theme != _selectedTheme) {
      setState(() {
        _selectedTheme = theme;
        _hasChanges = true;
      });
    }
  }
  
  void _handleLanguageChange(String languageCode) {
    if (languageCode != _selectedLanguage) {
      setState(() {
        _selectedLanguage = languageCode;
        _hasChanges = true;
      });
    }
  }
  
Future<void> _saveSettings() async {
  if (!_hasChanges) return;
  
  setState(() {
    _isSaving = true;
  });
  
  try {
    // Сохраняем настройки
    await _settingsManager.saveTheme(_selectedTheme);
    await _settingsManager.saveLanguage(_selectedLanguage);
    
    // Получаем AppState из провайдера
    final appState = AppStateProvider.getState(context);
    if (appState != null) {
      appState.updateAll(
        theme: _selectedTheme,
        language: _selectedLanguage,
      );
    }
    
    // Задержка для демонстрации сохранения
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _hasChanges = false;
      _isSaving = false;
    });
    
    // Показываем уведомление об успешном сохранении
    _showSuccessDialog();
    
  } catch (e) {
    setState(() {
      _isSaving = false;
    });
    _showErrorDialog(e.toString());
  }
}
  
  Future<void> _resetToDefaults() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemeManager.getPalette(_selectedTheme).cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppThemeManager.getPalette(_selectedTheme).border,
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppThemeManager.getPalette(_selectedTheme).warning,
              ),
              const SizedBox(width: 12),
              Text(
                'Сброс настроек',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Вы уверены, что хотите сбросить все настройки к значениям по умолчанию?',
            style: TextStyle(
              color: AppThemeManager.getPalette(_selectedTheme).secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? 'Отмена',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).accent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeManager.getPalette(_selectedTheme).danger,
              ),
              child: const Text(
                'Сбросить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
    
    if (confirm == true) {
      setState(() {
        _isSaving = true;
      });
      
      try {
        await _settingsManager.resetSettings();
        await _loadSettings(); // Перезагружаем настройки
        
        setState(() {
          _hasChanges = false;
          _isSaving = false;
        });
        
        _showResetSuccessDialog();
        
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        _showErrorDialog(e.toString());
      }
    }
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemeManager.getPalette(_selectedTheme).cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppThemeManager.getPalette(_selectedTheme).border,
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppThemeManager.getPalette(_selectedTheme).success,
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)?.changesSaved ?? 'Изменения сохранены',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)?.restartApp ?? 'Для применения изменений перезапустите приложение',
            style: TextStyle(
              color: AppThemeManager.getPalette(_selectedTheme).secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? 'Отмена',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).accent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Здесь можно добавить логику для перезапуска приложения
                // Например: SystemNavigator.pop(); или перезапуск через restartApp
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeManager.getPalette(_selectedTheme).accent,
              ),
              child: Text(
                AppLocalizations.of(context)?.apply ?? 'Применить',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _showResetSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemeManager.getPalette(_selectedTheme).cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppThemeManager.getPalette(_selectedTheme).border,
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppThemeManager.getPalette(_selectedTheme).success,
              ),
              const SizedBox(width: 12),
              Text(
                'Настройки сброшены',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Все настройки были успешно сброшены к значениям по умолчанию.',
            style: TextStyle(
              color: AppThemeManager.getPalette(_selectedTheme).secondaryText,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeManager.getPalette(_selectedTheme).accent,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemeManager.getPalette(_selectedTheme).cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppThemeManager.getPalette(_selectedTheme).border,
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: AppThemeManager.getPalette(_selectedTheme).danger,
              ),
              const SizedBox(width: 12),
              Text(
                'Ошибка сохранения',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Не удалось сохранить настройки: $error',
            style: TextStyle(
              color: AppThemeManager.getPalette(_selectedTheme).secondaryText,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeManager.getPalette(_selectedTheme).accent,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppThemeManager.getPalette(_selectedTheme).backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppThemeManager.getPalette(_selectedTheme).accent,
              ),
              const SizedBox(height: 20),
              Text(
                'Загрузка настроек...',
                style: TextStyle(
                  color: AppThemeManager.getPalette(_selectedTheme).secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final localizations = AppLocalizations.of(context);
    
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
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.settings, color: Colors.purple),
            ),
            const SizedBox(width: 15),
            Text(
              localizations?.settingsTitle ?? 'Настройки',
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
            color: palette.border,
            height: 1.0,
          ),
        ),
        actions: [
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.accent),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: palette.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Не сохранено',
                      style: TextStyle(
                        color: palette.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Секция внешнего вида
            _buildSection(
              context: context,
              title: localizations?.appearance ?? 'Внешний вид',
              icon: Icons.palette,
              iconColor: Colors.orange,
              children: [
                // Выбор темы
                _buildSettingItem(
                  context: context,
                  title: localizations?.theme ?? 'Тема',
                  icon: Icons.color_lens,
                  child: _buildThemeSelector(),
                ),
                
                // Предпросмотр тем
                const SizedBox(height: 20),
                _buildThemePreview(),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Секция языка
            _buildSection(
              context: context,
              title: localizations?.language ?? 'Язык',
              icon: Icons.language,
              iconColor: Colors.blue,
              children: [
                _buildSettingItem(
                  context: context,
                  title: localizations?.selectLanguage ?? 'Выберите язык',
                  icon: Icons.translate,
                  child: _buildLanguageSelector(),
                ),
                
                // Флаги языков
                const SizedBox(height: 20),
                _buildLanguageFlags(),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Кнопки управления
            _buildManagementSection(context),
            
            const SizedBox(height: 32),
            
            // Информация о приложении
            _buildAppInfoSection(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildManagementSection(BuildContext context) {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.settings_backup_restore, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Управление настройками',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              // Кнопка сохранения
              Expanded(
                child: _isSaving
                    ? Center(child: CircularProgressIndicator(color: palette.accent))
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _hasChanges
                                ? [palette.accent, palette.accent.withOpacity(0.8)]
                                : [palette.secondaryText, palette.secondaryText.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _hasChanges
                              ? [
                                  BoxShadow(
                                    color: palette.accent.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton(
                          onPressed: _hasChanges ? _saveSettings : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _hasChanges ? Icons.save : Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _hasChanges
                                    ? (localizations?.saveChanges ?? 'Сохранить изменения')
                                    : 'Все изменения сохранены',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(width: 16),
              
              // Кнопка сброса
              Container(
                decoration: BoxDecoration(
                  color: palette.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.danger, width: 1),
                ),
                child: TextButton(
                  onPressed: _resetToDefaults,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restore,
                        color: palette.danger,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Сбросить',
                        style: TextStyle(
                          color: palette.danger,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Информация о текущих настройках
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Текущие настройки:',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildCurrentSetting(
                      icon: Icons.color_lens,
                      title: 'Тема',
                      value: _selectedTheme == AppThemeType.dark
                          ? (localizations?.darkTheme ?? 'Тёмная')
                          : (localizations?.lightTheme ?? 'Светлая'),
                      color: _selectedTheme == AppThemeType.dark ? Colors.blue : Colors.orange,
                      palette: palette,
                    ),
                    const SizedBox(width: 12),
                    _buildCurrentSetting(
                      icon: Icons.language,
                      title: 'Язык',
                      value: LocaleManager.getDisplayName(_selectedLanguage, context),
                      color: Colors.green,
                      palette: palette,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentSetting({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required AppColorPalette palette,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: palette.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: palette.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.secondaryText, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: palette.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          child,
        ],
      ),
    );
  }
  
  Widget _buildThemeSelector() {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final localizations = AppLocalizations.of(context);
    
    return SegmentedButton<AppThemeType>(
      segments: [
        ButtonSegment<AppThemeType>(
          value: AppThemeType.dark,
          label: Text(localizations?.darkTheme ?? 'Тёмная'),
          icon: Icon(Icons.dark_mode, color: palette.primaryText),
        ),
        ButtonSegment<AppThemeType>(
          value: AppThemeType.light,
          label: Text(localizations?.lightTheme ?? 'Светлая'),
          icon: Icon(Icons.light_mode, color: palette.primaryText),
        ),
      ],
      selected: {_selectedTheme},
      onSelectionChanged: (Set<AppThemeType> newSelection) {
        _handleThemeChange(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: palette.cardBackground,
        selectedBackgroundColor: palette.accent,
        selectedForegroundColor: Colors.white,
        side: BorderSide(color: palette.border),
      ),
    );
  }
  
  Widget _buildThemePreview() {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final isDark = _selectedTheme == AppThemeType.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Предпросмотр',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.blue : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  isDark ? 'Тёмная' : 'Светлая',
                  style: TextStyle(
                    color: isDark ? Colors.blue : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Предпросмотр тёмной темы
              Expanded(
                child: _buildThemePreviewCard(
                  theme: AppThemeType.dark,
                  isActive: _selectedTheme == AppThemeType.dark,
                  onTap: () => _handleThemeChange(AppThemeType.dark),
                ),
              ),
              const SizedBox(width: 16),
              // Предпросмотр светлой темы
              Expanded(
                child: _buildThemePreviewCard(
                  theme: AppThemeType.light,
                  isActive: _selectedTheme == AppThemeType.light,
                  onTap: () => _handleThemeChange(AppThemeType.light),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildThemePreviewCard({
    required AppThemeType theme,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final palette = AppThemeManager.getPalette(theme);
    final isDark = theme == AppThemeType.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? palette.accent : palette.border,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: palette.accent.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Заголовок
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: palette.panelBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Контент
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: palette.backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: palette.border),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: palette.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDark ? 'Dark' : 'Light',
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Кнопка
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageSelector() {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final localizations = AppLocalizations.of(context);
    final availableLocales = LocaleManager.getAvailableLocales();
    
    return DropdownButton<String>(
      value: _selectedLanguage,
      onChanged: (String? newValue) {
        if (newValue != null) {
          _handleLanguageChange(newValue);
        }
      },
      dropdownColor: palette.panelBackground,
      style: TextStyle(color: palette.primaryText),
      underline: Container(height: 0),
      icon: Icon(Icons.arrow_drop_down, color: palette.secondaryText),
      items: availableLocales.map<DropdownMenuItem<String>>((AppLocale locale) {
        return DropdownMenuItem<String>(
          value: locale.locale.languageCode,
          child: Row(
            children: [
              Text(locale.flag),
              const SizedBox(width: 12),
              Text(
                locale.displayName,
                style: TextStyle(color: palette.primaryText),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildLanguageFlags() {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final availableLocales = LocaleManager.getAvailableLocales();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Доступные языки:',
            style: TextStyle(
              color: palette.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: availableLocales.map((locale) {
              final isSelected = _selectedLanguage == locale.locale.languageCode;
              
              return GestureDetector(
                onTap: () => _handleLanguageChange(locale.locale.languageCode),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? palette.accent.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? palette.accent : palette.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.flag,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        locale.displayName,
                        style: TextStyle(
                          color: isSelected
                              ? palette.accent
                              : palette.primaryText,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppInfoSection(BuildContext context) {
    final palette = AppThemeManager.getPalette(_selectedTheme);
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'О приложении',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
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
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BluePrint Kanban',
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Версия 1.0.0',
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: palette.border, height: 1),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            children: [
              _buildAppInfoItem(
                icon: Icons.developer_mode,
                title: 'Разработчик',
                value: 'BluePrint Team',
                color: palette.info,
                palette: palette,
              ),
              _buildAppInfoItem(
                icon: Icons.update,
                title: 'Обновлено',
                value: 'Сегодня',
                color: palette.success,
                palette: palette,
              ),
              _buildAppInfoItem(
                icon: Icons.storage,
                title: 'Хранилище',
                value: 'Локальное',
                color: palette.warning,
                palette: palette,
              ),
              _buildAppInfoItem(
                icon: Icons.security,
                title: 'Безопасность',
                value: 'Высокая',
                color: palette.success,
                palette: palette,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required AppColorPalette palette,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}