import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../models/permission.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import '../../components/app_header.dart';
import '../auth/login_screen.dart';
import '../ess/ess_screen.dart';
import '../ess/leaves_screen.dart';
import '../ess/expenses_screen.dart';
import '../ess/hr_reviews_screen.dart';
import '../team/team_performance_screen.dart';
import '../notifications/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final user = provider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Navigator.canPop(context)
          ? AppBar(title: const Text('My profile'))
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Head
            const Text(
              'My profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),

            // Hero Banner matching prototype with user photo on the right
            ModuleBanner(
              label: 'MY ACCOUNT',
              title: user.name,
              description: '${user.id.toUpperCase()} · ${user.title}',
              image: 'assets/photography/banner-workday-v1.jpg',
              trailing: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    user.avatarAsset,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primaryLight,
                      alignment: Alignment.center,
                      child: Text(
                        user.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Your Account Card (.card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildKvRow('Department', user.department),
                  _buildKvRow('Territory', user.territory),
                  _buildKvRow('Reporting manager', user.reportingManager),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Device status',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tealLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Device notice banner (.notice)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F8),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFDCE6EC)),
                    ),
                    child: const Text(
                      'Device approval is simulated locally. Hardware fingerprints and IP verification require the live authentication service.',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Device approval request submitted.')),
                      );
                    },
                    icon: const Icon(Icons.verified_user_outlined, size: 16),
                    label: const Text('Request device approval'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size.fromHeight(40),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Requests & updates Heading
            const Text(
              'Requests & updates',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),

            // Navigation List Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: 'Employee self-service',
                    badge: '6',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EssScreen()),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildListTile(
                    context,
                    icon: Icons.calendar_month_outlined,
                    iconColor: const Color(0xFF7E22CE),
                    title: 'Leave requests',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeavesScreen()),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildListTile(
                    context,
                    icon: Icons.work_outline_rounded,
                    iconColor: const Color(0xFFD97706),
                    title: 'Expense claims',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildListTile(
                    context,
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF0369A1),
                    title: 'Notifications',
                    badge: provider.unreadNotificationsCount > 0 ? '${provider.unreadNotificationsCount}' : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    ),
                  ),
                  if (provider.canAccess(AppFeature.hrReviews)) ...[
                    const Divider(height: 1, color: AppColors.border),
                    _buildListTile(
                      context,
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFF059669),
                      title: 'HR reviews',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HrReviewsScreen()),
                      ),
                    ),
                  ],
                  if (provider.canAccess(AppFeature.teamPerformance)) ...[
                    const Divider(height: 1, color: AppColors.border),
                    _buildListTile(
                      context,
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFF0284C7),
                      title: 'Team performance',
                      badge: '2',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TeamPerformanceScreen()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Switch Demo Role (Instant testing across Employee, Manager, Warehouse)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active workspace role',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Switch role to test live frontend RBAC permissions and dynamic navigation.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRoleChip(context, provider, UserRole.employee, 'Employee (EMP104)'),
                        const SizedBox(width: 8),
                        _buildRoleChip(context, provider, UserRole.manager, 'Manager (ASM001)'),
                        const SizedBox(width: 8),
                        _buildRoleChip(context, provider, UserRole.warehouse, 'Warehouse (WH001)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Sign out Button (.btn.danger.full)
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.logout();
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Sign out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKvRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
            const SizedBox(width: 14),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

  Widget _buildRoleChip(BuildContext context, AEConnectProvider provider, UserRole role, String label) {
    final isSelected = provider.currentRole == role;
    return InkWell(
      onTap: () {
        if (!isSelected) {
          provider.switchRole(role);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched role to ${role.label}'),
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF036E97) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF036E97) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
