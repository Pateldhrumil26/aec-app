import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../providers/aeconnect_provider.dart';

class EssScreen extends StatelessWidget {
  const EssScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Self-Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Attendance Punch', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: provider.isPunchedIn ? AppColors.statusSuccessBg : AppColors.border,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            provider.isPunchedIn ? 'Punched In' : 'Punched Out',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: provider.isPunchedIn ? AppColors.statusSuccessFg : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      provider.isPunchedIn
                          ? 'Active since ${AppFormatters.time(provider.punchInTime ?? DateTime.now())} (GPS Verified Noida Sector 62)'
                          : 'You have not checked in for duty today yet.',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isPunchedIn ? AppColors.kpiDangerFg : AppColors.primary,
                        ),
                        onPressed: () => provider.toggleAttendancePunch(),
                        icon: Icon(provider.isPunchedIn ? Icons.logout_rounded : Icons.fingerprint_rounded),
                        label: Text(provider.isPunchedIn ? 'Punch Out for the Day' : 'Punch In with GPS'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Leave Balances
            const Text('Leave Balances', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildLeaveCard('Casual Leave', '${provider.casualLeaveRemaining} days', AppColors.kpiLeadsBg, AppColors.kpiLeadsFg),
                const SizedBox(width: 8),
                _buildLeaveCard('Sick Leave', '${provider.sickLeaveRemaining} days', AppColors.kpiFollowupsBg, AppColors.kpiFollowupsFg),
                const SizedBox(width: 8),
                _buildLeaveCard('Earned Leave', '${provider.earnedLeaveRemaining} days', AppColors.kpiOrdersBg, AppColors.kpiOrdersFg),
              ],
            ),
            const SizedBox(height: 18),

            // Expense Reimbursements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expense Claims', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                TextButton.icon(
                  onPressed: () => _showAddExpenseDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New claim'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...provider.expenses.map((exp) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  title: Text(exp['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  subtitle: Text('${exp['category']} · ${exp['date']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(AppFormatters.rupee(exp['amount'] as double), style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(exp['status'] as String, style: const TextStyle(fontSize: 11, color: AppColors.statusSuccessFg, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'Travel & Fuel';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Submit Expense Claim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Expense Purpose *')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'Travel & Fuel', child: Text('Travel & Fuel')),
                  DropdownMenuItem(value: 'Food & Entertainment', child: Text('Food & Entertainment')),
                  DropdownMenuItem(value: 'Lodging', child: Text('Lodging / Hotel')),
                ],
                onChanged: (v) {
                  if (v != null) category = v;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (INR) *'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (titleCtrl.text.isNotEmpty && amt > 0) {
                  context.read<AEConnectProvider>().addExpense(titleCtrl.text.trim(), category, amt);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Submit Claim'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeaveCard(String title, String val, Color bg, Color fg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: fg)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
          ],
        ),
      ),
    );
  }
}
