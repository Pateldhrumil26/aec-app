import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/rbac/role_guard.dart';
import '../../models/permission.dart';
import '../collections/invoice_detail_screen.dart';
import 'salesperson_report_screen.dart';

class TeamPerformanceScreen extends StatefulWidget {
  const TeamPerformanceScreen({super.key});

  @override
  State<TeamPerformanceScreen> createState() => _TeamPerformanceScreenState();
}

class _TeamPerformanceScreenState extends State<TeamPerformanceScreen> {
  String _selectedMonth = 'November 2026';
  String _rankBy = 'Collected amount';
  int _activeTab = 0; // 0 = Team, 1 = Collections
  String _invoiceSort = 'Earliest due date';

  // Filter dialog state
  String _filterSalesperson = 'All salespeople';
  String _filterRegion = 'All regions';
  String _filterClient = 'All clients';
  String _filterStatus = 'All statuses';
  String _filterDueState = 'All due states';
  bool _onlyUnclearedCheques = false;

  static final List<Map<String, dynamic>> _salespeople = [
    {
      'id': 'emp105',
      'name': 'Neha Patel',
      'region': 'Maharashtra',
      'avatar': 'assets/people/emp105.jpg',
      'collectedNum': 1145308.0,
      'salesNum': 1659080.0,
      'collected': '₹11,45,308',
      'collectionDue': '₹11,05,424',
      'confirmedSales': '₹16,59,080',
      'targetNote': 'Collection target 127% · Sales target 104%',
      'flags': ['₹11,05,424 overdue'],
    },
    {
      'id': 'emp104',
      'name': 'John Doe',
      'region': 'Gujarat & North India',
      'avatar': 'assets/people/emp104.jpg',
      'collectedNum': 764415.8,
      'salesNum': 2097332.0,
      'collected': '₹7,64,415.80',
      'collectionDue': '₹21,97,165.90',
      'confirmedSales': '₹20,97,332',
      'targetNote': 'Collection target 64% · Sales target 87%',
      'flags': [
        'Collection pace short by ₹3,15,584.20',
        'Sales pace short by ₹62,668',
      ],
    },
  ];

  static final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'DEMO-INV-EMP104-opening-61',
      'client': 'Demo · Metro Fiber Projects',
      'salesperson': 'John Doe',
      'region': 'Gujarat & North India',
      'status': 'Unpaid',
      'dueNote': '147 days overdue',
      'isOverdue': true,
      'pending': '₹33,984',
      'pendingNum': 33984.0,
      'dueRank': 1,
      'chequeNote': null,
    },
    {
      'id': 'DEMO-INV-EMP104-opening-31',
      'client': 'Demo · Horizon Broadband',
      'salesperson': 'John Doe',
      'region': 'Gujarat & North India',
      'status': 'Unpaid',
      'dueNote': '48 days overdue',
      'isOverdue': true,
      'pending': '₹79,650',
      'pendingNum': 79650.0,
      'dueRank': 2,
      'chequeNote': null,
    },
    {
      'id': 'DEMO-INV-EMP105-2026-10-4',
      'client': 'Demo · Orchid Networks',
      'salesperson': 'Neha Patel',
      'region': 'Maharashtra',
      'status': 'Partly paid',
      'dueNote': '19 days overdue',
      'isOverdue': true,
      'pending': '₹11,05,424',
      'pendingNum': 1105424.0,
      'dueRank': 3,
      'chequeNote': 'Uncleared cheque ₹1,07,380 · included in pending',
    },
    {
      'id': 'DEMO-INV-002',
      'client': 'Bright Infra Solutions',
      'salesperson': 'John Doe',
      'region': 'Gujarat & North India',
      'status': 'Partly paid',
      'dueNote': 'Due 29 Nov 2026',
      'isOverdue': false,
      'pending': '₹2,46,572.80',
      'pendingNum': 246572.8,
      'dueRank': 4,
      'chequeNote': 'Uncleared cheque ₹2,51,935.90 · included in pending',
    },
  ];

  void _openFiltersDialog() {
    String sp = _filterSalesperson;
    String reg = _filterRegion;
    String cli = _filterClient;
    String st = _filterStatus;
    String due = _filterDueState;
    bool chq = _onlyUnclearedCheques;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter report',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _modalDropdown('Salesperson', sp, ['All salespeople', 'Neha Patel', 'John Doe'],
                    (v) => setModalState(() => sp = v)),
                _modalDropdown('Region', reg, ['All regions', 'Maharashtra', 'Gujarat & North India'],
                    (v) => setModalState(() => reg = v)),
                _modalDropdown('Client', cli, [
                  'All clients',
                  'Bright Infra Solutions',
                  'Demo · Metro Fiber Projects',
                  'Demo · Horizon Broadband',
                  'Demo · Orchid Networks',
                ], (v) => setModalState(() => cli = v)),
                _modalDropdown('Invoice status', st, ['All statuses', 'Unpaid', 'Partly paid', 'Paid'],
                    (v) => setModalState(() => st = v)),
                _modalDropdown('Due state', due, ['All due states', 'Overdue', 'Not yet due'],
                    (v) => setModalState(() => due = v)),
                const SizedBox(height: 4),
                CheckboxListTile(
                  value: chq,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Only invoices with uncleared cheques',
                    style: TextStyle(fontSize: 12.5, color: AppColors.navy),
                  ),
                  onChanged: (v) => setModalState(() => chq = v ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setModalState(() {
                  sp = 'All salespeople';
                  reg = 'All regions';
                  cli = 'All clients';
                  st = 'All statuses';
                  due = 'All due states';
                  chq = false;
                });
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterSalesperson = sp;
                  _filterRegion = reg;
                  _filterClient = cli;
                  _filterStatus = st;
                  _filterDueState = due;
                  _onlyUnclearedCheques = chq;
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF036E97),
                foregroundColor: Colors.white,
              ),
              child: const Text('Apply filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('d MMM yyyy').format(DateTime.now());

    // Filter & rank salespeople
    final rankedTeam = _salespeople.where((p) {
      if (_filterSalesperson != 'All salespeople' && p['name'] != _filterSalesperson) return false;
      if (_filterRegion != 'All regions' && p['region'] != _filterRegion) return false;
      return true;
    }).toList();

    rankedTeam.sort((a, b) {
      if (_rankBy == 'Confirmed sales') {
        return (b['salesNum'] as double).compareTo(a['salesNum'] as double);
      }
      return (b['collectedNum'] as double).compareTo(a['collectedNum'] as double);
    });

    // Filter & sort invoices
    final filteredInvoices = _invoices.where((inv) {
      if (_filterSalesperson != 'All salespeople' && inv['salesperson'] != _filterSalesperson) return false;
      if (_filterRegion != 'All regions' && inv['region'] != _filterRegion) return false;
      if (_filterClient != 'All clients' && inv['client'] != _filterClient) return false;
      if (_filterStatus != 'All statuses' && inv['status'] != _filterStatus) return false;
      if (_filterDueState == 'Overdue' && !(inv['isOverdue'] as bool)) return false;
      if (_filterDueState == 'Not yet due' && (inv['isOverdue'] as bool)) return false;
      if (_onlyUnclearedCheques && inv['chequeNote'] == null) return false;
      return true;
    }).toList();

    if (_invoiceSort == 'Highest pending amount') {
      filteredInvoices.sort((a, b) => (b['pendingNum'] as double).compareTo(a['pendingNum'] as double));
    } else if (_invoiceSort == 'Client name') {
      filteredInvoices.sort((a, b) => (a['client'] as String).compareTo(b['client'] as String));
    } else {
      filteredInvoices.sort((a, b) => (a['dueRank'] as int).compareTo(b['dueRank'] as int));
    }

    final activeFilterCount = (_filterSalesperson != 'All salespeople' ? 1 : 0) +
        (_filterRegion != 'All regions' ? 1 : 0) +
        (_filterClient != 'All clients' ? 1 : 0) +
        (_filterStatus != 'All statuses' ? 1 : 0) +
        (_filterDueState != 'All due states' ? 1 : 0) +
        (_onlyUnclearedCheques ? 1 : 0);

    return RoleGuard(
      feature: AppFeature.teamPerformance,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FC),
        appBar: AppBar(
          title: const Text('Team performance'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Page Header: Team performance + 'Manager overview' button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Team performance',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: Color(0xFF16364B),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Your assigned sales team.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF587083)),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded, size: 14, color: Color(0xFF036E97)),
                        label: const Text(
                          'Manager overview',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFC8E4F2)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2. Section Heading + Demo Note
                  const Text(
                    'Team performance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF164A66)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$_selectedMonth · ${rankedTeam.length} salespeople',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF637A8A)),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF4F8),
                      border: Border.all(color: const Color(0xFFDCE8EF)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Illustrative team data · 3 months · Sample targets are editable',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6A8090)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Filter Bar Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: const Color(0xFFDCE7EE)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text('Report month ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                      Text('*', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9C3B38))),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFAEB9C2)),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedMonth,
                                        isExpanded: true,
                                        icon: const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textMuted),
                                        style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                        items: const [
                                          DropdownMenuItem(value: 'November 2026', child: Text('November 2026')),
                                          DropdownMenuItem(value: 'October 2026', child: Text('October 2026')),
                                          DropdownMenuItem(value: 'September 2026', child: Text('September 2026')),
                                        ],
                                        onChanged: (v) {
                                          if (v != null) setState(() => _selectedMonth = v);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Rank team by', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFAEB9C2)),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _rankBy,
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
                                        style: const TextStyle(fontSize: 12.5, color: AppColors.navy),
                                        items: const [
                                          DropdownMenuItem(value: 'Collected amount', child: Text('Collected amount')),
                                          DropdownMenuItem(value: 'Confirmed sales', child: Text('Confirmed sales')),
                                        ],
                                        onChanged: (v) {
                                          if (v != null) setState(() => _rankBy = v);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _openFiltersDialog,
                              icon: const Icon(Icons.tune, size: 14, color: Color(0xFF036E97)),
                              label: Text(
                                activeFilterCount > 0 ? 'Filters ($activeFilterCount)' : 'Filters',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xFFC8E4F2)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                minimumSize: const Size(0, 34),
                              ),
                            ),
                            Text(
                              activeFilterCount > 0
                                  ? '${filteredInvoices.length} matching invoices'
                                  : '34 invoices · 13 clients',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF626E79)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Hero KPI Summary Card (.performance-due-summary)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7FB),
                      border: Border.all(color: const Color(0xFFC1E0EB)),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'As of $todayStr',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF626E79)),
                        ),
                        const SizedBox(height: 14),
                        const Text('Collection due', style: TextStyle(fontSize: 12, color: Color(0xFF53758A))),
                        const SizedBox(height: 4),
                        const Text(
                          '₹33,02,589.90',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            color: Color(0xFF075D85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '27 unpaid invoices due by this date',
                          style: TextStyle(fontSize: 11, color: Color(0xFF648090)),
                        ),
                        const Divider(height: 28, color: Color(0xFFCCE2EB)),
                        const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Collected this month', style: TextStyle(fontSize: 10.5, color: Color(0xFF547485))),
                                  SizedBox(height: 2),
                                  Text('₹19,09,723.80', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF175B76))),
                                  SizedBox(height: 14),
                                  Text('Not yet due', style: TextStyle(fontSize: 10.5, color: Color(0xFF547485))),
                                  SizedBox(height: 2),
                                  Text('₹8,52,502.80', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF175B76))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Overdue', style: TextStyle(fontSize: 10.5, color: Color(0xFF547485))),
                                  SizedBox(height: 2),
                                  Text('₹33,02,589.90', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFA35820))),
                                  SizedBox(height: 14),
                                  Text('Due in next 7 days', style: TextStyle(fontSize: 10.5, color: Color(0xFF547485))),
                                  SizedBox(height: 2),
                                  Text('₹8,52,502.80', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF175B76))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 26, color: Color(0xFFCCE2EB)),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total pending', style: TextStyle(fontSize: 11, color: Color(0xFF648090))),
                            Text('₹41,55,092.70', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF335E74))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Uncleared cheques', style: TextStyle(fontSize: 11, color: Color(0xFF648090))),
                            Text('₹3,59,315.90', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF335E74))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Segmented Pill Tabs: Team | Collections
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EEF2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        _buildSegmentTab(0, 'Team'),
                        const SizedBox(width: 4),
                        _buildSegmentTab(1, 'Collections'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 6. Active Tab Body
                  if (_activeTab == 0)
                    _buildTeamTab(context, rankedTeam)
                  else
                    _buildCollectionsTab(context, filteredInvoices),

                  const SizedBox(height: 12),
                  // 7. Bottom Footnote
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      'Collections use balances as of $todayStr. Due includes today; overdue excludes today. Uncleared cheques stay pending until cleared. Collections are credited to the order owner.',
                      style: const TextStyle(fontSize: 10.5, height: 1.4, color: Color(0xFF6B7D8A)),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentTab(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 3, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF0876A0) : const Color(0xFF637A8B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamTab(BuildContext context, List<Map<String, dynamic>> rankedTeam) {
    final top = rankedTeam.isNotEmpty ? rankedTeam.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: Top performer
        if (top != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFDCE7EE)),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top performer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D)),
                ),
                const SizedBox(height: 14),
                _buildPersonSection(context, top, rank: 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Card 2: Running behind / needs attention
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE7EE)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Running behind / needs attention',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D)),
              ),
              const SizedBox(height: 14),
              ...rankedTeam.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;
                final flags = p['flags'] as List<String>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (idx > 0) const Divider(height: 24, color: Color(0xFFE2EBF0)),
                    _buildPersonHeader(context, p),
                    const SizedBox(height: 10),
                    ...flags.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildFlagPill(f),
                        )),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 3: All salespeople
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE7EE)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All salespeople',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D)),
              ),
              const SizedBox(height: 14),
              ...rankedTeam.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (idx > 0) const Divider(height: 26, color: Color(0xFFE2EBF0)),
                    _buildPersonSection(context, p, rank: idx + 1),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonHeader(BuildContext context, Map<String, dynamic> p, {int? rank}) {
    return Row(
      children: [
        if (rank != null) ...[
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1CD),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF95640A)),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            p['avatar'] as String,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Text((p['name'] as String)[0], style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p['name'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF22475D)),
              ),
              Text(
                p['region'] as String,
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF6E8190)),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SalespersonReportScreen(
                employeeId: p['id'] as String,
                name: p['name'] as String,
              ),
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFC8E4F2)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: const Size(0, 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'View KPI',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonSection(BuildContext context, Map<String, dynamic> p, {int? rank}) {
    final flags = p['flags'] as List<String>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonHeader(context, p, rank: rank),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _metricCol('Collected', p['collected'] as String, const Color(0xFF157052), size: 15),
            _metricCol('Collection due', p['collectionDue'] as String, const Color(0xFF1F566F)),
            _metricCol('Confirmed sales', p['confirmedSales'] as String, const Color(0xFF1F566F)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          p['targetNote'] as String,
          style: const TextStyle(fontSize: 10.5, color: Color(0xFF7A8E9C)),
        ),
        const SizedBox(height: 8),
        ...flags.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildFlagPill(f),
            )),
      ],
    );
  }

  Widget _metricCol(String label, String value, Color color, {double size = 13.5}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFF6E8190))),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildFlagPill(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF8B5E25)),
      ),
    );
  }

  Widget _buildCollectionsTab(BuildContext context, List<Map<String, dynamic>> invoices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: Collection breakdown
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE7EE)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Collection breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D))),
              const SizedBox(height: 12),
              _kvRow('Due today', '₹0'),
              _kvRow('Opening pending', '₹23,08,404.50'),
              _kvRow('New invoices this month', '₹37,56,412'),
              _kvRow('Collected this month', '₹19,09,723.80', valueColor: const Color(0xFF157052)),
              _kvRow('Total pending', '₹41,55,092.70'),
              _kvRow('Collection rate', '31%'),
              const SizedBox(height: 8),
              const Text(
                'Opening pending + new invoices − cleared receipts = total pending. Collection rate uses opening pending + new invoices.',
                style: TextStyle(fontSize: 10.5, height: 1.4, color: Color(0xFF6B7D8A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Overdue age
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE7EE)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Overdue age', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D))),
              const SizedBox(height: 12),
              _ageRow('1-7 days', '₹7,94,529.40', '5 invoices'),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              _ageRow('8-30 days', '₹8,67,713', '6 invoices'),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              _ageRow('31-60 days', '₹11,06,397.50', '10 invoices'),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              _ageRow('61+ days', '₹5,33,950', '6 invoices'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 3: Invoices
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE7EE)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Invoices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF24475D))),
                  DropdownButton<String>(
                    value: _invoiceSort,
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
                    items: const [
                      DropdownMenuItem(value: 'Earliest due date', child: Text('Earliest due date')),
                      DropdownMenuItem(value: 'Highest pending amount', child: Text('Highest pending amount')),
                      DropdownMenuItem(value: 'Client name', child: Text('Client name')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _invoiceSort = v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...invoices.asMap().entries.map((entry) {
                final idx = entry.key;
                final inv = entry.value;
                final isOverdue = inv['isOverdue'] as bool;
                final chequeNote = inv['chequeNote'] as String?;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (idx > 0) const Divider(height: 24, color: Color(0xFFE2EBF0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            inv['client'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF22475D)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            inv['status'] as String,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${inv['id']} · ${inv['salesperson']}',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E8190)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          inv['dueNote'] as String,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isOverdue ? const Color(0xFFA35820) : const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          inv['pending'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1F566F)),
                        ),
                      ],
                    ),
                    if (chequeNote != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        chequeNote,
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF648090)),
                      ),
                    ],
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceDetailScreen(invoiceId: inv['id'] as String),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFC8E4F2)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: const Size(0, 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text(
                        'View invoice',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kvRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: valueColor ?? const Color(0xFF1F566F))),
        ],
      ),
    );
  }

  Widget _ageRow(String bucket, String amount, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bucket, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF22475D))),
            Text(count, style: const TextStyle(fontSize: 11, color: Color(0xFF6E8190))),
          ],
        ),
        Text(amount, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFFA35820))),
      ],
    );
  }
}
