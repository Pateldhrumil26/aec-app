import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class HrReviewsScreen extends StatefulWidget {
  const HrReviewsScreen({super.key});

  @override
  State<HrReviewsScreen> createState() => _HrReviewsScreenState();
}

class _HrReviewsScreenState extends State<HrReviewsScreen> {
  int _activeTab = 0; // 0: Leave, 1: Attendance, 2: Expenses, 3: Separation

  final List<Map<String, dynamic>> _leaveReviews = [
    {
      'employee': 'Rohan Sharma (EMP105)',
      'type': 'Paid Leave (PL)',
      'dates': '05 Dec 2026 - 08 Dec 2026',
      'days': '4 days · Full day',
      'reason': 'Family wedding in Jaipur',
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> _attendanceReviews = [
    {
      'employee': 'Rohan Sharma (EMP105)',
      'date': '24 Nov 2026',
      'original': 'Punch-in missing · Out: 06:40 PM',
      'requested': 'Punch-in: 09:30 AM · Out: 06:40 PM',
      'reason': 'Biometric scanner offline during morning field dispatch',
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> _expenseReviews = [
    {
      'employee': 'Rohan Sharma (EMP105)',
      'category': 'Travel & Fuel',
      'amount': '₹2,450',
      'date': '22 Nov 2026',
      'related': 'Client: CityNet Communications',
      'reason': 'Intercity travel for product demonstration',
      'receipts': 2,
      'status': 'Submitted',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('HR request reviews'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HR request reviews',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Requests assigned to you as reporting manager. Self-approval is blocked.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Underlined Text Tabs: Leave, Attendance, Expenses, Separation
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Leave', 'Attendance', 'Expenses', 'Separation'].asMap().entries.map((e) {
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
            ),
            const SizedBox(height: 16),

            if (_activeTab == 0) ...[
              // Leave Reviews
              ..._leaveReviews.map((r) => _buildReviewCard(
                    title: r['employee'],
                    badge: r['status'],
                    subtitle: '${r['type']} · ${r['dates']} (${r['days']})',
                    details: 'Reason: ${r['reason']}',
                    onApprove: () => _handleDecision('Leave application approved.'),
                    onSendBack: () => _handleDecision('Leave application sent back with comments.'),
                  )),
            ] else if (_activeTab == 1) ...[
              // Attendance Reviews
              ..._attendanceReviews.map((r) => _buildReviewCard(
                    title: r['employee'],
                    badge: r['status'],
                    subtitle: 'Date: ${r['date']}\nRequested: ${r['requested']}',
                    details: 'Original: ${r['original']}\nReason: ${r['reason']}',
                    onApprove: () => _handleDecision('Attendance regularization approved.'),
                    onSendBack: () => _handleDecision('Attendance regularization sent back.'),
                  )),
            ] else if (_activeTab == 2) ...[
              // Expense Reviews
              ..._expenseReviews.map((r) => _buildReviewCard(
                    title: '${r['employee']} · ${r['category']}',
                    badge: r['status'],
                    subtitle: 'Amount: ${r['amount']} · ${r['date']}\n${r['related']}',
                    details: 'Purpose: ${r['reason']} (${r['receipts']} receipts verified)',
                    onApprove: () => _handleDecision('Expense claim approved for disbursement.'),
                    onSendBack: () => _handleDecision('Expense claim sent back for revision.'),
                  )),
            ] else ...[
              // Separation Reviews
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text('No active resignation or separation requests.', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _handleDecision(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildReviewCard({
    required String title,
    required String badge,
    required String subtitle,
    required String details,
    required VoidCallback onApprove,
    required VoidCallback onSendBack,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
              StatusPill(label: badge),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(details, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Divider(height: 20, color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onSendBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text('Send back'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onApprove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusSuccessFg,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 36),
                ),
                child: const Text('Approve'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
