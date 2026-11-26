import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/order_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allOrders = provider.orders;

    final orders = allOrders.where((ord) {
      if (_selectedFilter == 'Awaiting Stock') return ord.status == OrderStatus.awaitingStock;
      if (_selectedFilter == 'Delivered') return ord.status == OrderStatus.delivered;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Awaiting Stock', 'Delivered'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return InkWell(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : const Color(0xFF7A8798),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Text('No orders found.', style: TextStyle(color: AppColors.textMuted)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final ord = orders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ord.id,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
                                  ),
                                  StatusPill(label: ord.status.label),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ord.customerName,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'PO Number: ${ord.poNumber} · ${ord.itemsCount} Line Items',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Order Value', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppFormatters.rupee(ord.totalAmount),
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Dispatch Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppFormatters.date(ord.dispatchDate),
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tracking: ${ord.trackingNumber}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
