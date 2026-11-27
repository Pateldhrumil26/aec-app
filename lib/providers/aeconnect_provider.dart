import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../models/lead_model.dart';
import '../models/visit_model.dart';
import '../models/task_model.dart';
import '../models/quotation_model.dart';
import '../models/order_model.dart';
import '../models/mom_model.dart';
import '../models/customer_model.dart';
import '../models/notification_model.dart';
import '../models/permission.dart';
import '../core/rbac/rbac_service.dart';

class AEConnectProvider extends ChangeNotifier {
  // Authentication & Role State
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  UserProfile _currentUser = UserProfile.employeeProfile;
  UserProfile get currentUser => _currentUser;
  UserRole get currentRole => _currentUser.role;

  // --- Centralized RBAC Helpers ---
  bool canAccess(AppFeature feature) => RbacService.canAccess(currentRole, feature);
  bool hasPermission(AppFeature feature, AppAction action) => RbacService.hasPermission(currentRole, feature, action);

  void switchRole(UserRole role) {
    login(role);
  }

  void login(UserRole role, {String? customId}) {
    switch (role) {
      case UserRole.employee:
        _currentUser = UserProfile.employeeProfile;
        break;
      case UserRole.manager:
        _currentUser = UserProfile.managerProfile;
        break;
      case UserRole.warehouse:
        _currentUser = UserProfile.warehouseProfile;
        break;
    }
    _isAuthenticated = true;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _currentTabIndex = 0;
    notifyListeners();
  }

  // Navigation State
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // --- LEADS ---
  LeadStage _leadStageFilter = LeadStage.all;
  LeadStage get leadStageFilter => _leadStageFilter;

  String _leadSearchQuery = '';
  String get leadSearchQuery => _leadSearchQuery;

  final List<LeadModel> _leads = [
    LeadModel(
      id: 'LD-2026-001',
      initials: 'AT',
      companyName: 'Acme Technologies',
      contactPerson: 'Rajesh Sharma',
      designation: 'VP - Network Infrastructure',
      phone: '+91 98765 43210',
      email: 'rajesh.s@acmetech.in',
      industry: 'Telecom / ISP',
      city: 'Noida',
      state: 'Uttar Pradesh',
      address: 'Plot 42, Sector 62, Electronic City, Noida 201309',
      gstNumber: '07AAAAA0000A1Z5',
      stage: LeadStage.proposal,
      estimatedValue: 450000,
      source: 'Field Visit',
      salesRep: 'John Doe (EMP104)',
      asm: 'Priya Mehta',
      notes: 'Fiber backbone upgrade for the new enterprise office campus.',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      activeQuotationId: 'QT-2026-0001',
    ),
    LeadModel(
      id: 'LD-2026-002',
      initials: 'BI',
      companyName: 'Bharat Infotech Solutions',
      contactPerson: 'Amit Patel',
      designation: 'Director of Procurement',
      phone: '+91 98220 11223',
      email: 'amit.p@bharatinfotech.com',
      industry: 'System Integrator',
      city: 'Ahmedabad',
      state: 'Gujarat',
      address: 'B-804, Titanium City Center, Prahlad Nagar, Ahmedabad',
      gstNumber: '24BBBBB1111B2Z8',
      stage: LeadStage.negotiation,
      estimatedValue: 1200000,
      source: 'Referral',
      salesRep: 'John Doe (EMP104)',
      asm: 'Priya Mehta',
      notes: 'Smart city networking hardware tender requirement.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      activeQuotationId: 'QT-2026-0002',
    ),
    LeadModel(
      id: 'LD-2026-003',
      initials: 'CC',
      companyName: 'Cloud Connect Networks',
      contactPerson: 'Sneha Roy',
      designation: 'Technical Lead',
      phone: '+91 97110 55443',
      email: 'sneha@cloudconnect.net',
      industry: 'Telecom / ISP',
      city: 'Mumbai',
      state: 'Maharashtra',
      address: 'BKC Bandra East, Mumbai 400051',
      gstNumber: '27CCCCC2222C3Z1',
      stage: LeadStage.qualified,
      estimatedValue: 320000,
      source: 'Website',
      salesRep: 'Neha Patel (EMP105)',
      asm: 'Priya Mehta',
      notes: 'Underground single-mode 48F cable deployment.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    LeadModel(
      id: 'LD-2026-004',
      initials: 'DS',
      companyName: 'Delta Systems',
      contactPerson: 'Kunal Mehta',
      designation: 'Project Director',
      phone: '+91 90000 00104',
      email: 'kunal@delta.example',
      industry: 'Government Contractor',
      city: 'Vadodara',
      state: 'Gujarat',
      address: 'Alkapuri, Vadodara, Gujarat',
      gstNumber: '24DDDDD0000D1Z5',
      stage: LeadStage.closedWon,
      estimatedValue: 420000,
      source: 'Exhibition',
      salesRep: 'Neha Patel (EMP105)',
      asm: 'Priya Mehta',
      notes: 'Government campus networking project.',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    LeadModel(
      id: 'LD-2026-005',
      initials: 'EC',
      companyName: 'Eastern Cables',
      contactPerson: 'Samir Shah',
      designation: 'Procurement Head',
      phone: '+91 90000 00105',
      email: 'samir@eastern.example',
      industry: 'Distributor',
      city: 'Mumbai',
      state: 'Maharashtra',
      address: 'Andheri East, Mumbai, Maharashtra',
      gstNumber: '27EEEEE0000E1Z5',
      stage: LeadStage.newLead,
      estimatedValue: 250000,
      source: 'Website',
      salesRep: 'Unassigned',
      asm: 'Priya Mehta',
      notes: 'Inbound distributor inquiry. Needs assignment.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<LeadModel> get leads {
    if (_currentUser.role == UserRole.manager) {
      return List.unmodifiable(_leads);
    }
    return List.unmodifiable(_leads.where((l) => l.salesRep.contains('John Doe') || l.salesRep.contains('EMP104')));
  }

  List<LeadModel> get filteredLeads {
    return leads.where((lead) {
      final matchesStage = _leadStageFilter == LeadStage.all || lead.stage == _leadStageFilter;
      final q = _leadSearchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          lead.companyName.toLowerCase().contains(q) ||
          lead.contactPerson.toLowerCase().contains(q) ||
          lead.city.toLowerCase().contains(q) ||
          lead.industry.toLowerCase().contains(q);
      return matchesStage && matchesQuery;
    }).toList();
  }

  void setLeadStageFilter(LeadStage stage) {
    _leadStageFilter = stage;
    notifyListeners();
  }

  void setLeadSearchQuery(String query) {
    _leadSearchQuery = query;
    notifyListeners();
  }

  void addLead(LeadModel lead) {
    _leads.insert(0, lead);
    notifyListeners();
  }

  void updateLeadStage(String id, LeadStage newStage) {
    final idx = _leads.indexWhere((l) => l.id == id);
    if (idx != -1) {
      _leads[idx] = _leads[idx].copyWith(stage: newStage);
      notifyListeners();
    }
  }

  // --- VISITS ---
  Timer? _visitTimer;
  int _activeDurationSeconds = 720;
  int get activeDurationSeconds => _activeDurationSeconds;

  final List<VisitModel> _visits = [
    VisitModel(
      id: 'VIS-2026-0001',
      leadId: 'LD-2026-001',
      companyName: 'Acme Technologies',
      contactPerson: 'Rajesh Sharma',
      purpose: 'Technical Discussion',
      isGpsVerified: true,
      locationAddress: 'Sector 62, Electronic City, Noida',
      latitude: 28.6280,
      longitude: 77.3649,
      checkInTime: DateTime.now().subtract(const Duration(hours: 4)),
      checkOutTime: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
      durationSeconds: 1800,
      status: VisitStatus.completed,
      outcome: 'Quotation Requested',
      discussionNotes: 'Reviewed optical fiber specs; client requested quotation for 24-core cable and accessories.',
      nextFollowUp: DateTime.now().add(const Duration(days: 2)),
    ),
    VisitModel(
      id: 'VIS-2026-0002',
      leadId: 'LD-2026-002',
      companyName: 'Bharat Infotech Solutions',
      contactPerson: 'Amit Patel',
      purpose: 'Commercial Discussion',
      isGpsVerified: true,
      locationAddress: 'Titanium City Center, Prahlad Nagar, Ahmedabad',
      latitude: 23.0120,
      longitude: 72.5080,
      checkInTime: DateTime.now().subtract(const Duration(minutes: 12)),
      durationSeconds: 720,
      status: VisitStatus.completed,
    ),
  ];

  List<VisitModel> get visits => List.unmodifiable(_visits);

  VisitModel? get activeVisit {
    final active = _visits.where((v) => v.status == VisitStatus.active);
    return active.isNotEmpty ? active.first : null;
  }

  void updateVisit(VisitModel updated) {
    final idx = _visits.indexWhere((v) => v.id == updated.id);
    if (idx != -1) {
      _visits[idx] = updated;
      notifyListeners();
    }
  }

  AEConnectProvider() {
    _startVisitTimer();
  }

  void _startVisitTimer() {
    _visitTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final hasActive = _visits.any((v) => v.status == VisitStatus.active);
      if (hasActive) {
        _activeDurationSeconds++;
        notifyListeners();
      }
    });
  }

  void checkInVisit(VisitModel newVisit) {
    _visits.insert(0, newVisit);
    _activeDurationSeconds = 0;
    notifyListeners();
  }

  void checkOutVisit(String id, String outcome, String notes, DateTime? nextFollowUp) {
    final idx = _visits.indexWhere((v) => v.id == id);
    if (idx != -1) {
      _visits[idx] = _visits[idx].copyWith(
        status: VisitStatus.completed,
        checkOutTime: DateTime.now(),
        outcome: outcome,
        discussionNotes: notes,
        nextFollowUp: nextFollowUp,
      );
      notifyListeners();
    }
  }

  // --- TASKS & FOLLOW-UPS ---
  final List<TaskModel> _tasks = [
    TaskModel(
      id: 't1',
      title: 'Call Acme about the fiber proposal',
      accountName: 'Acme Technologies',
      leadId: 'LD-2026-001',
      dueDate: DateTime.now(),
      time: '11:00',
      taskType: 'Call',
      assignedTo: 'John Doe',
      priority: TaskPriority.high,
      isCompleted: true,
      notes: 'Confirm phase-one quantities.',
    ),
    TaskModel(
      id: 't2',
      title: 'Schedule Bright Infra site visit',
      accountName: 'Bright Infra Solutions',
      leadId: 'LD-2026-002',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      time: '14:30',
      taskType: 'Visit',
      assignedTo: 'John Doe',
      priority: TaskPriority.medium,
      isCompleted: true,
      notes: 'Coordinate with the procurement team.',
    ),
  ];

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx] = _tasks[idx].copyWith(isCompleted: !_tasks[idx].isCompleted);
      notifyListeners();
    }
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // --- QUOTATIONS ---
  final List<QuotationModel> _quotations = [
    QuotationModel(
      id: 'QT-2026-0001',
      proposalNumber: 'AEIPL/001/2627',
      customerName: 'Acme Technologies',
      leadId: 'LD-2026-001',
      issueDate: DateTime.now().subtract(const Duration(days: 2)),
      validityDate: DateTime.now().add(const Duration(days: 28)),
      status: QuotationStatus.underReview,
      items: const [
        QuotationItem(
          sku: 'AEC-FOC-24C-SM',
          name: '24-Core Single Mode Armored Fiber Optic Cable (1000m)',
          category: 'Fiber Cable',
          unitRate: 34500,
          quantity: 1,
          discountPercent: 5.0,
        ),
        QuotationItem(
          sku: 'AEC-PC-LC-SC-3M',
          name: 'Optical Patch Cord LC-SC Duplex 3M',
          category: 'Accessories',
          unitRate: 450,
          quantity: 20,
          discountPercent: 10.0,
        ),
        QuotationItem(
          sku: 'AEC-SFP-10G-LR',
          name: '10G SFP+ Optical Transceiver 1310nm 10km',
          category: 'Networking',
          unitRate: 2800,
          quantity: 4,
          discountPercent: 0.0,
        ),
      ],
      freightFee: 2500,
      gstRate: 0.18,
      paymentTerms: '100% Advance against PI',
      warrantyTerms: '1 Year Standard Manufacturer Warranty',
      approvalNote: 'Waiting for Area Sales Manager (Priya Mehta) commercial approval.',
    ),
    QuotationModel(
      id: 'QT-2026-0002',
      proposalNumber: 'AEIPL/002/2627',
      customerName: 'Bharat Infotech Solutions',
      leadId: 'LD-2026-002',
      issueDate: DateTime.now().subtract(const Duration(days: 5)),
      validityDate: DateTime.now().add(const Duration(days: 25)),
      status: QuotationStatus.approved,
      items: const [
        QuotationItem(
          sku: 'AEC-FOC-48C-SM',
          name: '48-Core Outdoor Single Mode Fiber Optic Drum',
          category: 'Fiber Cable',
          unitRate: 68000,
          quantity: 5,
          discountPercent: 8.0,
        ),
        QuotationItem(
          sku: 'AEC-ODF-48P',
          name: '48-Port Rack Mount Optical Distribution Frame',
          category: 'Accessories',
          unitRate: 4200,
          quantity: 5,
          discountPercent: 5.0,
        ),
      ],
      freightFee: 7500,
      gstRate: 0.18,
      approvalNote: 'Approved by ASM Priya Mehta.',
    ),
    QuotationModel(
      id: 'QT-2026-0003',
      proposalNumber: 'AEIPL/003/2627',
      customerName: 'Cloud Connect Networks',
      leadId: 'LD-2026-003',
      issueDate: DateTime.now().subtract(const Duration(days: 1)),
      validityDate: DateTime.now().add(const Duration(days: 29)),
      status: QuotationStatus.draft,
      items: const [
        QuotationItem(
          sku: 'AEC-PLC-1X8-SC',
          name: 'PLC Optical Splitter 1x8 SC/APC',
          category: 'Fiber Accessories',
          unitRate: 1450,
          quantity: 10,
          discountPercent: 0.0,
        ),
      ],
      freightFee: 1200,
      gstRate: 0.18,
    ),
  ];

  List<QuotationModel> get quotations => List.unmodifiable(_quotations);

  void addQuotation(QuotationModel quote) {
    _quotations.insert(0, quote);
    notifyListeners();
  }

  void approveQuotation(String id, String note) {
    final idx = _quotations.indexWhere((q) => q.id == id);
    if (idx != -1) {
      _quotations[idx] = _quotations[idx].copyWith(
        status: QuotationStatus.approved,
        approvalNote: 'Approved by ASM ${_currentUser.name}: $note',
      );
      notifyListeners();
    }
  }

  void sendBackQuotation(String id, String feedback) {
    final idx = _quotations.indexWhere((q) => q.id == id);
    if (idx != -1) {
      _quotations[idx] = _quotations[idx].copyWith(
        status: QuotationStatus.draft,
        approvalNote: 'Revision requested by ASM ${_currentUser.name}: $feedback',
      );
      notifyListeners();
    }
  }

  // --- ORDERS ---
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'ORD-2026-0001',
      customerName: 'Bright Infra Solutions',
      poNumber: 'DEMO-PO-2026-001',
      orderDate: DateTime(2026, 11, 20),
      dispatchDate: DateTime(2026, 12, 1),
      totalAmount: 616432,
      status: OrderStatus.awaitingStock,
      itemsCount: 8,
      trackingNumber: 'TRK-BLUEDART-882103',
    ),
    OrderModel(
      id: 'DEMO-SO-EMP104-2026-09-1',
      customerName: 'Demo · Horizon Broadband',
      poNumber: 'DEMO-PO-emp104-2026-09-1',
      orderDate: DateTime(2026, 8, 25),
      dispatchDate: DateTime(2026, 9, 1),
      totalAmount: 206500,
      status: OrderStatus.delivered,
      itemsCount: 12,
      trackingNumber: 'TRK-DEL-0901',
    ),
    OrderModel(
      id: 'DEMO-SO-EMP104-2026-09-2',
      customerName: 'Demo · Westlink Networks',
      poNumber: 'DEMO-PO-emp104-2026-09-2',
      orderDate: DateTime(2026, 8, 28),
      dispatchDate: DateTime(2026, 9, 1),
      totalAmount: 265500,
      status: OrderStatus.delivered,
      itemsCount: 16,
      trackingNumber: 'TRK-DEL-0902',
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  void updateOrderStatus(String id, OrderStatus newStatus) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      final old = _orders[idx];
      _orders[idx] = OrderModel(
        id: old.id,
        customerName: old.customerName,
        poNumber: old.poNumber,
        orderDate: old.orderDate,
        dispatchDate: old.dispatchDate,
        totalAmount: old.totalAmount,
        status: newStatus,
        itemsCount: old.itemsCount,
        trackingNumber: old.trackingNumber,
      );
      notifyListeners();
    }
  }

  // --- COLLECTIONS & METRICS ---
  final double totalPendingCollections = 2704518.70;
  final double overdueCollections = 2197165.90;
  final double receivedCollections = 1661953.30;
  double get recoveryPercentage => (receivedCollections / (totalPendingCollections + receivedCollections)) * 100;

  // --- MINUTES OF MEETING (MOM) ---
  final List<MomModel> _moms = [
    MomModel(
      id: 'MOM-2026-0001',
      title: 'Fiber backbone specification review',
      accountName: 'Acme Technologies',
      date: DateTime(2026, 11, 24, 10, 30),
      status: 'Submitted',
      attendees: const [
        'Rajesh Sharma (VP Infra, Acme)',
        'Vikram Joshi (Sr. Network Architect, Acme)',
        'John Doe (Sr. Sales Rep, AEIPL)',
        'Priya Mehta (Area Sales Manager, AEIPL)',
      ],
      agenda: 'Finalizing technical specifications and dispatch timeline for 24F cable rollout.',
      discussionSummary: 'Client agreed to test our 10G SFP modules on existing switches. Price quote QT-2026-0001 shared and currently under management sign-off.',
      actionItems: [
        MomActionItem(
          task: 'Share SFP compatibility testing report',
          assignee: 'John Doe',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          isDone: true,
        ),
        MomActionItem(
          task: 'Review PI and provide advance payment clearance',
          assignee: 'Rajesh Sharma',
          dueDate: DateTime.now().add(const Duration(days: 3)),
          isDone: false,
        ),
      ],
    ),
  ];

  List<MomModel> get moms => List.unmodifiable(_moms);

  // --- CUSTOMERS & CONTACTS ---
  final List<CustomerModel> _customers = [
    const CustomerModel(
      id: 'c1',
      name: 'Acme Technologies',
      leadId: 'l1',
      category: 'Telecom / ISP',
      city: 'Noida',
      state: 'Uttar Pradesh',
      gst: '09AAAAA0000A1Z5',
      address: 'Sector 62, Electronic City, Noida',
      accountOwner: 'John Doe',
      asmName: 'Priya Mehta',
      terms: '100% Advance',
      kycStatus: 'Verified',
      status: 'Active',
      outstandingAmount: 246572.80,
      creditLimit: 200000,
      keyContact: 'Rahul Sharma',
      phone: '+91 98765 43210',
      email: 'rahul.sharma@acme.example',
    ),
    const CustomerModel(
      id: 'c2',
      name: 'Bright Infra Solutions',
      leadId: 'l2',
      category: 'System Integrator',
      city: 'Ahmedabad',
      state: 'Gujarat',
      gst: '24BBBBB0000B1Z5',
      address: 'SG Highway, Ahmedabad',
      accountOwner: 'John Doe',
      asmName: 'Priya Mehta',
      terms: '100% Advance',
      kycStatus: 'Pending Review',
      status: 'Active',
      outstandingAmount: 79650,
      creditLimit: 0,
      keyContact: 'Amit Patel',
      phone: '+91 98220 11223',
      email: 'amit@brightinfra.example',
    ),
    const CustomerModel(
      id: 'c3',
      name: 'CityNet Communications',
      leadId: 'l3',
      category: 'Broadband / ISP',
      city: 'Surat',
      state: 'Gujarat',
      gst: '24CCCC0000C1Z5',
      address: 'Ring Road, Surat',
      accountOwner: 'John Doe',
      asmName: 'Priya Mehta',
      terms: '100% Advance',
      kycStatus: 'Pending Review',
      status: 'Active',
      outstandingAmount: 33984,
      creditLimit: 0,
      keyContact: 'Kiran Deshmukh',
      phone: '+91 94230 77881',
      email: 'kiran@citynet.example',
    ),
    const CustomerModel(
      id: 'c4',
      name: 'Grand Telecom Infra',
      leadId: 'l4',
      category: 'EPC Contractor',
      city: 'Vadodara',
      state: 'Gujarat',
      gst: '24DDDDD0000D1Z5',
      address: 'Alkapuri, Vadodara',
      accountOwner: 'John Doe',
      asmName: 'Priya Mehta',
      terms: '100% Advance',
      kycStatus: 'Pending Review',
      status: 'Active',
      outstandingAmount: 23895,
      creditLimit: 0,
      keyContact: 'Manoj Joshi',
      phone: '+91 98980 44556',
      email: 'manoj@grandtelecom.example',
    ),
  ];

  List<CustomerModel> get customers => List.unmodifiable(_customers);

  // --- CRM CONTACTS ---
  final List<Map<String, String>> _crmContacts = [
    {
      'id': 'ct1',
      'name': 'Rahul Sharma',
      'role': 'Procurement Head',
      'company': 'Acme Technologies',
      'leadId': 'LD-2026-001',
      'phone': '9000000101',
      'altPhone': '',
      'email': 'rahul@acme.example',
      'city': 'Noida',
      'state': 'Uttar Pradesh',
      'address': 'Sector 62, Noida',
      'notes': 'Primary decision-maker for passive networking.',
    },
    {
      'id': 'ct2',
      'name': 'Priya Patel',
      'role': 'Procurement Head',
      'company': 'Bright Infra Solutions',
      'leadId': 'LD-2026-002',
      'phone': '9000000102',
      'altPhone': '',
      'email': 'priya@bright.example',
      'city': 'Ahmedabad',
      'state': 'Gujarat',
      'address': 'SG Highway, Ahmedabad',
      'notes': 'Handles quarterly rate contracts.',
    },
    {
      'id': 'ct3',
      'name': 'Ankit Shah',
      'role': 'Procurement Head',
      'company': 'CityNet Communications',
      'leadId': '',
      'phone': '9000000103',
      'altPhone': '',
      'email': 'ankit@citynet.example',
      'city': 'Surat',
      'state': 'Gujarat',
      'address': 'Ring Road, Surat',
      'notes': '',
    },
    {
      'id': 'ct4',
      'name': 'Sample Buyer 1',
      'role': 'Procurement Manager',
      'company': 'Demo · Horizon Broadband',
      'leadId': '',
      'phone': '9000104010',
      'altPhone': '',
      'email': 'emp104.buyer0@example.com',
      'city': 'Pune',
      'state': 'Maharashtra',
      'address': '',
      'notes': '',
    },
  ];

  List<Map<String, String>> get crmContacts => List.unmodifiable(_crmContacts);

  void addCrmContact(Map<String, String> contact) {
    _crmContacts.insert(0, contact);
    notifyListeners();
  }

  void updateCrmContact(String id, Map<String, String> updated) {
    final idx = _crmContacts.indexWhere((c) => c['id'] == id);
    if (idx != -1) {
      _crmContacts[idx] = updated;
      notifyListeners();
    }
  }

  // --- NOTIFICATIONS ---
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n1',
      title: 'Invoice due soon',
      text: 'DEMO-INV-002 · ₹2,46,572.80 pending · due 29 Nov 2026',
      at: DateTime(2026, 11, 26, 9, 27),
      isRead: false,
      page: 'collections',
      recordId: 'DEMO-INV-002',
    ),
    NotificationModel(
      id: 'n2',
      title: 'Invoice overdue',
      text: 'DEMO-INV-EMP104-opening-31 · ₹79,650 pending · due 10 Oct 2026',
      at: DateTime(2026, 11, 24, 11, 8),
      isRead: true,
      page: 'collections',
      recordId: 'DEMO-INV-EMP104-opening-31',
    ),
    NotificationModel(
      id: 'n3',
      title: 'Invoice overdue',
      text: 'DEMO-INV-EMP104-opening-61 · ₹33,984 pending · due 3 Jul 2026',
      at: DateTime(2026, 11, 24, 11, 8),
      isRead: true,
      page: 'collections',
      recordId: 'DEMO-INV-EMP104-opening-61',
    ),
    NotificationModel(
      id: 'n4',
      title: 'Awaiting cheque clearance',
      text: 'DEMO-INV-EMP104-2026-11-5 · ₹23,895 · cheque DEMO-emp104-2026-11-5-cheque',
      at: DateTime(2026, 11, 24, 11, 8),
      isRead: true,
      page: 'collections',
      recordId: 'DEMO-INV-EMP104-2026-11-5',
    ),
  ];

  final List<NotificationModel> _warehouseNotifications = [
    NotificationModel(
      id: 'wn1',
      title: 'Order awaiting stock confirmation',
      text: 'Confirm stock availability for ORD-2026-0001 before packing.',
      at: DateTime(2026, 11, 24, 11, 8),
      isRead: false,
      page: 'orders',
      recordId: 'ORD-2026-0001',
    ),
  ];

  List<NotificationModel> get notifications =>
      currentRole == UserRole.warehouse
          ? List.unmodifiable(_warehouseNotifications)
          : List.unmodifiable(_notifications);

  int get unreadNotificationsCount =>
      currentRole == UserRole.warehouse
          ? _warehouseNotifications.where((n) => !n.isRead).length
          : _notifications.where((n) => !n.isRead).length;

  void markAllNotificationsRead() {
    if (currentRole == UserRole.warehouse) {
      for (int i = 0; i < _warehouseNotifications.length; i++) {
        _warehouseNotifications[i] = _warehouseNotifications[i].copyWith(isRead: true);
      }
    } else {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  void markNotificationRead(String id) {
    if (currentRole == UserRole.warehouse) {
      final idx = _warehouseNotifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _warehouseNotifications[idx] = _warehouseNotifications[idx].copyWith(isRead: true);
        notifyListeners();
      }
    } else {
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _notifications[idx] = _notifications[idx].copyWith(isRead: true);
        notifyListeners();
      }
    }
  }

  // --- EMPLOYEE SELF SERVICE (ESS) ---
  bool _isPunchedIn = false;
  bool get isPunchedIn => _isPunchedIn;

  DateTime? _punchInTime;
  DateTime? get punchInTime => _punchInTime;

  void toggleAttendancePunch() {
    _isPunchedIn = !_isPunchedIn;
    if (_isPunchedIn) {
      _punchInTime = DateTime.now();
    }
    notifyListeners();
  }

  final int casualLeaveRemaining = 4;
  final int sickLeaveRemaining = 6;
  final int earnedLeaveRemaining = 12;

  final List<Map<String, dynamic>> _expenses = [
    {
      'title': 'Client Dinner & Technical Meeting',
      'category': 'Food & Entertainment',
      'amount': 2450.0,
      'date': '24 Nov 2026',
      'status': 'Approved',
    },
    {
      'title': 'Fuel & Toll - Noida Industrial Area Visits',
      'category': 'Travel & Fuel',
      'amount': 1850.0,
      'date': '25 Nov 2026',
      'status': 'Submitted',
    },
  ];
  List<Map<String, dynamic>> get expenses => List.unmodifiable(_expenses);

  void addExpense(String title, String category, double amount) {
    _expenses.insert(0, {
      'title': title,
      'category': category,
      'amount': amount,
      'date': '26 Nov 2026',
      'status': 'Submitted',
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _visitTimer?.cancel();
    super.dispose();
  }
}
