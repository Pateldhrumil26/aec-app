import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/order_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import '../../components/app_search_bar.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<String> _filterTabs = const [
    'All',
    'Awaiting Stock',
    'Ready to Pack',
    'Packed',
    'Dispatched',
    'Delivered',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allOrders = provider.orders;

    // Filter by tab
    final tabFiltered = allOrders.where((ord) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Awaiting Stock') return ord.status == OrderStatus.awaitingStock;
      if (_selectedFilter == 'Ready to Pack') return ord.status == OrderStatus.readyToPack;
      if (_selectedFilter == 'Packed') return ord.status == OrderStatus.packed;
      if (_selectedFilter == 'Dispatched') return ord.status == OrderStatus.dispatched;
      if (_selectedFilter == 'Delivered') return ord.status == OrderStatus.delivered;
      return true;
    }).toList();

    // Filter by search query
    final filtered = tabFiltered.where((ord) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return ord.id.toLowerCase().contains(q) ||
          ord.customerName.toLowerCase().contains(q) ||
          ord.poNumber.toLowerCase().contains(q);
    }).toList();

    final activeOrders = allOrders.where((o) => o.status != OrderStatus.delivered).toList();
    final inTransitCount = allOrders.where((o) => o.status == OrderStatus.dispatched).length;
    final readyToPackCount = allOrders.where((o) => o.status == OrderStatus.awaitingStock || o.status == OrderStatus.readyToPack).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Navigator.canPop(context)
          ? AppBar(title: const Text('Orders'))
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Order Book Hero Banner
                ModuleBanner(
                  label: 'ORDER BOOK',
                  title: '${activeOrders.length} active order${activeOrders.length == 1 ? "" : "s"}',
                  description: '$inTransitCount in transit · $readyToPackCount ready to pack',
                  image: 'assets/photography/banner-warehouse-v1.jpg',
                ),
                const SizedBox(height: 14),

                // 2. Search Bar
                AppSearchBar(
                  hintText: 'Search order, company or PO',
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: AppSearchBar.buildActionButton(
                    child: const Tooltip(
                      message: 'Options',
                      child: Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                    ),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Horizontal Filter Tabs (matching prototype)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterTabs.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return InkWell(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected ? const Color(0xFF036E97) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF036E97) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Order Cards List
                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'No orders found matching your search.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  )
                else
                  ...filtered.map((ord) => _buildOrderCard(context, ord)),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel ord) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(orderId: ord.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Delivery truck icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_shipping_rounded,
                  size: 20,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),

              // 2. Middle Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ord.id,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ord.customerName} · PO ${ord.poNumber}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dispatch ${AppFormatters.date(ord.dispatchDate)} · ${AppFormatters.rupee(ord.totalAmount)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildStatusPill(ord.status),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 3. Chevron
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(OrderStatus status) {
    Color bg;
    Color fg;

    switch (status) {
      case OrderStatus.awaitingStock:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        break;
      case OrderStatus.delivered:
        bg = const Color(0xFFEAF5EE);
        fg = const Color(0xFF2D7854);
        break;
      case OrderStatus.dispatched:
        bg = const Color(0xFFE0F2FE);
        fg = const Color(0xFF036E97);
        break;
      case OrderStatus.readyToPack:
      case OrderStatus.packed:
      case OrderStatus.partiallyDispatched:
        bg = const Color(0xFFFFF7ED);
        fg = const Color(0xFFC2410C);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
