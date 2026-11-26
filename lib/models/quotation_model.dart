enum QuotationStatus {
  draft('Draft'),
  underReview('Under Review'),
  approved('Approved'),
  sentToCustomer('Sent to Customer'),
  accepted('Accepted'),
  rejected('Rejected');

  final String label;
  const QuotationStatus(this.label);
}

class QuotationItem {
  final String sku;
  final String name;
  final String category;
  final double unitRate;
  final int quantity;
  final double discountPercent;

  const QuotationItem({
    required this.sku,
    required this.name,
    required this.category,
    required this.unitRate,
    required this.quantity,
    this.discountPercent = 0.0,
  });

  double get lineTotal {
    final base = unitRate * quantity;
    return base - (base * (discountPercent / 100));
  }
}

class QuotationModel {
  final String id;
  final String proposalNumber;
  final String customerName;
  final String? leadId;
  final DateTime issueDate;
  final DateTime validityDate;
  final QuotationStatus status;
  final List<QuotationItem> items;
  final double freightFee;
  final double gstRate; // e.g. 0.18 for 18%
  final String paymentTerms;
  final String warrantyTerms;
  final String approvalNote;

  const QuotationModel({
    required this.id,
    required this.proposalNumber,
    required this.customerName,
    this.leadId,
    required this.issueDate,
    required this.validityDate,
    required this.status,
    required this.items,
    this.freightFee = 2500,
    this.gstRate = 0.18,
    this.paymentTerms = '100% Advance against PI',
    this.warrantyTerms = '1 Year Standard Manufacturer Warranty',
    this.approvalNote = 'Approved by Area Sales Manager',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get gstAmount => (subtotal + freightFee) * gstRate;
  double get grandTotal => subtotal + freightFee + gstAmount;

  QuotationModel copyWith({
    String? id,
    String? proposalNumber,
    String? customerName,
    String? leadId,
    DateTime? issueDate,
    DateTime? validityDate,
    QuotationStatus? status,
    List<QuotationItem>? items,
    double? freightFee,
    double? gstRate,
    String? paymentTerms,
    String? warrantyTerms,
    String? approvalNote,
  }) {
    return QuotationModel(
      id: id ?? this.id,
      proposalNumber: proposalNumber ?? this.proposalNumber,
      customerName: customerName ?? this.customerName,
      leadId: leadId ?? this.leadId,
      issueDate: issueDate ?? this.issueDate,
      validityDate: validityDate ?? this.validityDate,
      status: status ?? this.status,
      items: items ?? this.items,
      freightFee: freightFee ?? this.freightFee,
      gstRate: gstRate ?? this.gstRate,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      warrantyTerms: warrantyTerms ?? this.warrantyTerms,
      approvalNote: approvalNote ?? this.approvalNote,
    );
  }
}
