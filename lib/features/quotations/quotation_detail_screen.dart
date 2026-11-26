import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/user_role.dart';
import '../../models/quotation_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';
import 'quote_terms_screen.dart';
import 'proposal_response_screen.dart';

class QuotationDetailScreen extends StatefulWidget {
  final String? quoteId;
  final QuotationModel? quotation;

  const QuotationDetailScreen({super.key, this.quoteId, this.quotation})
      : assert(quoteId != null || quotation != null, 'Either quoteId or quotation must be provided');

  @override
  State<QuotationDetailScreen> createState() => _QuotationDetailScreenState();
}

class _QuotationDetailScreenState extends State<QuotationDetailScreen> {
  final _reviewFeedbackController = TextEditingController(text: 'Pricing verified against minimum gross margin. Approved.');

  String get effectiveQuoteId => widget.quoteId ?? widget.quotation!.id;

  @override
  void dispose() {
    _reviewFeedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final isManager = provider.currentRole == UserRole.manager;
    final matches = provider.quotations.where((q) => q.id == effectiveQuoteId);

    if (matches.isEmpty && widget.quotation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quotation Not Found')),
        body: const Center(child: Text('Quotation not found.')),
      );
    }

    final quote = matches.isNotEmpty ? matches.first : widget.quotation!;
    final isUnderReview = quote.status == QuotationStatus.underReview;

    return Scaffold(
      appBar: AppBar(
        title: Text(quote.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'Commercial Terms',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuoteTermsScreen(quoteId: quote.id)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            tooltip: 'Proposal Response Preview',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProposalResponseScreen(quoteId: quote.id)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Quote PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating official PDF proposal...')),
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
            // Proposal Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quote.proposalNumber,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary),
                        ),
                        StatusPill(label: quote.status.label),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quote.customerName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Issue Date: ${AppFormatters.date(quote.issueDate)} · Valid until: ${AppFormatters.date(quote.validityDate)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // MANAGER COMMERCIAL DECISION PANEL
            if (isManager && isUnderReview) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // Soft Green tint
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.statusSuccessFg.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.gavel_rounded, color: AppColors.statusSuccessFg, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Manager Commercial Decision',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.statusSuccessFg),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calculated Gross Margin:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('24.0% (Target: >10%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.statusSuccessFg)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reviewFeedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Revision Note / Feedback',
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.kpiDangerFg,
                              side: const BorderSide(color: AppColors.kpiDangerFg),
                            ),
                            onPressed: () {
                              provider.sendBackQuotation(quote.id, _reviewFeedbackController.text.trim());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sent back to sales rep for revision.')),
                              );
                            },
                            child: const Text('Send Back'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.statusSuccessFg,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              provider.approveQuotation(quote.id, _reviewFeedbackController.text.trim());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Quotation approved! Ready to dispatch to client.'),
                                  backgroundColor: AppColors.statusSuccessFg,
                                ),
                              );
                            },
                            child: const Text('Approve Quote'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Itemized Products Table
            const Text(
              'Itemized Line Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: quote.items.map((item) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ),
                                Text(
                                  AppFormatters.rupee(item.lineTotal),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SKU: ${item.sku} · Qty: ${item.quantity} × ${AppFormatters.rupee(item.unitRate)}'
                              '${item.discountPercent > 0 ? " (${item.discountPercent.toStringAsFixed(0)}% disc)" : ""}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Pricing & Tax Breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPriceRow('Items Subtotal', AppFormatters.rupee(quote.subtotal)),
                    const SizedBox(height: 8),
                    _buildPriceRow('Freight & Handling', AppFormatters.rupee(quote.freightFee)),
                    const SizedBox(height: 8),
                    _buildPriceRow('Integrated GST (18%)', AppFormatters.rupee(quote.gstAmount)),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Grand Total Amount',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                        Text(
                          AppFormatters.rupee(quote.grandTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Commercial Terms
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Commercial Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => QuoteTermsScreen(quoteId: quote.id)),
                            );
                          },
                          child: const Text('Edit Terms'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem('Payment Terms', quote.paymentTerms),
                    const SizedBox(height: 8),
                    _buildTermItem('Warranty', quote.warrantyTerms),
                    const SizedBox(height: 8),
                    _buildTermItem('Dispatch Lead Time', '3 to 5 business days after payment confirmation'),
                    const SizedBox(height: 8),
                    _buildTermItem('Freight Policy', 'Door delivery via multimodal road transport'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Review / Approval Note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Approval Status', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(quote.approvalNote, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTermItem(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
        const SizedBox(height: 1),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
      ],
    );
  }
}
