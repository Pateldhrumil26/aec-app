enum TaskPriority {
  high('High'),
  medium('Medium'),
  low('Low');

  final String label;
  const TaskPriority(this.label);
}

enum TaskCategory {
  call('Call'),
  email('Email'),
  meeting('Meeting'),
  document('Document');

  final String label;
  const TaskCategory(this.label);
}

class TaskModel {
  final String id;
  final String title;
  final String accountName;
  final String? leadId;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final bool isCompleted;
  final String? notes;

  const TaskModel({
    required this.id,
    required this.title,
    required this.accountName,
    this.leadId,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    this.notes,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? accountName,
    String? leadId,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    bool? isCompleted,
    String? notes,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      accountName: accountName ?? this.accountName,
      leadId: leadId ?? this.leadId,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
