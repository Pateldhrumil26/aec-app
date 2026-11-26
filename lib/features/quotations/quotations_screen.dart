import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_search_bar.dart';
import '../../components/module_banner.dart';
import '../../components/status_pill.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/quotation_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'quotation_builder_screen.dart';
import 'quotation_detail_screen.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  static const Color _quotePurple = Color(0xFF6D3B8E);
  static const Color _quotePurpleBg = Color(0xFFF3E8FF);

  String _selectedFilter = 'All';
  String _searchQuery = '';
  String _sortOption = 'Newest first';

  static const List<String> _tabs = [
    'All',
    'Draft',
    'Submitted',
    'Approved',
    'Sent Back',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allQuotes = provider.quotations;

    final quotes = allQuotes.where((q) {
      if (_selectedFilter == 'Draft' && q.status != QuotationStatus.draft) return false;
      if (_selectedFilter == 'Submitted' && q.status != QuotationStatus.underReview) return false;
      if (_selectedFilter == 'Approved' && q.status != QuotationStatus.approved) return false;
      if (_selectedFilter == 'Sent Back' && q.status != QuotationStatus.sentBack) return false;

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

    final totalValue = allQuotes.fold<double>(0.0, (sum, q) => sum + q.grandTotal);
    final underReviewCount = allQuotes.where((q) => q.status == QuotationStatus.underReview).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quotations'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Header: Quotations + '+ Create quotation' purple button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Quotations',
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
                          MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text(
                        'Create quotation',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _quotePurple,
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

                // 2. Hero Banner
                ModuleBanner(
                  label: 'QUOTATION DESK',
                  title: AppFormatters.rupee(totalValue),
                  description: '${allQuotes.length} open quotations · $underReviewCount under review',
                  image: 'assets/photography/banner-network-v1.jpg',
                ),
                const SizedBox(height: 16),

                // 3. Search Bar + 3-dots sort menu (purple accent)
                AppSearchBar(
                  hintText: 'Search quote reference or customer',
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
                        color: _quotePurpleBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE9D5FF)),
                      ),
                      child: const Icon(Icons.more_vert, size: 20, color: _quotePurple),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Underlined Tabs: All | Draft | Submitted | Approved | Sent Back
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.map((tab) {
                        final isSelected = _selectedFilter == tab;
                        return InkWell(
                          onTap: () => setState(() => _selectedFilter = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? _quotePurple : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? _quotePurple : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 5. Grouped Quotes White Card (matching prototype)
                if (quotes.isEmpty)
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
                        'No quotations match your filter.',
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
                    child: Column(
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
                                  MaterialPageRoute(
                                    builder: (_) => QuotationDetailScreen(quoteId: quote.id),
                                  ),
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
                                            color: _quotePurpleBg,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.description_outlined,
                                            size: 18,
                                            color: _quotePurple,
                                          ),
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
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textMuted,
                                                ),
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
                                                        child: Text(
                                                          'J',
                                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      'John Doe · Valid $validStr',
                                                      style: const TextStyle(
                                                        fontSize: 11.5,
                                                        color: AppColors.textMuted,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                    ),
                  ),

                const SizedBox(height: 10),
                // 6. Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${quotes.length} record${quotes.length == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                    Text(
                      _selectedFilter == 'All' ? 'Showing all' : 'Filtered: $_selectedFilter',
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
