class CustomerModel {
  final String id;
  final String name;
  final String category;
  final String city;
  final String state;
  final double outstandingAmount;
  final double creditLimit;
  final int openQuotesCount;
  final int activeOrdersCount;
  final String keyContact;
  final String phone;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.state,
    required this.outstandingAmount,
    required this.creditLimit,
    required this.openQuotesCount,
    required this.activeOrdersCount,
    required this.keyContact,
    required this.phone,
  });
}
