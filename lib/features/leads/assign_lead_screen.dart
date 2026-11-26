import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AssignLeadScreen extends StatefulWidget {
  final String leadId;
  final String companyName;

  const AssignLeadScreen({
    super.key,
    this.leadId = 'l1',
    this.companyName = 'Acme Technologies',
  });

  @override
  State<AssignLeadScreen> createState() => _AssignLeadScreenState();
}

class _AssignLeadScreenState extends State<AssignLeadScreen> {
  String _selectedOwner = 'John Doe (EMP104) · Noida & Delhi NCR';
  final _notesCtrl = TextEditingController(text: 'Territory coverage assigned based on North NCR expansion.');

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assign lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign lead',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Route this relationship to the executive responsible for its territory.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Lead Summary Card
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
                  const Text('Lead summary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Company', widget.companyName),
                  _buildKvRow('Territory', 'Noida, Uttar Pradesh'),
                  _buildKvRow('Current owner', 'John Doe (EMP104)'),
                  _buildKvRow('Requirement', 'Passive networking FTTH expansion'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Assignment Form
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
                  const Text('Assign to executive *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _selectedOwner,
                    items: const [
                      DropdownMenuItem(
                        value: 'John Doe (EMP104) · Noida & Delhi NCR',
                        child: Text('John Doe (EMP104) · Noida & Delhi NCR'),
                      ),
                      DropdownMenuItem(
                        value: 'Rohan Sharma (EMP105) · Gurgaon & Haryana',
                        child: Text('Rohan Sharma (EMP105) · Gurgaon & Haryana'),
                      ),
                      DropdownMenuItem(
                        value: 'Kunal Verma (EMP106) · Ghaziabad & UP West',
                        child: Text('Kunal Verma (EMP106) · Ghaziabad & UP West'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedOwner = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Territory transfer notes', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  TextField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration()),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lead successfully assigned to $_selectedOwner.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Confirm assignment'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
