import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OrderFormScreen extends StatefulWidget {
  final String? quoteId;

  const OrderFormScreen({super.key, this.quoteId});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _poNumberCtrl = TextEditingController(text: 'PO-ACM-2026-089');
  final _customerCtrl = TextEditingController(text: 'Acme Technologies (Noida)');
  final _amountCtrl = TextEditingController(text: '₹6,16,432');
  final _deliveryAddressCtrl = TextEditingController(text: 'Plot 4A, Phase 3, Electronic City, Noida, Uttar Pradesh');
  final _poDateCtrl = TextEditingController(text: '26 Nov 2026');
  final _dispatchTargetCtrl = TextEditingController(text: '01 Dec 2026');

  @override
  void dispose() {
    _poNumberCtrl.dispose();
    _customerCtrl.dispose();
    _amountCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _poDateCtrl.dispose();
    _dispatchTargetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm sales order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify client PO',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Convert approved quotation into an official sales order for warehouse dispatch.',
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
                  _buildInput('Client Purchase Order (PO) number *', _poNumberCtrl),
                  _buildInput('Client / Company', _customerCtrl),
                  _buildInput('Order confirmed amount (INR) *', _amountCtrl),
                  _buildInput('Client PO date', _poDateCtrl),
                  _buildInput('Target dispatch date *', _dispatchTargetCtrl),
                  _buildInput('Shipping / Delivery address *', _deliveryAddressCtrl, maxLines: 2),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Client PO document attached & verified against Quotation Q-2026-0001.',
                            style: TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sales order confirmed and sent to warehouse.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Confirm and create sales order'),
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
