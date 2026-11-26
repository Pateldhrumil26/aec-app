import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../components/app_search_bar.dart';
import '../../core/constants/app_colors.dart';
import '../../models/notification_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../collections/collections_screen.dart';
import '../orders/order_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  String _sortOption = 'Newest first';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allNotifications = provider.notifications;

    final filtered = allNotifications.where((n) {
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = n.title.toLowerCase().contains(q);
        final matchesText = n.text.toLowerCase().contains(q);
        if (!matchesTitle && !matchesText) return false;
      }

      if (_selectedFilter == 'Unread') return !n.isRead;
      if (_selectedFilter == 'Read') return n.isRead;
      return true; // 'All'
    }).toList();

    if (_sortOption == 'Newest first') {
      filtered.sort((a, b) => b.at.compareTo(a.at));
    } else if (_sortOption == 'Oldest first') {
      filtered.sort((a, b) => a.at.compareTo(b.at));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Navigator.canPop(context)
          ? AppBar(title: const Text('Notifications'))
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title & Mark all read button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: AppColors.navy,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => provider.markAllNotificationsRead(),
                      icon: const Icon(Icons.check, size: 16, color: AppColors.textPrimary),
                      label: const Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Search & Filter toolbar
                AppSearchBar(
                  hintText: 'Search notifications',
                  value: _searchQuery,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  actionButton: PopupMenuButton<String>(
                    initialValue: _sortOption,
                    tooltip: 'Sort options',
                    onSelected: (val) => setState(() => _sortOption = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                      PopupMenuItem(value: 'Oldest first', child: Text('Sort by: Oldest first')),
                    ],
                    child: AppSearchBar.buildActionButton(
                      child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF036E97)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Segmented Tabs: All, Unread, Read
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: ['All', 'Unread', 'Read'].map((tab) {
                      final isSelected = _selectedFilter == tab;
                      return InkWell(
                        onTap: () => setState(() => _selectedFilter = tab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                const SizedBox(height: 16),

                // Notifications List Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: filtered.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.notifications_none, size: 36, color: Color(0xFF8A98AC)),
                                SizedBox(height: 10),
                                Text(
                                  'No notifications found',
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
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, thickness: 1, color: Color(0xFFEDF0F5)),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return _buildNotificationRow(context, provider, item);
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filtered.length} record',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const Text(
                        'Showing all',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
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

  Widget _buildNotificationRow(
      BuildContext context, AEConnectProvider provider, NotificationModel item) {
    final formattedTime = DateFormat('d MMM yyyy · hh:mm a').format(item.at).toLowerCase();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar (Bell if unread, Check if read)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.isRead ? const Color(0xFFF1F3F5) : const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.isRead ? Icons.check : Icons.notifications_none_outlined,
              size: 18,
              color: item.isRead ? const Color(0xFF526680) : AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),

          // Message details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF526680),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A98AC),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Open Action Button
          OutlinedButton(
            onPressed: () {
              provider.markNotificationRead(item.id);
              if (item.page == 'orders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(orderId: item.recordId ?? 'ORD-2026-0001'),
                  ),
                );
              } else if (item.page == 'collections') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opened: ${item.title}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              'Open',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
