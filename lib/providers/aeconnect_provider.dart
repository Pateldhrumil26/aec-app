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

class AEConnectProvider extends ChangeNotifier {
  // Authentication & Role State
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  UserProfile _currentUser = UserProfile.employeeProfile;
  UserProfile get currentUser => _currentUser;
  UserRole get currentRole => _currentUser.role;

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
      salesRep: 'John Doe (EMP104)',
      asm: 'Priya Mehta',
      notes: 'Underground single-mode 48F cable deployment.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<LeadModel> get leads => List.unmodifiable(_leads);

  List<LeadModel> get filteredLeads {
    return _leads.where((lead) {
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
      customerName: 'Acme Technologies',
      poNumber: 'PO-ACME-9912',
      orderDate: DateTime.now().subtract(const Duration(days: 4)),
      dispatchDate: DateTime.now().add(const Duration(days: 3)),
      totalAmount: 616432,
      status: OrderStatus.awaitingStock,
      itemsCount: 8,
      trackingNumber: 'TRK-BLUEDART-882103',
    ),
    OrderModel(
      id: 'ORD-2026-0002',
      customerName: 'Metro Rail Telecom Corp',
      poNumber: 'PO-MRT-2026-04',
      orderDate: DateTime.now().subtract(const Duration(days: 12)),
      dispatchDate: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: 1845000,
      status: OrderStatus.delivered,
      itemsCount: 24,
      trackingNumber: 'TRK-VRL-990142',
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
      title: 'Enterprise Campus Fiber Backbone Review',
      accountName: 'Acme Technologies',
      date: DateTime.now().subtract(const Duration(days: 4)),
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
      id: 'CUST-001',
      name: 'Acme Technologies',
      category: 'Telecom / ISP',
      city: 'Noida',
      state: 'Uttar Pradesh',
      outstandingAmount: 850000,
      creditLimit: 2500000,
      openQuotesCount: 1,
      activeOrdersCount: 1,
      keyContact: 'Rajesh Sharma',
      phone: '+91 98765 43210',
    ),
    const CustomerModel(
      id: 'CUST-002',
      name: 'Bharat Infotech Solutions',
      category: 'System Integrator',
      city: 'Ahmedabad',
      state: 'Gujarat',
      outstandingAmount: 420000,
      creditLimit: 1500000,
      openQuotesCount: 1,
      activeOrdersCount: 0,
      keyContact: 'Amit Patel',
      phone: '+91 98220 11223',
    ),
    const CustomerModel(
      id: 'CUST-003',
      name: 'CyberNet Fiber Systems',
      category: 'ISP / Contractor',
      city: 'Pune',
      state: 'Maharashtra',
      outstandingAmount: 1434518.70,
      creditLimit: 2000000,
      openQuotesCount: 0,
      activeOrdersCount: 0,
      keyContact: 'Kiran Deshmukh',
      phone: '+91 94230 77881',
    ),
  ];

  List<CustomerModel> get customers => List.unmodifiable(_customers);

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
