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
  final CustomerModel? customer;
  final String? customerId;

  const CustomerDetailScreen({super.key, this.customer, this.customerId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final targetId = customer?.id ?? customerId ?? 'c1';
    final matches = provider.customers.where((c) => c.id == targetId);
    final c = matches.isNotEmpty ? matches.first : (customer ?? provider.customers.first);

    final leadMatches = provider.leads.where((l) => l.companyName == c.name);
    final linkedLead = leadMatches.isNotEmpty ? leadMatches.first : provider.leads.first;

    final quotes = provider.quotations.where((q) => q.customerName == c.name).toList();

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
                // Top Title & Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              c.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeadFormScreen(lead: linkedLead),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Edit company details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(0, 36),
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF3FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            c.initials,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3866A8),
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
                              c.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${c.category} · ${c.city}, ${c.state}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF708096)),
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
                          c.status,
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
                      value: c.accountOwner,
                      avatarInitials: 'JD',
                    ),
                    _buildDivider(),
                    _buildRow(
                      label: 'Area Sales Manager',
                      value: c.asmName,
                      avatarInitials: 'PM',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Billing & Account Information Card
                _buildCard(
                  title: 'Billing & account information',
                  children: [
                    _buildRow(label: 'Billing address', value: c.address),
                    _buildDivider(),
                    _buildRow(label: 'GST number', value: c.gst),
                    _buildDivider(),
                    _buildRow(label: 'Payment terms', value: c.terms),
                    _buildDivider(),
                    _buildRow(
                      label: 'Credit limit',
                      value: c.creditLimit > 0
                          ? AppFormatters.rupee(c.creditLimit)
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
                            color: c.kycStatus == 'Verified'
                                ? const Color(0xFFEAF5EE)
                                : const Color(0xFFFFF3DD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            c.kycStatus,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: c.kycStatus == 'Verified'
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

                // Your contacts Card
                _buildCard(
                  title: 'Your contacts',
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
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
                                '${c.keyContact} · Procurement Head',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${c.phone} · ${c.email}',
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

                // Connected records Card
                _buildCard(
                  title: 'Connected records',
                  children: [
                    // Lead history
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeadDetailScreen(lead: linkedLead),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F5F0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.people_outline, size: 16, color: Color(0xFF128D7E)),
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
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  Text(
                                    c.name,
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF62748C)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
                          ],
                        ),
                      ),
                    ),
                    _buildDivider(),

                    // Quotations
                    if (quotes.isNotEmpty)
                      ...quotes.map((q) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuotationDetailScreen(quotation: q),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAEFF7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.description_outlined, size: 16, color: Color(0xFFB15B9A)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        q.id,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      Text(
                                        '${q.status.label} · ${AppFormatters.rupee(q.grandTotal)}',
                                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF62748C)),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 18, color: Color(0xFFB4BFCD)),
                              ],
                            ),
                          ),
                        );
                      }),
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
          style: const TextStyle(fontSize: 12, color: Color(0xFF62748C)),
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
