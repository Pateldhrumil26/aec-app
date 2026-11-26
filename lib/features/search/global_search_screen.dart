import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/aeconnect_provider.dart';
import '../leads/lead_detail_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final q = _query.trim().toLowerCase();

    final matchedLeads = provider.leads.where((l) {
      return q.isNotEmpty && (l.companyName.toLowerCase().contains(q) || l.contactPerson.toLowerCase().contains(q));
    }).toList();

    final matchedQuotes = provider.quotations.where((qt) {
      return q.isNotEmpty && (qt.customerName.toLowerCase().contains(q) || qt.id.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search leads, quotes, orders...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: _query.isEmpty
          ? const Center(
              child: Text('Type to search across leads, quotes, and orders...', style: TextStyle(color: AppColors.textMuted)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (matchedLeads.isNotEmpty) ...[
                  const Text('Leads', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  ...matchedLeads.map((l) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.people_alt_rounded, color: AppColors.primary),
                        title: Text(l.companyName, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${l.industry} · ${l.contactPerson}'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LeadDetailScreen(leadId: l.id)));
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
                if (matchedQuotes.isNotEmpty) ...[
                  const Text('Quotations', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  ...matchedQuotes.map((qt) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                        title: Text(qt.id, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(qt.customerName),
                      ),
                    );
                  }),
                ],
                if (matchedLeads.isEmpty && matchedQuotes.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No results matching your query.'),
                    ),
                  ),
              ],
            ),
    );
  }
}
