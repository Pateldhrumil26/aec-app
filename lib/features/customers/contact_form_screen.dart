import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ContactFormScreen extends StatefulWidget {
  final String? contactId;
  final String? leadCompany;

  const ContactFormScreen({super.key, this.contactId, this.leadCompany});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _nameCtrl = TextEditingController(text: 'Rajesh Sharma');
  final _roleCtrl = TextEditingController(text: 'General Manager - IT Infrastructure');
  final _phoneCtrl = TextEditingController(text: '+91 98100 23456');
  final _altPhoneCtrl = TextEditingController(text: '+91 120 4567890');
  final _emailCtrl = TextEditingController(text: 'rajesh.sharma@acme.com');
  final _notesCtrl = TextEditingController(text: 'Primary decision-maker for passive networking.');
  String _selectedCompany = 'Acme Technologies (Noida)';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.contactId != null ? 'Edit contact' : 'New CRM contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contactId != null ? 'Edit contact' : 'New CRM contact',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Save a contact independently or link it to an existing company lead.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
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
                  const Text('Linked company / lead *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _selectedCompany,
                    items: const [
                      DropdownMenuItem(value: 'Acme Technologies (Noida)', child: Text('Acme Technologies (Noida)')),
                      DropdownMenuItem(value: 'Bright Infra Solutions (Ahmedabad)', child: Text('Bright Infra Solutions (Ahmedabad)')),
                      DropdownMenuItem(value: 'CityNet Communications (Surat)', child: Text('CityNet Communications (Surat)')),
                    ],
                    onChanged: (v) => setState(() => _selectedCompany = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),
                  _buildInput('Contact person name *', _nameCtrl),
                  _buildInput('Designation / Role', _roleCtrl),
                  _buildInput('Primary mobile *', _phoneCtrl, keyboardType: TextInputType.phone),
                  _buildInput('Alternate phone / Landline', _altPhoneCtrl, keyboardType: TextInputType.phone),
                  _buildInput('Email address', _emailCtrl, keyboardType: TextInputType.emailAddress),
                  _buildInput('Notes & preferences', _notesCtrl, maxLines: 2),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Contact "${_nameCtrl.text}" saved successfully.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Save contact'),
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

  Widget _buildInput(String label, TextEditingController ctrl, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(controller: ctrl, maxLines: maxLines, keyboardType: keyboardType, decoration: const InputDecoration()),
        ],
      ),
    );
  }
}
