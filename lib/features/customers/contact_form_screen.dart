import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';

class ContactFormScreen extends StatefulWidget {
  final String? contactId;
  final Map<String, String>? initialContact;
  final String? leadCompany;

  const ContactFormScreen({
    super.key,
    this.contactId,
    this.initialContact,
    this.leadCompany,
  });

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _altPhoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;

  String _linkedLeadId = '';
  bool _locationExpanded = false;

  @override
  void initState() {
    super.initState();
    final c = widget.initialContact;
    _linkedLeadId = c?['leadId'] ?? '';
    _companyCtrl = TextEditingController(text: c?['company'] ?? widget.leadCompany ?? '');
    _nameCtrl = TextEditingController(text: c?['name'] ?? '');
    _roleCtrl = TextEditingController(text: c?['role'] ?? '');
    _phoneCtrl = TextEditingController(text: c?['phone'] ?? '');
    _altPhoneCtrl = TextEditingController(text: c?['altPhone'] ?? '');
    _emailCtrl = TextEditingController(text: c?['email'] ?? '');
    _cityCtrl = TextEditingController(text: c?['city'] ?? '');
    _stateCtrl = TextEditingController(text: c?['state'] ?? '');
    _addressCtrl = TextEditingController(text: c?['address'] ?? '');
    _notesCtrl = TextEditingController(text: c?['notes'] ?? '');
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AEConnectProvider>();
    final id = widget.contactId ?? 'ct_${DateTime.now().millisecondsSinceEpoch}';
    final payload = <String, String>{
      'id': id,
      'name': _nameCtrl.text.trim(),
      'role': _roleCtrl.text.trim(),
      'company': _companyCtrl.text.trim(),
      'leadId': _linkedLeadId,
      'phone': _phoneCtrl.text.trim(),
      'altPhone': _altPhoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'notes': _notesCtrl.text.trim(),
    };

    if (widget.contactId != null) {
      provider.updateCrmContact(id, payload);
    } else {
      provider.addCrmContact(payload);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact "${payload['name']}" saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leads = context.watch<AEConnectProvider>().leads;
    final isEditing = widget.contactId != null;

    // Ensure _linkedLeadId exists in dropdown items
    final validLeadIds = leads.map((l) => l.id).toSet();
    final dropdownLeadValue = validLeadIds.contains(_linkedLeadId) ? _linkedLeadId : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit contact' : 'New CRM contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit contact' : 'New CRM contact',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Save a contact independently or link it to an existing company lead.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Form Card matching prototype (#contactform)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Linked lead (optional)
                        const Text(
                          'Linked lead (optional)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: dropdownLeadValue,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem(
                              value: '',
                              child: Text('Unlinked CRM contact'),
                            ),
                            ...leads.map(
                              (l) => DropdownMenuItem(
                                value: l.id,
                                child: Text(
                                  '${l.companyName} (${l.id})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _linkedLeadId = val ?? '';
                              if (_linkedLeadId.isNotEmpty) {
                                final match = leads.where((l) => l.id == _linkedLeadId);
                                if (match.isNotEmpty) {
                                  _companyCtrl.text = match.first.companyName;
                                  if (_cityCtrl.text.isEmpty) _cityCtrl.text = match.first.city;
                                  if (_stateCtrl.text.isEmpty) _stateCtrl.text = match.first.state;
                                  if (_addressCtrl.text.isEmpty) _addressCtrl.text = match.first.address;
                                }
                              }
                            });
                          },
                          decoration: const InputDecoration(),
                        ),
                        const SizedBox(height: 14),

                        // Company name *
                        _buildLabel('Company name', required: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _companyCtrl,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          decoration: const InputDecoration(),
                        ),
                        const SizedBox(height: 14),

                        // Full name * | Designation *
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Full name', required: true),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _nameCtrl,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                                    decoration: const InputDecoration(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Designation', required: true),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _roleCtrl,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                                    decoration: const InputDecoration(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Primary phone * | Alternate phone (optional)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Primary phone', required: true),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                                    decoration: const InputDecoration(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Alternate phone (optional)'),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _altPhoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Official email *
                        _buildLabel('Official email', required: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          decoration: const InputDecoration(),
                        ),

                        const Divider(height: 28, color: Color(0xFFF1F5F9)),

                        // Expandable Company location (optional)
                        InkWell(
                          onTap: () => setState(() => _locationExpanded = !_locationExpanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Company location (optional)',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                Icon(
                                  _locationExpanded
                                      ? Icons.keyboard_arrow_down
                                      : Icons.chevron_right,
                                  size: 18,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_locationExpanded) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('City'),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _cityCtrl,
                                      decoration: const InputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('State'),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _stateCtrl,
                                      decoration: const InputDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildLabel('Address'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _addressCtrl,
                            decoration: const InputDecoration(),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // Relationship notes
                        _buildLabel('Relationship notes'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _notesCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(),
                        ),

                        const Divider(height: 28, color: Color(0xFFF1F5F9)),
                        const Text(
                          'Draft changes stay in this browser',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 16),

                        // Bottom Buttons: Cancel | Save contact
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF036E97),
                                  minimumSize: const Size(0, 44),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveContact,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF036E97),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  minimumSize: const Size(0, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Save contact',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.danger,
            ),
          ),
      ],
    );
  }
}
