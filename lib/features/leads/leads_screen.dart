import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/lead_model.dart';
import '../../providers/aeconnect_provider.dart';
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
                        backgroundColor: const Color(0xFF08897A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Search & Filter Toolbar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: Color(0xFF8A98AC)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: const InputDecoration(
                                  hintText: 'Search company, contact or city',
                                  hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF8A98AC)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () => setState(() => _searchQuery = ''),
                                child: const Icon(Icons.clear, size: 16, color: AppColors.textLight),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Filter / Options button
                    PopupMenuButton<String>(
                      initialValue: _sortOption,
                      tooltip: 'Sort options',
                      onSelected: (val) => setState(() => _sortOption = val),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                        const PopupMenuItem(value: 'Oldest first', child: Text('Sort by: Oldest first')),
                        const PopupMenuItem(value: 'Name / reference', child: Text('Sort by: Name / reference')),
                      ],
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
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
                                  color: isSelected ? const Color(0xFF08897A) : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF08897A) : const Color(0xFF7A8798),
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
                else
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, LeadModel lead) {
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
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar Box + Company Name & City + Chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initials Avatar Box
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F5F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      lead.initials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF08897A),
                      ),
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
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${lead.industry} · ${lead.city}, ${lead.state}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF62748C),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
              ],
            ),
            const SizedBox(height: 12),

            // Middle Row: Account Owner & Lead Source
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5F5F0),
                      ),
                      child: const Center(
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF08897A),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      lead.salesRep,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '·  ${lead.source}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF62748C),
                      ),
                    ),
                  ],
                ),

                // Stage Badge
                _buildStageBadge(lead.stage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageBadge(LeadStage stage) {
    Color bg = const Color(0xFFEAF1FF);
    Color fg = const Color(0xFF3168B8);

    if (stage == LeadStage.proposal || stage == LeadStage.qualified) {
      bg = const Color(0xFFEAF5EE);
      fg = const Color(0xFF2D7854);
    } else if (stage == LeadStage.discovery || stage == LeadStage.qualification) {
      bg = const Color(0xFFFFF3DD);
      fg = const Color(0xFF946419);
    } else if (stage == LeadStage.closedWon) {
      bg = const Color(0xFFE6F6EE);
      fg = const Color(0xFF15803D);
    } else if (stage == LeadStage.closedLost) {
      bg = const Color(0xFFFCECEF);
      fg = const Color(0xFFAC4353);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
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
