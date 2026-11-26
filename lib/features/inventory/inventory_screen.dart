import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/module_banner.dart';
import '../orders/orders_screen.dart';
import 'product_stock_detail_screen.dart';
import 'inward_qc_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, dynamic>> products = [
    {
      'sku': 'AEC-FOC-24C-SM',
      'name': '24-Core Single Mode Armored Cable',
      'category': 'Fiber Cable',
      'physical': '12,500 m',
      'reserved': '2,000 m',
      'available': '10,500 m',
      'status': 'In Stock',
      'minAlert': '3,000 m',
    },
    {
      'sku': 'AEC-FOC-48C-SM',
      'name': '48-Core Outdoor Single Mode Drum',
      'category': 'Fiber Cable',
      'physical': '4,000 m',
      'reserved': '3,500 m',
      'available': '500 m',
      'status': 'Low Stock',
      'minAlert': '2,000 m',
    },
    {
      'sku': 'AEC-SFP-10G-LR',
      'name': '10G SFP+ Optical Transceiver 1310nm',
      'category': 'Networking',
      'physical': '140 units',
      'reserved': '20 units',
      'available': '120 units',
      'status': 'In Stock',
      'minAlert': '25 units',
    },
    {
      'sku': 'AEC-ODF-48P',
      'name': '48-Port Rack Mount ODF',
      'category': 'Accessories',
      'physical': '0 units',
      'reserved': '10 units',
      'available': '0 units',
      'status': 'Out of Stock',
      'minAlert': '15 units',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory & Stock Control'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF137265),
          unselectedLabelColor: const Color(0xFF7A8798),
          indicatorColor: const Color(0xFF137265),
          indicatorWeight: 2.0,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Reservations'),
            Tab(text: 'Cable & Drums'),
            Tab(text: 'Inward & QC'),
            Tab(text: 'Movements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(),
          _buildReservationsTab(),
          _buildCableDrumsTab(),
          _buildInwardQcTab(),
          _buildMovementsTab(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ModuleBanner(
          label: 'STOCK CONTROL',
          title: 'Stock is available',
          description: '1 low-stock products · 4 active SKUs',
          image: 'assets/photography/banner-warehouse-v1.jpg',
          actionLabel: 'Sales orders',
          actionIcon: Icons.local_shipping_outlined,
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen()),
          ),
        ),
        const SizedBox(height: 14),

        // Formula Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.calculate_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Available stock = Physical − Reserved',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Product Cards
        ...products.map((p) {
          final isLow = p['status'] == 'Low Stock';
          final isOut = p['status'] == 'Out of Stock';

          Color badgeBg = AppColors.statusSuccessBg;
          Color badgeFg = AppColors.statusSuccessFg;
          if (isLow) {
            badgeBg = AppColors.statusWarningBg;
            badgeFg = AppColors.statusWarningFg;
          } else if (isOut) {
            badgeBg = AppColors.kpiDangerBg;
            badgeFg = AppColors.kpiDangerFg;
          }

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductStockDetailScreen(productId: p['sku'] as String),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p['sku'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                          child: Text(p['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeFg)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(p['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricCol('Physical', p['physical'] as String),
                        _buildMetricCol('Reserved', p['reserved'] as String),
                        _buildMetricCol('Available', p['available'] as String, isPrimary: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMetricCol(String label, String val, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isPrimary ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildReservationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.bookmark_added_rounded, color: AppColors.primary),
            title: Text('ORD-2026-0001 · Acme Technologies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Held: 2,000m 24C Cable + 4x 10G SFP+ modules'),
            trailing: Text('Dispatch Due: 3d', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kpiFollowupsFg)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.bookmark_added_rounded, color: AppColors.primary),
            title: Text('QT-2026-0002 · Bharat Infotech', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Reserved: 3,500m 48C Cable (Waiting for PO)'),
            trailing: Text('Valid: 25d', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildCableDrumsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.blur_circular_rounded, color: AppColors.primary),
            title: Text('Drum #DRM-24C-0082 (Batch B26-11)'),
            subtitle: Text('Full Length: 4,000m · Cut Remaining: 3,250m'),
            trailing: Text('Location: Bay A-4', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.blur_circular_rounded, color: AppColors.primary),
            title: Text('Drum #DRM-48C-0019 (Batch B26-10)'),
            subtitle: Text('Full Length: 2,000m · Cut Remaining: 500m'),
            trailing: Text('Location: Bay B-1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildInwardQcTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InwardQcDetailScreen(inwardId: 'inw1')),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: const Card(
            child: ListTile(
              leading: Icon(Icons.verified_rounded, color: AppColors.statusSuccessFg),
              title: Text('GRN-2026-0104 · Factory Dispatch Batch 9'),
              subtitle: Text('50x 10G SFP+ Modules · QC Passed 100%'),
              trailing: Text('Stocked', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.statusSuccessFg)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovementsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.outbox_rounded, color: AppColors.kpiDangerFg),
            title: Text('Dispatched · ORD-2026-0002 to Metro Rail Telecom'),
            subtitle: Text('VRL Logistics #TRK-VRL-990142 · 24 Items'),
            trailing: Text('25 Nov 2026', style: TextStyle(fontSize: 11)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.move_to_inbox_rounded, color: AppColors.statusSuccessFg),
            title: Text('Inward Stock Received from Plant A'),
            subtitle: Text('10 Drums 24-Core Single Mode · 10,000m'),
            trailing: Text('24 Nov 2026', style: TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }
}
