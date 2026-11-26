import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/customer_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../leads/lead_detail_screen.dart';
import '../leads/lead_form_screen.dart';
import '../quotations/quotation_builder_screen.dart';
import '../quotations/quotation_detail_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final leadMatches = provider.leads.where(
      (l) => l.id == customer.leadId || l.companyName == customer.name,
    );
    final linkedLead = leadMatches.isNotEmpty ? leadMatches.first : null;

    final quoteMatches = provider.quotations.where(
      (q) => q.leadId == customer.leadId || q.customerName == customer.name,
    );
    final linkedQuote = quoteMatches.isNotEmpty ? quoteMatches.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back & Title Row with Edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Customer account',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              customer.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: AppColors.navy,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (linkedLead != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LeadFormScreen(lead: linkedLead)),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit_outlined, size: 14),
                      label: const Text('Edit company details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(0, 34),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Hero Card (.detail-hero)
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            customer.initials,
                            style: const TextStyle(
                              fontSize: 16,
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
                              customer.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${customer.category} · ${customer.city}, ${customer.state}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5EE),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          customer.status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D7854),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Account Team Card
                _buildCard(
                  title: 'Account team',
                  children: [
                    _buildRow(
                      label: 'Account owner',
                      value: customer.accountOwner,
                      avatarInitials: 'JD',
                    ),
                    _buildDivider(),
                    _buildRow(
                      label: 'Area Sales Manager',
                      value: customer.asmName,
                      avatarInitials: 'PM',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Billing & Account Information Card
                _buildCard(
                  title: 'Billing & account information',
                  children: [
                    _buildRow(label: 'Billing address', value: customer.address),
                    _buildDivider(),
                    _buildRow(label: 'GST number', value: customer.gst),
                    _buildDivider(),
                    _buildRow(label: 'Payment terms', value: customer.terms),
                    _buildDivider(),
                    _buildRow(
                      label: 'Credit limit',
                      value: customer.creditLimit > 0
                          ? AppFormatters.rupee(customer.creditLimit)
                          : '₹0 (Advance only)',
                    ),
                    _buildDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'KYC status',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: customer.kycStatus == 'Verified'
                                ? const Color(0xFFEAF5EE)
                                : const Color(0xFFFFF3DD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            customer.kycStatus,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: customer.kycStatus == 'Verified'
                                  ? const Color(0xFF2D7854)
                                  : const Color(0xFF946419),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Your Contacts Card (.card 'Your contacts')
                _buildCard(
                  title: 'Your contacts',
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.person_outline, size: 18, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${customer.keyContact} · Procurement Head',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${customer.phone} · ${customer.email}',
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF62748C)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Connected Records Card (.card 'Connected records')
                _buildCard(
                  title: 'Connected records',
                  children: [
                    if (linkedLead != null) ...[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LeadDetailScreen(
                                leadId: linkedLead.id,
                                lead: linkedLead,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F5F0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.people_outline, size: 18, color: Color(0xFF08897A)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lead history',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  Text(
                                    linkedLead.companyName,
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF62748C)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
                          ],
                        ),
                      ),
                      _buildDivider(),
                    ],
                    if (linkedQuote != null) ...[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuotationDetailScreen(
                                quoteId: linkedQuote.id,
                                quotation: linkedQuote,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAEFF7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.description_outlined, size: 18, color: Color(0xFFB15B9A)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    linkedQuote.proposalNumber,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  Text(
                                    '${linkedQuote.status.label} · ${AppFormatters.rupee(linkedQuote.grandTotal)}',
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF62748C)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 18),

                // Action: Create another quotation
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                    );
                  },
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('Create another quotation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required String value, String? avatarInitials}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatarInitials != null) ...[
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAF1FF),
                ),
                child: Center(
                  child: Text(
                    avatarInitials,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFEDF0F5)),
    );
  }
}
