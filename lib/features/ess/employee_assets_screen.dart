import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class EmployeeAssetsScreen extends StatelessWidget {
  const EmployeeAssetsScreen({super.key});

  static const List<Map<String, dynamic>> _assets = [
    {
      'name': 'Lenovo ThinkPad L14 Gen 4',
      'category': 'IT Hardware / Laptop',
      'tag': 'AEC-IT-0042',
      'serial': 'PF-3X99A-2026',
      'allocated': '15 Jan 2026',
      'warrantyEnd': '15 Jan 2028',
      'warrantyStatus': 'Covered',
      'allocationStatus': 'Active',
      'serviceStatus': 'Operational',
    },
    {
      'name': 'Samsung Galaxy A54 5G Enterprise',
      'category': 'Mobile Device',
      'tag': 'AEC-MOB-0108',
      'serial': 'SM-A546E-IND-01',
      'allocated': '15 Jan 2026',
      'warrantyEnd': '15 Jan 2027',
      'warrantyStatus': 'Covered',
      'allocationStatus': 'Active',
      'serviceStatus': 'Operational',
    },
    {
      'name': 'AE Connect Optical Fiber Power Meter & VFL',
      'category': 'Testing Equipment',
      'tag': 'AEC-TLS-0089',
      'serial': 'FOP-9981-VFL',
      'allocated': '01 Feb 2026',
      'warrantyEnd': '01 Feb 2027',
      'warrantyStatus': 'Covered',
      'allocationStatus': 'Active',
      'serviceStatus': 'Operational',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assigned assets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigned assets',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Allocated company equipment and active warranty status',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _assets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final a = _assets[idx];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F5F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.devices_other, size: 20, color: Color(0xFF08897A)),
                          ),
                          Row(
                            children: [
                              StatusPill(label: a['allocationStatus']),
                              const SizedBox(width: 6),
                              StatusPill(label: a['serviceStatus']),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(a['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text('${a['category']} · Company allocated', style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                      const Divider(height: 20, color: AppColors.border),
                      _buildKv('Asset tag', a['tag']),
                      _buildKv('Serial number', a['serial']),
                      _buildKv('Allocation date', a['allocated']),
                      _buildKv('Warranty until', a['warrantyEnd']),
                      _buildKv('Warranty status', a['warrantyStatus']),
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

  Widget _buildKv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(v, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
        ],
      ),
    );
  }
}
