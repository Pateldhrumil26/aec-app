import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/app_header.dart';
import '../home/home_screen.dart';
import '../leads/leads_screen.dart';
import '../visits/visits_screen.dart';
import '../tasks/tasks_screen.dart';
import '../more/more_hub_screen.dart';
import '../orders/orders_screen.dart';
import '../inventory/inventory_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final currentIndex = provider.currentTabIndex;
    final isWarehouse = provider.currentRole == UserRole.warehouse;
    final isManager = provider.currentRole == UserRole.manager;

    // Distinct Screens for Roles
    final List<Widget> screens = isWarehouse
        ? const [
            HomeScreen(),
            OrdersScreen(),
            InventoryScreen(),
            NotificationsScreen(),
            ProfileScreen(),
          ]
        : const [
            HomeScreen(),
            LeadsScreen(),
            VisitsScreen(),
            TasksScreen(),
            MoreHubScreen(),
          ];

    final activeIndex = currentIndex >= screens.length ? 0 : currentIndex;

    return Scaffold(
      appBar: const AppHeader(),
      body: IndexedStack(
        index: activeIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: isWarehouse
            ? _buildWarehouseNav(context, provider, activeIndex)
            : _buildSalesNav(context, provider, activeIndex, isManager),
      ),
    );
  }

  // --- Warehouse Bottom Nav ---
  Widget _buildWarehouseNav(BuildContext context, AEConnectProvider provider, int activeIndex) {
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: (index) => provider.setTabIndex(index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.local_shipping_outlined, '1'),
          activeIcon: const Icon(Icons.local_shipping_rounded),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.inventory_2_outlined, '2'),
          activeIcon: const Icon(Icons.inventory_2_rounded),
          label: 'Stock',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.notifications_outlined, '1'),
          activeIcon: const Icon(Icons.notifications_rounded),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.person_outline_rounded, '6'),
          activeIcon: const Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }

  // --- Employee & Manager Bottom Nav ---
  Widget _buildSalesNav(BuildContext context, AEConnectProvider provider, int activeIndex, bool isManager) {
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: (index) => provider.setTabIndex(index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: isManager ? _buildBadgeIcon(Icons.people_outline_rounded, '1') : const Icon(Icons.people_outline_rounded),
          activeIcon: const Icon(Icons.people_rounded),
          label: 'Leads',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          activeIcon: Icon(Icons.location_on_rounded),
          label: 'Visits',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_rounded),
          activeIcon: Icon(Icons.check_circle_rounded),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.grid_view_rounded, isManager ? '48' : '29'),
          activeIcon: const Icon(Icons.grid_view_sharp),
          label: 'More',
        ),
      ],
    );
  }

  Widget _buildBadgeIcon(IconData icon, String count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          top: -4,
          right: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
