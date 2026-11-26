import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final String opportunityId;

  const OpportunityDetailScreen({super.key, this.opportunityId = 'op1'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Opportunity details'),
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
                    Text('Fiber Backbone Expansion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('OPP-2026-004 · Acme Technologies', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'Proposal'),
              ],
            ),
            const SizedBox(height: 16),

            // Deal Metrics Card
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
                  const Text('Deal information', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Expected deal value', '₹8,50,000'),
                  _buildKvRow('Win probability', '75%'),
                  _buildKvRow('Target close date', '15 Dec 2026'),
                  _buildKvRow('Sales executive', 'John Doe (EMP104)'),
                  _buildKvRow('Current pipeline stage', 'Proposal Stage'),
                  _buildKvRow('Customer segment', 'Telecom / ISP'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stage Progression Card
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
                  const Text('Stage pipeline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  _buildStageItem('1. Qualification', true),
                  _buildStageItem('2. Technical Discovery', true),
                  _buildStageItem('3. Commercial Proposal', true, isCurrent: true),
                  _buildStageItem('4. Negotiation', false),
                  _buildStageItem('5. Closed Won', false),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStageItem(String name, bool isDone, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isDone ? (isCurrent ? Icons.radio_button_checked : Icons.check_circle) : Icons.radio_button_unchecked,
            size: 18,
            color: isCurrent ? AppColors.primary : (isDone ? const Color(0xFF08897A) : AppColors.textMuted),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isCurrent ? FontWeight.w700 : (isDone ? FontWeight.w600 : FontWeight.w400),
              color: isCurrent ? AppColors.primary : (isDone ? AppColors.navy : AppColors.textMuted),
            ),
          ),
        ],
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
