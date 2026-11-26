import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _claims = [
    {
      'id': 'EXP-2026-001',
      'category': 'Travel & Fuel',
      'amount': '₹1,850',
      'date': '24 Nov 2026',
      'related': 'Client: Acme Technologies (Noida Visit)',
      'status': 'Submitted',
      'notes': 'Cab fare and toll charges for on-site client meeting',
      'receipts': 2,
    },
    {
      'id': 'EXP-2026-002',
      'category': 'Client Dining / Refreshments',
      'amount': '₹2,650',
      'date': '19 Nov 2026',
      'related': 'Client: Bright Infra Solutions',
      'status': 'Approved',
      'notes': 'Lunch meeting with VP of Procurement',
      'receipts': 1,
    },
    {
      'id': 'EXP-2026-003',
      'category': 'Lodging & Hotel',
      'amount': '₹6,400',
      'date': '05 Nov 2026',
      'related': 'Regional Tour: Chandigarh Telecom Expo',
      'status': 'Disbursed',
      'notes': 'Hotel stay for 2 nights approved by ASM',
      'receipts': 3,
    },
  ];

  void _showSubmitDialog() {
    String category = 'Travel & Fuel';
    String related = 'General expense';
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Submit expense claim', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expense category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(value: 'Travel & Fuel', child: Text('Travel & Fuel')),
                    DropdownMenuItem(value: 'Client Dining / Refreshments', child: Text('Client Dining / Refreshments')),
                    DropdownMenuItem(value: 'Lodging & Hotel', child: Text('Lodging & Hotel')),
                    DropdownMenuItem(value: 'Local Conveyance', child: Text('Local Conveyance')),
                    DropdownMenuItem(value: 'Miscellaneous', child: Text('Miscellaneous')),
                  ],
                  onChanged: (v) => setDialogState(() => category = v!),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 12),
                const Text('Related to', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: related,
                  items: const [
                    DropdownMenuItem(value: 'General expense', child: Text('General expense')),
                    DropdownMenuItem(value: 'Client: Acme Technologies', child: Text('Client: Acme Technologies')),
                    DropdownMenuItem(value: 'Lead: Bright Infra Solutions', child: Text('Lead: Bright Infra Solutions')),
                  ],
                  onChanged: (v) => setDialogState(() => related = v!),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 12),
                const Text('Claim amount (INR)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 1500')),
                const SizedBox(height: 12),
                const Text('Purpose / Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(controller: notesCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Expense purpose...')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _claims.insert(0, {
                    'id': 'EXP-2026-00${_claims.length + 1}',
                    'category': category,
                    'amount': '₹${amountCtrl.text.isEmpty ? '1,500' : amountCtrl.text}',
                    'date': '26 Nov 2026',
                    'related': related,
                    'status': 'Submitted',
                    'notes': notesCtrl.text.isEmpty ? 'Field expense' : notesCtrl.text,
                    'receipts': 1,
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense claim submitted for manager review.')),
                );
              },
              child: const Text('Submit claim'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _claims.where((c) {
      if (_selectedFilter != 'All' && c['status'] != _selectedFilter) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Expense reimbursements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense claims', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('Submit receipts and track reimbursements', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showSubmitDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Submit expense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stat Strip: Awaiting review, Approved to pay, Marked disbursed
            Row(
              children: [
                _buildStatBox('1', 'Awaiting review', const Color(0xFFFBF5EA), const Color(0xFF935817)),
                const SizedBox(width: 8),
                _buildStatBox('₹2,650', 'Approved to pay', const Color(0xFFE5F5F0), const Color(0xFF08897A)),
                const SizedBox(width: 8),
                _buildStatBox('₹6,400', 'Marked disbursed', const Color(0xFFE4F3F8), const Color(0xFF087F9D)),
              ],
            ),
            const SizedBox(height: 18),

            // Underlined Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Submitted', 'Approved', 'Disbursed', 'Rejected'].map((tab) {
                    final isSelected = _selectedFilter == tab;
                    return InkWell(
                      onTap: () => setState(() => _selectedFilter = tab),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          tab,
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
            ),
            const SizedBox(height: 16),

            // Claims List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final c = filtered[idx];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['category'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                          StatusPill(label: c['status']),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['amount'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          Text(c['date'], style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(c['related'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text(c['notes'], style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_file, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text('${c['receipts']} receipt attached', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String val, String label, Color bg, Color fg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: fg)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
