import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/lead_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';
import 'lead_form_screen.dart';
import 'assign_lead_screen.dart';
import '../pipeline/opportunity_detail_screen.dart';
import '../quotations/quotation_detail_screen.dart';
import '../visits/visit_form_screen.dart';
import '../moms/moms_screen.dart';

class LeadDetailScreen extends StatelessWidget {
  final String? leadId;
  final LeadModel? lead;

  const LeadDetailScreen({super.key, this.leadId, this.lead})
      : assert(leadId != null || lead != null, 'Either leadId or lead must be provided');

  String get effectiveLeadId => leadId ?? lead!.id;

  static const List<String> pipelineSteps = [
    'Connect',
    'Qualify',
    'Proposal',
    'Customer',
    'Order',
    'Delivery',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final matches = provider.leads.where((l) => l.id == effectiveLeadId);

    if (matches.isEmpty && this.lead == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lead Not Found')),
        body: const Center(child: Text('This lead was not found.')),
      );
    }

    final lead = matches.isNotEmpty ? matches.first : this.lead!;

    return Scaffold(
      appBar: AppBar(
        title: Text(lead.companyName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: 'Assign Lead',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AssignLeadScreen(leadId: lead.id)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.trending_up_rounded),
            tooltip: 'Opportunity Details',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OpportunityDetailScreen(opportunityId: 'op1')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Lead',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LeadFormScreen(lead: lead)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header Banner
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          lead.initials,
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
                            lead.companyName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${lead.industry} · ${lead.city}, ${lead.state}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    StatusPill(label: lead.stage.label),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Commercial Alert Banner (if quote linked)
            if (lead.activeQuotationId != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.kpiFollowupsBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.kpiFollowupsFg.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock_clock_rounded, size: 16, color: AppColors.kpiFollowupsFg),
                        SizedBox(width: 6),
                        Text(
                          'Commercial Review Pending',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.kpiFollowupsFg),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lead.activeQuotationId} is waiting for manager approval. Submitted pricing is locked.',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.kpiFollowupsFg,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuotationDetailScreen(quoteId: lead.activeQuotationId!),
                          ),
                        );
                      },
                      child: const Text('View submitted quotation'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Pipeline Stepper (Interactive)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sales Pipeline Stepper', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: pipelineSteps.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final step = entry.value;
                          final isPassed = idx <= 2; // e.g. Proposal stage

                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isPassed ? AppColors.primary : AppColors.border,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${idx + 1}. $step',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isPassed ? Colors.white : AppColors.textMuted,
                                  ),
                                ),
                              ),
                              if (idx < pipelineSteps.length - 1)
                                Container(
                                  width: 16,
                                  height: 2,
                                  color: isPassed ? AppColors.primary : AppColors.border,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Sales Activities Quick Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActivityBtn(Icons.phone_in_talk_rounded, 'Call', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dialing ${lead.phone}...')),
                      );
                    }),
                    _buildActivityBtn(Icons.pin_drop_rounded, 'Visit', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VisitFormScreen()));
                    }),
                    _buildActivityBtn(Icons.event_note_rounded, 'MOM', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MomsScreen()));
                    }),
                    _buildActivityBtn(Icons.receipt_rounded, 'Quote', () {
                      if (lead.activeQuotationId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuotationDetailScreen(quoteId: lead.activeQuotationId!)),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Account Team Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account Team', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryLight,
                          child: Text('JD', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lead.salesRep, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const Text('Account Owner / Field Rep', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.kpiFollowupsBg,
                          child: Text('PM', style: TextStyle(color: AppColors.kpiFollowupsFg, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lead.asm, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const Text('Area Sales Manager (Commercial Approver)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Company & Primary Contact
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Company & Contact Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 14),
                    _buildDetailRow('Primary Contact', lead.contactPerson),
                    const Divider(height: 18),
                    _buildDetailRow('Designation', lead.designation),
                    const Divider(height: 18),
                    _buildDetailRow('Phone', lead.phone),
                    const Divider(height: 18),
                    _buildDetailRow('Official Email', lead.email),
                    const Divider(height: 18),
                    _buildDetailRow('GST Number', lead.gstNumber),
                    const Divider(height: 18),
                    _buildDetailRow('Estimated Value', AppFormatters.rupee(lead.estimatedValue)),
                    const Divider(height: 18),
                    _buildDetailRow('Lead Source', lead.source),
                    const Divider(height: 18),
                    _buildDetailRow('Site Address', lead.address),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requirement Notes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 8),
                    Text(
                      lead.notes,
                      style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
