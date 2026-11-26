import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SalespersonReportScreen extends StatefulWidget {
  final String employeeId;
  final String name;

  const SalespersonReportScreen({
    super.key,
    required this.employeeId,
    required this.name,
  });

  @override
  State<SalespersonReportScreen> createState() => _SalespersonReportScreenState();
}

class _SalespersonReportScreenState extends State<SalespersonReportScreen> {
  int _activeTab = 0; // 0: Collections, 1: Sales & activity, 2: Targets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('assets/people/${widget.employeeId}.jpg'),
                  backgroundColor: AppColors.primaryLight,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.employeeId.toUpperCase()} · Noida & Delhi NCR Region',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Underlined Text Tabs: Collections, Sales & activity, Targets
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: ['Collections', 'Sales & activity', 'Targets'].asMap().entries.map((e) {
                  final idx = e.key;
                  final title = e.value;
                  final isSelected = _activeTab == idx;
                  return InkWell(
                    onTap: () => setState(() => _activeTab = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primary : const Color(0xFF7A8798),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            if (_activeTab == 0) ...[
              // Collections Overview
              _buildCard(
                title: 'Collection achievement',
                children: [
                  _buildKvRow('Collected this month', '₹10,45,500'),
                  _buildKvRow('Pending receivables', '₹6,58,950'),
                  _buildKvRow('Overdue > 30 days', '₹1,24,000'),
                  _buildKvRow('Uncleared cheques held', '₹85,000'),
                  _buildKvRow('Total billed client accounts', '14 active clients'),
                ],
              ),
            ] else if (_activeTab == 1) ...[
              // Sales & Activity
              _buildCard(
                title: 'Sales this month',
                children: [
                  _buildKvRow('Confirmed sales value', '₹8,22,932'),
                  _buildKvRow('Sales orders fulfilled', '2 orders'),
                  _buildKvRow('Pending stock dispatch', '1 order (ORD-2026-0001)'),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Lead & opportunity KPIs',
                children: [
                  _buildKvRow('New leads assigned', '4 leads'),
                  _buildKvRow('Won deals in period', '2 deals'),
                  _buildKvRow('Open pipeline value', '₹18,50,000 (3 deals)'),
                  _buildKvRow('Proposal stage', '2 proposals awaiting sign-off'),
                  _buildKvRow('Calls & site visits logged', '16 field activities'),
                ],
              ),
            ] else ...[
              // Targets Tab
              _buildCard(
                title: 'Monthly pacing & quota targets',
                children: [
                  const Text('Collections target', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Achieved: ₹10,45,500', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Target: ₹14,00,000 (74%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.74,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE5EDF2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Confirmed sales quota', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Achieved: ₹8,22,932', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Target: ₹12,00,000 (68%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.68,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE5EDF2),
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
          const Divider(height: 18, color: AppColors.border),
          ...children,
        ],
      ),
    );
  }

  Widget _buildKvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(v, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
        ],
      ),
    );
  }
}
