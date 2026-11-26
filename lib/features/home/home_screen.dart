import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../models/order_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../leads/lead_form_screen.dart';
import '../visits/visit_form_screen.dart';
import '../visits/active_visit_screen.dart';
import '../quotations/quotations_screen.dart';
import '../quotations/quotation_builder_screen.dart';
import '../orders/orders_screen.dart';
import '../collections/collections_screen.dart';
import '../moms/moms_screen.dart';
import '../inventory/inventory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final role = provider.currentRole;

    if (role == UserRole.manager) {
      return _buildManagerDashboard(context, provider);
    } else if (role == UserRole.warehouse) {
      return _buildWarehouseDashboard(context, provider);
    }
    return _buildEmployeeDashboard(context, provider);
  }

  // ==========================================
  // 1. EMPLOYEE DASHBOARD (Matches Prototype Exact)
  // ==========================================
  Widget _buildEmployeeDashboard(BuildContext context, AEConnectProvider provider) {
    final orders = provider.orders;
    final activeVisit = provider.activeVisit;
    final leads = provider.leads;
    final quotes = provider.quotations;
    final tasks = provider.tasks.where((t) => !t.isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Head: Sales overview + Date + New lead button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('d MMM yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadFormScreen()),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New lead'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  minimumSize: const Size(0, 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Banner KPI Hero (.banner-kpi in prototype)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D9AAD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'AE CONNECT / SALES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Color(0xFF7E8B96),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hello, John.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tasks.length} follow-ups due · ${orders.where((o) => o.status != OrderStatus.delivered).length} active order',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VisitFormScreen()),
                  ),
                  icon: const Icon(Icons.location_on_outlined, size: 16),
                  label: const Text('Log a visit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. 4 KPI Metrics
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'Open leads',
                        value: leads.length.toString(),
                        onTap: () => provider.setTabIndex(1),
                        borderRight: true,
                        borderBottom: true,
                      ),
                    ),
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'Follow-ups due',
                        value: tasks.length.toString(),
                        onTap: () => provider.setTabIndex(3),
                        borderRight: false,
                        borderBottom: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'Open quotations',
                        value: quotes.length.toString(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuotationsScreen()),
                        ),
                        borderRight: true,
                        borderBottom: false,
                      ),
                    ),
                    Expanded(
                      child: _buildMetricTile(
                        context,
                        label: 'Active orders',
                        value: orders.where((o) => o.status != OrderStatus.delivered).length.toString(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrdersScreen()),
                        ),
                        borderRight: false,
                        borderBottom: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4. Visit in progress notice (if active)
          if (activeVisit != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                border: Border.all(color: const Color(0xFFCCEBDD)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 18, color: AppColors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Visit in progress · ${activeVisit.companyName}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ActiveVisitScreen(visit: activeVisit)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.teal,
                      side: const BorderSide(color: AppColors.teal),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Resume visit', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // 5. Collections Card (.card.collection-compact)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Collections',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text('Monthly report', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pending', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          '₹27,04,518.70',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Overdue', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        SizedBox(height: 2),
                        Text(
                          '₹21,97,165.90',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Received ₹16,61,953.30',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    Text(
                      '38%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.38,
                    minHeight: 6,
                    backgroundColor: Color(0xFFEDF1F4),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('View collection report'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 6. Due follow-ups Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Due follow-ups',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => provider.setTabIndex(3),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text('View all', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tasks.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'No follow-ups due',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Your scheduled tasks will appear here.',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ...tasks.take(3).map(
                        (t) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_box_outline_blank, size: 16, color: AppColors.textLight),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.title,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 7. Recent orders Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent orders',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text('View all', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildOrderRow(
                  code: 'ORD-2026-0001',
                  company: 'Bright Infra Solutions · PO DEMO-PO-2026-001',
                  meta: 'Dispatch 1 Dec 2026 · ₹6,16,432',
                  status: 'Awaiting Stock',
                  statusBg: AppColors.amberLight,
                  statusFg: AppColors.amber,
                ),
                const Divider(height: 16, color: AppColors.border),
                _buildOrderRow(
                  code: 'DEMO-SO-EMP104-2026-09-1',
                  company: 'Demo · Horizon Broadband · PO DEMO-PO-emp104-2026-09-1',
                  meta: 'Dispatch 1 Sept 2026 · ₹2,06,500',
                  status: 'Delivered',
                  statusBg: AppColors.tealLight,
                  statusFg: AppColors.teal,
                ),
                const Divider(height: 16, color: AppColors.border),
                _buildOrderRow(
                  code: 'DEMO-SO-EMP104-2026-09-2',
                  company: 'Demo · Westlink Networks · PO DEMO-PO-emp104-2026-09-2',
                  meta: 'Dispatch 1 Sept 2026 · ₹2,65,500',
                  status: 'Delivered',
                  statusBg: AppColors.tealLight,
                  statusFg: AppColors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 8. Actions Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                        ),
                        icon: const Icon(Icons.description_outlined, size: 14),
                        label: const Text('New quotation', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          minimumSize: const Size(0, 42),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VisitFormScreen()),
                        ),
                        icon: const Icon(Icons.location_on_outlined, size: 14),
                        label: const Text('Log visit', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          minimumSize: const Size(0, 42),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MomsScreen()),
                        ),
                        icon: const Icon(Icons.assignment_outlined, size: 14),
                        label: const Text('New MOM', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          minimumSize: const Size(0, 42),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool borderRight,
    required bool borderBottom,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            right: borderRight ? const BorderSide(color: AppColors.border) : BorderSide.none,
            bottom: borderBottom ? const BorderSide(color: AppColors.border) : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow({
    required String code,
    required String company,
    required String meta,
    required String status,
    required Color statusBg,
    required Color statusFg,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              code,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusFg,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          company,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          meta,
          style: const TextStyle(fontSize: 10, color: AppColors.textLight),
        ),
      ],
    );
  }

  // ==========================================
  // 2. MANAGER DASHBOARD
  // ==========================================
  Widget _buildManagerDashboard(BuildContext context, AEConnectProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manager overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navy)),
                  Text('Priya’s team desk', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationsScreen())),
                icon: const Icon(Icons.rate_review_outlined, size: 16),
                label: const Text('Review queue'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Team KPIs
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Team performance · November 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Collection due', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        SizedBox(height: 2),
                        Text('₹33,02,589.90', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Target achieved', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        SizedBox(height: 2),
                        Text('82%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.teal)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. WAREHOUSE DASHBOARD
  // ==========================================
  Widget _buildWarehouseDashboard(BuildContext context, AEConnectProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Warehouse orders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navy)),
                  Text('Dispatch desk · 26 Nov 2026', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen())),
                icon: const Icon(Icons.inventory_2_outlined, size: 16),
                label: const Text('Inventory'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildOrderRow(
            code: 'ORD-2026-0001',
            company: 'Bright Infra Solutions · PO DEMO-PO-2026-001',
            meta: 'Dispatch 1 Dec 2026 · ₹6,16,432',
            status: 'Awaiting Stock',
            statusBg: AppColors.amberLight,
            statusFg: AppColors.amber,
          ),
        ],
      ),
    );
  }
}
