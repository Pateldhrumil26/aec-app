import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, this.orderId = 'ord-demo'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order detail'),
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
                    Text('ORD-2026-0001', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy)),
                    SizedBox(height: 2),
                    Text('Bright Infra Solutions · PO DEMO-PO-2026-001', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                StatusPill(label: 'Awaiting Stock'),
              ],
            ),
            const SizedBox(height: 16),

            // Order Summary Card
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
                  const Text('Order summary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildKvRow('Total order value', '₹6,16,432 (incl. 18% GST)'),
                  _buildKvRow('Target dispatch date', '01 Dec 2026'),
                  _buildKvRow('Logistics carrier', 'Safexpress Logistics Pvt Ltd'),
                  _buildKvRow('Waybill / Tracking', 'SFX-99827361'),
                  _buildKvRow('Shipping destination', 'Ahmedabad GIDC, Gujarat'),
                  _buildKvRow('Payment terms', '30 Days Net from Delivery'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items List
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
                  const Text('Ordered line items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.navy)),
                  const Divider(height: 18, color: AppColors.border),
                  _buildItemRow('24-Core Single Mode Armored Cable', '5,000 meters · Drum 1 & 2', '₹2,65,000'),
                  _buildItemRow('10G SFP+ Optical Transceiver 1310nm', '40 units · Bulk pack', '₹1,56,000'),
                  _buildItemRow('48-Port Rack Mount ODF', '4 units · 1U standard', '₹36,000'),
                  _buildItemRow('Cat6A UTP Patch Cords 2m', '200 units · Blue jacket', '₹65,000'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String title, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy)),
                Text(qty, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
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
