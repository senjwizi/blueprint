// models/task_model.dart
class Task {
  final String id;
  String title;
  String description;
  DateTime createdAt;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });
}

enum TaskStatus {
  todo('Задачи'),
  inProgress('В процессе'),
  done('Выполнено');

  final String title;
  const TaskStatus(this.title);
}