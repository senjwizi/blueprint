import 'package:blueprint/models/app_localizations.dart';
import 'package:blueprint/models/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:blueprint/providers/app_state_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущую тему
    final appState = AppStateProvider.getState(context);
    final currentTheme = appState?.theme ?? AppThemeType.dark;
    final palette = AppThemeManager.getPalette(currentTheme);
    final localizations = AppLocalizations.of(context);
    
    // Мок-данные для демонстрации
    final userTasks = _getUserTasks();
    final projectProgress = _getProjectProgress();
    final recentActivity = _getRecentActivity();
    final upcomingDeadlines = _getUpcomingDeadlines();
    final teamStats = _getTeamStats();
    
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dashboard, color: Colors.blue),
            ),
            const SizedBox(width: 15),
            Text(
              localizations?.home ?? 'Главная',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            _buildWelcomeSection(palette),
            const SizedBox(height: 24),
            
            // Быстрая статистика
            _buildQuickStats(palette, projectProgress),
            const SizedBox(height: 24),
            
            // Задачи пользователя
            _buildUserTasksSection(palette, userTasks, localizations),
            const SizedBox(height: 24),
            
            // Предстоящие сроки
            _buildUpcomingDeadlines(palette, upcomingDeadlines, localizations),
            const SizedBox(height: 24),
            
            // Последняя активность
            _buildRecentActivity(palette, recentActivity, localizations),
            const SizedBox(height: 24),
            
            // Статистика команды
            _buildTeamStats(palette, teamStats, localizations),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeSection(AppColorPalette palette) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://tapback.co/api/avatar/admin'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Добро пожаловать, Администратор! 👋',
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Сегодня ${_getFormattedDate()}',
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Активен в проекте',
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active, color: palette.accent),
            tooltip: 'Уведомления',
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickStats(AppColorPalette palette, ProjectProgress progress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: palette.accent),
              const SizedBox(width: 12),
              Text(
                'Прогресс проекта',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Круговая диаграмма прогресса
          Row(
            children: [
              CircularPercentIndicator(
                radius: 60,
                lineWidth: 10,
                percent: progress.completionPercentage,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress.completionPercentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'готово',
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                progressColor: palette.accent,
                backgroundColor: palette.border,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 30),
              
              // Детали прогресса
              Expanded(
                child: Column(
                  children: [
                    _buildStatItem(
                      title: 'Всего задач',
                      value: progress.totalTasks.toString(),
                      color: palette.accent,
                      palette: palette,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      title: 'Выполнено',
                      value: progress.completedTasks.toString(),
                      color: Colors.green,
                      palette: palette,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      title: 'В процессе',
                      value: progress.inProgressTasks.toString(),
                      color: Colors.orange,
                      palette: palette,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      title: 'Просрочено',
                      value: progress.overdueTasks.toString(),
                      color: Colors.red,
                      palette: palette,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserTasksSection(
    AppColorPalette palette,
    List<UserTask> tasks,
    AppLocalizations? localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.task, color: palette.accent),
                  const SizedBox(width: 12),
                  Text(
                    localizations?.tasks ?? 'Мои задачи',
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Все задачи →',
                  style: TextStyle(color: palette.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (tasks.isEmpty)
            _buildEmptyState(
              'Нет активных задач',
              'Все задачи выполнены!',
              Icons.check_circle_outline,
              Colors.green,
              palette,
            )
          else
            Column(
              children: tasks.map((task) => _buildTaskItem(task, palette)).toList(),
            ),
        ],
      ),
    );
  }
  
  Widget _buildTaskItem(UserTask task, AppColorPalette palette) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                _getPriorityIcon(task.priority),
                color: _getPriorityColor(task.priority),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: palette.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      task.dueDate,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.person, size: 12, color: palette.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      task.project,
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildProgressIndicator(task.progress, palette),
        ],
      ),
    );
  }
  
  Widget _buildProgressIndicator(double progress, AppColorPalette palette) {
    return Container(
      width: 60,
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 20,
            lineWidth: 4,
            percent: progress / 100,
            center: Text(
              '${progress.toInt()}%',
              style: TextStyle(
                color: palette.primaryText,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: _getProgressColor(progress),
            backgroundColor: palette.border,
          ),
          const SizedBox(height: 4),
          Text(
            'Прогресс',
            style: TextStyle(
              color: palette.secondaryText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpcomingDeadlines(
    AppColorPalette palette,
    List<Deadline> deadlines,
    AppLocalizations? localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.orange),
                  const SizedBox(width: 12),
                  Text(
                    'Предстоящие сроки',
                    style: TextStyle(
                      color: palette.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  '${deadlines.length} дедлайнов',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (deadlines.isEmpty)
            _buildEmptyState(
              'Нет предстоящих сроков',
              'Все дедлайны выполнены!',
              Icons.celebration,
              Colors.green,
              palette,
            )
          else
            Column(
              children: deadlines.map((deadline) => _buildDeadlineItem(deadline, palette)).toList(),
            ),
        ],
      ),
    );
  }
  
  Widget _buildDeadlineItem(Deadline deadline, AppColorPalette palette) {
    final isUrgent = deadline.daysLeft <= 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.withOpacity(0.05) : palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? Colors.red.withOpacity(0.3) : palette.border,
          width: isUrgent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.withOpacity(0.1) : palette.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                isUrgent ? Icons.warning : Icons.flag,
                color: isUrgent ? Colors.red : palette.accent,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deadline.title,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deadline.description,
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.withOpacity(0.1) : palette.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isUrgent ? Colors.red : palette.accent,
                width: 1,
              ),
            ),
            child: Text(
              '${deadline.daysLeft} дн.',
              style: TextStyle(
                color: isUrgent ? Colors.red : palette.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity(
    AppColorPalette palette,
    List<Activity> activities,
    AppLocalizations? localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: palette.accent),
              const SizedBox(width: 12),
              Text(
                'Последняя активность',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (activities.isEmpty)
            _buildEmptyState(
              'Нет активности',
              'Будьте первым, кто начнет работу!',
              Icons.rocket_launch,
              palette.accent,
              palette,
            )
          else
            Column(
              children: activities.map((activity) => _buildActivityItem(activity, palette)).toList(),
            ),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(Activity activity, AppColorPalette palette) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getActivityColor(activity.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getActivityIcon(activity.type),
                color: _getActivityColor(activity.type),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: TextStyle(
                    color: palette.primaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.time,
                  style: TextStyle(
                    color: palette.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTeamStats(
    AppColorPalette palette,
    TeamStats stats,
    AppLocalizations? localizations,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: palette.accent),
              const SizedBox(width: 12),
              Text(
                'Команда проекта',
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
              // Статистика команды
              Expanded(
                child: Column(
                  children: [
                    _buildStatItem(
                      title: 'Всего участников',
                      value: stats.totalMembers.toString(),
                      color: palette.accent,
                      palette: palette,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      title: 'Активных сейчас',
                      value: stats.activeMembers.toString(),
                      color: Colors.green,
                      palette: palette,
                    ),
                    const SizedBox(height: 12),
                    _buildStatItem(
                      title: 'Задач на человека',
                      value: stats.tasksPerMember.toStringAsFixed(1),
                      color: Colors.orange,
                      palette: palette,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              
              // Аватары команды
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Участники:',
                      style: TextStyle(
                        color: palette.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...stats.teamMembers.map((member) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Tooltip(
                            message: member.name,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(member.avatarUrl),
                              backgroundColor: palette.border,
                            ),
                          ),
                        )).toList(),
                        if (stats.totalMembers > 4)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: palette.cardBackground,
                              shape: BoxShape.circle,
                              border: Border.all(color: palette.border),
                            ),
                            child: Center(
                              child: Text(
                                '+${stats.totalMembers - 4}',
                                style: TextStyle(
                                  color: palette.secondaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required String title,
    required String value,
    required Color color,
    required AppColorPalette palette,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: palette.secondaryText,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    AppColorPalette palette,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: palette.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: palette.secondaryText,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Вспомогательные методы
  
  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    
    return '${now.day} ${months[now.month - 1]} ${now.year}, ${days[now.weekday - 1]}';
  }
  
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
  
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Icons.warning;
      case TaskPriority.medium:
        return Icons.info;
      case TaskPriority.low:
        return Icons.check_circle;
    }
  }
  
  Color _getProgressColor(double progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }
  
  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.taskAdded:
        return Colors.blue;
      case ActivityType.taskCompleted:
        return Colors.green;
      case ActivityType.commentAdded:
        return Colors.purple;
      case ActivityType.fileUploaded:
        return Colors.teal;
      case ActivityType.statusChanged:
        return Colors.orange;
    }
  }
  
  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.taskAdded:
        return Icons.add_task;
      case ActivityType.taskCompleted:
        return Icons.check_circle;
      case ActivityType.commentAdded:
        return Icons.comment;
      case ActivityType.fileUploaded:
        return Icons.file_upload;
      case ActivityType.statusChanged:
        return Icons.change_circle;
    }
  }
  
  // Мок-данные
  
  List<UserTask> _getUserTasks() {
    return [
      UserTask(
        id: '1',
        title: 'Дизайн интерфейса настроек',
        project: 'BluePrint',
        priority: TaskPriority.high,
        progress: 75,
        dueDate: 'Сегодня',
      ),
      UserTask(
        id: '2',
        title: 'Интеграция с API файлового менеджера',
        project: 'BluePrint',
        priority: TaskPriority.medium,
        progress: 30,
        dueDate: 'Завтра',
      ),
      UserTask(
        id: '3',
        title: 'Тестирование канбан-доски',
        project: 'BluePrint',
        priority: TaskPriority.low,
        progress: 90,
        dueDate: '28.12.2024',
      ),
    ];
  }
  
  ProjectProgress _getProjectProgress() {
    return ProjectProgress(
      totalTasks: 42,
      completedTasks: 28,
      inProgressTasks: 10,
      overdueTasks: 4,
      completionPercentage: 0.67,
    );
  }
  
  List<Deadline> _getUpcomingDeadlines() {
    return [
      Deadline(
        id: '1',
        title: 'Сдача проекта BluePrint',
        description: 'Финальный релиз приложения',
        daysLeft: 2,
      ),
      Deadline(
        id: '2',
        title: 'Демонстрация заказчику',
        description: 'Презентация функционала',
        daysLeft: 5,
      ),
      Deadline(
        id: '3',
        title: 'Техническая документация',
        description: 'Подготовка документации по API',
        daysLeft: 7,
      ),
    ];
  }
  
  List<Activity> _getRecentActivity() {
    return [
      Activity(
        id: '1',
        type: ActivityType.taskCompleted,
        description: 'Radmir завершил задачу "Авторизация пользователей"',
        time: '10 минут назад',
      ),
      Activity(
        id: '2',
        type: ActivityType.commentAdded,
        description: 'Alice оставила комментарий к дизайну',
        time: '30 минут назад',
      ),
      Activity(
        id: '3',
        type: ActivityType.fileUploaded,
        description: 'Bob загрузил новый макет интерфейса',
        time: '1 час назад',
      ),
      Activity(
        id: '4',
        type: ActivityType.statusChanged,
        description: 'Задача "Мобильная версия" переведена в тестирование',
        time: '2 часа назад',
      ),
    ];
  }
  
  TeamStats _getTeamStats() {
    return TeamStats(
      totalMembers: 8,
      activeMembers: 6,
      tasksPerMember: 5.3,
      teamMembers: [
        TeamMember(name: 'Radmir', avatarUrl: 'https://tapback.co/api/avatar/radmir'),
        TeamMember(name: 'Alice', avatarUrl: 'https://tapback.co/api/avatar/alice'),
        TeamMember(name: 'Bob', avatarUrl: 'https://tapback.co/api/avatar/bob'),
        TeamMember(name: 'Charlie', avatarUrl: 'https://tapback.co/api/avatar/charlie'),
      ],
    );
  }
}

// Модели данных

enum TaskPriority { high, medium, low }

class UserTask {
  final String id;
  final String title;
  final String project;
  final TaskPriority priority;
  final double progress; // 0-100
  final String dueDate;
  
  UserTask({
    required this.id,
    required this.title,
    required this.project,
    required this.priority,
    required this.progress,
    required this.dueDate,
  });
}

class ProjectProgress {
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int overdueTasks;
  final double completionPercentage; // 0-1
  
  ProjectProgress({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.overdueTasks,
    required this.completionPercentage,
  });
}

class Deadline {
  final String id;
  final String title;
  final String description;
  final int daysLeft;
  
  Deadline({
    required this.id,
    required this.title,
    required this.description,
    required this.daysLeft,
  });
}

enum ActivityType {
  taskAdded,
  taskCompleted,
  commentAdded,
  fileUploaded,
  statusChanged,
}

class Activity {
  final String id;
  final ActivityType type;
  final String description;
  final String time;
  
  Activity({
    required this.id,
    required this.type,
    required this.description,
    required this.time,
  });
}

class TeamMember {
  final String name;
  final String avatarUrl;
  
  TeamMember({
    required this.name,
    required this.avatarUrl,
  });
}

class TeamStats {
  final int totalMembers;
  final int activeMembers;
  final double tasksPerMember;
  final List<TeamMember> teamMembers;
  
  TeamStats({
    required this.totalMembers,
    required this.activeMembers,
    required this.tasksPerMember,
    required this.teamMembers,
  });
}