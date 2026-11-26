import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/module_banner.dart';
import '../../components/app_search_bar.dart';
import '../../core/rbac/role_guard.dart';
import '../../models/permission.dart';
import '../orders/orders_screen.dart';
import 'product_stock_detail_screen.dart';
import 'inward_qc_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedCategoryTab = 'Products';
  String _selectedStatusFilter = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  static const List<String> _categoryTabs = [
    'Products',
    'Reservations',
    'Cable & drums',
    'Inward & QC',
    'Movements',
  ];

  static const List<String> _statusFilters = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

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
    {
      'sku': 'AEC-PC-LC-SC-3M',
      'name': 'Optical Patch Cord LC-SC Duplex 3M',
      'category': 'Accessories',
      'physical': '450 units',
      'reserved': '50 units',
      'available': '400 units',
      'status': 'In Stock',
      'minAlert': '100 units',
    },
    {
      'sku': 'AEC-PLC-1X8-SC',
      'name': 'PLC Optical Splitter 1x8 SC/APC',
      'category': 'Fiber Accessories',
      'physical': '280 units',
      'reserved': '30 units',
      'available': '250 units',
      'status': 'In Stock',
      'minAlert': '40 units',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter products by status
    final statusFiltered = products.where((p) {
      if (_selectedStatusFilter == 'All') return true;
      return p['status'] == _selectedStatusFilter;
    }).toList();

    // Filter products by search query
    final filteredProducts = statusFiltered.where((p) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      final sku = (p['sku'] as String).toLowerCase();
      final name = (p['name'] as String).toLowerCase();
      final category = (p['category'] as String).toLowerCase();
      return sku.contains(q) || name.contains(q) || category.contains(q);
    }).toList();

    return RoleGuard(
      feature: AppFeature.inventory,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: Navigator.canPop(context)
            ? AppBar(title: const Text('Inventory'))
            : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Page Header (Title + Record movement button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                          color: AppColors.navy,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Record movement feature opened.')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF036E97),
                          side: const BorderSide(color: Color(0xFFCCE3FD), width: 1),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Record movement',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Stock Control Hero Banner
                  ModuleBanner(
                    label: 'STOCK CONTROL',
                    title: '1 product needs restocking',
                    description: '1 low-stock products · 6 active SKUs',
                    image: 'assets/photography/banner-warehouse-v1.jpg',
                    actionLabel: 'Sales orders',
                    actionIcon: Icons.receipt_long_outlined,
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Formula Caption Text
                  const Text(
                    'Available stock = physical - reserved',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),

                  // 4. 3 KPI Stat Cards Row (In Stock, Low Stock, Out of Stock)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStockKpiCard(
                          count: '4',
                          label: 'In Stock',
                          subtext: 'active products',
                          numColor: const Color(0xFF15803D),
                          bgColor: const Color(0xFFF0FDF4),
                          borderColor: const Color(0xFFDCFCE7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStockKpiCard(
                          count: '1',
                          label: 'Low Stock',
                          subtext: 'active product',
                          numColor: const Color(0xFFB45309),
                          bgColor: const Color(0xFFFFFBEB),
                          borderColor: const Color(0xFFFEF3C7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStockKpiCard(
                          count: '1',
                          label: 'Out of Stock',
                          subtext: 'active product',
                          numColor: const Color(0xFFBE123C),
                          bgColor: const Color(0xFFFFF1F2),
                          borderColor: const Color(0xFFFFE4E6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 5. Category Navigation Tabs (Products, Reservations, Cable & drums, Inward & QC, Movements)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categoryTabs.map((tab) {
                        final isSelected = _selectedCategoryTab == tab;
                        return InkWell(
                          onTap: () => setState(() => _selectedCategoryTab = tab),
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
                              tab,
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
                  const SizedBox(height: 16),

                  // 6. Tab Content Switcher
                  if (_selectedCategoryTab == 'Products') ...[
                    // Procurement demand Quick Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Procurement demand: 2 items pending review.')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.bar_chart_rounded,
                                  size: 20,
                                  color: Color(0xFF036E97),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Procurement demand',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '2 items to review',
                                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Search Bar
                    AppSearchBar(
                      hintText: 'Search product name, SKU or lifecycle',
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      actionButton: AppSearchBar.buildActionButton(
                        child: const Tooltip(
                          message: 'Filter',
                          child: Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                        ),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Status Filter Row (All, In Stock, Low Stock, Out of Stock)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _statusFilters.map((st) {
                          final isSelected = _selectedStatusFilter == st;
                          return InkWell(
                            onTap: () => setState(() => _selectedStatusFilter = st),
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
                                st,
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

                    // Product Cards
                    if (filteredProducts.isEmpty)
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
                            'No products matching your search.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      )
                    else
                      ...filteredProducts.map((p) => _buildProductCard(context, p)),
                  ] else if (_selectedCategoryTab == 'Reservations') ...[
                    _buildReservationsTab(),
                  ] else if (_selectedCategoryTab == 'Cable & drums') ...[
                    _buildCableDrumsTab(),
                  ] else if (_selectedCategoryTab == 'Inward & QC') ...[
                    _buildInwardQcTab(context),
                  ] else if (_selectedCategoryTab == 'Movements') ...[
                    _buildMovementsTab(),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockKpiCard({
    required String count,
    required String label,
    required String subtext,
    required Color numColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: numColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> p) {
    final isLow = p['status'] == 'Low Stock';
    final isOut = p['status'] == 'Out of Stock';

    Color badgeBg = const Color(0xFFEAF5EE);
    Color badgeFg = const Color(0xFF2D7854);
    if (isLow) {
      badgeBg = const Color(0xFFFEF3C7);
      badgeFg = const Color(0xFFB45309);
    } else if (isOut) {
      badgeBg = const Color(0xFFFCECEF);
      badgeFg = const Color(0xFFBE123C);
    }

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
              builder: (_) => ProductStockDetailScreen(productId: p['sku'] as String),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    p['sku'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      p['status'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: badgeFg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                p['name'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
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
  }

  Widget _buildMetricCol(String label, String val, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isPrimary ? AppColors.primary : AppColors.navy,
          ),
        ),
      ],
    );
  }

  Widget _buildReservationsTab() {
    return Column(
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.bookmark_added_rounded, color: AppColors.primary),
            title: Text('ORD-2026-0001 · Bright Infra Solutions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Held: 2,000m 24C Cable + 4x 10G SFP+ modules'),
            trailing: Text('Dispatch Due: 3d', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
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
    return Column(
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

  Widget _buildInwardQcTab(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InwardQcDetailScreen(inwardId: 'inw1')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: const Card(
        child: ListTile(
          leading: Icon(Icons.verified_rounded, color: Color(0xFF15803D)),
          title: Text('GRN-2026-0104 · Factory Dispatch Batch 9'),
          subtitle: Text('50x 10G SFP+ Modules · QC Passed 100%'),
          trailing: Text('Stocked', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
        ),
      ),
    );
  }

  Widget _buildMovementsTab() {
    return Column(
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.outbox_rounded, color: Color(0xFFBE123C)),
            title: Text('Dispatched · ORD-2026-0002 to Metro Rail Telecom'),
            subtitle: Text('VRL Logistics #TRK-VRL-990142 · 24 Items'),
            trailing: Text('25 Nov 2026', style: TextStyle(fontSize: 11)),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.move_to_inbox_rounded, color: Color(0xFF15803D)),
            title: Text('Inward Stock Received from Plant A'),
            subtitle: Text('10 Drums 24-Core Single Mode · 10,000m'),
            trailing: Text('24 Nov 2026', style: TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }
}
