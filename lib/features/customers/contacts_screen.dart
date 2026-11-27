import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../components/app_search_bar.dart';
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
  String _sortOption = 'Default order';

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'C';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final contacts = provider.crmContacts.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return (item['name'] ?? '').toLowerCase().contains(q) ||
          (item['company'] ?? '').toLowerCase().contains(q) ||
          (item['email'] ?? '').toLowerCase().contains(q) ||
          (item['phone'] ?? '').toLowerCase().contains(q);
    }).toList();

    if (_sortOption == 'Name A–Z') {
      contacts.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    } else if (_sortOption == 'Company A–Z') {
      contacts.sort((a, b) => (a['company'] ?? '').compareTo(b['company'] ?? ''));
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
                // 1. Page Header: Contacts + '+ New contact' button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Contacts',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: AppColors.navy,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ContactFormScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text(
                        'New contact',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF036E97),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Search Bar + 3-dots sort menu
                AppSearchBar(
                  hintText: 'Search name, company or email',
                  value: _searchQuery,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: PopupMenuButton<String>(
                    initialValue: _sortOption,
                    tooltip: 'Sort options',
                    onSelected: (val) => setState(() => _sortOption = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Default order', child: Text('Sort by: Default')),
                      PopupMenuItem(value: 'Name A–Z', child: Text('Sort by: Name A–Z')),
                      PopupMenuItem(value: 'Company A–Z', child: Text('Sort by: Company A–Z')),
                    ],
                    child: AppSearchBar.buildActionButton(
                      child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Contacts List Card
                if (contacts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No contacts match your search.',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
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
                        final name = c['name'] ?? '';
                        final role = c['role'] ?? '';
                        final company = c['company'] ?? '';
                        final phone = c['phone'] ?? '';
                        final email = c['email'] ?? '';

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ContactFormScreen(
                                  contactId: c['id'],
                                  initialContact: c,
                                ),
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
                                    color: const Color(0xFFEAF6FC),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _initials(name),
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF036E97),
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
                                        name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$role · $company',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF526680),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$phone · $email',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF8A98AC),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Color(0xFF8A98AC),
                                ),
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
