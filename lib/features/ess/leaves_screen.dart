import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({super.key});

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  int _activeTab = 0; // 0: My requests, 1: Holiday calendar

  final List<Map<String, dynamic>> _myRequests = [
    {
      'type': 'Paid Leave (PL)',
      'code': 'PL',
      'dates': '12 Dec 2026 - 15 Dec 2026',
      'days': '4 days · Full day',
      'reason': 'Family vacation & travel to hometown',
      'status': 'Approved',
      'appliedOn': '18 Nov 2026',
    },
    {
      'type': 'Casual Leave (CL)',
      'code': 'CL',
      'dates': '28 Nov 2026',
      'days': '1 day · Full day',
      'reason': 'Personal bank and administrative work',
      'status': 'Pending',
      'appliedOn': '25 Nov 2026',
    },
    {
      'type': 'Sick Leave (SL)',
      'code': 'SL',
      'dates': '10 Oct 2026',
      'days': '1 day · Half day',
      'reason': 'Dental appointment',
      'status': 'Approved',
      'appliedOn': '09 Oct 2026',
    },
  ];

  static const List<Map<String, String>> _holidays2026 = [
    {'day': '26', 'month': 'Jan', 'name': 'Republic Day', 'weekday': 'Monday'},
    {'day': '15', 'month': 'Feb', 'name': 'Maha Shivratri', 'weekday': 'Sunday'},
    {'day': '04', 'month': 'Mar', 'name': 'Holi', 'weekday': 'Wednesday'},
    {'day': '21', 'month': 'Mar', 'name': 'Id-ul-Fitr', 'weekday': 'Saturday'},
    {'day': '14', 'month': 'Apr', 'name': 'Ambedkar Jayanti', 'weekday': 'Tuesday'},
    {'day': '15', 'month': 'Aug', 'name': 'Independence Day', 'weekday': 'Saturday'},
    {'day': '02', 'month': 'Oct', 'name': 'Mahatma Gandhi Jayanti', 'weekday': 'Friday'},
    {'day': '20', 'month': 'Oct', 'name': 'Dussehra', 'weekday': 'Tuesday'},
    {'day': '08', 'month': 'Nov', 'name': 'Diwali (Deepavali)', 'weekday': 'Sunday'},
    {'day': '25', 'month': 'Dec', 'name': 'Christmas Day', 'weekday': 'Friday'},
  ];

  void _showApplyDialog() {
    String selectedType = 'PL · Paid Leave';
    final startCtrl = TextEditingController(text: '01 Dec 2026');
    final endCtrl = TextEditingController(text: '02 Dec 2026');
    String portion = 'Full day';
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Apply for leave', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Leave type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'PL · Paid Leave', child: Text('PL · Paid Leave')),
                    DropdownMenuItem(value: 'CL · Casual Leave', child: Text('CL · Casual Leave')),
                    DropdownMenuItem(value: 'SL · Sick Leave', child: Text('SL · Sick Leave')),
                    DropdownMenuItem(value: 'CO · Comp-off', child: Text('CO · Comp-off')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedType = v!),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 12),
                const Text('Start date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: startCtrl, decoration: const InputDecoration()),
                const SizedBox(height: 12),
                const Text('End date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: endCtrl, decoration: const InputDecoration()),
                const SizedBox(height: 12),
                const Text('Duration', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: portion,
                  items: const [
                    DropdownMenuItem(value: 'Full day', child: Text('Full day')),
                    DropdownMenuItem(value: 'Half day', child: Text('Half day')),
                  ],
                  onChanged: (v) => setDialogState(() => portion = v!),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 12),
                const Text('Reason for leave', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: reasonCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Provide reason...')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _myRequests.insert(0, {
                    'type': selectedType,
                    'code': selectedType.substring(0, 2),
                    'dates': '${startCtrl.text} - ${endCtrl.text}',
                    'days': '2 days · $portion',
                    'reason': reasonCtrl.text.isEmpty ? 'Personal leave' : reasonCtrl.text,
                    'status': 'Pending',
                    'appliedOn': 'Today',
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave application submitted successfully.')),
                );
              },
              child: const Text('Submit application'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leave & time-off'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leave & time-off',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    SizedBox(height: 2),
                    Text('Balances, requests and company calendar', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showApplyDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Apply for leave'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4 Leave Balances Cards Grid
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBalanceCard('PL', '18', '24', 'Paid Leave', '6 approved · 0 pending', const Color(0xFFE5F5F0), const Color(0xFF08897A)),
                  const SizedBox(width: 8),
                  _buildBalanceCard('CL', '7', '12', 'Casual Leave', '5 approved · 1 pending', const Color(0xFFFBF5EA), const Color(0xFF935817)),
                  const SizedBox(width: 8),
                  _buildBalanceCard('SL', '10', '12', 'Sick Leave', '2 approved · 0 pending', const Color(0xFFFAEFF7), const Color(0xFFB15B9A)),
                  const SizedBox(width: 8),
                  _buildBalanceCard('CO', '2', '2', 'Comp-off', '0 approved · 0 pending', const Color(0xFFE4F3F8), const Color(0xFF087F9D)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Underlined Text Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: ['My requests', 'Holiday calendar'].asMap().entries.map((e) {
                  final idx = e.key;
                  final title = e.value;
                  final isSelected = _activeTab == idx;
                  return InkWell(
                    onTap: () => setState(() => _activeTab = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

            // Tab Content
            if (_activeTab == 0) ...[
              // My Requests List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _myRequests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final r = _myRequests[idx];
                  return Container(
                    padding: const EdgeInsets.all(14),
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
                            Text(r['type'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                            StatusPill(label: r['status']),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(r['dates'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(r['days'], style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                        const SizedBox(height: 6),
                        Text('Reason: ${r['reason']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              // Company Holidays List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _holidays2026.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, idx) {
                    final h = _holidays2026[idx];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(h['day']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
                                Text(h['month']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: AppColors.primary)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(h['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                                const SizedBox(height: 2),
                                Text('${h['weekday']} · Declared company holiday', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String code, String rem, String total, String name, String sub, Color bg, Color fg) {
    return Container(
      width: 145,
      padding: const EdgeInsets.all(12),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
                child: Text(code, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: rem, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
                    TextSpan(text: ' / $total', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
