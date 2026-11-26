class MomActionItem {
  final String task;
  final String assignee;
  final DateTime dueDate;
  final bool isDone;

  const MomActionItem({
    required this.task,
    required this.assignee,
    required this.dueDate,
    this.isDone = false,
  });
}

class MomModel {
  final String id;
  final String title;
  final String accountName;
  final DateTime date;
  final List<String> attendees;
  final String agenda;
  final String discussionSummary;
  final List<MomActionItem> actionItems;
  final String status;

  const MomModel({
    required this.id,
    required this.title,
    required this.accountName,
    required this.date,
    required this.attendees,
    required this.agenda,
    required this.discussionSummary,
    required this.actionItems,
    this.status = 'Completed',
  });
}
