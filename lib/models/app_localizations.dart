import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      'app_title': 'Канбан-доска',
      'home': 'Главная',
      'kanban': 'Канбан-доска',
      'messenger': 'Мессенджер',
      'settings': 'Настройки',
      
      // Настройки
      'settings_title': 'Настройки',
      'appearance': 'Внешний вид',
      'theme': 'Тема',
      'dark_theme': 'Тёмная',
      'light_theme': 'Светлая',
      'language': 'Язык',
      'russian': 'Русский',
      'english': 'Английский',
      'japanese': 'Японский',
      'system_default': 'Системная',
      'save_changes': 'Сохранить изменения',
      'changes_saved': 'Изменения сохранены',
      'restart_app': 'Для применения изменений перезапустите приложение',
      'select_theme': 'Выберите тему',
      'select_language': 'Выберите язык',
      
      // Общие
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'apply': 'Применить',
      'back': 'Назад',
      'profile': 'Профиль',
      'logout': 'Выйти',
      'system': 'Система',
      'status': 'Статус',
      'active': 'Активна',
      
      // Статистика
      'statistics': 'Статистика',
      'project_statistics': 'Статистика проекта',
      'completion': 'Готовность',
      'done': 'Готово',
      'tasks_completed': 'задач выполнено',
      'project_stage': 'Этап проекта',
      'task_distribution': 'Распределение задач',
      'todo': 'К выполнению',
      'in_progress': 'В процессе',
      'done_tasks': 'Выполнено',
      'average_difficulty': 'Средняя сложность',
      'easy': 'Легко',
      'medium': 'Средне',
      'hard': 'Сложно',
      'overdue': 'Просрочено',
      'days_left': 'дн. осталось',
      
      // Задачи
      'add_task': 'Добавить задачу',
      'task_title': 'Название задачи',
      'task_description': 'Описание задачи',
      'difficulty': 'Сложность',
      'assigned_users': 'Назначенные пользователи',
      'start_date': 'Дата начала',
      'deadline': 'Срок выполнения',
      'add': 'Добавить',
      'edit': 'Редактировать',
      'delete': 'Удалить',
      'drag_to_move': 'Перетащите для перемещения',
      
      // Роли
      'developer': 'Разработчик',
      'designer': 'Дизайнер',
      'manager': 'Менеджер',
      'unknown': 'Неизвестно',
    },
    'en': {
      'app_title': 'Kanban Board',
      'home': 'Home',
      'kanban': 'Kanban Board',
      'messenger': 'Messenger',
      'settings': 'Settings',
      
      // Settings
      'settings_title': 'Settings',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'dark_theme': 'Dark',
      'light_theme': 'Light',
      'language': 'Language',
      'russian': 'Russian',
      'english': 'English',
      'japanese': 'Japanese',
      'system_default': 'System Default',
      'save_changes': 'Save Changes',
      'changes_saved': 'Changes Saved',
      'restart_app': 'Restart the app to apply changes',
      'select_theme': 'Select Theme',
      'select_language': 'Select Language',
      
      // Common
      'cancel': 'Cancel',
      'save': 'Save',
      'apply': 'Apply',
      'back': 'Back',
      'profile': 'Profile',
      'logout': 'Logout',
      'system': 'System',
      'status': 'Status',
      'active': 'Active',
      
      // Statistics
      'statistics': 'Statistics',
      'project_statistics': 'Project Statistics',
      'completion': 'Completion',
      'done': 'Done',
      'tasks_completed': 'tasks completed',
      'project_stage': 'Project Stage',
      'task_distribution': 'Task Distribution',
      'todo': 'To Do',
      'in_progress': 'In Progress',
      'done_tasks': 'Done',
      'average_difficulty': 'Average Difficulty',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'overdue': 'Overdue',
      'days_left': 'days left',
      
      // Tasks
      'add_task': 'Add Task',
      'task_title': 'Task Title',
      'task_description': 'Task Description',
      'difficulty': 'Difficulty',
      'assigned_users': 'Assigned Users',
      'start_date': 'Start Date',
      'deadline': 'Deadline',
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'drag_to_move': 'Drag to move',
      
      // Roles
      'developer': 'Developer',
      'designer': 'Designer',
      'manager': 'Manager',
      'unknown': 'Unknown',
    },
    'ja': {
      'app_title': 'カンバンボード',
      'home': 'ホーム',
      'kanban': 'カンバンボード',
      'messenger': 'メッセンジャー',
      'settings': '設定',
      
      // Settings
      'settings_title': '設定',
      'appearance': '外観',
      'theme': 'テーマ',
      'dark_theme': 'ダーク',
      'light_theme': 'ライト',
      'language': '言語',
      'russian': 'ロシア語',
      'english': '英語',
      'japanese': '日本語',
      'system_default': 'システム設定',
      'save_changes': '変更を保存',
      'changes_saved': '変更を保存しました',
      'restart_app': '変更を適用するにはアプリを再起動してください',
      'select_theme': 'テーマを選択',
      'select_language': '言語を選択',
      
      // Common
      'cancel': 'キャンセル',
      'save': '保存',
      'apply': '適用',
      'back': '戻る',
      'profile': 'プロフィール',
      'logout': 'ログアウト',
      'system': 'システム',
      'status': 'ステータス',
      'active': 'アクティブ',
      
      // Statistics
      'statistics': '統計',
      'project_statistics': 'プロジェクト統計',
      'completion': '完了率',
      'done': '完了',
      'tasks_completed': 'タスク完了',
      'project_stage': 'プロジェクト段階',
      'task_distribution': 'タスク分布',
      'todo': '未着手',
      'in_progress': '進行中',
      'done_tasks': '完了',
      'average_difficulty': '平均難易度',
      'easy': '簡単',
      'medium': '普通',
      'hard': '難しい',
      'overdue': '期限切れ',
      'days_left': '日残り',
      
      // Tasks
      'add_task': 'タスクを追加',
      'task_title': 'タスク名',
      'task_description': 'タスク説明',
      'difficulty': '難易度',
      'assigned_users': '担当者',
      'start_date': '開始日',
      'deadline': '期限',
      'add': '追加',
      'edit': '編集',
      'delete': '削除',
      'drag_to_move': '移動するにはドラッグ',
      
      // Roles
      'developer': '開発者',
      'designer': 'デザイナー',
      'manager': 'マネージャー',
      'unknown': '不明',
    },
  };

  String? get appTitle => _localizedValues[locale.languageCode]?['app_title'];
  String? get home => _localizedValues[locale.languageCode]?['home'];
  String? get kanban => _localizedValues[locale.languageCode]?['kanban'];
  String? get messenger => _localizedValues[locale.languageCode]?['messenger'];
  String? get settings => _localizedValues[locale.languageCode]?['settings'];
  String? get settingsTitle => _localizedValues[locale.languageCode]?['settings_title'];
  String? get appearance => _localizedValues[locale.languageCode]?['appearance'];
  String? get theme => _localizedValues[locale.languageCode]?['theme'];
  String? get darkTheme => _localizedValues[locale.languageCode]?['dark_theme'];
  String? get lightTheme => _localizedValues[locale.languageCode]?['light_theme'];
  String? get language => _localizedValues[locale.languageCode]?['language'];
  String? get russian => _localizedValues[locale.languageCode]?['russian'];
  String? get english => _localizedValues[locale.languageCode]?['english'];
  String? get japanese => _localizedValues[locale.languageCode]?['japanese'];
  String? get systemDefault => _localizedValues[locale.languageCode]?['system_default'];
  String? get saveChanges => _localizedValues[locale.languageCode]?['save_changes'];
  String? get changesSaved => _localizedValues[locale.languageCode]?['changes_saved'];
  String? get restartApp => _localizedValues[locale.languageCode]?['restart_app'];
  String? get selectTheme => _localizedValues[locale.languageCode]?['select_theme'];
  String? get selectLanguage => _localizedValues[locale.languageCode]?['select_language'];
  String? get cancel => _localizedValues[locale.languageCode]?['cancel'];
  String? get save => _localizedValues[locale.languageCode]?['save'];
  String? get apply => _localizedValues[locale.languageCode]?['apply'];
  String? get back => _localizedValues[locale.languageCode]?['back'];
  String? get profile => _localizedValues[locale.languageCode]?['profile'];
  String? get logout => _localizedValues[locale.languageCode]?['logout'];
  String? get system => _localizedValues[locale.languageCode]?['system'];
  String? get status => _localizedValues[locale.languageCode]?['status'];
  String? get active => _localizedValues[locale.languageCode]?['active'];
  String? get statistics => _localizedValues[locale.languageCode]?['statistics'];
  String? get projectStatistics => _localizedValues[locale.languageCode]?['project_statistics'];
  String? get completion => _localizedValues[locale.languageCode]?['completion'];
  String? get done => _localizedValues[locale.languageCode]?['done'];
  String? get tasksCompleted => _localizedValues[locale.languageCode]?['tasks_completed'];
  String? get projectStage => _localizedValues[locale.languageCode]?['project_stage'];
  String? get taskDistribution => _localizedValues[locale.languageCode]?['task_distribution'];
  String? get todo => _localizedValues[locale.languageCode]?['todo'];
  String? get inProgress => _localizedValues[locale.languageCode]?['in_progress'];
  String? get doneTasks => _localizedValues[locale.languageCode]?['done_tasks'];
  String? get averageDifficulty => _localizedValues[locale.languageCode]?['average_difficulty'];
  String? get easy => _localizedValues[locale.languageCode]?['easy'];
  String? get medium => _localizedValues[locale.languageCode]?['medium'];
  String? get hard => _localizedValues[locale.languageCode]?['hard'];
  String? get overdue => _localizedValues[locale.languageCode]?['overdue'];
  String? get daysLeft => _localizedValues[locale.languageCode]?['days_left'];
  String? get addTask => _localizedValues[locale.languageCode]?['add_task'];
  String? get taskTitle => _localizedValues[locale.languageCode]?['task_title'];
  String? get taskDescription => _localizedValues[locale.languageCode]?['task_description'];
  String? get difficulty => _localizedValues[locale.languageCode]?['difficulty'];
  String? get assignedUsers => _localizedValues[locale.languageCode]?['assigned_users'];
  String? get startDate => _localizedValues[locale.languageCode]?['start_date'];
  String? get deadline => _localizedValues[locale.languageCode]?['deadline'];
  String? get add => _localizedValues[locale.languageCode]?['add'];
  String? get edit => _localizedValues[locale.languageCode]?['edit'];
  String? get delete => _localizedValues[locale.languageCode]?['delete'];
  String? get dragToMove => _localizedValues[locale.languageCode]?['drag_to_move'];
  String? get developer => _localizedValues[locale.languageCode]?['developer'];
  String? get designer => _localizedValues[locale.languageCode]?['designer'];
  String? get manager => _localizedValues[locale.languageCode]?['manager'];
  String? get unknown => _localizedValues[locale.languageCode]?['unknown'];

  static List<Locale> supportedLocales = [
    const Locale('ru', 'RU'),
    const Locale('en', 'US'),
    const Locale('ja', 'JP'),
  ];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}