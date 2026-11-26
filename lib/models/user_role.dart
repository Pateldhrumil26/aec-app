enum UserRole {
  employee('Employee'),
  manager('Manager / Admin'),
  warehouse('Warehouse');

  final String label;
  const UserRole(this.label);
}

class UserProfile {
  final UserRole role;
  final String id;
  final String name;
  final String title;
  final String email;
  final String phone;
  final String department;
  final String territory;
  final String reportingManager;

  String get designation => title;

  const UserProfile({
    required this.role,
    required this.id,
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.department,
    required this.territory,
    required this.reportingManager,
  });

  static const employeeProfile = UserProfile(
    role: UserRole.employee,
    id: 'EMP104',
    name: 'John Doe',
    title: 'Senior Sales Executive',
    email: 'john.doe@aeconnect.com',
    phone: '+91 98100 12345',
    department: 'Commercial & Sales (Enterprise)',
    territory: 'Noida & Delhi NCR Region',
    reportingManager: 'Priya Mehta (Area Sales Manager)',
  );

  static const managerProfile = UserProfile(
    role: UserRole.manager,
    id: 'ASM001',
    name: 'Priya Mehta',
    title: 'Area Sales Manager (Commercial Approver)',
    email: 'priya.mehta@aeconnect.com',
    phone: '+91 98200 67890',
    department: 'Commercial & Sales Leadership',
    territory: 'West & North India Region',
    reportingManager: 'Director of Enterprise Business',
  );

  static const warehouseProfile = UserProfile(
    role: UserRole.warehouse,
    id: 'WH001',
    name: 'Amit Shah',
    title: 'Warehouse & Fulfillment Controller',
    email: 'amit.shah@aeconnect.com',
    phone: '+91 98300 45678',
    department: 'Warehouse Operations & Logistics',
    territory: 'Central Logistics Hub (Noida)',
    reportingManager: 'Priya Mehta (Area Sales Manager)',
  );
}
