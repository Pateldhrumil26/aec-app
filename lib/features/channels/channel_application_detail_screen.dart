import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class ChannelApplicationDetailScreen extends StatelessWidget {
  final String applicationId;

  const ChannelApplicationDetailScreen({super.key, this.applicationId = 'ap1'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Application review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NorthStar Infotech Pvt Ltd', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('AP-2026-001 · Exclusive Distributor Application', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'Pending Review'),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Card
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
                  const Text('Business profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Business segment', 'Passive Networking & Telecom Systems'),
                  _buildKvRow('Annual turnover', '₹12.50 Crores (FY 2024-25)'),
                  _buildKvRow('Target product lines', 'Optical Fiber Cables, ODF, SFP Transceivers'),
                  _buildKvRow('Requested territory', 'Lucknow & Eastern Uttar Pradesh'),
                  _buildKvRow('Warehouse & office setup', '3,500 sq ft owned facility in Transport Nagar, Lucknow'),
                  _buildKvRow('Territory conflict check', 'Clear · No existing exclusive distributor in territory'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Decision Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Additional compliance documents requested.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size(0, 42),
                    ),
                    child: const Text('Request docs'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Channel application approved.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusSuccessFg,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 42),
                    ),
                    child: const Text('Approve partner'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(v, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
        ],
      ),
    );
  }
}
