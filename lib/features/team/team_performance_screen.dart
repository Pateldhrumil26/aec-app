import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'salesperson_report_screen.dart';

class TeamPerformanceScreen extends StatelessWidget {
  const TeamPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Team performance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team performance',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Assigned sales executives, monthly pacing and KPI targets',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Performance Goals Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly team goals (November 2026)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.navy)),
                  const SizedBox(height: 14),
                  _buildGoal('Collections target', '₹16,61,953', '₹25,00,000', 0.66, '66% of monthly target'),
                  const SizedBox(height: 14),
                  _buildGoal('Confirmed sales target', '₹12,45,000', '₹20,00,000', 0.62, '62% of monthly target'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Team Members List
            const Text('Sales executives', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),

            _buildMemberCard(
              context,
              name: 'John Doe',
              code: 'EMP104',
              territory: 'Noida & Delhi NCR Region',
              achieved: '₹10,45,500',
              target: '₹14,00,000',
              percent: '74%',
              orders: '3',
              avatar: 'assets/people/emp104.jpg',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalespersonReportScreen(employeeId: 'emp104', name: 'John Doe')),
              ),
            ),
            const SizedBox(height: 10),
            _buildMemberCard(
              context,
              name: 'Rohan Sharma',
              code: 'EMP105',
              territory: 'Gurgaon & Haryana Region',
              achieved: '₹6,16,453',
              target: '₹11,00,000',
              percent: '56%',
              orders: '2',
              avatar: 'assets/people/emp105.jpg',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalespersonReportScreen(employeeId: 'emp105', name: 'Rohan Sharma')),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGoal(String title, String actual, String target, double ratio, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Achieved: $actual', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('Target: $target', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: const Color(0xFFE5EDF2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(
    BuildContext context, {
    required String name,
    required String code,
    required String territory,
    required String achieved,
    required String target,
    required String percent,
    required String orders,
    required String avatar,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(avatar),
              backgroundColor: AppColors.primaryLight,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                  const SizedBox(height: 2),
                  Text('$code · $territory', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Text('Collected: $achieved / $target ($percent)', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFB4BFCD)),
          ],
        ),
      ),
    );
  }
}
