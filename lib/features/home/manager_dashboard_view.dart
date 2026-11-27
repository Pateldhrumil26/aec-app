import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/module_banner.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import '../collections/collections_screen.dart';
import '../collections/monthly_collections_screen.dart';
import '../ess/hr_reviews_screen.dart';
import '../leads/leads_screen.dart';
import '../moms/mom_detail_screen.dart';
import '../moms/moms_screen.dart';
import '../orders/orders_screen.dart';
import '../quotations/approvals_screen.dart';
import '../quotations/quotation_detail_screen.dart';
import '../quotations/quotations_screen.dart';
import '../team/salesperson_report_screen.dart';
import '../team/team_performance_screen.dart';
import '../visits/visits_screen.dart';

class ManagerDashboardView extends StatefulWidget {
  final AEConnectProvider provider;

  const ManagerDashboardView({super.key, required this.provider});

  @override
  State<ManagerDashboardView> createState() => _ManagerDashboardViewState();
}

class _ManagerDashboardViewState extends State<ManagerDashboardView> {
  String _selectedMonth = 'November 2026';
  String _rankBy = 'Collected amount';

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('d MMM yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header (Manager overview + Review queue)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        todayStr,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ApprovalsScreen()),
                    ),
                    icon: const Icon(Icons.verified_user_outlined, size: 16),
                    label: const Text('Review queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF036E97),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      minimumSize: const Size(0, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                onAction: () => widget.provider.setTabIndex(1),
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
                        '$_selectedMonth · 2 salespeople',
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
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF036E97),
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hint Box
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
                          const Row(
                            children: [
                              Text(
                                'Report month ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderDark),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedMonth,
                                isExpanded: true,
                                icon: const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textMuted),
                                style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                items: const [
                                  DropdownMenuItem(value: 'November 2026', child: Text('November 2026')),
                                  DropdownMenuItem(value: 'October 2026', child: Text('October 2026')),
                                  DropdownMenuItem(value: 'September 2026', child: Text('September 2026')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => _selectedMonth = v);
                                },
                              ),
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
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderDark),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _rankBy,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
                                style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                items: const [
                                  DropdownMenuItem(value: 'Collected amount', child: Text('Collected amount')),
                                  DropdownMenuItem(value: 'Confirmed sales', child: Text('Confirmed sales')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => _rankBy = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Collection due Summary Card (soft light-blue tinted card matching prototype)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F9FD),
                  border: Border.all(color: const Color(0xFFD6E6F2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          color: const Color(0xFF036E97),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'As of $todayStr',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Collection due',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 2),
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
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                            const Divider(height: 26, thickness: 1, color: Color(0xFFDCE8F2)),

                            // 2x2 Stat Grid
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Collected this month', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                      SizedBox(height: 2),
                                      Text('₹19,09,723.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF036E97))),
                                      SizedBox(height: 14),
                                      Text('Not yet due', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                      SizedBox(height: 2),
                                      Text('₹8,52,502.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF036E97))),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Overdue', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                      SizedBox(height: 2),
                                      Text('₹33,02,589.90', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFB45309))),
                                      SizedBox(height: 14),
                                      Text('Due in next 7 days', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                      SizedBox(height: 2),
                                      Text('₹8,52,502.80', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF036E97))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 26, thickness: 1, color: Color(0xFFDCE8F2)),

                            // Footer lines
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total pending', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                Text('₹41,55,092.70', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Uncleared cheques', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                Text('₹3,59,315.90', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 5. Top Performer Card
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
                      'Top performer',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '1',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildAvatar('assets/people/emp105.jpg', 'NP'),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Neha Patel', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              Text('Maharashtra', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        _buildViewKpiBtn(context, 'emp105', 'Neha Patel'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFactItem('Collected', '₹11,45,308', valueColor: const Color(0xFF15803D)),
                        _buildFactItem('Collection due', '₹11,05,424'),
                        _buildFactItem('Confirmed sales', '₹16,59,080'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Collection target 127% · Sales target 104%',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 10),
                    _buildWarningBar('₹11,05,424 overdue'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 6. Running behind / needs attention Card (Both Neha Patel & John Doe matching prototype)
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
                      'Running behind / needs attention',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 14),

                    // Row 1: Neha Patel
                    Row(
                      children: [
                        _buildAvatar('assets/people/emp105.jpg', 'NP'),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Neha Patel', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              Text('Maharashtra', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        _buildViewKpiBtn(context, 'emp105', 'Neha Patel'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildWarningBar('₹11,05,424 overdue'),

                    const Divider(height: 24, color: Color(0xFFF1F5F9)),

                    // Row 2: John Doe
                    Row(
                      children: [
                        _buildAvatar('assets/people/emp104.jpg', 'JD'),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('John Doe', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              Text('Gujarat & North India', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        _buildViewKpiBtn(context, 'emp104', 'John Doe'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildWarningBar('Collection pace short by ₹3,15,584.20'),
                    const SizedBox(height: 6),
                    _buildWarningBar('Sales pace short by ₹62,668'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Footnote
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Collections use balances as of $todayStr. Due includes today; overdue excludes today. Uncleared cheques stay pending until cleared. Collections are credited to the order owner.',
                  style: const TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 16),

              // 7. Operational Queue 2x2 Colored Cards
              Row(
                children: [
                  Expanded(
                    child: _buildQueueCard(
                      label: 'Quote approvals',
                      value: '2',
                      icon: Icons.description_outlined,
                      fgColor: const Color(0xFFB45309),
                      bgColor: const Color(0xFFFFFBEB),
                      borderColor: const Color(0xFFFEF3C7),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ApprovalsScreen(initialTab: 0)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQueueCard(
                      label: 'MOM reviews',
                      value: '1',
                      icon: Icons.article_outlined,
                      fgColor: const Color(0xFF7E22CE),
                      bgColor: const Color(0xFFFAF5FF),
                      borderColor: const Color(0xFFF3E8FF),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ApprovalsScreen(initialTab: 1)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildQueueCard(
                      label: 'Unassigned leads',
                      value: '1',
                      icon: Icons.people_outline_rounded,
                      fgColor: const Color(0xFF036E97),
                      bgColor: const Color(0xFFF0F9FF),
                      borderColor: const Color(0xFFBAE6FD),
                      onTap: () => widget.provider.setTabIndex(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQueueCard(
                      label: 'Active visits',
                      value: '0',
                      icon: Icons.location_on_outlined,
                      fgColor: const Color(0xFF15803D),
                      bgColor: const Color(0xFFF0FDF4),
                      borderColor: const Color(0xFFDCFCE7),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VisitsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 8. Collections Card (left accent bar matching prototype)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Container(width: 3.5, color: const Color(0xFF0284C7)),
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
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const MonthlyCollectionsScreen()),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 28),
                                    foregroundColor: const Color(0xFF036E97),
                                  ),
                                  child: const Text('Monthly report', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Pending', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            const Text(
                              '₹41,55,092.70',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Color(0xFF036E97),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Overdue', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                                Text(
                                  '₹33,02,589.90',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFBE123C)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Received ₹44,23,684.30', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                Text('52%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                value: 0.52,
                                minHeight: 6,
                                backgroundColor: Color(0xFFEDF1F4),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                              child: const Text(
                                '› View collection report',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 9. Awaiting Review Card (3 items matching prototype)
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 14),
                    _buildAwaitingQuoteRow(
                      context,
                      company: 'Acme Technologies',
                      refAndDate: 'AEIPL/001/2627 · 26 Nov 2026',
                      validUntil: 'John Doe · Valid 26 Dec 2026',
                      amount: '₹29,500',
                      quoteId: 'QT-2026-0001',
                    ),
                    const Divider(height: 22, color: Color(0xFFF1F5F9)),
                    _buildAwaitingQuoteRow(
                      context,
                      company: 'Acme Technologies',
                      refAndDate: 'QT-2026-0001 · 24 Nov 2026',
                      validUntil: 'John Doe · Valid 24 Dec 2026',
                      amount: '₹56,050',
                      quoteId: 'QT-2026-0001',
                    ),
                    const Divider(height: 22, color: Color(0xFFF1F5F9)),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MomDetailScreen(momId: 'MOM-2026-0001')),
                      ),
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
                            child: const Text(
                              'FB',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF036E97)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fiber backbone specification review',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Acme Technologies · MOM-2026-0001',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Submitted',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 10. Recent activity Timeline Card
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
                      'Recent activity',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 14),
                    _buildTimelineEntry('Task completed', 'John Doe · 25 Nov 2026 11:00 am'),
                    _buildTimelineEntry('Task completed', 'John Doe · 25 Nov 2026 11:00 am'),
                    _buildTimelineEntry('Created AEIPL/001/2627', 'John Doe · 26 Nov 2026 09:53 am'),
                    _buildTimelineEntry('AEIPL/001/2627 submitted', 'John Doe · 26 Nov 2026 09:54 am'),
                    _buildTimelineEntry('Device verification requested by Amit Shah', 'Amit Shah · 26 Nov 2026 04:14 pm', isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 11. Team Quick-Links Card
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
                      'Team',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTeamBtn(
                            icon: Icons.people_outline,
                            label: 'Lead assignments',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LeadsScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTeamBtn(
                            icon: Icons.local_shipping_outlined,
                            label: 'Sales orders',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const OrdersScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTeamBtn(
                            icon: Icons.person_outline,
                            label: 'HR requests',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HrReviewsScreen()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String asset, String fallback) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(
          child: Text(fallback, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _buildViewKpiBtn(BuildContext context, String employeeId, String name) {
    return OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SalespersonReportScreen(employeeId: employeeId, name: name)),
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
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
      ),
    );
  }

  Widget _buildWarningBar(String text) {
    return Container(
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
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFB45309)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard({
    required String label,
    required String value,
    required IconData icon,
    required Color fgColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: fgColor),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: fgColor),
                ),
                Icon(icon, size: 20, color: fgColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAwaitingQuoteRow(
    BuildContext context, {
    required String company,
    required String refAndDate,
    required String validUntil,
    required String amount,
    required String quoteId,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuotationDetailScreen(quoteId: quoteId)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.description_outlined, size: 18, color: Color(0xFF036E97)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: 2),
                Text(refAndDate, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/people/emp104.jpg', fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 6),
                    Text(validUntil, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Submitted',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(String title, String subtitle, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF036E97)),
              ),
              if (!isLast)
                Container(width: 1.5, height: 22, color: const Color(0xFFE2E8F0)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
                const SizedBox(height: 1),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        minimumSize: const Size(0, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.navy),
        ),
      ],
    );
  }
}
