import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../models/order_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import '../team/team_performance_screen.dart';
import '../leads/lead_form_screen.dart';
import '../visits/visit_form_screen.dart';
import '../visits/active_visit_screen.dart';
import '../quotations/quotations_screen.dart';
import '../quotations/quotation_builder_screen.dart';
import '../orders/orders_screen.dart';
import '../orders/order_detail_screen.dart';
import '../collections/collections_screen.dart';
import '../moms/moms_screen.dart';
import '../inventory/inventory_screen.dart';
import 'manager_dashboard_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final role = provider.currentRole;

    if (role == UserRole.manager) {
      return ManagerDashboardView(provider: provider);
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

          // 2. Banner KPI Hero (With authentic network background image)
          ModuleBanner(
            label: 'AE CONNECT / SALES',
            title: 'Hello, John.',
            description:
                '${tasks.length} follow-ups due · ${orders.where((o) => o.status != OrderStatus.delivered).length} active order',
            image: 'assets/photography/banner-network-v1.jpg',
            actionLabel: 'Log a visit',
            actionIcon: Icons.location_on_outlined,
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VisitFormScreen()),
            ),
          ),
          const SizedBox(height: 14),

          // 3. 4 KPI Metrics (Matching prototype cards with pastel backgrounds and bottom-right icons)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildEmployeeKpiCard(
                      label: 'Open leads',
                      value: leads.length.toString(),
                      icon: Icons.people_outline_rounded,
                      iconColor: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFF0F9FF),
                      borderColor: const Color(0xFFBAE6FD),
                      onTap: () => provider.setTabIndex(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEmployeeKpiCard(
                      label: 'Follow-ups due',
                      value: tasks.length.toString(),
                      icon: Icons.assignment_outlined,
                      iconColor: const Color(0xFFB45309),
                      bgColor: const Color(0xFFFFFBEB),
                      borderColor: const Color(0xFFFEF3C7),
                      onTap: () => provider.setTabIndex(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildEmployeeKpiCard(
                      label: 'Open quotations',
                      value: quotes.length.toString(),
                      icon: Icons.receipt_long_outlined,
                      iconColor: const Color(0xFF7E22CE),
                      bgColor: const Color(0xFFFAF5FF),
                      borderColor: const Color(0xFFF3E8FF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuotationsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEmployeeKpiCard(
                      label: 'Active orders',
                      value: orders.where((o) => o.status != OrderStatus.delivered).length.toString(),
                      icon: Icons.local_shipping_outlined,
                      iconColor: const Color(0xFF15803D),
                      bgColor: const Color(0xFFF0FDF4),
                      borderColor: const Color(0xFFDCFCE7),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                // Cyan accent indicator bar on the left edge
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3.5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
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
                              foregroundColor: const Color(0xFF64748B),
                            ),
                            child: const Text('Monthly report', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pending',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '₹27,04,518.70',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Overdue', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          Text(
                            '₹21,97,165.90',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFBE123C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Received ₹16,61,953.30',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
                          minHeight: 5,
                          backgroundColor: Color(0xFFEDF1F4),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF036E97)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF036E97),
                          side: const BorderSide(color: Color(0xFFCCE3FD)),
                          minimumSize: const Size.fromHeight(38),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF036E97)),
                            SizedBox(width: 4),
                            Text(
                              'View collection report',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('View all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOrderRow(
                  context: context,
                  code: 'ORD-2026-0001',
                  company: 'Bright Infra Solutions · PO DEMO-PO-2026-001',
                  meta: 'Dispatch 1 Dec 2026 · ₹6,16,432',
                  status: 'Awaiting Stock',
                  statusBg: const Color(0xFFFEF3C7),
                  statusFg: const Color(0xFFB45309),
                ),
                const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildOrderRow(
                  context: context,
                  code: 'DEMO-SO-EMP104-2026-09-1',
                  company: 'Demo · Horizon Broadband · PO DEMO-PO-emp104-2026-09-1',
                  meta: 'Dispatch 1 Sept 2026 · ₹2,06,500',
                  status: 'Delivered',
                  statusBg: const Color(0xFFDEF7EC),
                  statusFg: const Color(0xFF03543F),
                ),
                const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildOrderRow(
                  context: context,
                  code: 'DEMO-SO-EMP104-2026-09-2',
                  company: 'Demo · Westlink Networks · PO DEMO-PO-emp104-2026-09-2',
                  meta: 'Dispatch 1 Sept 2026 · ₹2,65,500',
                  status: 'Delivered',
                  statusBg: const Color(0xFFDEF7EC),
                  statusFg: const Color(0xFF03543F),
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

  Widget _buildEmployeeKpiCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Icon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderRow({
    BuildContext? context,
    required String code,
    required String company,
    required String meta,
    required String status,
    required Color statusBg,
    required Color statusFg,
  }) {
    final rowContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Delivery Truck Icon Container
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
            size: 19,
            color: Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        // 2. Middle Details (Code, Company+PO, Dispatch+Amount, Status Badge below)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                company,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF64748B),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meta,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // 3. Subtle chevron arrow
        const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: Color(0xFF94A3B8),
        ),
      ],
    );

    if (context != null) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(orderId: code),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: rowContent,
        ),
      );
    }

    return rowContent;
  }

  // ==========================================
  // 2. WAREHOUSE DASHBOARD
  // ==========================================
  Widget _buildWarehouseDashboard(BuildContext context, AEConnectProvider provider) {
    final orders = provider.orders;
    final readyToPack = orders.where((o) => o.status == OrderStatus.partiallyDispatched).length;
    final awaitingStock = orders.where((o) => o.status == OrderStatus.awaitingStock).length;
    final inTransit = orders.where((o) => o.status == OrderStatus.dispatched).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Warehouse orders',
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
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen())),
                icon: const Icon(Icons.inventory_2_outlined, size: 16),
                label: const Text('Inventory'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: Color(0xFFCCE3FD), width: 1),
                  elevation: 0,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ModuleBanner(
            label: 'AE CONNECT / WAREHOUSE',
            title: 'Dispatch desk',
            description: '${orders.length} active orders · $awaitingStock awaiting stock',
            image: 'assets/photography/banner-warehouse-v1.jpg',
            actionLabel: 'Open orders',
            actionIcon: Icons.local_shipping_outlined,
            onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
          ),
          const SizedBox(height: 16),

          // 3 KPI cards row (Ready to pack, Awaiting stock, In transit)
          Row(
            children: [
              Expanded(
                child: _buildWarehouseKpiCard(
                  title: 'Ready to pack',
                  value: '$readyToPack',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildWarehouseKpiCard(
                  title: 'Awaiting stock',
                  value: '$awaitingStock',
                  icon: Icons.access_time_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildWarehouseKpiCard(
                  title: 'In transit',
                  value: '$inTransit',
                  icon: Icons.local_shipping_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Orders to fulfil Card
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Orders to fulfil',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersScreen()),
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildOrderRow(
                  context: context,
                  code: 'ORD-2026-0001',
                  company: 'Bright Infra Solutions · PO DEMO-PO-2026-001',
                  meta: 'Dispatch 1 Dec 2026 · ₹6,16,432',
                  status: 'Awaiting Stock',
                  statusBg: const Color(0xFFFEF3C7),
                  statusFg: const Color(0xFFB45309),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarehouseKpiCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: const Color(0xFF16A34A),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
