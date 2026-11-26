enum TaskPriority {
  high('High'),
  medium('Medium'),
  low('Low');

  final String label;
  const TaskPriority(this.label);

  static TaskPriority fromString(String val) {
    final lower = val.toLowerCase();
    if (lower == 'high') return TaskPriority.high;
    if (lower == 'low') return TaskPriority.low;
    return TaskPriority.medium;
  }
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
  final String time;
  final String taskType;
  final String assignedTo;
  final TaskPriority priority;
  final bool isCompleted;
  final String? notes;

  const TaskModel({
    required this.id,
    required this.title,
    required this.accountName,
    this.leadId,
    required this.dueDate,
    this.time = '10:00',
    this.taskType = 'Call',
    this.assignedTo = 'John Doe',
    required this.priority,
    TaskCategory? category,
    this.isCompleted = false,
    this.notes,
  });

  TaskCategory get category {
    final t = taskType.toLowerCase();
    if (t == 'visit') return TaskCategory.meeting;
    if (t == 'meeting') return TaskCategory.meeting;
    if (t == 'email') return TaskCategory.email;
    if (t == 'document') return TaskCategory.document;
    return TaskCategory.call;
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? accountName,
    String? leadId,
    DateTime? dueDate,
    String? time,
    String? taskType,
    String? assignedTo,
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
      time: time ?? this.time,
      taskType: taskType ?? this.taskType,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
