class CustomerModel {
  final String id;
  final String name;
  final String? leadId;
  final String category;
  final String city;
  final String state;
  final String gst;
  final String address;
  final String accountOwner;
  final String asmName;
  final String terms;
  final String kycStatus; // 'Verified', 'Pending Review'
  final String status; // 'Draft', 'Pending Verification', 'Credit Review', 'Approved', 'Active', 'Inactive'
  final double outstandingAmount;
  final double creditLimit;
  final int openQuotesCount;
  final int activeOrdersCount;
  final String keyContact;
  final String phone;
  final String email;

  const CustomerModel({
    required this.id,
    required this.name,
    this.leadId,
    this.category = 'Telecom / Enterprise',
    required this.city,
    required this.state,
    this.gst = '09AAAAA0000A1Z5',
    this.address = 'Industrial Area, Phase 2',
    this.accountOwner = 'John Doe',
    this.asmName = 'Priya Mehta',
    this.terms = '100% Advance',
    this.kycStatus = 'Verified',
    this.status = 'Active',
    this.outstandingAmount = 0.0,
    this.creditLimit = 0.0,
    this.openQuotesCount = 0,
    this.activeOrdersCount = 0,
    this.keyContact = 'Rahul Sharma',
    this.phone = '+91 98765 43210',
    this.email = 'contact@client.example',
  });

  String get company => name;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'AE';
  }
}
