import '../../models/user_role.dart';
import '../../models/permission.dart';

/// Centralized Role-Based Permissions Matrix
class RolePermissions {
  static const Map<UserRole, Map<AppFeature, Set<AppAction>>> _matrix = {
    // -------------------------------------------------------------
    // 1. Employee: Sales Executive (EMP104 - John Doe)
    // -------------------------------------------------------------
    UserRole.employee: {
      AppFeature.dashboard: {AppAction.view},
      AppFeature.leads: {AppAction.view, AppAction.create, AppAction.edit},
      AppFeature.pipeline: {AppAction.view},
      AppFeature.quotations: {AppAction.view, AppAction.create, AppAction.edit}, // No approve!
      AppFeature.orders: {AppAction.view, AppAction.create},
      AppFeature.visits: {AppAction.view, AppAction.create, AppAction.edit},
      AppFeature.tasks: {AppAction.view, AppAction.create, AppAction.edit},
      AppFeature.moms: {AppAction.view, AppAction.create, AppAction.edit}, // No approve!
      AppFeature.collections: {AppAction.view, AppAction.create},
      AppFeature.customers: {AppAction.view, AppAction.create},
      AppFeature.contacts: {AppAction.view, AppAction.create, AppAction.edit},
      AppFeature.ess: {AppAction.view, AppAction.manage},
      AppFeature.attendance: {AppAction.view, AppAction.create},
      AppFeature.leaves: {AppAction.view, AppAction.create},
      AppFeature.expenses: {AppAction.view, AppAction.create},
      AppFeature.devices: {AppAction.view, AppAction.create},
      AppFeature.notifications: {AppAction.view},
      AppFeature.profile: {AppAction.view, AppAction.edit},
      // Restricted: inventory, teamPerformance, hrReviews, partnerApplications
    },

    // -------------------------------------------------------------
    // 2. Manager / Admin: Area Sales Manager (ASM001 - Priya Mehta)
    // -------------------------------------------------------------
    UserRole.manager: {
      AppFeature.dashboard: {AppAction.view, AppAction.manage},
      AppFeature.leads: {AppAction.view, AppAction.create, AppAction.edit, AppAction.delete, AppAction.assign, AppAction.manage},
      AppFeature.pipeline: {AppAction.view, AppAction.manage},
      AppFeature.quotations: {AppAction.view, AppAction.create, AppAction.edit, AppAction.approve, AppAction.manage},
      AppFeature.orders: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage},
      AppFeature.visits: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage},
      AppFeature.tasks: {AppAction.view, AppAction.create, AppAction.edit, AppAction.assign, AppAction.manage},
      AppFeature.moms: {AppAction.view, AppAction.create, AppAction.edit, AppAction.approve, AppAction.manage},
      AppFeature.collections: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage, AppAction.export},
      AppFeature.customers: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage},
      AppFeature.contacts: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage},
      AppFeature.partnerApplications: {AppAction.view, AppAction.approve, AppAction.manage},
      AppFeature.teamPerformance: {AppAction.view, AppAction.manage, AppAction.export},
      AppFeature.hrReviews: {AppAction.view, AppAction.approve, AppAction.manage},
      AppFeature.ess: {AppAction.view, AppAction.manage},
      AppFeature.attendance: {AppAction.view, AppAction.manage},
      AppFeature.leaves: {AppAction.view, AppAction.approve, AppAction.manage},
      AppFeature.expenses: {AppAction.view, AppAction.approve, AppAction.manage},
      AppFeature.devices: {AppAction.view, AppAction.approve, AppAction.manage},
      AppFeature.notifications: {AppAction.view},
      AppFeature.profile: {AppAction.view, AppAction.edit},
      // Restricted: inventory (Warehouse Controller module)
    },

    // -------------------------------------------------------------
    // 3. Warehouse: Warehouse Controller (WH001 - Amit Shah)
    // -------------------------------------------------------------
    UserRole.warehouse: {
      AppFeature.dashboard: {AppAction.view, AppAction.manage},
      AppFeature.inventory: {AppAction.view, AppAction.create, AppAction.edit, AppAction.manage},
      AppFeature.orders: {AppAction.view, AppAction.edit, AppAction.manage}, // Pack, Reserve, Dispatch
      AppFeature.notifications: {AppAction.view},
      AppFeature.profile: {AppAction.view, AppAction.edit},
      // Restricted: sales leads, pipeline, quotations, visits, tasks, moms, collections, customers, teamPerformance, hrReviews
    },
  };

  /// Check if a specific role possesses permission for an action on a feature
  static bool hasPermission(UserRole role, AppFeature feature, AppAction action) {
    final featureMap = _matrix[role];
    if (featureMap == null) return false;
    final actions = featureMap[feature];
    if (actions == null) return false;
    return actions.contains(action);
  }

  /// Check if a role can access (view) a feature
  static bool canAccessFeature(UserRole role, AppFeature feature) {
    return hasPermission(role, feature, AppAction.view);
  }

  /// Get all features accessible by a role
  static List<AppFeature> getAccessibleFeatures(UserRole role) {
    final featureMap = _matrix[role];
    if (featureMap == null) return [];
    return featureMap.keys.toList();
  }
}
