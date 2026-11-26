import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/visit_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../leads/lead_detail_screen.dart';
import '../moms/moms_screen.dart';

class VisitSummaryScreen extends StatefulWidget {
  final String? visitId;
  final VisitModel? visit;

  const VisitSummaryScreen({super.key, this.visitId, this.visit});

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  String _outcome = 'Quotation Requested';
  final _notesController = TextEditingController();
  DateTime _nextFollowUp = DateTime.now().add(const Duration(days: 2));

  final List<String> _outcomes = [
    'Product Discussion',
    'Initial Pitch',
    'Demo Completed',
    'Payment Follow-up',
    'Quotation Requested',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.visit;
    if (v != null) {
      if (v.outcome != null && v.outcome!.isNotEmpty) {
        _outcome = v.outcome!;
      }
      if (v.discussionNotes != null) {
        _notesController.text = v.discussionNotes!;
      }
      if (v.nextFollowUp != null) {
        _nextFollowUp = v.nextFollowUp!;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final targetId = widget.visit?.id ?? widget.visitId ?? 'v1';
    final matches = provider.visits.where((v) => v.id == targetId);
    final visit = matches.isNotEmpty
        ? matches.first
        : (widget.visit ??
            VisitModel(
              id: 'v1',
              leadId: 'l1',
              companyName: 'Acme Technologies',
              contactPerson: 'Rahul Sharma',
              purpose: 'Technical Discussion',
              isGpsVerified: true,
              locationAddress: 'Noida - illustrative customer site',
              latitude: 28.627,
              longitude: 77.373,
              checkInTime: DateTime.now().subtract(const Duration(hours: 2)),
              checkOutTime: DateTime.now().subtract(const Duration(minutes: 90)),
              durationSeconds: 1800,
              status: VisitStatus.completed,
              outcome: 'Quotation Requested',
              discussionNotes:
                  'Reviewed the proposed network architecture and cable specifications. Agreed to share a phased commercial offer.',
              nextFollowUp: DateTime.now().add(const Duration(days: 2)),
            ));

    final isCompleted = visit.status == VisitStatus.completed;

    final checkInStr = DateFormat('hh:mm a').format(visit.checkInTime);
    final checkOutStr = visit.checkOutTime != null
        ? DateFormat('hh:mm a').format(visit.checkOutTime!)
        : DateFormat('hh:mm a').format(visit.checkInTime.add(Duration(seconds: visit.durationSeconds)));
    final followUpStr = DateFormat('d MMM yyyy').format(visit.nextFollowUp ?? _nextFollowUp);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back & Title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCompleted ? 'Visit summary' : 'Complete visit',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCompleted
                                ? 'A saved visit record with a fixed start, end and duration.'
                                : 'Capture the outcome while the conversation is fresh.',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Card 1: Visit Meta Card
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Company Name & Code / Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  visit.companyName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  visit.id.startsWith('VIS-') ? visit.id : 'VIS-2026-0001',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF62748C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFFEAF5EE)
                                  : const Color(0xFFFFF3DD),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              visit.status.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isCompleted
                                    ? const Color(0xFF2D7854)
                                    : const Color(0xFF946419),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFEDF0F5)),
                      const SizedBox(height: 12),

                      // Start Time
                      _buildFactRow('Start', checkInStr),
                      const SizedBox(height: 10),

                      // End Time
                      _buildFactRow('End', checkOutStr),
                      const SizedBox(height: 10),

                      // Fixed Duration
                      _buildFactRow(
                        'Fixed duration',
                        AppFormatters.formatSeconds(visit.durationSeconds),
                        isDuration: true,
                      ),
                      const SizedBox(height: 10),

                      // Location
                      _buildFactRow('Location', visit.locationAddress),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2: Discussion Outcome Card
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isCompleted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Discussion outcome',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 14),

                            _buildFactRow('Outcome', visit.outcome ?? 'Quotation Requested'),
                            const SizedBox(height: 12),

                            if (visit.discussionNotes != null &&
                                visit.discussionNotes!.isNotEmpty) ...[
                              Text(
                                visit.discussionNotes!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF334A66),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            _buildFactRow('Next follow-up', followUpStr),
                            const SizedBox(height: 20),

                            // Next Actions Row
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final leadMatches = provider.leads.where(
                                        (l) =>
                                            l.id == visit.leadId ||
                                            l.companyName == visit.companyName,
                                      );
                                      if (leadMatches.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LeadDetailScreen(lead: leadMatches.first),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_forward, size: 16),
                                    label: const Text('Continue sales workflow'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 42),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const MomsScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.description_outlined, size: 16),
                                  label: const Text('Generate MOM'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textPrimary,
                                    side: const BorderSide(color: AppColors.border),
                                    minimumSize: const Size(0, 42),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Meeting outcome',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _outcome,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              items: _outcomes
                                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _outcome = val);
                              },
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Meeting summary',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _notesController,
                              maxLines: 4,
                              minLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Write meeting notes and agreed next steps...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Back to visits'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    final updated = visit.copyWith(
                                      status: VisitStatus.completed,
                                      outcome: _outcome,
                                      discussionNotes: _notesController.text.trim(),
                                      nextFollowUp: _nextFollowUp,
                                    );
                                    provider.updateVisit(updated);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Save visit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactRow(String label, String value, {bool isDuration = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF62748C)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isDuration ? FontWeight.w700 : FontWeight.w600,
            color: isDuration ? const Color(0xFF087E6D) : AppColors.navy,
          ),
        ),
      ],
    );
  }
}
