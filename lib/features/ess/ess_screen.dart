import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import 'attendance_screen.dart';
import 'leaves_screen.dart';
import 'expenses_screen.dart';
import 'employee_assets_screen.dart';
import 'hr_resources_screen.dart';
import 'hr_profile_screen.dart';
import 'separation_screen.dart';
import 'hr_reviews_screen.dart';

class EssScreen extends StatelessWidget {
  const EssScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final isMgr = provider.currentRole == UserRole.manager;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Employee self-service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head
            const Text(
              'Employee self-service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: AppColors.navy),
            ),
            const SizedBox(height: 2),
            const Text(
              'John Doe · 26 Nov 2026',
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Hero Banner matching prototype
            const ModuleBanner(
              label: 'EMPLOYEE SERVICES',
              title: 'Your workday',
              description: '6 requests awaiting review',
              image: 'assets/photography/banner-workday-v1.jpg',
            ),
            const SizedBox(height: 16),

            // Top Overview (hr-overview)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Attendance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        const Text('Punched in', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF08897A))),
                        const SizedBox(height: 2),
                        const Text('Since 09:30 AM', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 28),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text('Attendance', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Paid leave balance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        const Text('18', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navy)),
                        const SizedBox(height: 2),
                        const Text('1 pending approval', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeavesScreen())),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 28),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text('Leaves', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Employee services list
            const Text(
              'Employee services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 2),
            const Text(
              'Badges show open requests, pending payouts and unread guides.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildServiceTile(
                    context,
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFE4F3F8),
                    iconColor: const Color(0xFF087F9D),
                    title: 'Attendance',
                    subtitle: 'Punch in, view hours and correct missed punches',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.calendar_today_rounded,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'Leave & holidays',
                    subtitle: 'Balances, requests and the holiday calendar',
                    badge: '1',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeavesScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.receipt_long_rounded,
                    iconBg: const Color(0xFFFBF5EA),
                    iconColor: const Color(0xFF935817),
                    title: 'Expenses',
                    subtitle: 'Submit receipts and track reimbursements',
                    badge: '1',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.devices_other_rounded,
                    iconBg: const Color(0xFFE5F5F0),
                    iconColor: const Color(0xFF08897A),
                    title: 'My assets',
                    subtitle: 'Allocated equipment and service details',
                    badge: '3',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeAssetsScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.description_outlined,
                    iconBg: const Color(0xFFFAEFF7),
                    iconColor: const Color(0xFFB15B9A),
                    title: 'Policies & training',
                    subtitle: 'Read guides and follow your learning progress',
                    badge: '2',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HrResourcesScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.badge_outlined,
                    iconBg: const Color(0xFFE4F3F8),
                    iconColor: const Color(0xFF087F9D),
                    title: 'Personal & bank details',
                    subtitle: 'Emergency contacts and payroll bank confirmation',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HrProfileScreen())),
                  ),
                  _buildDivider(),
                  _buildServiceTile(
                    context,
                    icon: Icons.logout_rounded,
                    iconBg: const Color(0xFFFDE8E8),
                    iconColor: AppColors.danger,
                    title: 'Exit & clearance',
                    subtitle: 'Resignation notice, handover tasks and clearances',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeparationScreen())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // HR Reviews Card (if manager or admin)
            if (isMgr) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HR reviews', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 4),
                    const Text('Review assigned leave, attendance & expense requests from team members', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HrReviewsScreen())),
                      icon: const Icon(Icons.shield_outlined, size: 16),
                      label: const Text('Review assigned requests'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 38),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Text(
              'Sample HR records · Reporting manager: Priya Mehta (Area Sales Manager).',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, color: Color(0xFFECEFF3));

  Widget _buildServiceTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.navy)),
                  const SizedBox(height: 1),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFBF5EA), borderRadius: BorderRadius.circular(10)),
                child: Text(badge, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF935817))),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
          ],
        ),
      ),
    );
  }
}
