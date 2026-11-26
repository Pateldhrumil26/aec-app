import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  static const List<Map<String, dynamic>> _devices = [
    {
      'employee': 'John Doe (EMP104)',
      'device': 'Vivo V2321 (Android 14)',
      'registered': '15 Jan 2026',
      'ip': '192.168.1.104',
      'status': 'Active',
    },
    {
      'employee': 'Rohan Sharma (EMP105)',
      'device': 'OnePlus Nord CE 3 (Android 13)',
      'registered': '20 Feb 2026',
      'ip': '192.168.1.105',
      'status': 'Active',
    },
    {
      'employee': 'Amit Shah (WH001)',
      'device': 'Zebra TC26 Barcode Scanner (Android 12)',
      'registered': '10 Mar 2026',
      'ip': '192.168.2.20',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Employee devices'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee devices',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Review authorized mobile and handheld terminal registrations',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _devices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final d = _devices[idx];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.smartphone, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d['employee'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.navy)),
                            const SizedBox(height: 2),
                            Text(d['device'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text('Registered on ${d['registered']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      StatusPill(label: d['status']),
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
