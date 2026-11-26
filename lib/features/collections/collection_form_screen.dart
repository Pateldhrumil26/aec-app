import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CollectionFormScreen extends StatefulWidget {
  final String invoiceId;

  const CollectionFormScreen({super.key, this.invoiceId = 'inv1'});

  @override
  State<CollectionFormScreen> createState() => _CollectionFormScreenState();
}

class _CollectionFormScreenState extends State<CollectionFormScreen> {
  String _mode = 'Cheque';
  final _amountCtrl = TextEditingController(text: '246572');
  final _chequeNumberCtrl = TextEditingController(text: 'CHQ-889102');
  final _bankCtrl = TextEditingController(text: 'ICICI Bank');
  final _dateCtrl = TextEditingController(text: '26 Nov 2026');
  final _remarksCtrl = TextEditingController(text: 'Received against full settlement of INV-2026-0001');

  @override
  void dispose() {
    _amountCtrl.dispose();
    _chequeNumberCtrl.dispose();
    _bankCtrl.dispose();
    _dateCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Record collection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record collection',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.invoiceId} · Acme Technologies (Noida)',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
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
                  const Text('Payment instrument mode *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _mode,
                    items: const [
                      DropdownMenuItem(value: 'Cheque', child: Text('Cheque / Demand Draft')),
                      DropdownMenuItem(value: 'NEFT / RTGS', child: Text('NEFT / RTGS Online Transfer')),
                      DropdownMenuItem(value: 'UPI', child: Text('UPI / Direct Transfer')),
                    ],
                    onChanged: (v) => setState(() => _mode = v!),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),
                  _buildInput('Amount collected (INR) *', _amountCtrl, keyboardType: TextInputType.number),
                  if (_mode == 'Cheque') ...[
                    _buildInput('Cheque / DD number *', _chequeNumberCtrl),
                    _buildInput('Issuing bank name *', _bankCtrl),
                  ] else ...[
                    _buildInput('Transaction / UTR reference *', _chequeNumberCtrl),
                  ],
                  _buildInput('Collection date *', _dateCtrl),
                  _buildInput('Collection remarks', _remarksCtrl, maxLines: 2),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment collection entry recorded.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                      child: const Text('Save collection entry'),
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
