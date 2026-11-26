enum OrderStatus {
  awaitingStock('Awaiting Stock'),
  partiallyDispatched('Partially Dispatched'),
  dispatched('Dispatched'),
  delivered('Delivered');

  final String label;
  const OrderStatus(this.label);
}

class OrderModel {
  final String id;
  final String customerName;
  final String poNumber;
  final DateTime orderDate;
  final DateTime dispatchDate;
  final double totalAmount;
  final OrderStatus status;
  final int itemsCount;
  final String trackingNumber;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.poNumber,
    required this.orderDate,
    required this.dispatchDate,
    required this.totalAmount,
    required this.status,
    required this.itemsCount,
    required this.trackingNumber,
  });
}
