class Task {
  final int? id;
  final String title;
  final String description;
  final int isCompleted;
  final String date;
  final String priority;

  Task({this.id, required this.title, required this.description, required this.isCompleted, required this.date, required this.priority});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'date': date,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      date: map['date'],
      priority: map['priority'],
    );
  }
}
