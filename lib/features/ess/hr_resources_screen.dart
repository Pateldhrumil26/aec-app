import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class HrResourcesScreen extends StatefulWidget {
  const HrResourcesScreen({super.key});

  @override
  State<HrResourcesScreen> createState() => _HrResourcesScreenState();
}

class _HrResourcesScreenState extends State<HrResourcesScreen> {
  int _activeTab = 0; // 0: Policies, 1: Training

  final List<Map<String, dynamic>> _policies = [
    {
      'title': 'AE Connect Employee Code of Conduct',
      'description': 'Workplace integrity, client communication, and operational standards.',
      'version': 'v2.4 · 2026 Edition',
      'read': true,
    },
    {
      'title': 'Travel & Field Expense Reimbursement Policy',
      'description': 'Daily DA, vehicle mileage rates, lodging slabs, and approval matrix.',
      'version': 'v1.8 · Updated Oct 2026',
      'read': true,
    },
    {
      'title': 'Customer Credit & KYC Guidelines',
      'description': 'Mandatory GST verification, billing terms, and credit review workflow.',
      'version': 'v3.0 · Mandatory',
      'read': false,
    },
    {
      'title': 'Information Security & Non-Disclosure Agreement',
      'description': 'Protection of proprietary pricing, dealer agreements, and ERP customer data.',
      'version': 'v2.0 · Standard Policy',
      'read': true,
    },
  ];

  final List<Map<String, dynamic>> _trainings = [
    {
      'title': 'Fiber Optic Cable Specs & Selection Guide',
      'description': 'Armored, aerial ADSS, duct cables and core count recommendations.',
      'version': 'Technical Module · 45 mins',
      'read': true,
    },
    {
      'title': 'PoE Switches & Industrial Networking Architecture',
      'description': 'Layer 2/3 managed switches, CCTV PoE budgets, and SFP transceiver pairing.',
      'version': 'Product Training · 60 mins',
      'read': true,
    },
    {
      'title': 'Field Site Visits SOP & Check-In Workflow',
      'description': 'Real-time GPS capture, site surveys, client meetings, and MOM documentation.',
      'version': 'Field Sales SOP · 30 mins',
      'read': false,
    },
    {
      'title': 'Commercial Proposal Pricing & Approval Rules',
      'description': 'Discount structures, minimum gross margin guidelines, and manager sign-off.',
      'version': 'Commercial Guide · 40 mins',
      'read': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final list = _activeTab == 0 ? _policies : _trainings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Policies & training'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Policies & training',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Read guides and follow your learning & compliance progress',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Underlined Text Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: ['Policies', 'Training'].asMap().entries.map((e) {
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

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final item = list[idx];
                final isRead = item['read'] as bool;
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
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAEFF7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.description_outlined, size: 18, color: Color(0xFFB15B9A)),
                          ),
                          StatusPill(label: isRead ? 'Read' : 'To read'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                      const SizedBox(height: 4),
                      Text(item['description'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['version'], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening ${item['title']}...')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 30),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: const Text('Read document', style: TextStyle(fontSize: 11)),
                          ),
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
}
