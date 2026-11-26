import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../orders/orders_screen.dart';

class CollectionInvoiceItem {
  final String id;
  final String invoiceNumber;
  final String orderCode;
  final String clientName;
  final double totalAmount;
  final double pendingAmount;
  final double receivedAmount;
  final double heldCheques;
  final String status; // 'Pending', 'Partially received', 'Paid', 'Overdue', 'Uncleared cheques'
  final DateTime dueDate;
  final bool isOverdue;

  const CollectionInvoiceItem({
    required this.id,
    required this.invoiceNumber,
    required this.orderCode,
    required this.clientName,
    required this.totalAmount,
    required this.pendingAmount,
    required this.receivedAmount,
    this.heldCheques = 0,
    required this.status,
    required this.dueDate,
    required this.isOverdue,
  });
}

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  int _activeTab = 0; // 0: Outstanding, 1: Monthly reports
  final _searchController = TextEditingController();
  String _selectedPaymentStatus = 'All';
  String _selectedClient = 'All';

  final List<CollectionInvoiceItem> _allInvoices = [
    CollectionInvoiceItem(
      id: 'inv-1',
      invoiceNumber: 'INV-2026-0001',
      orderCode: 'ORD-2026-0001',
      clientName: 'Bright Infra Solutions',
      totalAmount: 616432.0,
      pendingAmount: 616432.0,
      receivedAmount: 0.0,
      status: 'Overdue',
      dueDate: DateTime(2026, 11, 15),
      isOverdue: true,
    ),
    CollectionInvoiceItem(
      id: 'inv-2',
      invoiceNumber: 'INV-2026-0002',
      orderCode: 'ORD-2026-0002',
      clientName: 'Acme Technologies',
      totalAmount: 790000.0,
      pendingAmount: 540000.0,
      receivedAmount: 250000.0,
      heldCheques: 100000.0,
      status: 'Pending',
      dueDate: DateTime(2026, 11, 28),
      isOverdue: false,
    ),
    CollectionInvoiceItem(
      id: 'inv-3',
      invoiceNumber: 'INV-2026-0003',
      orderCode: 'DEMO-SO-EMP104-2026-09-1',
      clientName: 'Horizon Broadband',
      totalAmount: 206500.0,
      pendingAmount: 206500.0,
      receivedAmount: 0.0,
      status: 'Overdue',
      dueDate: DateTime(2026, 11, 10),
      isOverdue: true,
    ),
    CollectionInvoiceItem(
      id: 'inv-4',
      invoiceNumber: 'INV-2026-0004',
      orderCode: 'DEMO-SO-EMP104-2026-09-2',
      clientName: 'Westlink Networks',
      totalAmount: 265500.0,
      pendingAmount: 165500.0,
      receivedAmount: 100000.0,
      status: 'Partially received',
      dueDate: DateTime(2026, 11, 30),
      isOverdue: false,
    ),
    CollectionInvoiceItem(
      id: 'inv-5',
      invoiceNumber: 'INV-2026-0005',
      orderCode: 'ORD-2026-0005',
      clientName: 'Acme Technologies',
      totalAmount: 620500.0,
      pendingAmount: 420500.0,
      receivedAmount: 200000.0,
      heldCheques: 143587.40,
      status: 'Overdue',
      dueDate: DateTime(2026, 11, 1),
      isOverdue: true,
    ),
    CollectionInvoiceItem(
      id: 'inv-6',
      invoiceNumber: 'INV-2026-0006',
      orderCode: 'ORD-2026-0004',
      clientName: 'CyberNet Fiber Systems',
      totalAmount: 315000.0,
      pendingAmount: 0.0,
      receivedAmount: 315000.0,
      status: 'Paid',
      dueDate: DateTime(2026, 11, 20),
      isOverdue: false,
    ),
    CollectionInvoiceItem(
      id: 'inv-7',
      invoiceNumber: 'INV-2026-0007',
      orderCode: 'ORD-2026-0006',
      clientName: 'Bright Infra Solutions',
      totalAmount: 480000.0,
      pendingAmount: 380000.0,
      receivedAmount: 100000.0,
      status: 'Overdue',
      dueDate: DateTime(2026, 11, 5),
      isOverdue: true,
    ),
    CollectionInvoiceItem(
      id: 'inv-8',
      invoiceNumber: 'INV-2026-0008',
      orderCode: 'ORD-2026-0007',
      clientName: 'Horizon Broadband',
      totalAmount: 375540.0,
      pendingAmount: 195586.70,
      receivedAmount: 179953.30,
      status: 'Pending',
      dueDate: DateTime(2026, 12, 2),
      isOverdue: false,
    ),
    CollectionInvoiceItem(
      id: 'inv-9',
      invoiceNumber: 'INV-2026-0009',
      orderCode: 'ORD-2026-0008',
      clientName: 'Acme Technologies',
      totalAmount: 460000.0,
      pendingAmount: 460000.0,
      receivedAmount: 0.0,
      status: 'Overdue',
      dueDate: DateTime(2026, 11, 12),
      isOverdue: true,
    ),
    CollectionInvoiceItem(
      id: 'inv-10',
      invoiceNumber: 'INV-2026-0010',
      orderCode: 'ORD-2026-0009',
      clientName: 'Westlink Networks',
      totalAmount: 236000.0,
      pendingAmount: 100000.0,
      receivedAmount: 136000.0,
      status: 'Partially received',
      dueDate: DateTime(2026, 11, 25),
      isOverdue: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CollectionInvoiceItem> get _filteredInvoices {
    final query = _searchController.text.trim().toLowerCase();
    return _allInvoices.where((inv) {
      if (_selectedPaymentStatus != 'All' && inv.status != _selectedPaymentStatus) {
        return false;
      }
      if (_selectedClient != 'All' && inv.clientName != _selectedClient) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchesQuery = inv.clientName.toLowerCase().contains(query) ||
            inv.invoiceNumber.toLowerCase().contains(query) ||
            inv.orderCode.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final invoices = _filteredInvoices;

    // Totals matching screenshot
    const double pendingTotal = 2704518.70;
    const double receivedTotal = 1661953.30;
    const double overdueTotal = 2197165.90;
    const double chequesTotal = 243587.40;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Page Head: Collections title + Sales orders button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.navy,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  ),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text('Sales orders'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 38),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Tabs Row: Outstanding vs Monthly reports
            Row(
              children: [
                _buildTab('Outstanding', 0),
                const SizedBox(width: 24),
                _buildTab('Monthly reports', 1, icon: Icons.calendar_today_outlined),
              ],
            ),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 16),

            if (_activeTab == 0) ...[
              // 3. Search & Filters Card (.card.collection-report-tools)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Client, invoice, order or cheque',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filters Row
                    Row(
                      children: [
                        // Payment Status Filter
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment status',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedPaymentStatus,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'All', child: Text('All')),
                                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                                  DropdownMenuItem(value: 'Partially received', child: Text('Partially received')),
                                  DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                                  DropdownMenuItem(value: 'Overdue', child: Text('Overdue')),
                                  DropdownMenuItem(value: 'Uncleared cheques', child: Text('Uncleared cheques')),
                                  DropdownMenuItem(value: 'Bounced', child: Text('Bounced')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => _selectedPaymentStatus = v);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Client Filter
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Client',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedClient,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'All', child: Text('All clients')),
                                  DropdownMenuItem(value: 'Bright Infra Solutions', child: Text('Bright Infra Solutions')),
                                  DropdownMenuItem(value: 'Acme Technologies', child: Text('Acme Technologies')),
                                  DropdownMenuItem(value: 'Horizon Broadband', child: Text('Horizon Broadband')),
                                  DropdownMenuItem(value: 'Westlink Networks', child: Text('Westlink Networks')),
                                  DropdownMenuItem(value: 'CyberNet Fiber Systems', child: Text('CyberNet Fiber Systems')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => _selectedClient = v);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Hero Card (.collection-hero - Exact replica of media_1795671789900_971a0377.jpg)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F1E36), Color(0xFF13324C), Color(0xFF164761)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF102D4C).withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pending collection',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCFE2EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRupee(pendingTotal),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0x33FFFFFF), height: 1),
                    const SizedBox(height: 16),

                    // Middle Row: Received & Overdue
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Received', style: TextStyle(fontSize: 11, color: Color(0xFFCFE2EB))),
                            const SizedBox(height: 3),
                            Text(
                              _formatRupee(receivedTotal),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Overdue', style: TextStyle(fontSize: 11, color: Color(0xFFCFE2EB))),
                            const SizedBox(height: 3),
                            Text(
                              _formatRupee(overdueTotal),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bottom Row: Uncleared cheques
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Uncleared cheques', style: TextStyle(fontSize: 11, color: Color(0xFFCFE2EB))),
                        const SizedBox(height: 3),
                        Text(
                          _formatRupee(chequesTotal),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pending includes uncleared cheques.',
                      style: TextStyle(fontSize: 10, color: Color(0x99CFE2EB)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 5. Matching Invoices Caption
              const Text(
                '22 matching invoices · Billed ₹43,66,472. Totals reflect the selected filters.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 18),

              // 6. Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Invoices & outstanding',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${invoices.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 7. Invoices List Cards (.collection-invoice)
              ...invoices.map((inv) => _buildInvoiceCard(inv)),
            ] else ...[
              // Monthly Reports Tab
              _buildMonthlyReportsView(),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, {IconData? icon}) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.textMuted),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(CollectionInvoiceItem inv) {
    Color badgeBg;
    Color badgeFg;

    if (inv.status == 'Overdue') {
      badgeBg = AppColors.dangerLight;
      badgeFg = AppColors.danger;
    } else if (inv.status == 'Paid') {
      badgeBg = AppColors.tealLight;
      badgeFg = AppColors.teal;
    } else if (inv.status == 'Partially received') {
      badgeBg = AppColors.primaryLight;
      badgeFg = AppColors.primary;
    } else {
      badgeBg = AppColors.amberLight;
      badgeFg = AppColors.amber;
    }

    final dueDateStr = inv.isOverdue
        ? 'Overdue since ${inv.dueDate.day} ${_monthName(inv.dueDate.month)} ${inv.dueDate.year}'
        : 'Due ${inv.dueDate.day} ${_monthName(inv.dueDate.month)} ${inv.dueDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Company + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  inv.clientName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  inv.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${inv.invoiceNumber} · ${inv.orderCode}',
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),

          // Amounts Row: Pending collection vs Received
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pending collection', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupee(inv.pendingAmount),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Received', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupee(inv.receivedAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),

          // Footer: Due Date & Cheques info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueDateStr,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: inv.isOverdue ? FontWeight.w600 : FontWeight.w400,
                  color: inv.isOverdue ? AppColors.danger : AppColors.textMuted,
                ),
              ),
              if (inv.heldCheques > 0)
                Text(
                  '${_formatRupee(inv.heldCheques)} in cheques',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.amber,
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyReportsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Monthly Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F1E36), Color(0xFF13324C), Color(0xFF164761)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NOVEMBER 2026',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF92DCE7),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Collected this month',
                style: TextStyle(fontSize: 12, color: Color(0xFFCFE2EB)),
              ),
              const SizedBox(height: 2),
              const Text(
                '₹16,61,953.30',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0x33FFFFFF), height: 1),
              const SizedBox(height: 14),

              // Monthly Totals Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Opening pending', style: TextStyle(fontSize: 10, color: Color(0xFFCFE2EB))),
                      SizedBox(height: 2),
                      Text('₹25,12,040', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('New invoices', style: TextStyle(fontSize: 10, color: Color(0xFFCFE2EB))),
                      SizedBox(height: 2),
                      Text('₹18,54,432', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Collected', style: TextStyle(fontSize: 10, color: Color(0xFFCFE2EB))),
                      SizedBox(height: 2),
                      Text('₹16,61,953', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Closing pending', style: TextStyle(fontSize: 10, color: Color(0xFFCFE2EB))),
                      SizedBox(height: 2),
                      Text('₹27,04,519', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'Pending by client',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        const SizedBox(height: 10),

        _buildClientMonthlyCard('Acme Technologies', '₹14,20,500', '8 invoices · Received ₹8,10,000 · Overdue ₹11,50,000'),
        _buildClientMonthlyCard('Bright Infra Solutions', '₹6,16,432', '5 invoices · Received ₹3,50,000 · Overdue ₹5,20,000'),
        _buildClientMonthlyCard('Horizon Broadband', '₹4,02,087', '5 invoices · Received ₹3,01,953 · Overdue ₹3,27,166'),
        _buildClientMonthlyCard('Westlink Networks', '₹2,65,500', '4 invoices · Received ₹2,00,000 · Overdue ₹2,00,000'),
      ],
    );
  }

  Widget _buildClientMonthlyCard(String client, String pending, String meta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                client,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              Text(
                pending,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(meta, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  String _formatRupee(double amount) {
    if (amount == 0) return '₹0';
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
