import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MomFormScreen extends StatefulWidget {
  final String? momId;

  const MomFormScreen({super.key, this.momId});

  @override
  State<MomFormScreen> createState() => _MomFormScreenState();
}

class _MomFormScreenState extends State<MomFormScreen> {
  final _titleCtrl = TextEditingController(text: 'Fiber backbone specification review');
  final _attendeesCtrl = TextEditingController(text: 'Rajesh Sharma (Acme), John Doe (AEC)');
  final _minutesCtrl = TextEditingController(
    text: 'Client confirmed requirement of 24-core armored single mode cables for Q1 rollout. Price proposal discussed.',
  );
  final _actionItemsCtrl = TextEditingController(text: 'Send official quotation with delivery lead time by Friday.');
  String _selectedCustomer = 'Acme Technologies';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _attendeesCtrl.dispose();
    _minutesCtrl.dispose();
    _actionItemsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.momId != null ? 'Edit MOM' : 'New MOM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.momId != null ? 'Edit MOM' : 'New MOM',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Document meeting discussions, agreed action items and attendees.',
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
                  const Text('Client / Account *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _selectedCustomer,
                    items: const [
                      DropdownMenuItem(value: 'Acme Technologies', child: Text('Acme Technologies')),
                      DropdownMenuItem(value: 'Bright Infra Solutions', child: Text('Bright Infra Solutions')),
                      DropdownMenuItem(value: 'CityNet Communications', child: Text('CityNet Communications')),
                    ],
                    onChanged: (v) => setState(() => _selectedCustomer = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),
                  _buildInput('Meeting title *', _titleCtrl),
                  _buildInput('Attendees *', _attendeesCtrl),
                  _buildInput('Meeting minutes / Key points *', _minutesCtrl, maxLines: 4),
                  _buildInput('Agreed action items & deadlines', _actionItemsCtrl, maxLines: 2),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('MOM recorded and submitted for manager review.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Save and submit MOM'),
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

  Widget _buildInput(String label, TextEditingController ctrl, {int maxLines = 1}) {
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
}
