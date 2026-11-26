class NotificationModel {
  final String id;
  final String title;
  final String text;
  final DateTime at;
  final bool isRead;
  final String? page;
  final String? recordId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.text,
    required this.at,
    this.isRead = false,
    this.page,
    this.recordId,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? text,
    DateTime? at,
    bool? isRead,
    String? page,
    String? recordId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      at: at ?? this.at,
      isRead: isRead ?? this.isRead,
      page: page ?? this.page,
      recordId: recordId ?? this.recordId,
    );
  }
}
