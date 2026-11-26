import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class InvoiceFormScreen extends StatefulWidget {
  final String? orderId;

  const InvoiceFormScreen({super.key, this.orderId});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _invNumberCtrl = TextEditingController(text: 'INV-2026-0089');
  final _customerCtrl = TextEditingController(text: 'Bright Infra Solutions');
  final _orderRefCtrl = TextEditingController(text: 'ORD-2026-0001 (PO-DEMO-2026-001)');
  final _amountCtrl = TextEditingController(text: '₹6,16,432');
  final _dueDateCtrl = TextEditingController(text: '31 Dec 2026');

  @override
  void dispose() {
    _invNumberCtrl.dispose();
    _customerCtrl.dispose();
    _orderRefCtrl.dispose();
    _amountCtrl.dispose();
    _dueDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Record invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record invoice',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Link the actual GST invoice number and due date to this sales order.',
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
                  _buildInput('GST invoice number *', _invNumberCtrl),
                  _buildInput('Client account', _customerCtrl),
                  _buildInput('Sales order reference', _orderRefCtrl),
                  _buildInput('Invoice amount (INR) *', _amountCtrl),
                  _buildInput('Payment due date *', _dueDateCtrl),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invoice ${_invNumberCtrl.text} recorded successfully.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Save invoice'),
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

  Widget _buildInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(controller: ctrl, decoration: const InputDecoration()),
        ],
      ),
    );
  }
}
