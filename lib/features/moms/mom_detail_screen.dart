import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class MomDetailScreen extends StatelessWidget {
  final String momId;

  const MomDetailScreen({super.key, this.momId = 'm1'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meeting detail'),
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
                    Text('Fiber backbone review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('MOM-2026-0001 · Acme Technologies', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'Approved'),
              ],
            ),
            const SizedBox(height: 16),

            // Meeting Facts Card
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
                  const Text('Meeting metadata', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Date of meeting', '24 Nov 2026 · 11:30 AM'),
                  _buildKvRow('Client account', 'Acme Technologies (Noida)'),
                  _buildKvRow('Recorded by', 'John Doe (EMP104)'),
                  _buildKvRow('Attendees', 'Rajesh Sharma, John Doe'),
                  _buildKvRow('Manager review', 'Approved by Priya Mehta'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Discussion & Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Minutes & discussion', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  SizedBox(height: 8),
                  Text(
                    'Client confirmed requirement of 24-core armored single mode cables for Q1 rollout. Price proposal discussed.',
                    style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
                  ),
                  Divider(height: 20, color: AppColors.border),
                  Text('Agreed action items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  SizedBox(height: 8),
                  Text(
                    'Send official quotation with delivery lead time by Friday.',
                    style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
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
