import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/aeconnect_provider.dart';
import '../features/search/global_search_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final user = provider.currentUser;
    final initials = user.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          // AE CONNECT Wordmark with Cyan circle accent
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: AppColors.primary,
              ),
              children: [
                TextSpan(text: 'AE '),
                TextSpan(text: 'C', style: TextStyle(color: AppColors.textPrimary)),
                TextSpan(text: 'O', style: TextStyle(color: AppColors.accent)),
                TextSpan(text: 'NNECT', style: TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // 1. Global Search
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
          tooltip: 'Search',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
            );
          },
        ),

        // 2. Notifications with badge pill (2)
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 22),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.kpiDangerFg,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),

        // 3. Profile Avatar with badge pill (6)
        Padding(
          padding: const EdgeInsets.only(right: 14.0, left: 4.0),
          child: GestureDetector(
            key: const Key('header_profile_button'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      initials.isEmpty ? 'JD' : initials,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
