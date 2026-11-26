import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<Map<String, dynamic>> items = [
    {
      'title': 'Quotation Submitted for Review',
      'body': 'QT-2026-0001 for Acme Technologies has been submitted to ASM Priya Mehta.',
      'time': '10 mins ago',
      'isUnread': true,
      'icon': Icons.description_rounded,
      'color': Color(0xFF7E22CE),
    },
    {
      'title': 'Order Dispatched',
      'body': 'ORD-2026-0002 has been marked as Dispatched via BlueDart tracking #TRK-882103.',
      'time': '2 hours ago',
      'isUnread': true,
      'icon': Icons.local_shipping_rounded,
      'color': Color(0xFF15803D),
    },
    {
      'title': 'Site Visit Completed',
      'body': 'Site visit VIS-2026-0001 at Sector 62 Noida was completed with GPS check-out.',
      'time': '4 hours ago',
      'isUnread': false,
      'icon': Icons.pin_drop_rounded,
      'color': Color(0xFF0369A1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          final isUnread = item['isUnread'] as bool;

          return Card(
            color: isUnread ? Colors.white : AppColors.background,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
              ),
              title: Text(
                item['title'] as String,
                style: TextStyle(fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600, fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(item['body'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(item['time'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
