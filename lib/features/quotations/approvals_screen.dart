import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_search_bar.dart';
import '../../components/status_pill.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/quotation_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../moms/mom_detail_screen.dart';
import 'quotation_detail_screen.dart';

class ApprovalsScreen extends StatefulWidget {
  final int initialTab;

  const ApprovalsScreen({super.key, this.initialTab = 0});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  static const Color _purple = Color(0xFF6D3B8E);
  static const Color _purpleBg = Color(0xFFF3E8FF);

  late int _primaryTab; // 0 = Quotes, 1 = MOM
  String _statusFilter = 'All';
  String _searchQuery = '';
  String _sortOption = 'Newest first';

  static const List<String> _quoteFilters = [
    'All',
    'Submitted',
    'Approved',
    'Sent Back',
    'Draft',
  ];

  static const List<String> _momFilters = [
    'All',
    'Submitted',
    'Approved',
    'Sent Back',
    'Rejected',
    'Draft',
  ];

  @override
  void initState() {
    super.initState();
    _primaryTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final filters = _primaryTab == 0 ? _quoteFilters : _momFilters;
    if (!filters.contains(_statusFilter)) {
      _statusFilter = 'All';
    }

    final quotes = provider.quotations.where((q) {
      if (_statusFilter == 'Submitted' && q.status != QuotationStatus.underReview) return false;
      if (_statusFilter == 'Approved' && q.status != QuotationStatus.approved) return false;
      if (_statusFilter == 'Sent Back' && q.status != QuotationStatus.sentBack) return false;
      if (_statusFilter == 'Draft' && q.status != QuotationStatus.draft) return false;

      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        return q.customerName.toLowerCase().contains(query) ||
            q.proposalNumber.toLowerCase().contains(query) ||
            q.id.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    if (_sortOption == 'Newest first') {
      quotes.sort((a, b) => b.issueDate.compareTo(a.issueDate));
    } else if (_sortOption == 'Oldest first') {
      quotes.sort((a, b) => a.issueDate.compareTo(b.issueDate));
    } else if (_sortOption == 'Highest value') {
      quotes.sort((a, b) => b.grandTotal.compareTo(a.grandTotal));
    }

    final moms = provider.moms.where((m) {
      if (_statusFilter != 'All' &&
          m.status.toLowerCase() != _statusFilter.toLowerCase()) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        return m.title.toLowerCase().contains(query) ||
            m.accountName.toLowerCase().contains(query) ||
            m.id.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    if (_sortOption == 'Newest first') {
      moms.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortOption == 'Oldest first') {
      moms.sort((a, b) => a.date.compareTo(b.date));
    }

    final recordCount = _primaryTab == 0 ? quotes.length : moms.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Approvals'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Title
                const Text(
                  'Approvals',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Primary Underlined Tabs: Quotes | MOM
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      _buildPrimaryTab(0, 'Quotes'),
                      _buildPrimaryTab(1, 'MOM'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Search Bar + Purple 3-dots Sort Menu
                AppSearchBar(
                  hintText: 'Search reference or customer',
                  value: _searchQuery,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: PopupMenuButton<String>(
                    initialValue: _sortOption,
                    tooltip: 'Sort options',
                    onSelected: (val) => setState(() => _sortOption = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                      PopupMenuItem(value: 'Oldest first', child: Text('Sort by: Oldest first')),
                      PopupMenuItem(value: 'Highest value', child: Text('Sort by: Highest value')),
                    ],
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _purpleBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE9D5FF)),
                      ),
                      child: const Icon(Icons.more_vert, size: 20, color: _purple),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Secondary Underlined Status Filter Tabs
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((tab) {
                        final isSelected = _statusFilter == tab;
                        return InkWell(
                          onTap: () => setState(() => _statusFilter = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? _purple : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? _purple : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 5. Grouped White Card List
                if (recordCount == 0)
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
                        'No items awaiting approval.',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _primaryTab == 0
                        ? _buildQuotesList(context, quotes)
                        : _buildMomsList(context, moms),
                  ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$recordCount record${recordCount == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                    Text(
                      _statusFilter == 'All' ? 'Showing all' : 'Filtered: $_statusFilter',
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

  Widget _buildPrimaryTab(int index, String label) {
    final isSelected = _primaryTab == index;
    return InkWell(
      onTap: () => setState(() {
        _primaryTab = index;
        _statusFilter = 'All';
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _purple : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? _purple : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildQuotesList(BuildContext context, List<QuotationModel> quotes) {
    return Column(
      children: quotes.asMap().entries.map((entry) {
        final idx = entry.key;
        final quote = entry.value;
        final issueStr = DateFormat('d MMM yyyy').format(quote.issueDate);
        final validStr = DateFormat('d MMM yyyy').format(quote.validityDate);
        final statusLabel = quote.status == QuotationStatus.underReview
            ? 'Submitted'
            : quote.status.label;

        return Column(
          children: [
            if (idx > 0) const Divider(height: 1, color: AppColors.border),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuotationDetailScreen(quoteId: quote.id)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _purpleBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description_outlined, size: 18, color: _purple),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quote.customerName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${quote.proposalNumber} · $issueStr',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryLight,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      'assets/people/emp104.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Text('J', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'John Doe · Valid $validStr',
                                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppFormatters.rupee(quote.grandTotal),
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          StatusPill(label: statusLabel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMomsList(BuildContext context, List moms) {
    return Column(
      children: moms.asMap().entries.map((entry) {
        final idx = entry.key;
        final mom = entry.value;
        final dateStr = DateFormat('d MMM yyyy HH:mm').format(mom.date);
        final itemCount = mom.actionItems.length;

        return Column(
          children: [
            if (idx > 0) const Divider(height: 1, color: AppColors.border),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MomDetailScreen(momId: mom.id)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _purpleBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description_outlined, size: 18, color: _purple),
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
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${mom.id} · $itemCount action item${itemCount == 1 ? '' : 's'}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 6),
                          StatusPill(label: mom.status),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
