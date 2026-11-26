import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_search_bar.dart';
import '../../components/status_pill.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import 'mom_detail_screen.dart';
import 'mom_form_screen.dart';

class MomsScreen extends StatefulWidget {
  const MomsScreen({super.key});

  @override
  State<MomsScreen> createState() => _MomsScreenState();
}

class _MomsScreenState extends State<MomsScreen> {
  String _selectedTab = 'All';
  String _searchQuery = '';
  String _sortOption = 'Newest first';

  static const List<String> _tabs = [
    'All',
    'Draft',
    'Submitted',
    'Approved',
    'Sent Back',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allMoms = provider.moms;

    final filtered = allMoms.where((mom) {
      final matchesTab = _selectedTab == 'All' ||
          mom.status.toLowerCase() == _selectedTab.toLowerCase();
      if (!matchesTab) return false;
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return mom.title.toLowerCase().contains(q) ||
          mom.accountName.toLowerCase().contains(q) ||
          mom.id.toLowerCase().contains(q);
    }).toList();

    if (_sortOption == 'Newest first') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortOption == 'Oldest first') {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    } else if (_sortOption == 'Title A–Z') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meetings / MOM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Header: Meetings / MOM + '+ New MOM' button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Meetings / MOM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.navy,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MomFormScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text(
                        'New MOM',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF036E97),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Search Bar + 3-dots sort menu
                AppSearchBar(
                  hintText: 'Search moms',
                  value: _searchQuery,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: PopupMenuButton<String>(
                    initialValue: _sortOption,
                    tooltip: 'Sort options',
                    onSelected: (val) => setState(() => _sortOption = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                      PopupMenuItem(value: 'Oldest first', child: Text('Sort by: Oldest first')),
                      PopupMenuItem(value: 'Title A–Z', child: Text('Sort by: Title A–Z')),
                    ],
                    child: AppSearchBar.buildActionButton(
                      child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Underlined Filter Tabs
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.map((tab) {
                        final isSelected = _selectedTab == tab;
                        return InkWell(
                          onTap: () => setState(() => _selectedTab = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? const Color(0xFF036E97) : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF036E97) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. MOM Cards List
                if (filtered.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'No MOM records match your filter.',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  ...filtered.map((mom) {
                    final dateStr = DateFormat('d MMM yyyy HH:mm').format(mom.date);
                    final itemCount = mom.actionItems.length;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MomDetailScreen(momId: mom.id)),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.description_outlined,
                                  size: 18,
                                  color: Color(0xFF036E97),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mom.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${mom.accountName} · $dateStr',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${mom.id} · $itemCount action item${itemCount == 1 ? '' : 's'}',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    StatusPill(label: mom.status),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 6),
                // 5. Footer Count Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filtered.length} record${filtered.length == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                    Text(
                      _selectedTab == 'All' ? 'Showing all' : 'Filtered: $_selectedTab',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
