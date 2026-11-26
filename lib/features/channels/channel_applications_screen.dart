import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';
import 'channel_application_detail_screen.dart';

class ChannelApplicationsScreen extends StatefulWidget {
  const ChannelApplicationsScreen({super.key});

  @override
  State<ChannelApplicationsScreen> createState() => _ChannelApplicationsScreenState();
}

class _ChannelApplicationsScreenState extends State<ChannelApplicationsScreen> {
  int _activeTab = 0; // 0: Distributor, 1: Dealer, 2: SI Partner

  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'AP-2026-001',
      'company': 'NorthStar Infotech Pvt Ltd',
      'type': 'Distributor',
      'location': 'Lucknow, Uttar Pradesh',
      'turnover': '₹12.5 Cr',
      'status': 'Pending Review',
      'applied': '22 Nov 2026',
    },
    {
      'id': 'AP-2026-002',
      'company': 'Zenith Netcom Systems',
      'type': 'Dealer',
      'location': 'Jaipur, Rajasthan',
      'turnover': '₹4.8 Cr',
      'status': 'Documents Requested',
      'applied': '18 Nov 2026',
    },
    {
      'id': 'AP-2026-003',
      'company': 'OptiLink Solutions LLP',
      'type': 'SI Partner',
      'location': 'Dehradun, Uttarakhand',
      'turnover': '₹8.2 Cr',
      'status': 'Approved',
      'applied': '10 Nov 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Channel applications'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Channel applications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Distributor, dealer and system integrator partnership requests',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Underlined Text Tabs
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: ['Distributor', 'Dealer', 'SI Partner'].asMap().entries.map((e) {
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
              itemCount: _applications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final a = _applications[idx];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChannelApplicationDetailScreen(applicationId: a['id'])),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
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
                            Text(a['company'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.navy)),
                            StatusPill(label: a['status']),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('${a['type']} · ${a['location']}', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('Turnover: ${a['turnover']} · Applied on ${a['applied']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
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
