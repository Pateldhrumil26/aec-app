import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/quotation_model.dart';
import '../../providers/aeconnect_provider.dart';

class QuotationBuilderScreen extends StatefulWidget {
  const QuotationBuilderScreen({super.key});

  @override
  State<QuotationBuilderScreen> createState() => _QuotationBuilderScreenState();
}

class _QuotationBuilderScreenState extends State<QuotationBuilderScreen> {
  String _customerName = 'Acme Technologies';
  final List<QuotationItem> _selectedItems = [
    const QuotationItem(
      sku: 'AEC-FOC-24C-SM',
      name: '24-Core Single Mode Armored Fiber Optic Cable (1000m)',
      category: 'Fiber Cable',
      unitRate: 34500,
      quantity: 1,
      discountPercent: 5.0,
    ),
  ];

  void _addItem(String name, String sku, double rate) {
    setState(() {
      _selectedItems.add(
        QuotationItem(
          name: name,
          sku: sku,
          category: 'Hardware',
          unitRate: rate,
          quantity: 1,
        ),
      );
    });
  }

  void _submit() {
    final newQuote = QuotationModel(
      id: 'QT-${DateTime.now().millisecondsSinceEpoch % 10000}',
      proposalNumber: 'AEIPL/${DateTime.now().millisecondsSinceEpoch % 1000}/2627',
      customerName: _customerName,
      issueDate: DateTime.now(),
      validityDate: DateTime.now().add(const Duration(days: 30)),
      status: QuotationStatus.underReview,
      items: List.from(_selectedItems),
      freightFee: 2500,
      gstRate: 0.18,
      approvalNote: 'Submitted by John Doe for Area Sales Manager approval.',
    );

    context.read<AEConnectProvider>().addQuotation(newQuote);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quotation ${newQuote.id} created and sent for ASM review!'),
        backgroundColor: AppColors.statusSuccessFg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _selectedItems.fold(0.0, (sum, i) => sum + i.lineTotal);
    final freight = 2500.0;
    final gst = (subtotal + freight) * 0.18;
    final grandTotal = subtotal + freight + gst;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposal Wizard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Selector
            const Text('Client & Account', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _customerName,
              decoration: const InputDecoration(labelText: 'Customer Account *'),
              items: const [
                DropdownMenuItem(value: 'Acme Technologies', child: Text('Acme Technologies')),
                DropdownMenuItem(value: 'Bharat Infotech Solutions', child: Text('Bharat Infotech Solutions')),
                DropdownMenuItem(value: 'Cloud Connect Networks', child: Text('Cloud Connect Networks')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _customerName = v);
              },
            ),
            const SizedBox(height: 20),

            // Products Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selected Products', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                TextButton.icon(
                  onPressed: () {
                    _showAddProductSheet(context);
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add product'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: _selectedItems.map((item) {
                  return ListTile(
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    subtitle: Text('${item.quantity} × ${AppFormatters.rupee(item.unitRate)} · SKU: ${item.sku}'),
                    trailing: Text(
                      AppFormatters.rupee(item.lineTotal),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Live Calculation Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Subtotal', AppFormatters.rupee(subtotal)),
                    const SizedBox(height: 6),
                    _buildRow('Freight (Door Delivery)', AppFormatters.rupee(freight)),
                    const SizedBox(height: 6),
                    _buildRow('GST (18%)', AppFormatters.rupee(gst)),
                    const Divider(height: 18),
                    _buildRow('Grand Total', AppFormatters.rupee(grandTotal), isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit for Admin & ASM Review', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add from AEIPL Catalog', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('48-Port Optical Distribution Frame (ODF)'),
                subtitle: const Text('SKU: AEC-ODF-48P · ₹4,200'),
                trailing: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                onTap: () {
                  _addItem('48-Port Optical Distribution Frame (ODF)', 'AEC-ODF-48P', 4200);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Optical Patch Cord LC-SC Duplex 3M'),
                subtitle: const Text('SKU: AEC-PC-LC-SC-3M · ₹450'),
                trailing: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                onTap: () {
                  _addItem('Optical Patch Cord LC-SC Duplex 3M', 'AEC-PC-LC-SC-3M', 450);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
        Text(val, style: TextStyle(fontSize: isBold ? 16 : 13, fontWeight: isBold ? FontWeight.w900 : FontWeight.w600, color: isBold ? AppColors.primary : null)),
      ],
    );
  }
}
