import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';
import '../../core/rbac/role_guard.dart';
import '../../models/permission.dart';

class KycReviewScreen extends StatefulWidget {
  final String customerId;

  const KycReviewScreen({super.key, this.customerId = 'c1'});

  @override
  State<KycReviewScreen> createState() => _KycReviewScreenState();
}

class _KycReviewScreenState extends State<KycReviewScreen> {
  String _kycDecision = 'Approved';
  final _approvedLimitCtrl = TextEditingController(text: '₹15,00,000');
  final _termsCtrl = TextEditingController(text: '30 Days Net');
  final _reviewNotesCtrl = TextEditingController(text: 'GST registered active entity. Verified with clear CIBIL and supplier reference.');

  @override
  void dispose() {
    _approvedLimitCtrl.dispose();
    _termsCtrl.dispose();
    _reviewNotesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoleGuard(
      feature: AppFeature.customers,
      action: AppAction.approve,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Customer KYC & credit'),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acme Technologies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('GST: 09AAAAA0000A1Z5 · Sector 62, Noida', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'Verified'),
              ],
            ),
            const SizedBox(height: 16),

            // Document Review List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KYC documents submitted', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildDocRow('GST Certificate (Form REG-06)', 'Verified online', Icons.verified_user),
                  _buildDocRow('Company PAN Card', 'Matched with MCA directory', Icons.badge),
                  _buildDocRow('Cancelled Cheque (Bank Proof)', 'HDFC Bank Account verified', Icons.account_balance),
                  _buildDocRow('Financial Statements FY 2024-25', 'Turnover ₹48.5 Cr audited', Icons.assessment),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Credit Decision Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manager credit evaluation', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  const Text('Credit limit approved (INR)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  TextField(controller: _approvedLimitCtrl, decoration: const InputDecoration()),
                  const SizedBox(height: 12),
                  const Text('Approved credit payment terms', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  TextField(controller: _termsCtrl, decoration: const InputDecoration()),
                  const SizedBox(height: 12),
                  const Text('Review comments & risk notes', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  TextField(controller: _reviewNotesCtrl, maxLines: 2, decoration: const InputDecoration()),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Customer KYC & credit terms updated.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusSuccessFg,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Approve KYC & Credit Limit'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildDocRow(String name, String status, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF08897A)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF08897A))),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 28),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('View', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
