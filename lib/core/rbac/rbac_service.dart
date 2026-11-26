import '../../models/user_role.dart';
import '../../models/permission.dart';
import 'role_permissions.dart';

/// Service providing centralized Role-Based Access Control logic
class RbacService {
  /// Checks whether [role] has [action] permission for [feature]
  static bool hasPermission(UserRole role, AppFeature feature, AppAction action) {
    return RolePermissions.hasPermission(role, feature, action);
  }

  /// Checks whether [role] can view/access [feature]
  static bool canAccess(UserRole role, AppFeature feature) {
    return RolePermissions.canAccessFeature(role, feature);
  }

  /// Quick helper: Can this role approve items in [feature]?
  static bool canApprove(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.approve);
  }

  /// Quick helper: Can this role assign items in [feature]?
  static bool canAssign(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.assign);
  }

  /// Quick helper: Can this role create items in [feature]?
  static bool canCreate(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.create);
  }

  /// Quick helper: Can this role edit items in [feature]?
  static bool canEdit(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.edit);
  }

  /// Quick helper: Can this role delete items in [feature]?
  static bool canDelete(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.delete);
  }

  /// Quick helper: Can this role manage or administrate [feature]?
  static bool canManage(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.manage);
  }

  /// Human-readable explanation for restricted access
  static String getAccessDeniedReason(UserRole role, AppFeature feature) {
    final roleName = role.label;
    final featureName = feature.label;
    return 'Your current role as "$roleName" does not have authorization to access $featureName. Please contact an administrator or switch roles to proceed.';
  }
}
