import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/lead_model.dart';
import '../../providers/aeconnect_provider.dart';

class LeadFormScreen extends StatefulWidget {
  final LeadModel? lead;
  const LeadFormScreen({super.key, this.lead});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();
  final _estimatedValueController = TextEditingController();
  final _notesController = TextEditingController();

  String _contactMode = 'New';
  String _category = 'Telecom / ISP';
  String _source = 'Field Visit';
  final LeadStage _stage = LeadStage.newLead;

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) {
      final l = widget.lead!;
      _companyController.text = l.companyName;
      _contactPersonController.text = l.contactPerson;
      _designationController.text = l.designation;
      _phoneController.text = l.phone;
      _emailController.text = l.email;
      _cityController.text = l.city;
      _stateController.text = l.state;
      _addressController.text = l.address;
      _gstController.text = l.gstNumber;
      _estimatedValueController.text = l.estimatedValue.toStringAsFixed(0);
      _notesController.text = l.notes;
      _category = l.industry.isNotEmpty ? l.industry : 'Telecom / ISP';
      _source = l.source.isNotEmpty ? l.source : 'Field Visit';
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactPersonController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _estimatedValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final val = double.tryParse(_estimatedValueController.text.trim()) ?? 100000;
      final comp = _companyController.text.trim();
      final inits = comp.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

      final newLead = LeadModel(
        id: 'LD-${DateTime.now().millisecondsSinceEpoch % 10000}',
        initials: inits.isEmpty ? 'LD' : inits,
        companyName: comp,
        contactPerson: _contactPersonController.text.trim(),
        designation: _designationController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        industry: _category,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        address: _addressController.text.trim(),
        gstNumber: _gstController.text.trim().toUpperCase(),
        stage: _stage,
        estimatedValue: val,
        source: _source,
        salesRep: 'John Doe (EMP104)',
        asm: 'Priya Mehta',
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      context.read<AEConnectProvider>().addLead(newLead);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lead "${newLead.companyName}" captured successfully!'),
          backgroundColor: AppColors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Capture a lead'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Head matching prototype
              const Text(
                'Capture a lead',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Contact, location, ownership and the opportunity ahead.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),

              // Section 01: Company & Contact (.card in prototype)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '01 / COMPANY & CONTACT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFF7E8B96),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Start with the right contact',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Contact setup
                    _buildLabel('Contact setup'),
                    DropdownButtonFormField<String>(
                      value: _contactMode,
                      items: const [
                        DropdownMenuItem(value: 'New', child: Text('Create a new contact')),
                        DropdownMenuItem(value: 'Existing', child: Text('Link an existing contact')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _contactMode = v);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Company name
                    _buildLabel('Company name', isRequired: true),
                    TextFormField(
                      controller: _companyController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Primary contact person
                    _buildLabel('Primary contact person', isRequired: true),
                    TextFormField(
                      controller: _contactPersonController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Designation
                    _buildLabel('Designation', isRequired: true),
                    TextFormField(
                      controller: _designationController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Primary phone
                    _buildLabel('Primary phone', isRequired: true),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Exactly 10 digits; omit +91.',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),

                    // Official email
                    _buildLabel('Official email', isRequired: true),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Customer category
                    _buildLabel('Customer category', isRequired: true),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: const [
                        DropdownMenuItem(value: 'Telecom / ISP', child: Text('Telecom / ISP')),
                        DropdownMenuItem(value: 'System Integrator', child: Text('System Integrator')),
                        DropdownMenuItem(value: 'Distributor', child: Text('Distributor')),
                        DropdownMenuItem(value: 'Enterprise / Corporate', child: Text('Enterprise / Corporate')),
                        DropdownMenuItem(value: 'Government', child: Text('Government')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _category = v);
                      },
                    ),
                    const SizedBox(height: 14),

                    // GST
                    _buildLabel('GST number (if available)'),
                    TextFormField(
                      controller: _gstController,
                      decoration: const InputDecoration(hintText: 'e.g. 07AAAAA0000A1Z5'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 02: Location
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '02 / LOCATION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFF7E8B96),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Find the right territory',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'State, city and territory are linked to local master.',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('State', isRequired: true),
                    TextFormField(
                      controller: _stateController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('City', isRequired: true),
                    TextFormField(
                      controller: _cityController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Street address'),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 03: Opportunity
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '03 / OPPORTUNITY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFF7E8B96),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Define the commercial opportunity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Lead source'),
                    DropdownButtonFormField<String>(
                      value: _source,
                      items: const [
                        DropdownMenuItem(value: 'Field Visit', child: Text('Field Visit')),
                        DropdownMenuItem(value: 'Referral', child: Text('Referral')),
                        DropdownMenuItem(value: 'Website', child: Text('Website')),
                        DropdownMenuItem(value: 'Exhibition / Expo', child: Text('Exhibition / Expo')),
                        DropdownMenuItem(value: 'Tender Portal', child: Text('Tender Portal')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _source = v);
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Estimated deal value (INR)', isRequired: true),
                    TextFormField(
                      controller: _estimatedValueController,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Requirement / Project specifications'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Form Actions: Cancel + Save lead
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
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(42),
                      ),
                      child: const Text('Save lead'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
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
}
