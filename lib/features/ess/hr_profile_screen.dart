import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HrProfileScreen extends StatefulWidget {
  const HrProfileScreen({super.key});

  @override
  State<HrProfileScreen> createState() => _HrProfileScreenState();
}

class _HrProfileScreenState extends State<HrProfileScreen> {
  int _activeTab = 0; // 0: Personal details, 1: Salary bank account

  final _phoneCtrl = TextEditingController(text: '+91 98100 12345');
  final _emailCtrl = TextEditingController(text: 'john.doe@aeconnect.com');
  final _addressCtrl = TextEditingController(text: 'Flat 402, Tower B, Sector 62, Noida, Uttar Pradesh 201301');
  final _emergencyNameCtrl = TextEditingController(text: 'Rajesh Doe');
  final _emergencyRelCtrl = TextEditingController(text: 'Father');
  final _emergencyPhoneCtrl = TextEditingController(text: '+91 98111 22334');

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyRelCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile & bank details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile & bank details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 16),

            // Underlined Text Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: ['Personal details', 'Salary bank account'].asMap().entries.map((e) {
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

            if (_activeTab == 0) ...[
              // Personal Details Form
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
                    // Identity banner
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('JD', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.navy)),
                            SizedBox(height: 2),
                            Text('EMP104 · Noida & Delhi NCR Region', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.border),

                    const Text('Contact information', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                    const SizedBox(height: 10),
                    _buildField('Contact phone', _phoneCtrl),
                    _buildField('Email address', _emailCtrl),
                    _buildField('Home / mailing address', _addressCtrl, maxLines: 2),

                    const SizedBox(height: 12),
                    const Text('Emergency contact', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                    const SizedBox(height: 10),
                    _buildField('Emergency contact name', _emergencyNameCtrl),
                    _buildField('Relationship', _emergencyRelCtrl),
                    _buildField('Emergency contact phone', _emergencyPhoneCtrl),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Personal details updated successfully.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 42),
                        ),
                        child: const Text('Save personal details'),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Salary Bank Account Card
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DEMO PAYROLL DETAILS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildKvRow('Account holder', 'John Doe'),
                    _buildKvRow('Bank name', 'HDFC Bank Ltd'),
                    _buildKvRow('Account number', '•••• •••• •••• 4092'),
                    _buildKvRow('IFSC code', 'HDFC0001234'),
                    _buildKvRow('PAN number', 'ABCDE1234F'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F5F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, size: 18, color: Color(0xFF08897A)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'These displayed details are verified and active for monthly salary disbursement.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF08897A), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(controller: ctrl, maxLines: maxLines, decoration: const InputDecoration()),
        ],
      ),
    );
  }

  Widget _buildKvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
        ],
      ),
    );
  }
}
