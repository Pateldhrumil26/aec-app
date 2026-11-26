enum VisitStatus {
  active('Active'),
  awaitingSummary('Awaiting Summary'),
  completed('Completed');

  final String label;
  const VisitStatus(this.label);
}

class VisitModel {
  final String id;
  final String leadId;
  final String companyName;
  final String contactPerson;
  final String purpose;
  final bool isGpsVerified;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int durationSeconds;
  final VisitStatus status;
  final String? outcome;
  final String? discussionNotes;
  final DateTime? nextFollowUp;

  const VisitModel({
    required this.id,
    required this.leadId,
    required this.companyName,
    required this.contactPerson,
    required this.purpose,
    required this.isGpsVerified,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.checkInTime,
    this.checkOutTime,
    required this.durationSeconds,
    required this.status,
    this.outcome,
    this.discussionNotes,
    this.nextFollowUp,
  });

  VisitModel copyWith({
    String? id,
    String? leadId,
    String? companyName,
    String? contactPerson,
    String? purpose,
    bool? isGpsVerified,
    String? locationAddress,
    double? latitude,
    double? longitude,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? durationSeconds,
    VisitStatus? status,
    String? outcome,
    String? discussionNotes,
    DateTime? nextFollowUp,
  }) {
    return VisitModel(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      purpose: purpose ?? this.purpose,
      isGpsVerified: isGpsVerified ?? this.isGpsVerified,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      status: status ?? this.status,
      outcome: outcome ?? this.outcome,
      discussionNotes: discussionNotes ?? this.discussionNotes,
      nextFollowUp: nextFollowUp ?? this.nextFollowUp,
    );
  }
}
