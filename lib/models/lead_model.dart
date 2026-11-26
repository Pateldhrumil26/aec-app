enum LeadStage {
  all('All'),
  newLead('New'),
  qualification('Qualification'),
  contacted('Contacted'),
  qualified('Qualified'),
  discovery('Discovery'),
  proposal('Proposal'),
  negotiation('Negotiation'),
  closedWon('Closed Won'),
  closedLost('Closed Lost');

  final String label;
  const LeadStage(this.label);
}

class LeadModel {
  final String id;
  final String initials;
  final String companyName;
  final String contactPerson;
  final String designation;
  final String phone;
  final String email;
  final String industry;
  final String city;
  final String state;
  final String address;
  final String gstNumber;
  final LeadStage stage;
  final double estimatedValue;
  final String source;
  final String salesRep;
  final String asm;
  final String notes;
  final DateTime createdAt;
  final String? activeQuotationId;

  bool get isUnassigned => salesRep.isEmpty || salesRep.toLowerCase().contains('unassigned');
  String get ownerName => isUnassigned ? 'Unassigned' : (salesRep.contains('(') ? salesRep.split('(')[0].trim() : salesRep);

  const LeadModel({
    required this.id,
    required this.initials,
    required this.companyName,
    required this.contactPerson,
    required this.designation,
    required this.phone,
    required this.email,
    required this.industry,
    required this.city,
    required this.state,
    required this.address,
    required this.gstNumber,
    required this.stage,
    required this.estimatedValue,
    required this.source,
    required this.salesRep,
    required this.asm,
    required this.notes,
    required this.createdAt,
    this.activeQuotationId,
  });

  LeadModel copyWith({
    String? id,
    String? initials,
    String? companyName,
    String? contactPerson,
    String? designation,
    String? phone,
    String? email,
    String? industry,
    String? city,
    String? state,
    String? address,
    String? gstNumber,
    LeadStage? stage,
    double? estimatedValue,
    String? source,
    String? salesRep,
    String? asm,
    String? notes,
    DateTime? createdAt,
    String? activeQuotationId,
  }) {
    return LeadModel(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      designation: designation ?? this.designation,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      industry: industry ?? this.industry,
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      stage: stage ?? this.stage,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      source: source ?? this.source,
      salesRep: salesRep ?? this.salesRep,
      asm: asm ?? this.asm,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      activeQuotationId: activeQuotationId ?? this.activeQuotationId,
    );
  }
}
