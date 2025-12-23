import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/board_item.dart';
import 'package:blueprint/models/board.dart';
import 'package:blueprint/data/users.dart';
import 'package:percent_indicator/percent_indicator.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Темный фон всей страницы
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E), // Темно-серый вместо черного
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.view_kanban_outlined, color: Colors.lightBlue),
            ),
            SizedBox(width: 15),
            Text(
              'Канбан-доска',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[800]!.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      body: BoardViewWidget(),
    );
  }
}

class BoardViewWidget extends StatefulWidget {
  BoardViewWidget({super.key});

  @override
  State<BoardViewWidget> createState() => _BoardViewWidgetState();
}

class _BoardViewWidgetState extends State<BoardViewWidget> {
  final List<User> _users = [
    User(
      id: '1',
      name: 'Radmir',
      avatarUrl: 'https://tapback.co/api/avatar/radmir',
      role: EmployeeRole.developer,
    ),
    User(
      id: '2',
      name: 'Alice',
      avatarUrl: 'https://tapback.co/api/avatar/alice',
      role: EmployeeRole.designer
    ),
    User(
      id: '3',
      name: 'Bob',
      avatarUrl: 'https://tapback.co/api/avatar/bob',
      role: EmployeeRole.manager
    ),
  ];

  late List<BoardListObject> _listData;
  final BoardController _boardViewController = BoardController();
  int _taskIdCounter = 5;

  // Статистика
  late ProjectStatistics _projectStats;

  // Цветовая схема
  final Color _backgroundColor = Color(0xFF1E1E1E);
  final Color _cardBackground = Color(0xFF2D2D2D);
  final Color _textColor = Colors.white;
  final Color _secondaryTextColor = Colors.grey[400]!;
  final Color _accentColor = Colors.lightBlue;
  final Color _hoverColor = Colors.grey[700]!;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _calculateStatistics();
  }

  void _initializeData() {
    _listData = [
      BoardListObject(
        id: '1',
        title: 'To Do',
        items: [
          BoardItemObject(
            id: '1',
            title: 'Design login screen',
            difficulty: Difficulty.medium,
            date: '2024-06-01',
            expirationDate: '2024-06-05',
            tasks: 'Create wireframes and mockups for the login screen.',
            assignedUsers: [_users[0], _users[1]],
          ),
          BoardItemObject(
            id: '2',
            title: 'Set up database',
            difficulty: Difficulty.hard,
            date: '2024-06-02',
            expirationDate: '2024-06-10',
            tasks: 'Install and configure the PostgreSQL database.',
            assignedUsers: [_users[2]],
          ),
        ],
      ),
      BoardListObject(
        id: '2',
        title: 'In Progress',
        items: [
          BoardItemObject(
            id: '3',
            title: 'Implement authentication',
            difficulty: Difficulty.hard,
            date: '2024-06-03',
            expirationDate: '2024-06-15',
            tasks: 'Develop user login and registration functionality.',
            assignedUsers: [_users[0]],
          ),
        ],
      ),
      BoardListObject(
        id: '3',
        title: 'Done',
        items: [
          BoardItemObject(
            id: '4',
            title: 'Project setup',
            difficulty: Difficulty.easy,
            date: '2026-05-28',
            expirationDate: '2026-05-30',
            tasks: 'Initialize project repository and basic structure.',
            assignedUsers: [_users[1], _users[2]],
          ),
        ],
      ),
    ];
  }

  void _calculateStatistics() {
    int totalTasks = 0;
    int doneTasks = 0;
    int inProgressTasks = 0;
    int todoTasks = 0;
    
    for (var list in _listData) {
      totalTasks += list.items.length;
      
      if (list.title == 'Done') {
        doneTasks = list.items.length;
      } else if (list.title == 'In Progress') {
        inProgressTasks = list.items.length;
      } else if (list.title == 'To Do') {
        todoTasks = list.items.length;
      }
    }
    
    double completionPercentage = totalTasks > 0 ? (doneTasks / totalTasks) : 0.0;
    
    String projectStage = _determineProjectStage(todoTasks, inProgressTasks, doneTasks, totalTasks);
    
    _projectStats = ProjectStatistics(
      totalTasks: totalTasks,
      doneTasks: doneTasks,
      inProgressTasks: inProgressTasks,
      todoTasks: todoTasks,
      completionPercentage: completionPercentage,
      projectStage: projectStage,
    );
  }
  
  String _determineProjectStage(int todo, int inProgress, int done, int total) {
    if (total == 0) return 'Не начат';
    
    double doneRatio = done / total;
    double inProgressRatio = inProgress / total;
    
    if (doneRatio >= 0.7) return 'Завершающий этап';
    if (doneRatio >= 0.3 && inProgressRatio > 0) return 'Активная разработка';
    if (inProgressRatio > 0) return 'Начальная стадия';
    if (todo == total) return 'Планирование';
    
    return 'В процессе';
  }

  Future<void> _showAddTaskDialog(int listIndex) async {
    String title = '';
    String description = '';
    Difficulty selectedDifficulty = Difficulty.medium;
    DateTime selectedDate = DateTime.now();
    DateTime selectedExpirationDate = DateTime.now().add(Duration(days: 7));
    List<User> selectedUsers = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: _backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: _accentColor),
                          SizedBox(width: 12),
                          Text(
                            'Добавить новую задачу',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      
                      // Название задачи
                      Text(
                        'Название задачи',
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!, width: 1),
                        ),
                        child: TextField(
                          style: TextStyle(color: _textColor),
                          decoration: InputDecoration(
                            hintText: 'Введите название задачи',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onChanged: (value) => title = value,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Описание задачи
                      Text(
                        'Описание задачи',
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!, width: 1),
                        ),
                        child: TextField(
                          style: TextStyle(color: _textColor),
                          decoration: InputDecoration(
                            hintText: 'Опишите задачу подробнее...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          maxLines: 3,
                          onChanged: (value) => description = value,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Сложность
                      Text(
                        'Сложность',
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: _cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<Difficulty>(
                            value: selectedDifficulty,
                            isExpanded: true,
                            underline: SizedBox(),
                            dropdownColor: _cardBackground,
                            style: TextStyle(color: _textColor),
                            items: Difficulty.values.map((difficulty) {
                              return DropdownMenuItem(
                                value: difficulty,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: difficultyColor(difficulty),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(_difficultyText(difficulty)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedDifficulty = value);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Даты
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Дата начала',
                                  style: TextStyle(
                                    color: _secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: _cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700]!, width: 1),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                    leading: Icon(Icons.calendar_today, color: _accentColor, size: 20),
                                    title: Text(
                                      '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                                      style: TextStyle(color: _textColor),
                                    ),
                                    onTap: () async {
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                primary: _accentColor,
                                                surface: _backgroundColor,
                                              ),
                                              dialogBackgroundColor: _backgroundColor,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null && picked != selectedDate) {
                                        setState(() => selectedDate = picked);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Срок выполнения',
                                  style: TextStyle(
                                    color: _secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: _cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700]!, width: 1),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                    leading: Icon(Icons.flag, color: Colors.orange, size: 20),
                                    title: Text(
                                      '${selectedExpirationDate.day}.${selectedExpirationDate.month}.${selectedExpirationDate.year}',
                                      style: TextStyle(color: _textColor),
                                    ),
                                    onTap: () async {
                                      final DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: selectedExpirationDate,
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2030),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                primary: _accentColor,
                                                surface: _backgroundColor,
                                              ),
                                              dialogBackgroundColor: _backgroundColor,
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (picked != null && picked != selectedExpirationDate) {
                                        setState(() => selectedExpirationDate = picked);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Пользователи
                      Container(
                        decoration: BoxDecoration(
                          color: _cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!, width: 1),
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            'Назначенные пользователи (${selectedUsers.length})',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            color: _accentColor,
                          ),
                          children: _users.map((user) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 32),
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: NetworkImage(user.avatarUrl),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: TextStyle(color: _textColor),
                                      ),
                                      Text(
                                        _roleText(user.role),
                                        style: TextStyle(color: _secondaryTextColor, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              activeColor: _accentColor,
                              checkColor: _textColor,
                              value: selectedUsers.contains(user),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedUsers.add(user);
                                  } else {
                                    selectedUsers.remove(user);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Кнопки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[700]!, width: 1),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Отмена',
                                style: TextStyle(color: _secondaryTextColor),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_accentColor, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: _accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (title.isNotEmpty && description.isNotEmpty) {
                                  Navigator.of(context).pop(true);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              ),
                              child: Text(
                                'Добавить задачу',
                                style: TextStyle(
                                  color: _textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value == true) {
        _addNewTask(
          listIndex,
          title,
          description,
          selectedDifficulty,
          selectedDate,
          selectedExpirationDate,
          selectedUsers,
        );
      }
    });
  }

  void _addNewTask(
    int listIndex,
    String title,
    String description,
    Difficulty difficulty,
    DateTime date,
    DateTime expirationDate,
    List<User> assignedUsers,
  ) {
    setState(() {
      final newTask = BoardItemObject(
        id: (_taskIdCounter++).toString(),
        title: title,
        difficulty: difficulty,
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        expirationDate: '${expirationDate.year}-${expirationDate.month.toString().padLeft(2, '0')}-${expirationDate.day.toString().padLeft(2, '0')}',
        tasks: description,
        assignedUsers: assignedUsers,
      );

      _listData[listIndex].items.add(newTask);
      _calculateStatistics();
    });
  }

  String _roleText(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.developer:
        return 'Разработчик';
      case EmployeeRole.designer:
        return 'Дизайнер';
      case EmployeeRole.manager:
        return 'Менеджер';
      }
  }

  @override
  Widget build(BuildContext context) {
    _calculateStatistics();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Основная доска
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildBoardView(),
          ),
        ),
        
        // Панель статистики
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: _buildStatisticsPanel(),
          ),
        ),
      ],
    );
  }

  Widget _buildBoardView() {
    List<BoardList> lists = <BoardList>[];

    for (int i = 0; i < _listData.length; i++) {
      lists.add(_createBoardList(_listData[i], i));
    }

    return BoardView(
      width: 350,
      dragDelay: 10,
      lists: lists,
      boardController: _boardViewController,
    );
  }

  Widget _buildStatisticsPanel() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.analytics, color: _accentColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'Статистика проекта',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Круговая диаграмма
          Center(
            child: CircularPercentIndicator(
              radius: 80,
              lineWidth: 14,
              percent: _projectStats.completionPercentage,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_projectStats.completionPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'готово',
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              progressColor: _accentColor,
              backgroundColor: Colors.grey[800]!,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animateFromLastPercent: true,
            ),
          ),
          SizedBox(height: 24),
          
          // Информация о готовности
          _buildInfoCard(
            title: 'Готовность проекта',
            value: '${_projectStats.doneTasks} из ${_projectStats.totalTasks} задач',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          ),
          SizedBox(height: 16),
          
          // Статус проекта
          _buildInfoCard(
            title: 'Этап проекта',
            value: _projectStats.projectStage,
            icon: _getStageIcon(_projectStats.projectStage),
            iconColor: _getStageColor(_projectStats.projectStage),
          ),
          SizedBox(height: 24),
          
          // Детали по задачам
          Text(
            'Распределение задач',
            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12),
          
          _buildTaskStatItem('To Do', _projectStats.todoTasks, Colors.orange),
          SizedBox(height: 8),
          _buildTaskStatItem('In Progress', _projectStats.inProgressTasks, Colors.blue),
          SizedBox(height: 8),
          _buildTaskStatItem('Done', _projectStats.doneTasks, Colors.green),
          
          Spacer(),
          
          // Информация о сложности
          _buildInfoCard(
            title: 'Средняя сложность',
            value: _calculateAverageDifficulty(),
            icon: Icons.auto_graph,
            iconColor: _calculateAverageColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color iconColor}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatItem(String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: _textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: _textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _calculateAverageColor() {
    String difficulty = _calculateAverageDifficulty();
    switch (difficulty) {
      case 'Легко':
        return Colors.green;
      case 'Средне':
        return Colors.orange;
      case 'Сложно':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _calculateAverageDifficulty() {
    if (_projectStats.totalTasks == 0) return 'Нет задач';
    
    int totalScore = 0;
    for (var list in _listData) {
      for (var item in list.items) {
        switch (item.difficulty) {
          case Difficulty.easy:
            totalScore += 1;
            break;
          case Difficulty.medium:
            totalScore += 2;
            break;
          case Difficulty.hard:
            totalScore += 3;
            break;
          case Difficulty.undefined:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }
    }
    
    double average = totalScore / _projectStats.totalTasks;
    if (average < 1.5) return 'Легко';
    if (average < 2.5) return 'Средне';
    return 'Сложно';
  }

  IconData _getStageIcon(String stage) {
    switch (stage) {
      case 'Не начат':
        return Icons.not_started;
      case 'Планирование':
        return Icons.edit_document;
      case 'Начальная стадия':
        return Icons.play_arrow;
      case 'Активная разработка':
        return Icons.trending_up;
      case 'Завершающий этап':
        return Icons.flag;
      default:
        return Icons.autorenew;
    }
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'Не начат':
        return Colors.grey;
      case 'Планирование':
        return Colors.blue;
      case 'Начальная стадия':
        return Colors.orange;
      case 'Активная разработка':
        return _accentColor;
      case 'Завершающий этап':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  BoardList _createBoardList(BoardListObject listObject, int listIndex) {
    List<BoardItem> items = <BoardItem>[];
    for (int i = 0; i < listObject.items.length; i++) {
      items.insert(i, buildBoardItem(listObject.items[i], listIndex, i));
    }

    // Определяем цвет заголовка в зависимости от списка
    Color headerColor;
    switch (listObject.title) {
      case 'To Do':
        headerColor = const Color.fromARGB(200, 255, 152, 0);
        break;
      case 'In Progress':
        headerColor = Colors.blue.withOpacity(0.9);
        break;
      case 'Done':
        headerColor = Colors.green.withOpacity(0.9);
        break;
      default:
        headerColor = _accentColor;
    }

    return BoardList(
      draggable: false,
      headerBackgroundColor: Colors.transparent,
      backgroundColor: _cardBackground,
      header: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              //color: headerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  listObject.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${listObject.items.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _showAddTaskDialog(listIndex),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
      footer: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showAddTaskDialog(listIndex),
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: _accentColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Добавить задачу',
                    style: TextStyle(
                      color: _accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      items: items,
    );
  }

  Color difficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int daysToDeadline(String expirationDate) {
    DateTime now = DateTime.now();
    DateTime deadline = DateTime.parse(expirationDate);
    return deadline.difference(now).inDays;
  }

  String difficultyText(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Легко';
      case Difficulty.medium:
        return 'Средне';
      case Difficulty.hard:
        return 'Сложно';
      default:
        return 'Неопределено';
    }
  }

  String _difficultyText(Difficulty difficulty) {
    return difficultyText(difficulty);
  }

  Future<void> onDropItem(
    int? listIndex,
    int? itemIndex,
    int? oldListIndex,
    int? oldItemIndex,
  ) async {
    if (listIndex == null ||
        itemIndex == null ||
        oldListIndex == null ||
        oldItemIndex == null) {
      return;
    }

    var item = _listData[oldListIndex].items[oldItemIndex];

    setState(() {
      _listData[oldListIndex].items.removeAt(oldItemIndex);
      _listData[listIndex].items.insert(itemIndex, item);
      _calculateStatistics();
    });
  }

  BoardItem buildBoardItem(
    BoardItemObject itemObject,
    int listIndex,
    int itemIndex,
  ) {
    return BoardItem(
      onStartDragItem: (listIndex, itemIndex, state) {},
      onDropItem: (listIndex, itemIndex, oldListIndex, oldItemIndex, state) async {
        await onDropItem(
          listIndex,
          itemIndex,
          oldListIndex,
          oldItemIndex,
        );
      },
      onTapItem: (listIndex, itemIndex, state) {},
      item: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Card(
            color: _backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[800]!, width: 1),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: difficultyColor(itemObject.difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: difficultyColor(itemObject.difficulty),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          difficultyText(itemObject.difficulty),
                          style: TextStyle(
                            color: difficultyColor(itemObject.difficulty),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: daysToDeadline(itemObject.expirationDate) <= 0
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: daysToDeadline(itemObject.expirationDate) <= 0
                                ? Colors.red
                                : Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          daysToDeadline(itemObject.expirationDate) <= 0
                              ? 'Просрочено'
                              : '${daysToDeadline(itemObject.expirationDate)} дн.',
                          style: TextStyle(
                            color: daysToDeadline(itemObject.expirationDate) <= 0
                                ? Colors.red
                                : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    itemObject.title,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    itemObject.tasks,
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: -8,
                        children: itemObject.assignedUsers.map((user) {
                          return Tooltip(
                            message: '${user.name} (${_roleText(user.role)})',
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _backgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(user.avatarUrl),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Icon(
                        Icons.drag_indicator,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectStatistics {
  final int totalTasks;
  final int doneTasks;
  final int inProgressTasks;
  final int todoTasks;
  final double completionPercentage;
  final String projectStage;

  ProjectStatistics({
    required this.totalTasks,
    required this.doneTasks,
    required this.inProgressTasks,
    required this.todoTasks,
    required this.completionPercentage,
    required this.projectStage,
  });
}