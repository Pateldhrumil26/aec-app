import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class QuoteTermsScreen extends StatefulWidget {
  final String quoteId;

  const QuoteTermsScreen({super.key, this.quoteId = 'q1'});

  @override
  State<QuoteTermsScreen> createState() => _QuoteTermsScreenState();
}

class _QuoteTermsScreenState extends State<QuoteTermsScreen> {
  String _paymentTerms = '30 Days Net from Invoice Date';
  String _deliveryTerms = 'Ex-Factory Noida with Freight Included';
  String _scheme = 'High-Volume Enterprise Tier (5% Margin Rebate)';
  final _validityCtrl = TextEditingController(text: '30 Days');
  final _specialConditionsCtrl = TextEditingController(text: 'Inspection on delivery by client technical representative.');

  @override
  void dispose() {
    _validityCtrl.dispose();
    _specialConditionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Commercial terms'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Commercial terms',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Q-2026-0001 · Acme Technologies · Scheme & payment rules',
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
                  const Text('Schemes and discounts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _scheme,
                    items: const [
                      DropdownMenuItem(
                        value: 'High-Volume Enterprise Tier (5% Margin Rebate)',
                        child: Text('High-Volume Enterprise Tier (5% Margin Rebate)'),
                      ),
                      DropdownMenuItem(
                        value: 'Prompt Payment Scheme (2% Cash Discount within 7 days)',
                        child: Text('Prompt Payment Scheme (2% Cash Discount)'),
                      ),
                      DropdownMenuItem(
                        value: 'Standard Commercial Tier (No Special Scheme)',
                        child: Text('Standard Commercial Tier (No Special Scheme)'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _scheme = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 14),

                  const Text('Payment terms *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _paymentTerms,
                    items: const [
                      DropdownMenuItem(value: '100% Advance Payment', child: Text('100% Advance Payment')),
                      DropdownMenuItem(value: '30 Days Net from Invoice Date', child: Text('30 Days Net from Invoice Date')),
                      DropdownMenuItem(value: '50% Advance, 50% Against Delivery', child: Text('50% Advance, 50% Against Delivery')),
                    ],
                    onChanged: (v) => setState(() => _paymentTerms = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 14),

                  const Text('Delivery terms *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _deliveryTerms,
                    items: const [
                      DropdownMenuItem(value: 'Ex-Factory Noida with Freight Included', child: Text('Ex-Factory Noida (Freight Included)')),
                      DropdownMenuItem(value: 'FOR Client Destination Site', child: Text('FOR Client Destination Site')),
                      DropdownMenuItem(value: 'Ex-Works Warehouse', child: Text('Ex-Works Warehouse')),
                    ],
                    onChanged: (v) => setState(() => _deliveryTerms = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 14),

                  const Text('Quote validity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  TextField(controller: _validityCtrl, decoration: const InputDecoration()),
                  const SizedBox(height: 14),

                  const Text('Special conditions / Delivery notes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 6),
                  TextField(controller: _specialConditionsCtrl, maxLines: 2, decoration: const InputDecoration()),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Commercial terms updated for quotation.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Save commercial terms'),
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
}
