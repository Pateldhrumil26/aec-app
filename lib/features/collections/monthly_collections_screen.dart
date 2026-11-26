import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';
import 'invoice_detail_screen.dart';

class MonthlyCollectionsScreen extends StatefulWidget {
  const MonthlyCollectionsScreen({super.key});

  @override
  State<MonthlyCollectionsScreen> createState() => _MonthlyCollectionsScreenState();
}

class _MonthlyCollectionsScreenState extends State<MonthlyCollectionsScreen> {
  String _selectedMonth = 'November 2026';

  final List<Map<String, dynamic>> _monthlyRows = [
    {
      'inv': 'INV-2026-0001',
      'client': 'Acme Technologies',
      'billed': '₹2,46,572',
      'collected': '₹2,46,572',
      'pending': '₹0',
      'status': 'Paid',
    },
    {
      'inv': 'INV-2026-0002',
      'client': 'Bright Infra Solutions',
      'billed': '₹6,16,432',
      'collected': '₹3,00,000',
      'pending': '₹3,16,432',
      'status': 'Partially Paid',
    },
    {
      'inv': 'INV-2026-0003',
      'client': 'CityNet Communications',
      'billed': '₹4,85,000',
      'collected': '₹0',
      'pending': '₹4,85,000',
      'status': 'Overdue',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Monthly collections'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly collections',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Detailed aging analysis, billing breakdown and realization reports',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Month Selector Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Report period', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'November 2026', child: Text('November 2026')),
                      DropdownMenuItem(value: 'October 2026', child: Text('October 2026')),
                      DropdownMenuItem(value: 'September 2026', child: Text('September 2026')),
                    ],
                    onChanged: (v) => setState(() => _selectedMonth = v!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Stat Boxes
            Row(
              children: [
                _buildStatBox('₹13,48,004', 'Total Billed', AppColors.navy),
                const SizedBox(width: 8),
                _buildStatBox('₹5,46,572', 'Realized', const Color(0xFF08897A)),
                const SizedBox(width: 8),
                _buildStatBox('₹8,01,432', 'Pending', const Color(0xFFD97706)),
              ],
            ),
            const SizedBox(height: 16),

            // Monthly Invoices Table
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
                  const Text('Invoice realizations', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _monthlyRows.length,
                    separatorBuilder: (_, __) => const Divider(height: 16, color: AppColors.border),
                    itemBuilder: (context, idx) {
                      final r = _monthlyRows[idx];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoiceId: r['inv'])),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r['inv'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
                                  const SizedBox(height: 1),
                                  Text(r['client'], style: const TextStyle(fontSize: 12, color: AppColors.navy)),
                                  const SizedBox(height: 2),
                                  Text('Billed: ${r['billed']} · Recv: ${r['collected']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  StatusPill(label: r['status']),
                                  const SizedBox(height: 4),
                                  Text('Bal: ${r['pending']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.danger)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

  Widget _buildStatBox(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
