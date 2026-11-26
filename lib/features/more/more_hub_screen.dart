import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import '../pipeline/pipeline_screen.dart';
import '../quotations/quotations_screen.dart';
import '../orders/orders_screen.dart';
import '../collections/collections_screen.dart';
import '../moms/moms_screen.dart';
import '../customers/customers_screen.dart';
import '../ess/ess_screen.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Head: Title
            const Text(
              'More',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),

            // Group 1: Workspace
            _buildGroupSection(
              title: 'Workspace',
              children: [
                _buildNavItem(
                  icon: Icons.people_outline_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Leads',
                  onTap: () => provider.setTabIndex(1),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.teal,
                  title: 'Field visits',
                  onTap: () => provider.setTabIndex(2),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.task_alt_rounded,
                  iconColor: AppColors.amber,
                  title: 'Tasks & follow-ups',
                  onTap: () => provider.setTabIndex(3),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Group 2: Relationships
            _buildGroupSection(
              title: 'Relationships',
              children: [
                _buildNavItem(
                  icon: Icons.business_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Customers',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomersScreen()),
                  ),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.contacts_outlined,
                  iconColor: const Color(0xFF087FC2),
                  title: 'Contacts',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomersScreen()),
                  ),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.filter_alt_outlined,
                  iconColor: const Color(0xFF7E22CE),
                  title: 'Opportunities',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PipelineScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Group 3: Commercial
            _buildGroupSection(
              title: 'Commercial',
              children: [
                _buildNavItem(
                  icon: Icons.assignment_outlined,
                  iconColor: const Color(0xFF4D9693),
                  title: 'Meetings / MOM',
                  badge: '1',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MomsScreen()),
                  ),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF3A82BC),
                  title: 'Quotations',
                  badge: '2',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Group 4: Operations
            _buildGroupSection(
              title: 'Operations',
              children: [
                _buildNavItem(
                  icon: Icons.local_shipping_outlined,
                  iconColor: const Color(0xFF5B79AB),
                  title: 'Sales orders',
                  badge: '1',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  ),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFFEA580C),
                  title: 'Collections',
                  badge: '16',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Group 5: Personal
            _buildGroupSection(
              title: 'Personal',
              children: [
                _buildNavItem(
                  icon: Icons.badge_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Employee self-service',
                  badge: '6',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EssScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Group 6: Account
            _buildGroupSection(
              title: 'Account',
              children: [
                _buildNavItem(
                  icon: Icons.notifications_none_rounded,
                  iconColor: const Color(0xFF0369A1),
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
                  iconColor: AppColors.textMuted,
                  title: 'Search',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
                  ),
                ),
                _buildDivider(),
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'My profile',
                  badge: '6',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13.0),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.amber,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.border);
  }
}
