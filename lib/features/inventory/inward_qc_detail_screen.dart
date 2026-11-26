import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class InwardQcDetailScreen extends StatelessWidget {
  final String inwardId;

  const InwardQcDetailScreen({super.key, this.inwardId = 'inw1'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Material inward & QC'),
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
                    Text('INW-2026-0001', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('Gate Ref: GR-9982 · Supplier Consignment', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'QC Passed'),
              ],
            ),
            const SizedBox(height: 16),

            // Consignment Details
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
                  const Text('Consignment details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Material received', '24-Core Single Mode Outdoor Drums'),
                  _buildKvRow('Received quantity', '10,000 meters (2 Drums)'),
                  _buildKvRow('Supplier invoice & challan', 'CH-77821 · M/s Sterlite Opticals'),
                  _buildKvRow('Gate entry timestamp', '26 Nov 2026 · 08:45 AM'),
                  _buildKvRow('Inward inspection controller', 'Amit Shah (WH001)'),
                  _buildKvRow('OTDR fiber attenuation test', 'Passed (<0.35 dB/km @ 1310nm)'),
                  _buildKvRow('Physical armor & sheath inspection', 'Intact · No transit deformation'),
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
