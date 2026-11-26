/// Supported RBAC Actions in AE Connect
enum AppAction {
  view('View'),
  create('Create'),
  edit('Edit'),
  delete('Delete'),
  approve('Approve'),
  assign('Assign'),
  manage('Manage'),
  export('Export');

  final String label;
  const AppAction(this.label);
}

/// System Features and Modules
enum AppFeature {
  dashboard('Dashboard'),
  leads('Leads'),
  pipeline('Sales Pipeline'),
  quotations('Quotations'),
  orders('Orders'),
  visits('Field Visits'),
  tasks('Tasks & Follow-ups'),
  moms('Meeting MOMs'),
  collections('Collections & Invoices'),
  customers('Customers'),
  contacts('Contacts'),
  partnerApplications('Partner Applications'),
  inventory('Inventory & Stock'),
  ess('Employee Self Service'),
  attendance('Attendance'),
  leaves('Leave Requests'),
  expenses('Expense Claims'),
  hrReviews('HR Reviews'),
  teamPerformance('Team Performance'),
  devices('Device Management'),
  notifications('Notifications'),
  profile('Profile');

  final String label;
  const AppFeature(this.label);
}
