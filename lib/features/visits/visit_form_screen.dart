import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/visit_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'active_visit_screen.dart';

class VisitFormScreen extends StatefulWidget {
  final String? initialLeadId;
  const VisitFormScreen({super.key, this.initialLeadId});

  @override
  State<VisitFormScreen> createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final _customerSearchController = TextEditingController(text: 'Acme Technologies');
  final _addressController = TextEditingController(text: 'Sector 62, Electronic City, Noida, Uttar Pradesh');

  String _selectedContact = 'c1';
  String _selectedPurpose = 'Technical Discussion';
  String _locationMode = 'Demo';
  bool _gpsCaptured = false;
  double _lat = 28.62800;
  double _lon = 77.36490;
  int _accuracy = 5;

  final List<Map<String, String>> _customers = [
    {
      'id': 'LD-2026-001',
      'company': 'Acme Technologies',
      'city': 'Noida, Uttar Pradesh',
      'address': 'Sector 62, Electronic City, Noida, Uttar Pradesh',
      'contactName': 'Rajesh Sharma',
      'contactRole': 'Procurement Lead',
      'contactId': 'c1',
    },
    {
      'id': 'LD-2026-002',
      'company': 'Bright Infra Solutions',
      'city': 'Gurugram, Haryana',
      'address': 'Cyber City, Phase 2, Gurugram, Haryana',
      'contactName': 'Amit Verma',
      'contactRole': 'VP Infrastructure',
      'contactId': 'c2',
    },
    {
      'id': 'LD-2026-003',
      'company': 'Horizon Broadband',
      'city': 'Mumbai, Maharashtra',
      'address': 'BKC Industrial Complex, Bandra East, Mumbai',
      'contactName': 'Suresh Menon',
      'contactRole': 'Network Director',
      'contactId': 'c3',
    },
    {
      'id': 'LD-2026-004',
      'company': 'Westlink Networks',
      'city': 'Ahmedabad, Gujarat',
      'address': 'SG Highway, Bodakdev, Ahmedabad, Gujarat',
      'contactName': 'Ketan Patel',
      'contactRole': 'Senior Purchase Manager',
      'contactId': 'c4',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLeadId != null) {
      final match = _customers.firstWhere(
        (c) => c['id'] == widget.initialLeadId,
        orElse: () => _customers.first,
      );
      _customerSearchController.text = match['company']!;
      _addressController.text = match['address']!;
      _selectedContact = match['contactId']!;
    }
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onCustomerSelected(Map<String, String> cust) {
    setState(() {
      _customerSearchController.text = cust['company']!;
      _addressController.text = cust['address']!;
      _selectedContact = cust['contactId']!;
    });
  }

  void _captureGps() {
    setState(() {
      _gpsCaptured = true;
      _locationMode = 'GPS';
      _lat = 28.62800;
      _lon = 77.36490;
      _accuracy = 5;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS coordinates captured: 28.62800, 77.36490'),
        backgroundColor: AppColors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _checkIn() {
    final currentCustomer = _customers.firstWhere(
      (c) => c['company'] == _customerSearchController.text.trim(),
      orElse: () => {
        'id': 'LD-2026-001',
        'company': _customerSearchController.text.trim().isEmpty
            ? 'Acme Technologies'
            : _customerSearchController.text.trim(),
        'address': _addressController.text.trim(),
        'contactName': 'Rajesh Sharma',
      },
    );

    final visit = VisitModel(
      id: 'VIS-${DateTime.now().millisecondsSinceEpoch % 10000}',
      leadId: currentCustomer['id']!,
      companyName: currentCustomer['company']!,
      contactPerson: currentCustomer['contactName'] ?? 'Primary Contact',
      purpose: _selectedPurpose,
      isGpsVerified: _gpsCaptured || _locationMode == 'GPS',
      locationAddress: _addressController.text.trim(),
      latitude: _lat,
      longitude: _lon,
      checkInTime: DateTime.now(),
      durationSeconds: 0,
      status: VisitStatus.active,
    );

    context.read<AEConnectProvider>().checkInVisit(visit);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveVisitScreen(visit: visit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final activeVisit = provider.activeVisit;

    // If already active visit, show resume card
    if (activeVisit != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('New visit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your visit is still running.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Complete the active visit before starting another.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.tealLight,
                  border: Border.all(color: const Color(0xFFCCEBDD)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeVisit.companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activeVisit.purpose} · Started ${_formatTime(activeVisit.checkInTime)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.teal),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActiveVisitScreen(visit: activeVisit),
                          ),
                        );
                      },
                      icon: const Icon(Icons.timer_outlined, size: 16),
                      label: const Text('Resume active visit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New visit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title and Subtitle matching prototype
            const Text(
              'New visit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose your customer, contact and purpose before checking in.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),

            // Main Form Container Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field 1: Search customer / lead *
                  _buildFieldLabel('Search customer / lead', isRequired: true),
                  TextFormField(
                    controller: _customerSearchController,
                    decoration: InputDecoration(
                      hintText: 'Type a company name...',
                      suffixIcon: PopupMenuButton<Map<String, String>>(
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                        onSelected: _onCustomerSelected,
                        itemBuilder: (context) => _customers
                            .map(
                              (c) => PopupMenuItem(
                                value: c,
                                child: Text('${c['company']} (${c['city']})'),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Field 2: Contact person *
                  _buildFieldLabel('Contact person', isRequired: true),
                  DropdownButtonFormField<String>(
                    value: _selectedContact,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text(
                          'Select the person you are meeting',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'c1',
                        child: Text('Rajesh Sharma · Procurement Lead'),
                      ),
                      DropdownMenuItem(
                        value: 'c2',
                        child: Text('Amit Verma · VP Infrastructure'),
                      ),
                      DropdownMenuItem(
                        value: 'c3',
                        child: Text('Suresh Menon · Network Director'),
                      ),
                      DropdownMenuItem(
                        value: 'c4',
                        child: Text('Ketan Patel · Senior Purchase Manager'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedContact = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field 3: Visit purpose *
                  _buildFieldLabel('Visit purpose', isRequired: true),
                  DropdownButtonFormField<String>(
                    value: _selectedPurpose,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Technical Discussion',
                        child: Text('Technical Discussion'),
                      ),
                      DropdownMenuItem(
                        value: 'Product Demo',
                        child: Text('Product Demo'),
                      ),
                      DropdownMenuItem(
                        value: 'Initial Pitch',
                        child: Text('Initial Pitch'),
                      ),
                      DropdownMenuItem(
                        value: 'Payment Follow-up',
                        child: Text('Payment Follow-up'),
                      ),
                      DropdownMenuItem(
                        value: 'Quotation Discussion',
                        child: Text('Quotation Discussion'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedPurpose = v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field 4: Location mode
                  _buildFieldLabel('Location mode', isRequired: false),
                  DropdownButtonFormField<String>(
                    value: _locationMode,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(value: 'Demo', child: Text('Demo')),
                      DropdownMenuItem(value: 'GPS', child: Text('GPS')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _locationMode = v;
                          if (v == 'GPS') {
                            _gpsCaptured = true;
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Demo uses an illustrative customer location. GPS requests your browser location only when you choose Capture GPS.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Field 5: On-site street address *
                  _buildFieldLabel('On-site street address', isRequired: true),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Confirm the street address yourself; no external geocoding service is used.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Location Preview Card (matches .location-card in prototype)
                  Container(
                    height: 135,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDCE8E4)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.tealLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFCCEBDD)),
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                size: 28,
                                color: AppColors.teal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _addressController.text.split(',').first,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                        const Positioned(
                          bottom: 8,
                          child: Text(
                            'Location preview · illustrative map',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4E7E75),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Notice Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _gpsCaptured ? AppColors.tealLight : const Color(0xFFEDF4FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _gpsCaptured ? const Color(0xFFCCEBDD) : const Color(0xFFD2E3FC),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _gpsCaptured ? Icons.check_circle_outline : Icons.info_outline_rounded,
                          size: 16,
                          color: _gpsCaptured ? AppColors.teal : const Color(0xFF315B8B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _gpsCaptured
                                ? 'GPS captured · ${_lat.toStringAsFixed(5)}, ${_lon.toStringAsFixed(5)} · accuracy ${_accuracy}m'
                                : 'Demo mode is ready. For GPS mode, capture your current coordinates first.',
                            style: TextStyle(
                              fontSize: 11,
                              color: _gpsCaptured ? AppColors.teal : const Color(0xFF315B8B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Capture GPS Button (Secondary Button Full Width)
                  OutlinedButton.icon(
                    onPressed: _captureGps,
                    icon: const Icon(Icons.location_searching_rounded, size: 16),
                    label: const Text('Capture GPS coordinates'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size.fromHeight(42),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Form Actions: Cancel + Check in
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textMuted,
                            side: const BorderSide(color: AppColors.border),
                            minimumSize: const Size.fromHeight(42),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _checkIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(42),
                          ),
                          child: const Text('Check in'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
                  ),
                ]
              : const [],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'pm' : 'am';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
