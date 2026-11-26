import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import '../team/team_performance_screen.dart';
import '../team/salesperson_report_screen.dart';
import '../quotations/quotations_screen.dart';
import '../quotations/quotation_detail_screen.dart';
import '../leads/leads_screen.dart';
import '../orders/orders_screen.dart';
import '../moms/moms_screen.dart';
import '../moms/mom_detail_screen.dart';
import '../visits/visits_screen.dart';
import '../ess/hr_reviews_screen.dart';

class ManagerDashboardView extends StatelessWidget {
  final AEConnectProvider provider;

  const ManagerDashboardView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Header (Manager overview + Review queue)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manager overview',
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
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuotationsScreen()),
                ),
                icon: const Icon(Icons.verified_user_outlined, size: 16),
                label: const Text('Review queue'),
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

          // 2. Hero Banner: Priya's team desk
          ModuleBanner(
            label: 'AE CONNECT / TEAM',
            title: 'Priya’s team desk',
            description: '2 quotations awaiting review · 1 active orders',
            image: 'assets/photography/banner-network-v1.jpg',
            actionLabel: 'View team leads',
            actionIcon: Icons.people_outline,
            onAction: () => provider.setTabIndex(1),
          ),
          const SizedBox(height: 20),

          // 3. Team Performance Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Team performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormat('MMMM yyyy').format(DateTime.now())} · 2 salespeople',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeamPerformanceScreen()),
                ),
                icon: const Icon(Icons.bar_chart_outlined, size: 15),
                label: const Text('Full team report'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Hint box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Illustrative team data · 3 months · Sample targets are editable',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(height: 14),

          // Month & Rank filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report month *',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(DateTime.now()),
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            ),
                            const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rank team by',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Collected amount', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                            Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
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

          // 4. Card 1: Collection due Summary Card (Exact match to Photo 1)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: Color(0xFF036E97), width: 3),
                left: BorderSide(color: AppColors.border),
                right: BorderSide(color: AppColors.border),
                bottom: BorderSide(color: AppColors.border),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Collection due',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '₹33,02,589.90',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: Color(0xFF036E97),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '27 unpaid invoices due by this date',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF8A98AC)),
                ),
                const Divider(height: 26, thickness: 1, color: Color(0xFFF1F5F9)),

                // 2x2 Stat Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Collected this month', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('₹19,09,723.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                          SizedBox(height: 14),
                          Text('Not yet due', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('₹8,52,502.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Overdue', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('₹33,02,589.90', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFB45309))),
                          SizedBox(height: 14),
                          Text('Due in next 7 days', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          SizedBox(height: 2),
                          Text('₹8,52,502.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 26, thickness: 1, color: Color(0xFFF1F5F9)),

                // Footer lines
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Total pending', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('₹41,55,092.70', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Uncleared cheques', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    Text('₹3,59,315.90', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. Card 2: Top performer (Exact match to Photo 1)
          _buildPerformerCard(
            context,
            cardTitle: 'Top performer',
            rank: 1,
            name: 'Neha Patel',
            territory: 'Maharashtra',
            avatar: 'assets/people/emp105.jpg',
            collected: '₹11,45,308',
            collectionDue: '₹11,05,424',
            confirmedSales: '₹16,59,080',
            targetNote: 'Collection target 127% · Sales target 104%',
            overdueAlert: '₹11,05,424 overdue',
            employeeId: 'emp105',
          ),
          const SizedBox(height: 14),

          // 6. Card 3: Running behind / needs attention
          _buildPerformerCard(
            context,
            cardTitle: 'Running behind / needs attention',
            rank: null,
            name: 'John Doe',
            territory: 'Gujarat & North India',
            avatar: 'assets/people/emp104.jpg',
            collected: '₹7,64,416',
            collectionDue: '₹21,97,166',
            confirmedSales: '₹13,42,000',
            targetNote: 'Collection target 68% · Sales target 92%',
            overdueAlert: '₹21,97,166 overdue',
            employeeId: 'emp104',
          ),
          const SizedBox(height: 14),

          // 7. Review & Operations Quick Access
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Awaiting review',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReviewItem(
                  context,
                  title: 'Campus Backbone Upgrade',
                  subtitle: 'Acme Technologies · QT-2026-0001',
                  badge: 'Submitted',
                  badgeBg: const Color(0xFFFEF3C7),
                  badgeFg: const Color(0xFFB45309),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationDetailScreen(quoteId: 'q1')),
                  ),
                ),
                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                _buildReviewItem(
                  context,
                  title: 'Metro Fiber Link Tender',
                  subtitle: 'Central Rail Infra · QT-2026-0002',
                  badge: 'Submitted',
                  badgeBg: const Color(0xFFFEF3C7),
                  badgeFg: const Color(0xFFB45309),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationDetailScreen(quoteId: 'q2')),
                  ),
                ),
                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                _buildReviewItem(
                  context,
                  title: 'Client Technical Discussion',
                  subtitle: 'Acme Technologies · MOM-2026-0001',
                  badge: 'Submitted',
                  badgeBg: const Color(0xFFE0F2FE),
                  badgeFg: const Color(0xFF036E97),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MomDetailScreen(momId: 'm1')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 8. Team Management Actions
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
                  'Team management',
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
                          MaterialPageRoute(builder: (_) => const LeadsScreen()),
                        ),
                        icon: const Icon(Icons.people_outline, size: 14),
                        label: const Text('Leads', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          minimumSize: const Size(0, 42),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrdersScreen()),
                        ),
                        icon: const Icon(Icons.local_shipping_outlined, size: 14),
                        label: const Text('Orders', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          minimumSize: const Size(0, 42),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HrReviewsScreen()),
                        ),
                        icon: const Icon(Icons.assignment_outlined, size: 14),
                        label: const Text('HR reviews', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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

  Widget _buildPerformerCard(
    BuildContext context, {
    required String cardTitle,
    required int? rank,
    required String name,
    required String territory,
    required String avatar,
    required String collected,
    required String collectionDue,
    required String confirmedSales,
    required String targetNote,
    required String overdueAlert,
    required String employeeId,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),

          // Performer Header Row
          Row(
            children: [
              if (rank != null) ...[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatar,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      territory,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SalespersonReportScreen(employeeId: employeeId, name: name),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD0E7F5)),
                  backgroundColor: const Color(0xFFE8F5FC),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'View KPI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF036E97),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Financial Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFactItem('Collected', collected),
              _buildFactItem('Collection due', collectionDue),
              _buildFactItem('Confirmed sales', confirmedSales),
            ],
          ),
          const SizedBox(height: 8),

          // Target note
          Text(
            targetNote,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),

          // Overdue Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              border: Border.all(color: const Color(0xFFFED7AA)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB45309),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  overdueAlert,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB45309),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeBg,
    required Color badgeFg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: badgeFg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
