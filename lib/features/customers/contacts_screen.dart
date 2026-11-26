import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import 'contact_form_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final customers = provider.customers;

    final contacts = customers.map((c) {
      return {
        'name': c.keyContact,
        'role': 'Procurement Head',
        'company': c.name,
        'phone': c.phone,
        'email': c.email,
        'city': c.city,
      };
    }).where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item['name']!.toLowerCase().contains(q) ||
          item['company']!.toLowerCase().contains(q) ||
          item['phone']!.toLowerCase().contains(q);
    }).toList();

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
                // Title
                const Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 18),

                // Search box
                Container(
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
                            hintText: 'Search person, phone or company',
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
                const SizedBox(height: 18),

                // Contacts List
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contacts.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, thickness: 1, color: Color(0xFFEDF0F5)),
                    itemBuilder: (context, index) {
                      final c = contacts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContactFormScreen(contactId: 'ct1'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF1FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.person_outline,
                                    size: 20, color: AppColors.primary),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['name']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${c['role']} · ${c['company']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF526680),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${c['phone']} · ${c['email']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF8A98AC),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14, color: Color(0xFF8A98AC)),
                            ],
                          ),
                        ),
                      );
                    },
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
}
