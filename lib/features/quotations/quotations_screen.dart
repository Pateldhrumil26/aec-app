import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/quotation_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';
import 'quotation_detail_screen.dart';
import 'quotation_builder_screen.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allQuotes = provider.quotations;

    final quotes = allQuotes.where((q) {
      if (_selectedFilter == 'Under Review') return q.status == QuotationStatus.underReview;
      if (_selectedFilter == 'Approved') return q.status == QuotationStatus.approved;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
              );
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New quote'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips
                  Row(
                    children: ['All', 'Under Review', 'Approved'].map((f) {
                      final isSelected = _selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedFilter = f),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // Quotes List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final quote = quotes[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuotationDetailScreen(quoteId: quote.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  quote.id,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                StatusPill(label: quote.status.label),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              quote.customerName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Proposal Ref: ${quote.proposalNumber} · Issued ${AppFormatters.date(quote.issueDate)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total (inc. GST & Freight)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    const SizedBox(height: 2),
                                    Text(
                                      AppFormatters.rupee(quote.grandTotal),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: quotes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
