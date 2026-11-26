import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/visit_model.dart';
import '../../providers/aeconnect_provider.dart';
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
  DateTime _nextFollowUp = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final targetId = widget.visit?.id ?? widget.visitId ?? '';
    final matches = provider.visits.where((v) => v.id == targetId);
    final visit = matches.isNotEmpty ? matches.first : widget.visit;

    if (visit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Visit Not Found')),
        body: const Center(child: Text('Visit record not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Summary · ${visit.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.companyName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Purpose: ${visit.purpose} · Contact: ${visit.contactPerson}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Duration', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              AppFormatters.formatSeconds(visit.durationSeconds),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Checked In At', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              AppFormatters.time(visit.checkInTime),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Discussion Outcome
            const Text(
              'Discussion Outcome',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _outcome,
              decoration: const InputDecoration(labelText: 'Outcome *'),
              items: const [
                DropdownMenuItem(value: 'Quotation Requested', child: Text('Quotation Requested')),
                DropdownMenuItem(value: 'Follow-up Required', child: Text('Follow-up Required')),
                DropdownMenuItem(value: 'Order Won', child: Text('Order Won')),
                DropdownMenuItem(value: 'Not Interested', child: Text('Not Interested')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _outcome = v);
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Discussion Notes *',
                hintText: 'Record key points discussed, technical queries, or pricing expectations...',
              ),
            ),
            const SizedBox(height: 16),

            // Next Follow-up Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                title: const Text('Next Follow-up Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                subtitle: Text(AppFormatters.date(_nextFollowUp)),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _nextFollowUp,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _nextFollowUp = picked);
                  },
                  child: const Text('Change'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Complete Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  provider.checkOutVisit(
                    visit.id,
                    _outcome,
                    _notesController.text.trim(),
                    _nextFollowUp,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Visit marked as completed!'),
                      backgroundColor: AppColors.statusSuccessFg,
                    ),
                  );
                },
                child: const Text('Save & Complete Visit'),
              ),
            ),
            const SizedBox(height: 10),

            // Generate MOM Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MomsScreen()),
                  );
                },
                icon: const Icon(Icons.event_note_rounded),
                label: const Text('Generate MOM from Visit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
