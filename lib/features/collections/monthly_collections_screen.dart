import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../providers/aeconnect_provider.dart';
import '../orders/orders_screen.dart';
import 'collections_screen.dart';
import 'invoice_detail_screen.dart';

class MonthlyCollectionsScreen extends StatefulWidget {
  const MonthlyCollectionsScreen({super.key});

  @override
  State<MonthlyCollectionsScreen> createState() => _MonthlyCollectionsScreenState();
}

class _MonthlyCollectionsScreenState extends State<MonthlyCollectionsScreen> {
  String _selectedMonth = 'November 2026';
  String _selectedClient = 'All clients';
  String _selectedAssignee = 'All order assignees';

  static const List<String> _months = [
    'November 2026',
    'October 2026',
    'September 2026',
  ];

  static const List<String> _clients = [
    'All clients',
    'Bright Infra Solutions',
    'Demo · Horizon Broadband',
    'Demo · Westlink Networks',
    'Demo · Metro Fiber Projects',
    'Demo · Crest Infrastructure',
    'Demo · Northgate Systems',
    'Demo · Summit Integrators',
    'Demo · Seabreeze Telecom',
    'Demo · Unity Data Systems',
    'Demo · Orchid Networks',
    'Demo · Meridian Digital',
    'Demo · Silverline Infrastructure',
    'Demo · Oakwood Technologies',
  ];

  static const List<String> _assignees = [
    'All order assignees',
    'John Doe',
    'Neha Patel',
  ];

  static const List<Map<String, String>> _clientReports = [
    {
      'client': 'Demo · Metro Fiber Projects',
      'assignee': 'John Doe',
      'opening': '₹3,40,000',
      'newInv': '₹5,12,000',
      'collected': '₹2,85,000',
      'closing': '₹5,67,000',
    },
    {
      'client': 'Demo · Orchid Networks',
      'assignee': 'Neha Patel',
      'opening': '₹2,15,400',
      'newInv': '₹4,18,000',
      'collected': '₹3,20,000',
      'closing': '₹3,13,400',
    },
    {
      'client': 'Demo · Horizon Broadband',
      'assignee': 'John Doe',
      'opening': '₹1,80,000',
      'newInv': '₹4,95,000',
      'collected': '₹2,95,000',
      'closing': '₹3,80,000',
    },
    {
      'client': 'Demo · Westlink Networks',
      'assignee': 'Neha Patel',
      'opening': '₹2,60,000',
      'newInv': '₹3,40,000',
      'collected': '₹2,15,308',
      'closing': '₹3,84,692',
    },
    {
      'client': 'Bright Infra Solutions',
      'assignee': 'John Doe',
      'opening': '₹1,90,000',
      'newInv': '₹6,16,432',
      'collected': '₹1,90,000',
      'closing': '₹6,16,432',
    },
  ];

  static const List<Map<String, String>> _paymentMethods = [
    {'method': 'Cash', 'amount': '₹1,23,900'},
    {'method': 'UPI', 'amount': '₹3,57,540'},
    {'method': 'Bank transfer', 'amount': '₹13,20,903.80'},
    {'method': 'PDC cheque', 'amount': '₹1,07,380'},
  ];

  static const List<Map<String, String>> _receivedCollections = [
    {
      'inv': 'DEMO-INV-EMP104-2026-11-1',
      'client': 'Demo · Horizon Broadband',
      'assignee': 'John Doe',
      'method': 'Bank transfer',
      'date': '24 Nov 2026',
      'amount': '₹2,95,000',
    },
    {
      'inv': 'DEMO-INV-EMP105-2026-11-2',
      'client': 'Demo · Orchid Networks',
      'assignee': 'Neha Patel',
      'method': 'Bank transfer',
      'date': '22 Nov 2026',
      'amount': '₹3,20,000',
    },
    {
      'inv': 'DEMO-INV-EMP104-2026-11-3',
      'client': 'Demo · Metro Fiber Projects',
      'assignee': 'John Doe',
      'method': 'UPI',
      'date': '19 Nov 2026',
      'amount': '₹1,85,000',
    },
    {
      'inv': 'DEMO-INV-EMP105-2026-11-4',
      'client': 'Demo · Westlink Networks',
      'assignee': 'Neha Patel',
      'method': 'Bank transfer',
      'date': '16 Nov 2026',
      'amount': '₹2,15,308',
    },
    {
      'inv': 'DEMO-INV-EMP104-2026-11-5',
      'client': 'Bright Infra Solutions',
      'assignee': 'John Doe',
      'method': 'PDC cheque',
      'date': '12 Nov 2026',
      'amount': '₹1,07,380',
    },
  ];

  static const List<Map<String, dynamic>> _reportInvoices = [
    {
      'inv': 'DEMO-INV-EMP104-opening-61',
      'client': 'Demo · Metro Fiber Projects',
      'assignee': 'John Doe',
      'issued': '3 Jun 2026',
      'opening': '₹33,984',
      'newInv': '₹0',
      'collected': '₹0',
      'closing': '₹33,984',
      'due': '3 Jul 2026',
      'isOverdue': true,
    },
    {
      'inv': 'DEMO-INV-002',
      'client': 'Bright Infra Solutions',
      'assignee': 'John Doe',
      'issued': '30 Oct 2026',
      'opening': '₹2,46,572.80',
      'newInv': '₹0',
      'collected': '₹0',
      'closing': '₹2,46,572.80',
      'due': '29 Nov 2026',
      'isOverdue': false,
    },
    {
      'inv': 'DEMO-INV-EMP104-2026-11-1',
      'client': 'Demo · Horizon Broadband',
      'assignee': 'John Doe',
      'issued': '4 Nov 2026',
      'opening': '₹0',
      'newInv': '₹4,95,000',
      'collected': '₹2,95,000',
      'closing': '₹2,00,000',
      'due': '4 Dec 2026',
      'isOverdue': false,
    },
    {
      'inv': 'DEMO-INV-EMP105-2026-11-2',
      'client': 'Demo · Orchid Networks',
      'assignee': 'Neha Patel',
      'issued': '6 Nov 2026',
      'opening': '₹0',
      'newInv': '₹4,18,000',
      'collected': '₹3,20,000',
      'closing': '₹98,000',
      'due': '6 Dec 2026',
      'isOverdue': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final isManager = provider.currentRole == UserRole.manager;

    final filteredClients = _clientReports.where((c) {
      final matchClient = _selectedClient == 'All clients' || c['client'] == _selectedClient;
      final matchAssignee = _selectedAssignee == 'All order assignees' || c['assignee'] == _selectedAssignee;
      final matchRole = isManager || c['assignee'] == 'John Doe';
      return matchClient && matchAssignee && matchRole;
    }).toList();

    final filteredReceived = _receivedCollections.where((r) {
      final matchClient = _selectedClient == 'All clients' || r['client'] == _selectedClient;
      final matchAssignee = _selectedAssignee == 'All order assignees' || r['assignee'] == _selectedAssignee;
      final matchRole = isManager || r['assignee'] == 'John Doe';
      return matchClient && matchAssignee && matchRole;
    }).toList();

    final filteredInvoices = _reportInvoices.where((inv) {
      final matchClient = _selectedClient == 'All clients' || inv['client'] == _selectedClient;
      final matchAssignee = _selectedAssignee == 'All order assignees' || inv['assignee'] == _selectedAssignee;
      final matchRole = isManager || inv['assignee'] == 'John Doe';
      return matchClient && matchAssignee && matchRole;
    }).toList();

    final collectedHeadline = isManager ? '₹19,09,723.80' : '₹16,61,953.30';
    final openingPending = isManager ? '₹23,08,404.50' : '₹14,20,100.00';
    final newInvoicesVal = isManager ? '₹37,56,412' : '₹29,46,372.00';
    final closingPending = isManager ? '₹41,55,092.70' : '₹27,04,518.70';
    final overdueEnd = isManager ? '₹33,02,589.90' : '₹21,97,165.90';
    final unclearedEnd = isManager ? '₹3,59,315.90' : '₹1,84,500.00';
    final invoiceBadgeCount = isManager && _selectedClient == 'All clients' && _selectedAssignee == 'All order assignees'
        ? 34
        : filteredInvoices.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Monthly collections'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Header: Title + Sales orders outlined button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'Monthly collections',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrdersScreen()),
                        );
                      },
                      icon: const Icon(Icons.local_shipping_outlined, size: 15, color: Color(0xFF036E97)),
                      label: const Text(
                        'Sales orders',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF036E97),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. Underlined Sub-Tabs: Outstanding | Monthly reports
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.transparent, width: 2)),
                          ),
                          child: const Text(
                            'Outstanding',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFF036E97), width: 2)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xFF036E97)),
                            SizedBox(width: 6),
                            Text(
                              'Monthly reports',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF036E97),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Filter Card (Report month *, Client, Order assignee)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Report month ',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                          Text('*', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.danger)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.borderDark),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedMonth,
                            isExpanded: true,
                            icon: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
                            style: const TextStyle(fontSize: 13, color: AppColors.navy, fontWeight: FontWeight.w500),
                            items: _months
                                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _selectedMonth = v);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Client',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.borderDark),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedClient,
                                      isExpanded: true,
                                      style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                      items: _clients
                                          .map((c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(c, overflow: TextOverflow.ellipsis),
                                              ))
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedClient = v);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isManager) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order assignee',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.borderDark),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedAssignee,
                                        isExpanded: true,
                                        style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                        items: _assignees
                                            .map((a) => DropdownMenuItem(
                                                  value: a,
                                                  child: Text(a, overflow: TextOverflow.ellipsis),
                                                ))
                                            .toList(),
                                        onChanged: (v) {
                                          if (v != null) setState(() => _selectedAssignee = v);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Hero Summary Card (Dark network banner matching prototype)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/photography/banner-network-v1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF071B2E).withValues(alpha: 0.92),
                          const Color(0xFF0B2F4A).withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMonth,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF93C5FD),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Collected this month',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          collectedHeadline,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: _heroMetric('Opening pending', openingPending)),
                            Expanded(child: _heroMetric('New invoices', newInvoicesVal)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _heroMetric('Collected', collectedHeadline)),
                            Expanded(child: _heroMetric('Closing pending', closingPending)),
                          ],
                        ),
                        const Divider(height: 22, color: Colors.white24),
                        const Text(
                          'Opening pending + new invoices − collected = closing pending.',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Month to date · As of 26 Nov 2026',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFBAE6FD)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 5. Period-End Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                          const Text('Overdue at period end', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                          Text(overdueEnd, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        ],
                      ),
                      const Divider(height: 20, color: Color(0xFFF1F5F9)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Uncleared cheques at period end', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                          Text(unclearedEnd, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Uncleared cheques remain in pending. Collections use the payment received date; cheques use their clearance date.',
                        style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 6. Client-wise monthly report Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Client-wise monthly report',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                      const SizedBox(height: 12),
                      if (filteredClients.isEmpty)
                        const Text('No matching client records.', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted))
                      else
                        ...filteredClients.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final c = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (idx > 0) const Divider(height: 22, color: Color(0xFFF1F5F9)),
                              Text(
                                c['client']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: _subMetric('Opening pending', c['opening']!)),
                                  Expanded(child: _subMetric('New invoices', c['newInv']!)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(child: _subMetric('Collected', c['collected']!, valueColor: const Color(0xFF059669))),
                                  Expanded(child: _subMetric('Closing pending', c['closing']!)),
                                ],
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 7. Collections by payment method Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Collections by payment method',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                      const SizedBox(height: 10),
                      ..._paymentMethods.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final m = entry.value;
                        return Column(
                          children: [
                            if (idx > 0) const Divider(height: 18, color: Color(0xFFF1F5F9)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(m['method']!, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                                Text(m['amount']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 8. Collections received this month Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Collections received this month',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                      const SizedBox(height: 12),
                      if (filteredReceived.isEmpty)
                        const Text('No collections matching filters.', style: TextStyle(fontSize: 12.5, color: AppColors.textMuted))
                      else
                        ...filteredReceived.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final r = entry.value;
                          return Column(
                            children: [
                              if (idx > 0) const Divider(height: 20, color: Color(0xFFF1F5F9)),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoiceId: r['inv']!)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.check, size: 18, color: Color(0xFF036E97)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r['inv']!,
                                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                                          ),
                                          Text(
                                            r['client']!,
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${r['method']} · ${r['date']}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            r['amount']!,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 9. Invoices in this report Section Header + Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Invoices in this report',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$invoiceBadgeCount',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ...filteredInvoices.map((inv) {
                  final isOverdue = inv['isOverdue'] as bool;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoiceId: inv['inv'] as String)),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inv['inv'] as String,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${inv['client']} · Issued ${inv['issued']}',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: _subMetric('Opening pending', inv['opening'] as String)),
                                Expanded(child: _subMetric('New invoices', inv['newInv'] as String)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(child: _subMetric('Collected', inv['collected'] as String)),
                                Expanded(child: _subMetric('Closing pending', inv['closing'] as String)),
                              ],
                            ),
                            const Divider(height: 18, color: Color(0xFFF1F5F9)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due ${inv['due']}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w500,
                                    color: isOverdue ? const Color(0xFFBE123C) : AppColors.textMuted,
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ],
    );
  }

  Widget _subMetric(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.navy,
          ),
        ),
      ],
    );
  }
}
