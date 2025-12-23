class BoardListObject {
  String id;
  String title;
  List<BoardItemObject> items;

  BoardListObject({
    required this.id,
    required this.title,
    required this.items,
  });
}

enum Difficulty { undefined, easy, medium, hard }
enum EmployeeRole { developer, designer, manager }

class User {
  String id;
  String name;
  String avatarUrl;
  EmployeeRole role;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
  });
}

class BoardItemObject {
  String id;
  String title;
  Difficulty difficulty;
  String date;
  String expirationDate;
  String tasks;
  List<User> assignedUsers = [];

  BoardItemObject({
    required this.id,
    required this.title,
    this.difficulty = Difficulty.undefined,
    required this.date,
    required this.expirationDate,
    required this.tasks,
    required this.assignedUsers,
  });
}