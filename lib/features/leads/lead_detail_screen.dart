import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/lead_model.dart';
import '../../models/permission.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';
import 'lead_form_screen.dart';
import 'assign_lead_screen.dart';
import '../pipeline/opportunity_detail_screen.dart';
import '../quotations/quotation_detail_screen.dart';
import '../visits/visit_form_screen.dart';
import '../moms/mom_form_screen.dart';
import '../tasks/task_form_screen.dart';

class LeadDetailScreen extends StatefulWidget {
  final String? leadId;
  final LeadModel? lead;

  const LeadDetailScreen({super.key, this.leadId, this.lead})
      : assert(leadId != null || lead != null, 'Either leadId or lead must be provided');

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  int _activeTab = 0;
  bool _manualStageExpanded = false;

  static const List<String> _tabs = ['Overview', 'Contacts', 'Activity'];

  static const List<String> _pipelineSteps = [
    'Connect',
    'Qualify',
    'Proposal',
    'Customer',
    'Order',
    'Delivery',
  ];

  String get _effectiveLeadId => widget.leadId ?? widget.lead!.id;

  int _currentStepIndex(LeadStage stage) {
    switch (stage) {
      case LeadStage.newLead:
        return 0;
      case LeadStage.qualified:
        return 1;
      case LeadStage.proposal:
        return 3; // Connect, Qualify, Proposal done -> Customer next
      case LeadStage.negotiation:
        return 3;
      case LeadStage.closedWon:
        return 5;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final matches = provider.leads.where((l) => l.id == _effectiveLeadId);

    if (matches.isEmpty && widget.lead == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Lead Not Found')),
        body: const Center(child: Text('This lead was not found.')),
      );
    }

    final lead = matches.isNotEmpty ? matches.first : widget.lead!;
    final canEdit = provider.hasPermission(AppFeature.leads, AppAction.edit);
    final canAssign = provider.hasPermission(AppFeature.leads, AppAction.assign);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lead details'),
        actions: [
          if (canAssign)
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Header: Lead details + company subtitle + Edit lead button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lead details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lead.companyName,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (canEdit)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LeadFormScreen(lead: lead)),
                          );
                        },
                        icon: const Icon(Icons.edit_square, size: 15, color: Color(0xFF036E97)),
                        label: const Text(
                          'Edit lead',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF036E97),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2. Company Summary Card (matching prototype)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            lead.initials,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${lead.industry} · ${lead.city}, ${lead.state}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            StatusPill(label: lead.stage.label),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Underlined Tabs: Overview | Contacts | Activity
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: _tabs.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final title = entry.value;
                      final isSelected = _activeTab == idx;
                      return InkWell(
                        onTap: () => setState(() => _activeTab = idx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected ? const Color(0xFF036E97) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF036E97) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Tab Body
                if (_activeTab == 0) _buildOverviewTab(context, lead, canAssign),
                if (_activeTab == 1) _buildContactsTab(context, lead),
                if (_activeTab == 2) _buildActivityTab(context, lead),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, LeadModel lead, bool canAssign) {
    final ownerName = lead.salesRep.split(' (').first;
    final ownerCode = lead.salesRep.contains('EMP105')
        ? 'EMP105'
        : lead.salesRep.contains('EMP104')
            ? 'EMP104'
            : (lead.salesRep == 'Unassigned' ? 'Needs assignment' : 'Sales Rep');
    final ownerAsset = lead.salesRep.contains('EMP105')
        ? 'assets/people/emp105.jpg'
        : lead.salesRep.contains('EMP104')
            ? 'assets/people/emp104.jpg'
            : null;
    final activeStep = _currentStepIndex(lead.stage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // People on this account card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'People on this account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  if (canAssign)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AssignLeadScreen(leadId: lead.id)),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        minimumSize: const Size(0, 28),
                      ),
                      child: const Text('Reassign', style: TextStyle(fontSize: 11.5)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAvatar(ownerAsset, ownerName.isNotEmpty ? ownerName[0] : 'U', 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account owner',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          ownerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF036E97),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          ownerCode,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 22, color: Color(0xFFF1F5F9)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildAvatar('assets/people/mgr1.jpg', 'P', 36),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.asm,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          const Text(
                            'Area Sales Manager',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Next action + 6-step horizontal stepper + Commercial review + Sales activities
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Next action',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Required',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6-step compact stepper fitting cleanly across card width
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _pipelineSteps.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final label = entry.value;
                  final isDone = idx < activeStep;
                  final isCurrent = idx == activeStep;

                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: idx == 0 ? Colors.transparent : const Color(0xFFE2E8F0),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? const Color(0xFF036E97)
                                    : isDone
                                        ? const Color(0xFFECFDF5)
                                        : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: isDone
                                    ? Border.all(color: const Color(0xFFA7F3D0))
                                    : null,
                              ),
                              child: Center(
                                child: isDone
                                    ? const Icon(Icons.check, size: 13, color: Color(0xFF059669))
                                    : Text(
                                        '${idx + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isCurrent ? Colors.white : const Color(0xFF64748B),
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: idx == _pipelineSteps.length - 1
                                    ? Colors.transparent
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCurrent ? const Color(0xFF036E97) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Commercial review block (matching prototype)
              if (lead.activeQuotationId != null) ...[
                const SizedBox(height: 18),
                const Text(
                  'Commercial review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${lead.activeQuotationId} is waiting for manager approval. Submitted details are locked.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuotationDetailScreen(quoteId: lead.activeQuotationId!),
                        ),
                      );
                    },
                    icon: const Icon(Icons.verified_user_outlined, size: 18),
                    label: const Text(
                      'View submitted quotation',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF036E97),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 18),
              // Sales activities header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sales activities',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    'Optional',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 2x2 Outlined Grid: Log call | Log meeting / Site visit | Assign task
              Row(
                children: [
                  Expanded(
                    child: _buildSalesActivityTile(
                      Icons.phone_outlined,
                      'Log call',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logging call with ${lead.contactPerson}...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSalesActivityTile(
                      Icons.calendar_today_outlined,
                      'Log meeting',
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MomFormScreen()));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSalesActivityTile(
                      Icons.location_on_outlined,
                      'Site visit',
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const VisitFormScreen()));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSalesActivityTile(
                      Icons.check_box_outlined,
                      'Assign task',
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskFormScreen()));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: _buildSalesActivityTile(
                  Icons.description_outlined,
                  'Record MOM',
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MomFormScreen()));
                  },
                  centered: true,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpportunityDetailScreen(opportunityId: 'op1')),
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF036E97)),
                      SizedBox(width: 6),
                      Text(
                        'Linked opportunity',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF036E97),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Company & contact card (right-aligned values, matching prototype)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Company & contact',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 12),
              _buildKvRow('Primary contact', lead.contactPerson),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Designation', lead.designation),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Phone', lead.phone, valueColor: const Color(0xFF036E97)),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Email', lead.email, valueColor: const Color(0xFF036E97)),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Address', lead.address),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('GST number', lead.gstNumber),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Lead source', lead.source),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Territory / Region', '${lead.city} / ${lead.state}'),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Pincode', 'Not provided'),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildKvRow('Area Sales Manager', lead.asm),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assigned to', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                  Row(
                    children: [
                      _buildAvatar(ownerAsset, ownerName.isNotEmpty ? ownerName[0] : 'U', 20),
                      const SizedBox(width: 6),
                      Text(
                        ownerName,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.navy),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Requirement summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Requirement summary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                lead.notes,
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Manual stage change (collapsible card matching prototype)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manual stage change',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => setState(() => _manualStageExpanded = !_manualStageExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Advance or close this lead',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                    ),
                    Icon(
                      _manualStageExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              if (_manualStageExpanded) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: LeadStage.values
                      .where((s) => s != LeadStage.all)
                      .map((stage) {
                    final isCurrent = lead.stage == stage;
                    return ChoiceChip(
                      label: Text(stage.label, style: const TextStyle(fontSize: 11.5)),
                      selected: isCurrent,
                      onSelected: (_) {
                        context.read<AEConnectProvider>().updateLeadStage(lead.id, stage);
                      },
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactsTab(BuildContext context, LeadModel lead) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company & Contact Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
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
          _buildDetailRow('Site Address', lead.address),
        ],
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context, LeadModel lead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Commercial & Activity Summary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 14),
              _buildDetailRow('Estimated Value', AppFormatters.rupee(lead.estimatedValue)),
              const Divider(height: 18),
              _buildDetailRow('Lead Source', lead.source),
              const Divider(height: 18),
              _buildDetailRow('Current Stage', lead.stage.label),
              if (lead.activeQuotationId != null) ...[
                const Divider(height: 18),
                _buildDetailRow('Linked Quote', lead.activeQuotationId!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Requirement Notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                lead.notes,
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? assetPath, String fallbackInitial, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
      ),
      clipBehavior: Clip.antiAlias,
      child: assetPath != null
          ? Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text(
                  fallbackInitial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                fallbackInitial,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
    );
  }

  Widget _buildSalesActivityTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool centered = false,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF036E97),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF036E97)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKvRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.navy,
            ),
          ),
        ),
      ],
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
