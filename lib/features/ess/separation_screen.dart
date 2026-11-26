import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SeparationScreen extends StatelessWidget {
  const SeparationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Exit & clearance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exit & clearance',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 16),

            // Card 1: Resignation request
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.logout_rounded, size: 22, color: AppColors.danger),
                  ),
                  const SizedBox(height: 12),
                  const Text('Resignation request', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter your proposed last working day, reason, and handover details for manager and HR clearance.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showResignationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      minimumSize: const Size(0, 38),
                    ),
                    child: const Text('Submit resignation request'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Departmental Clearances Checklist
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
                  const Text('Departmental clearance workflow', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  const Text('Standard clearance checkpoints upon separation initiation', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                  const Divider(height: 20, color: AppColors.border),
                  _buildClearanceItem('IT Hardware & Access', 'Laptop, mobile device & email de-provisioning', 'Pending initiation'),
                  _buildClearanceItem('Commercial & Sales Accounts', 'Handover of leads, quotations & client receivables', 'Pending initiation'),
                  _buildClearanceItem('Finance & Accounts', 'Pending expense reimbursements & loan settlements', 'Pending initiation'),
                  _buildClearanceItem('HR & Administrative', 'Full & final settlement and service certificate', 'Pending initiation'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showResignationDialog(BuildContext context) {
    final dateCtrl = TextEditingController(text: '31 Dec 2026');
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit resignation request', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Proposed last working day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: dateCtrl, decoration: const InputDecoration()),
              const SizedBox(height: 12),
              const Text('Notice period duration', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('30 Days as per employment agreement', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 12),
              const Text('Reason / Handover details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: reasonCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Brief explanation...')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Separation request submitted for review.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
            child: const Text('Submit request'),
          ),
        ],
      ),
    );
  }

  Widget _buildClearanceItem(String title, String desc, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.radio_button_unchecked, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                const SizedBox(height: 1),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(status, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
