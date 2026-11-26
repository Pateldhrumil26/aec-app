import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../models/customer_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'customer_detail_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  String _sortOption = 'Name / reference';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allCustomers = provider.customers;

    final filtered = allCustomers.where((c) {
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = c.name.toLowerCase().contains(q);
        final matchesCity = c.city.toLowerCase().contains(q);
        final matchesGst = c.gst.toLowerCase().contains(q);
        if (!matchesName && !matchesCity && !matchesGst) return false;
      }

      if (_selectedFilter != 'All' && c.status != _selectedFilter) {
        return false;
      }
      return true;
    }).toList();

    if (_sortOption == 'Name / reference') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == 'City') {
      filtered.sort((a, b) => a.city.compareTo(b.city));
    }

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
                // Top Title
                const Text(
                  'Customers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: AppColors.navy,
                  ),
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
                                  hintText: 'Search company, GST or city',
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

                    // Filter button
                    PopupMenuButton<String>(
                      initialValue: _sortOption,
                      tooltip: 'Sort options',
                      onSelected: (val) => setState(() => _sortOption = val),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Name / reference', child: Text('Sort by: Name / reference')),
                        const PopupMenuItem(value: 'City', child: Text('Sort by: City')),
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

                // Segmented Tabs: All, Draft, Pending Verification, Credit Review, Approved, Active, Inactive
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Draft',
                        'Pending Verification',
                        'Credit Review',
                        'Approved',
                        'Active',
                        'Inactive'
                      ].map((tab) {
                        final isSelected = _selectedFilter == tab;
                        return InkWell(
                          onTap: () => setState(() => _selectedFilter = tab),
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
                              tab,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? AppColors.primary : const Color(0xFF7A8798),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Cards List
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
                          Icon(Icons.business_outlined, size: 36, color: Color(0xFF8A98AC)),
                          SizedBox(height: 10),
                          Text(
                            'No customers found',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
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
                      final customer = filtered[index];
                      return _buildCustomerCard(context, customer);
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

  Widget _buildCustomerCard(BuildContext context, CustomerModel customer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailScreen(customer: customer),
          ),
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
            // Top Row: Avatar Box + Company Name & City/GST + Chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initials Avatar Box
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      customer.initials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3168B8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Company Name & Location / GST
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${customer.city}, ${customer.state} · GST ${customer.gst}',
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

            // Middle Row: Account Owner & Terms/KYC + ASM Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Owner & Terms
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account owner',
                      style: TextStyle(fontSize: 10, color: Color(0xFF8A98AC)),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEAF1FF),
                          ),
                          child: const Center(
                            child: Text(
                              'JD',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          customer.accountOwner,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${customer.terms} · KYC ${customer.kycStatus}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF526680)),
                    ),
                  ],
                ),

                // Team avatar (Priya Mehta)
                Row(
                  children: [
                    const Text('Team ', style: TextStyle(fontSize: 10, color: Color(0xFF8A98AC))),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFF0DF),
                      ),
                      child: const Center(
                        child: Text(
                          'PM',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC26319),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Status Badge (Active)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5EE),
                borderRadius: BorderRadius.circular(4),
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
    );
  }
}
