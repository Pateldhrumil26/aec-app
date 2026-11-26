import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import '../pipeline/pipeline_screen.dart';
import '../quotations/quotations_screen.dart';
import '../orders/orders_screen.dart';
import '../collections/collections_screen.dart';
import '../collections/monthly_collections_screen.dart';
import '../moms/moms_screen.dart';
import '../inventory/inventory_screen.dart';
import '../customers/customers_screen.dart';
import '../customers/contacts_screen.dart';
import '../customers/kyc_review_screen.dart';
import '../channels/channel_applications_screen.dart';
import '../devices/devices_screen.dart';
import '../ess/ess_screen.dart';
import '../ess/attendance_screen.dart';
import '../ess/leaves_screen.dart';
import '../ess/expenses_screen.dart';
import '../ess/hr_reviews_screen.dart';
import '../team/team_performance_screen.dart';
import '../quotations/quote_terms_screen.dart';
import '../search/global_search_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Head: Title
                const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 18),

                // Group 1: Workspace
                _buildGroupHeader('Workspace'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.people_alt_rounded,
                    iconBg: const Color(0xFFE5F5F0),
                    iconColor: const Color(0xFF128D7E),
                    title: 'Leads',
                    onTap: () => provider.setTabIndex(1),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.location_on_rounded,
                    iconBg: const Color(0xFFFFF0DF),
                    iconColor: const Color(0xFFC26319),
                    title: 'Field visits',
                    onTap: () => provider.setTabIndex(2),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.task_alt_rounded,
                    iconBg: const Color(0xFFFBF5EA),
                    iconColor: const Color(0xFF935817),
                    title: 'Tasks & follow-ups',
                    onTap: () => provider.setTabIndex(3),
                  ),
                ]),
                const SizedBox(height: 20),

                // Group 2: Relationships
                _buildGroupHeader('Relationships'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.business_center_rounded,
                    iconBg: const Color(0xFFE4F3F8),
                    iconColor: const Color(0xFF087F9D),
                    title: 'Customers',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomersScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    iconBg: const Color(0xFFE4F3F8),
                    iconColor: const Color(0xFF087F9D),
                    title: 'Contacts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.bar_chart_rounded,
                    iconBg: const Color(0xFFF0EAFA),
                    iconColor: const Color(0xFF7061CE),
                    title: 'Opportunities',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PipelineScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.verified_user_outlined,
                    iconBg: const Color(0xFFE4F3F8),
                    iconColor: const Color(0xFF087F9D),
                    title: 'KYC & Credit review',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KycReviewScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                // Group 3: Commercial
                _buildGroupHeader('Commercial'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.description_rounded,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'Meetings / MOM',
                    badge: '1',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MomsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.description_rounded,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'Quotations',
                    badge: '3',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuotationsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.gavel_rounded,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'Commercial terms',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuoteTermsScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                // Group 4: Operations
                _buildGroupHeader('Operations'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.local_shipping_rounded,
                    iconBg: const Color(0xFFE6F6EE),
                    iconColor: const Color(0xFF178E74),
                    title: 'Sales orders',
                    badge: '1',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.insert_chart_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: const Color(0xFF2466DF),
                    title: 'Collections',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.receipt_long_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: const Color(0xFF2466DF),
                    title: 'Monthly collections report',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MonthlyCollectionsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.inventory_2_rounded,
                    iconBg: const Color(0xFFE6F6EE),
                    iconColor: const Color(0xFF178E74),
                    title: 'Inventory',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InventoryScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.storefront_rounded,
                    iconBg: const Color(0xFFFFF0DF),
                    iconColor: const Color(0xFFC26319),
                    title: 'Channel applications',
                    badge: '1',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChannelApplicationsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.devices_other_rounded,
                    iconBg: const Color(0xFFF1F3F5),
                    iconColor: const Color(0xFF526680),
                    title: 'Registered devices',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DevicesScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                // Group 5: Personal
                _buildGroupHeader('Personal'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: AppColors.primary,
                    title: 'Employee self-service',
                    badge: '6',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EssScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFE5F5F0),
                    iconColor: const Color(0xFF128D7E),
                    title: 'Attendance & hours',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.calendar_month_rounded,
                    iconBg: const Color(0xFFF3ECFB),
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Leave requests',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeavesScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.work_outline_rounded,
                    iconBg: const Color(0xFFFFF3DD),
                    iconColor: const Color(0xFFB45309),
                    title: 'Expense claims',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.rate_review_rounded,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'HR request reviews',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HrReviewsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.leaderboard_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: const Color(0xFF2466DF),
                    title: 'Team performance',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TeamPerformanceScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),

                // Group 6: Account
                _buildGroupHeader('Account'),
                _buildGroupContainer([
                  _buildNavItem(
                    icon: Icons.notifications_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: AppColors.primary,
                    title: 'Notifications',
                    badge: '2',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.search_rounded,
                    iconBg: const Color(0xFFF1F3F5),
                    iconColor: const Color(0xFF526680),
                    title: 'Search',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildNavItem(
                    icon: Icons.account_circle_rounded,
                    iconBg: const Color(0xFFEAF1FF),
                    iconColor: AppColors.primary,
                    title: 'My profile',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF62748C),
        ),
      ),
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Icon in soft colored box
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),

            // Badge Pill (if any)
            if (badge != null) ...[
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF946419),
                  ),
                ),
              ),
            ],

            // Chevron
            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 62,
      color: Color(0xFFEDF0F5),
    );
  }
}
