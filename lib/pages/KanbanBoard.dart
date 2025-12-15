import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;

  Task({required this.id, required this.title});
}

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final Map<String, List<Task>> columns = {
    'Задачи': [
      Task(id: '1', title: 'Сделать дизайн'),
      Task(id: '2', title: 'Настроить проект'),
    ],
    'В процессе': [
      Task(id: '3', title: 'Верстка экрана'),
    ],
    'Выполнено': [
      Task(id: '4', title: 'Создать репозиторий'),
    ],
  };

  void _moveTask(Task task, String from, String to, int index) {
    setState(() {
      columns[from]!.removeWhere((t) => t.id == task.id);
      columns[to]!.insert(index, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kanban Board')),
      body: Row(
        children: columns.entries.map((entry) {
          return Expanded(
            child: KanbanColumn(
              title: entry.key,
              tasks: entry.value,
              onTaskDropped: (task, from, index) {
                _moveTask(task, from, entry.key, index);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final void Function(Task task, String from, int index) onTaskDropped;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.onTaskDropped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return DragTarget<Map<String, dynamic>>(
                    onAccept: (data) {
                      onTaskDropped(data['task'], data['from'], index);
                    },
                    builder: (_, __, ___) => const SizedBox(height: 40),
                  );
                }

                final task = tasks[index];
                return DragTarget<Map<String, dynamic>>(
                  onAccept: (data) {
                    onTaskDropped(data['task'], data['from'], index);
                  },
                  builder: (_, __, ___) {
                    return Draggable<Map<String, dynamic>>(
                      data: {'task': task, 'from': title},
                      feedback: Material(
                        child: TaskCard(task: task, isDragging: true),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: TaskCard(task: task),
                      ),
                      child: TaskCard(task: task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDragging;

  const TaskCard({
    super.key,
    required this.task,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDragging ? 8 : 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(task.title),
      ),
    );
  }
}
