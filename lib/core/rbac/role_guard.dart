import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_role.dart';
import '../../models/permission.dart';
import '../../providers/aeconnect_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../components/app_header.dart';
import 'rbac_service.dart';

/// Extension on BuildContext for quick and elegant permission checking in any widget
extension RbacContextExtension on BuildContext {
  /// Checks if active role can access the given feature
  bool canAccess(AppFeature feature) {
    final role = watch<AEConnectProvider>().currentRole;
    return RbacService.canAccess(role, feature);
  }

  /// Checks if active role has permission for a specific action on a feature
  bool hasPermission(AppFeature feature, AppAction action) {
    final role = watch<AEConnectProvider>().currentRole;
    return RbacService.hasPermission(role, feature, action);
  }
}

/// A screen displayed when a user navigates to an unauthorized route/screen
class AccessDeniedScreen extends StatelessWidget {
  final AppFeature feature;
  final String? customMessage;

  const AccessDeniedScreen({
    super.key,
    required this.feature,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final role = provider.currentRole;
    final reason = customMessage ?? RbacService.getAccessDeniedReason(role, feature);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Shield / Lock Icon Circle
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFDE68A), width: 2),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFFB45309),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Access Restricted',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Feature Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3F7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Feature: ${feature.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF036E97),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reason text
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Action Buttons
                  Row(
                    children: [
                      // Back Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              provider.setTabIndex(0);
                            }
                          },
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Go back'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Return to Dashboard Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            provider.setTabIndex(0);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.dashboard_outlined, size: 16),
                          label: const Text('Dashboard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Route & Screen Guard: Checks permission before rendering [child]
/// If unauthorized, displays [AccessDeniedScreen]
class RoleGuard extends StatelessWidget {
  final AppFeature feature;
  final AppAction action;
  final Widget child;
  final String? customDeniedMessage;

  const RoleGuard({
    super.key,
    required this.feature,
    this.action = AppAction.view,
    required this.child,
    this.customDeniedMessage,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AEConnectProvider>().currentRole;
    final isAllowed = RbacService.hasPermission(role, feature, action);

    if (!isAllowed) {
      return AccessDeniedScreen(
        feature: feature,
        customMessage: customDeniedMessage,
      );
    }

    return child;
  }
}

/// Widget-level Gate: Conditionally renders [child] if the active role has permission
/// Otherwise renders [fallback] (defaults to SizedBox.shrink())
class PermissionGate extends StatelessWidget {
  final AppFeature feature;
  final AppAction action;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.feature,
    required this.action,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AEConnectProvider>().currentRole;
    final isAllowed = RbacService.hasPermission(role, feature, action);

    if (isAllowed) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
