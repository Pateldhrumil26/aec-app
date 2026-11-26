import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/visit_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'visit_summary_screen.dart';

class ActiveVisitScreen extends StatefulWidget {
  final VisitModel visit;
  const ActiveVisitScreen({super.key, required this.visit});

  @override
  State<ActiveVisitScreen> createState() => _ActiveVisitScreenState();
}

class _ActiveVisitScreenState extends State<ActiveVisitScreen> {
  late Timer _timer;
  late int _secondsElapsed;

  @override
  void initState() {
    super.initState();
    final diff = DateTime.now().difference(widget.visit.checkInTime).inSeconds;
    _secondsElapsed = diff > 0 ? diff : widget.visit.durationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _checkOut() {
    _timer.cancel();
    final updatedVisit = widget.visit.copyWith(
      checkOutTime: DateTime.now(),
      durationSeconds: _secondsElapsed,
      status: VisitStatus.awaitingSummary,
    );

    context.read<AEConnectProvider>().updateVisit(updatedVisit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VisitSummaryScreen(visit: updatedVisit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.visit.companyName
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join();

    final dateFormat = DateFormat('d MMM yyyy · hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active visit'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('All visits', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Head
            const Text(
              'Active visit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Visit in progress · ${widget.visit.companyName}',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Main Visit in progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  // Detail Hero
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.visit.companyName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.visit.purpose} · John Doe',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Timer Ring (.timer-ring)
                  Container(
                    width: 175,
                    height: 175,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FDFB),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFC6E9E0), width: 6),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDuration(_secondsElapsed),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              fontFeatures: [FontFeature.tabularFigures()],
                              color: AppColors.navy,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Time on site',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Active Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fiber_manual_record, size: 8, color: AppColors.teal),
                        SizedBox(width: 5),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 12),

                  // Key Values (.kv)
                  _buildKvRow('Checked in', dateFormat.format(widget.visit.checkInTime)),
                  _buildKvRow('Meeting contact', widget.visit.contactPerson),
                  _buildKvRow('Location', widget.visit.locationAddress),
                  _buildKvRow(
                    'Coordinates',
                    '${widget.visit.latitude.toStringAsFixed(5)}, ${widget.visit.longitude.toStringAsFixed(5)}',
                  ),
                  const SizedBox(height: 20),

                  // Check out button
                  ElevatedButton.icon(
                    onPressed: _checkOut,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Check out & record summary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKvRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
