import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/lead_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/module_banner.dart';
import '../../components/app_search_bar.dart';
import '../pipeline/pipeline_screen.dart';
import 'lead_detail_screen.dart';
import 'lead_form_screen.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  String _selectedStage = 'All';
  String _searchQuery = '';
  String _sortOption = 'Newest first';

  final List<String> _stages = [
    'All',
    'New',
    'Qualification',
    'Contacted',
    'Qualified',
    'Discovery',
    'Proposal',
    'Negotiation',
    'Closed Won',
    'Closed Lost',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allLeads = provider.leads;

    final filtered = allLeads.where((lead) {
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesCompany = lead.companyName.toLowerCase().contains(q);
        final matchesContact = lead.contactPerson.toLowerCase().contains(q);
        final matchesCity = lead.city.toLowerCase().contains(q);
        if (!matchesCompany && !matchesContact && !matchesCity) return false;
      }

      if (_selectedStage != 'All') {
        if (lead.stage.label != _selectedStage) return false;
      }
      return true;
    }).toList();

    if (_sortOption == 'Newest first') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortOption == 'Oldest first') {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_sortOption == 'Name / reference') {
      filtered.sort((a, b) => a.companyName.compareTo(b.companyName));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title & New Lead Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Leads',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: AppColors.navy,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LeadFormScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New lead'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hero Banner matching prototype
                ModuleBanner(
                  label: 'CLIENT RELATIONSHIPS',
                  title: '${allLeads.length} open leads',
                  description:
                      '${allLeads.where((l) => l.stage == LeadStage.negotiation).length} in negotiation',
                  image: 'assets/photography/banner-network-v1.jpg',
                  actionLabel: 'View pipeline',
                  actionIcon: Icons.bar_chart,
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PipelineScreen()),
                  ),
                ),
                const SizedBox(height: 18),

                // Search & Filter Toolbar
                AppSearchBar(
                  hintText: 'Search company, contact or city',
                  value: _searchQuery,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: PopupMenuButton<String>(
                    initialValue: _sortOption,
                    tooltip: 'Sort options',
                    onSelected: (val) => setState(() => _sortOption = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                      PopupMenuItem(value: 'Oldest first', child: Text('Sort by: Oldest first')),
                      PopupMenuItem(value: 'Name / reference', child: Text('Sort by: Name / reference')),
                    ],
                    child: AppSearchBar.buildActionButton(
                      child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Segmented Tabs
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _stages.map((stage) {
                        final isSelected = _selectedStage == stage;
                        return InkWell(
                          onTap: () => setState(() => _selectedStage = stage),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Leads Cards List
                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.people_outline, size: 36, color: Color(0xFF8A98AC)),
                          SizedBox(height: 10),
                          Text(
                            'No leads found',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Try another search or filter, or create a new lead.',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lead = filtered[index];
                      return _buildLeadCard(context, lead);
                    },
                  ),
                  const SizedBox(height: 12),
                  // List Footer matching prototype: "X records", "Showing all"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filtered.length} ${filtered.length == 1 ? "record" : "records"}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                        const Text(
                          'Showing all',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, LeadModel lead) {
    final isUnassigned = lead.isUnassigned;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LeadDetailScreen(leadId: lead.id, lead: lead)),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Avatar Box + Company Name & City + Chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initials Avatar Box (Light cyan container with brand teal text)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3F7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lead.initials,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF036E97),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Company Name & Industry / City, State
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.companyName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${lead.industry} · ${lead.city}, ${lead.state}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
              ],
            ),
            const SizedBox(height: 12),

            // Row 2: Lead Owner Strip & Team Manager Avatar (100% match to prototype)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Lead owner (Icon + label + owner name + source pill)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isUnassigned)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF1F5F9),
                        ),
                        child: const Icon(Icons.person_outline, size: 15, color: Color(0xFF64748B)),
                      )
                    else
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.asset(
                            lead.salesRep.contains('EMP105') ? 'assets/people/emp105.jpg' : 'assets/people/emp104.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Lead owner',
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        Text(
                          lead.ownerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        lead.source,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),

                // Right: Team [mgr1 photo]
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Team',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/people/mgr1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row 3: Stage Pill Badge (e.g. [New], [Proposal])
            _buildStageBadge(lead.stage),
          ],
        ),
      ),
    );
  }

  Widget _buildStageBadge(LeadStage stage) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);

    if (stage == LeadStage.proposal || stage == LeadStage.qualified) {
      bg = const Color(0xFFEAF5EE);
      fg = const Color(0xFF2D7854);
    } else if (stage == LeadStage.discovery || stage == LeadStage.qualification) {
      bg = const Color(0xFFFFF3DD);
      fg = const Color(0xFF946419);
    } else if (stage == LeadStage.negotiation) {
      bg = const Color(0xFFE0F2FE);
      fg = const Color(0xFF036E97);
    } else if (stage == LeadStage.closedWon) {
      bg = const Color(0xFFE6F6EE);
      fg = const Color(0xFF15803D);
    } else if (stage == LeadStage.closedLost) {
      bg = const Color(0xFFFCECEF);
      fg = const Color(0xFFBE123C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        stage.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
