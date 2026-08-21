import 'package:flutter/material.dart';
import 'models.dart';

class DummyDataProvider extends ChangeNotifier {
  static final DummyDataProvider _instance = DummyDataProvider._internal();
  factory DummyDataProvider() => _instance;
  DummyDataProvider._internal();

  final List<ProjectModel> _projects = [
    ProjectModel(
      id: 'p1',
      projectName: 'Smart Campus Portal',
      projectDescription: 'Comprehensive academic and hostel administrative portal.',
      collegeName: 'IIT Madras',
      domain: 'Web Development',
      createdDate: '20 August 2026',
      assignedEmployee: 'Employee',
      status: ProjectStatus.phase1Review,
      assignedDate: DateTime(2026, 8, 20),
    ),
    ProjectModel(
      id: 'p2',
      projectName: 'AI Placement Predictor',
      projectDescription: 'Machine learning framework to analyze student career trends.',
      collegeName: 'NIT Trichy',
      domain: 'Artificial Intelligence',
      createdDate: '18 August 2026',
      assignedEmployee: 'Employee',
      status: ProjectStatus.inProgress,
      assignedDate: DateTime(2026, 8, 18),
    ),
    ProjectModel(
      id: 'p3',
      projectName: 'IoT Lab Monitor',
      projectDescription: 'Real-time telemetry and equipment monitoring application.',
      collegeName: 'Anna University',
      domain: 'Internet of Things',
      createdDate: '15 August 2026',
      assignedEmployee: 'Michael Chen',
      status: ProjectStatus.inProgress,
      assignedDate: DateTime(2026, 8, 15),
    ),
    ProjectModel(
      id: 'p4',
      projectName: 'E-Library Mobile App',
      projectDescription: 'Digital book reader and journal catalog for students.',
      collegeName: 'BITS Pilani',
      domain: 'Mobile App',
      createdDate: '10 August 2026',
      assignedEmployee: 'Alex Rivera',
      status: ProjectStatus.completed,
      assignedDate: DateTime(2026, 8, 10),
    ),
  ];

  final List<AdminUserModel> _adminUsers = [
    AdminUserModel(
      id: 'sa1',
      name: 'Super Admin',
      email: 'superadmin@kevorch.com',
      role: 'SUPER ADMIN',
      accessScope: 'Full System & Operations Access',
      createdDate: '01 January 2026',
      isActive: true,
    ),
    AdminUserModel(
      id: 'a1',
      name: 'KEVOCH System Admin',
      email: 'admin@kevorch.com',
      role: 'ADMIN',
      accessScope: 'Project, Task & Employee Control',
      createdDate: '15 June 2026',
      isActive: true,
    ),
    AdminUserModel(
      id: 'a2',
      name: 'DevOps & Infrastructure Lead',
      email: 'devops@kevorch.com',
      role: 'ADMIN',
      accessScope: 'Monitoring & System Metrics',
      createdDate: '10 July 2026',
      isActive: true,
    ),
  ];

  // ── Student Submissions in-memory store ─────────────────────────────────────
  final List<StudentSubmissionModel> _studentSubmissions = [
    StudentSubmissionModel(
      id: 'sub1',
      projectId: 'p1',
      employeeId: 'e_demo',
      studentName: 'Aishwarya R',
      registerNumber: '2026CSE001',
      department: 'Computer Science',
      college: 'IIT Madras',
      email: 'aishwarya@iitm.ac.in',
      phone: '9876543210',
      notes: 'Excellent candidate, project milestone completed.',
      documentName: 'report.pdf',
      documentPath: '/simulated/documents/report.pdf',
      documentType: 'PDF',
      documentSize: '1.2 MB',
      status: 'SUBMITTED',
      createdAt: DateTime(2026, 8, 20, 14, 0),
      submittedAt: DateTime(2026, 8, 20, 16, 30),
    ),
    StudentSubmissionModel(
      id: 'sub2',
      projectId: 'p1',
      employeeId: 'e_demo',
      studentName: 'Bharat S',
      registerNumber: '2026CSE005',
      department: 'Information Technology',
      college: 'IIT Madras',
      email: 'bharat@iitm.ac.in',
      phone: '8765432109',
      notes: 'Drafting initial proposal.',
      documentName: 'proposal.docx',
      documentPath: '/simulated/documents/proposal.docx',
      documentType: 'DOCX',
      documentSize: '640 KB',
      status: 'DRAFT',
      createdAt: DateTime(2026, 8, 21, 10, 15),
    ),
  ];

  // ── Employee TO DO in-memory store ──────────────────────────────────────────
  final List<EmployeeTodoModel> _todos = [
    // Seed: 2 PENDING, 1 SUBMITTED for p1 / e1 (Sarah Jenkins)
    EmployeeTodoModel(
      id: 'td1',
      projectId: 'p1',
      employeeId: 'e1',
      studentName: 'Kavitha R',
      title: 'Collect Requirements',
      description: 'Gather detailed functional requirements from the college coordinator for the Smart Campus Portal.',
      note: 'Schedule a meeting with Kavitha before Aug 24.',
      status: 'PENDING',
      createdAt: DateTime(2026, 8, 20, 10, 30),
    ),
    EmployeeTodoModel(
      id: 'td2',
      projectId: 'p1',
      employeeId: 'e1',
      studentName: 'Kavitha R',
      title: 'Prepare Phase 1 Document',
      description: 'Create the initial project scope and SRS document based on the collected requirements.',
      status: 'SUBMITTED',
      createdAt: DateTime(2026, 8, 18, 9, 0),
      submittedAt: DateTime(2026, 8, 19, 16, 10),
    ),
    EmployeeTodoModel(
      id: 'td3',
      projectId: 'p1',
      employeeId: 'e1',
      studentName: 'Siddharth M',
      title: 'Database Schema Review',
      description: 'Review and validate the student enrollment database schema with the backend team.',
      status: 'PENDING',
      createdAt: DateTime(2026, 8, 21, 11, 15),
    ),
  ];

  final List<EmployeeModel> _employees = [
    EmployeeModel(
      id: 'e_demo',
      employeeName: 'Employee',
      email: 'employee@kevorch.com',
      role: 'Employee',
      currentProject: 'Smart Campus Portal',
      currentTask: 'Frontend Component Development',
      priority: 'High',
      deadline: 'Aug 30, 2026',
      status: 'In Progress',
      studentId: 'STU-100',
      studentName: 'Employee User',
      college: 'IIT Madras',
      domain: 'Web Development',
      projectTitle: 'Smart Campus Portal',
    ),
    EmployeeModel(
      id: 'e1',
      employeeName: 'Sarah Jenkins',
      email: 'sarah.j@admintech.com',
      role: 'Lead Full Stack Dev',
      currentProject: 'Smart Campus Portal',
      currentTask: 'IoT Telemetry Protocol Test',
      priority: 'High',
      deadline: 'Aug 28, 2026',
      status: 'In Progress',
      studentId: 'STU-101',
      studentName: 'Kavitha R',
      college: 'IIT Madras',
      domain: 'Web Development',
      projectTitle: 'Smart Campus Portal',
    ),
    EmployeeModel(
      id: 'e2',
      employeeName: 'Alex Rivera',
      email: 'alex.r@admintech.com',
      role: 'UI/UX Specialist',
      currentProject: 'E-Library Mobile App',
      currentTask: 'Dashboard UI Wireframes',
      priority: 'Medium',
      deadline: 'Aug 24, 2026',
      status: 'Submitted',
      studentId: 'STU-102',
      studentName: 'Rohan Verma',
      college: 'BITS Pilani',
      domain: 'UI/UX Design',
      projectTitle: 'E-Library Mobile App',
    ),
    EmployeeModel(
      id: 'e6',
      employeeName: 'Arun Kumar',
      email: 'arun.k@admintech.com',
      role: 'AI / ML Engineer',
      currentProject: 'Student Mobile Portal',
      currentTask: 'Model Optimization',
      priority: 'High',
      deadline: 'Aug 29, 2026',
      status: 'In Progress',
      studentId: 'STU-106',
      studentName: 'Meera S',
      college: 'IIT Madras',
      domain: 'AIML',
      projectTitle: 'Student Mobile Portal',
    ),
    EmployeeModel(
      id: 'e7',
      employeeName: 'Ravi Kumar',
      email: 'ravi.k@admintech.com',
      role: 'ML Developer',
      currentProject: 'Campus Vision AI',
      currentTask: 'Dataset Annotation',
      priority: 'Medium',
      deadline: 'Sep 05, 2026',
      status: 'In Progress',
      studentId: 'STU-107',
      studentName: 'Sanjay P',
      college: 'Anna University',
      domain: 'AIML',
      projectTitle: 'Campus Vision AI',
    ),
    EmployeeModel(
      id: 'e3',
      employeeName: 'Michael Chen',
      email: 'm.chen@admintech.com',
      role: 'Backend Systems Architect',
      currentProject: 'Smart Campus Portal',
      currentTask: 'Database Schema Design',
      priority: 'High',
      deadline: 'Sep 02, 2026',
      status: 'Pending',
      studentId: 'STU-103',
      studentName: 'Siddharth M',
      college: 'NIT Trichy',
      domain: 'AIML',
      projectTitle: 'AI Placement Predictor',
    ),
    EmployeeModel(
      id: 'e4',
      employeeName: 'Priya Sharma',
      email: 'priya.s@admintech.com',
      role: 'Mobile Engineer',
      currentProject: 'E-Library Mobile App',
      currentTask: 'OAuth Auth Module Implementation',
      priority: 'Low',
      deadline: 'Aug 20, 2026',
      status: 'Completed',
      studentId: 'STU-104',
      studentName: 'Ananya P',
      college: 'Anna University',
      domain: 'Mobile App',
      projectTitle: 'E-Library Mobile App',
    ),
    EmployeeModel(
      id: 'e5',
      employeeName: 'David Vance',
      email: 'david.v@admintech.com',
      role: 'QA & Compliance Lead',
      currentProject: 'IoT Lab Monitor',
      currentTask: 'Telemetry Protocol Test',
      priority: 'Medium',
      deadline: 'Aug 30, 2026',
      status: 'In Progress',
      studentId: 'STU-105',
      studentName: 'Vikram S',
      college: 'Anna University',
      domain: 'Internet of Things',
      projectTitle: 'IoT Lab Monitor',
    ),
  ];

  final List<TaskModel> _tasks = [
    TaskModel(
      id: 't_demo1',
      taskTitle: 'Frontend UI Components',
      taskDescription: 'Implement dynamic widgets and interactive forms for Smart Campus Portal.',
      projectType: 'Smart Campus Portal',
      taskType: 'Frontend Architecture',
      assignedEmployee: 'Employee',
      createdDate: '20 August 2026',
      dueDate: 'Aug 29, 2026',
      status: 'TO DO',
    ),
    TaskModel(
      id: 't_demo2',
      taskTitle: 'AI Placement Dataset Cleanup',
      taskDescription: 'Normalize student placement data and handle missing value imputations.',
      projectType: 'AI Placement Predictor',
      taskType: 'Data Engineering',
      assignedEmployee: 'Employee',
      createdDate: '19 August 2026',
      dueDate: 'Sep 01, 2026',
      status: 'IN PROGRESS',
      workUpdateNote: 'Normalized salary fields and completed missing value imputation.',
    ),
    TaskModel(
      id: 't_demo3',
      taskTitle: 'Student Registration Flow',
      taskDescription: 'Build student onboarding multi-step wizard UI with real-time validation.',
      projectType: 'Smart Campus Portal',
      taskType: 'UI Engineering',
      assignedEmployee: 'Employee',
      createdDate: '18 August 2026',
      dueDate: 'Sep 04, 2026',
      status: 'REWORK',
      workUpdateNote: 'Admin requested mobile layout adjustment on Step 2.',
    ),
    TaskModel(
      id: 't1',
      taskTitle: 'Database Schema Design',
      taskDescription: 'Define core tables for student enrollment and grades.',
      projectType: 'Smart Campus Portal',
      taskType: 'Backend Architecture',
      assignedEmployee: 'Michael Chen',
      createdDate: '15 August 2026',
      dueDate: 'Aug 25, 2026',
      status: 'TO DO',
    ),
    TaskModel(
      id: 't2',
      taskTitle: 'Dashboard UI Wireframes',
      taskDescription: 'Create minimalist high-fidelity prototypes in Figma.',
      projectType: 'E-Library Mobile App',
      taskType: 'UI/UX Design',
      assignedEmployee: 'Alex Rivera',
      createdDate: '16 August 2026',
      dueDate: 'Aug 22, 2026',
      status: 'TO DO',
    ),
  ];

  final List<NotificationItemModel> _notifications = [
    // Fixed Demo Employee notifications (targetEmployeeId = 'e_demo')
    NotificationItemModel(
      id: 'n_demo1',
      type: 'task_assigned',
      employeeName: 'Employee',
      taskName: 'Frontend UI Components',
      title: 'New Task Assigned',
      message: 'You have been assigned to Frontend UI Components',
      subTitle: 'Smart Campus Portal',
      timestamp: '5 min ago',
      eventDateTime: '21 Aug 2026 • 10:25 AM',
      isRead: false,
      icon: Icons.assignment_rounded,
      relatedTaskId: 't_demo1',
      relatedEmployeeId: 'e_demo',
      relatedProjectId: 'p1',
      targetEmployeeId: 'e_demo',
    ),
    NotificationItemModel(
      id: 'n_demo2',
      type: 'project_assigned',
      employeeName: 'Employee',
      taskName: 'Smart Campus Portal',
      title: 'Project Assigned',
      message: 'You have been assigned to project Smart Campus Portal',
      subTitle: 'IIT Madras',
      timestamp: '30 min ago',
      eventDateTime: '21 Aug 2026 • 10:00 AM',
      isRead: false,
      icon: Icons.folder_shared_rounded,
      relatedProjectId: 'p1',
      relatedEmployeeId: 'e_demo',
      targetEmployeeId: 'e_demo',
    ),
    NotificationItemModel(
      id: 'n_demo3',
      type: 'task_status_updated',
      employeeName: 'Employee',
      taskName: 'Student Registration Flow',
      title: 'Rework Requested by Admin',
      message: 'Please update mobile layout on Step 2 of registration flow.',
      subTitle: 'Smart Campus Portal',
      timestamp: '1 hour ago',
      eventDateTime: '21 Aug 2026 • 09:30 AM',
      isRead: true,
      icon: Icons.build_circle_outlined,
      relatedTaskId: 't_demo3',
      relatedEmployeeId: 'e_demo',
      relatedProjectId: 'p1',
      targetEmployeeId: 'e_demo',
    ),
    NotificationItemModel(
      id: 'n_emp1',
      type: 'task_assigned',
      employeeName: 'Sarah Jenkins',
      taskName: 'IoT Telemetry Protocol Test',
      title: 'New Task Assigned',
      message: 'You have been assigned to IoT Telemetry Protocol Test',
      subTitle: 'IoT Lab Monitor',
      timestamp: '10 min ago',
      eventDateTime: '21 Aug 2026 • 10:10 AM',
      isRead: false,
      icon: Icons.assignment_rounded,
      relatedTaskId: 't3',
      relatedEmployeeId: 'e1',
      relatedProjectId: 'p3',
      targetEmployeeId: 'e1',
    ),
    NotificationItemModel(
      id: 'n_emp2',
      type: 'project_assigned',
      employeeName: 'Sarah Jenkins',
      taskName: 'AI Placement Predictor',
      title: 'Project Lead Assigned',
      message: 'You have been assigned as lead for AI Placement Predictor',
      subTitle: 'NIT Trichy',
      timestamp: '1 hour ago',
      eventDateTime: '21 Aug 2026 • 09:15 AM',
      isRead: false,
      icon: Icons.folder_shared_rounded,
      relatedProjectId: 'p2',
      relatedEmployeeId: 'e1',
      targetEmployeeId: 'e1',
    ),
    NotificationItemModel(
      id: 'n_emp3',
      type: 'task_status_updated',
      employeeName: 'Sarah Jenkins',
      taskName: 'AI Placement Model Training',
      title: 'Action Required: Rework Requested',
      message: 'Admin requested rework: Please refine model validation split.',
      subTitle: 'AI Placement Predictor',
      timestamp: '2 hours ago',
      eventDateTime: '21 Aug 2026 • 08:30 AM',
      isRead: true,
      icon: Icons.build_circle_outlined,
      relatedTaskId: 't5',
      relatedEmployeeId: 'e1',
      relatedProjectId: 'p2',
      targetEmployeeId: 'e1',
    ),
    // Admin Notifications (targetEmployeeId = null)
    NotificationItemModel(
      id: 'n1',
      type: 'task_submitted',
      employeeName: 'Alex Rivera',
      taskName: 'Dashboard UI Wireframes',
      title: 'Task Submitted',
      message: 'Alex Rivera submitted Dashboard UI Wireframes',
      subTitle: 'E-Library Mobile App',
      timestamp: '5 min ago',
      eventDateTime: '21 Aug 2026 • 10:18 AM',
      isRead: false,
      icon: Icons.unarchive_rounded,
      relatedTaskId: 't2',
      relatedEmployeeId: 'e2',
      relatedProjectId: 'p4',
      targetEmployeeId: null,
    ),
    NotificationItemModel(
      id: 'n2',
      type: 'task_assigned',
      employeeName: 'Michael Chen',
      taskName: 'Database Schema Design',
      title: 'Task Assigned',
      message: 'Database Schema Design was assigned to Michael Chen',
      subTitle: 'Smart Campus Portal',
      timestamp: '18 min ago',
      eventDateTime: '21 Aug 2026 • 10:05 AM',
      isRead: false,
      icon: Icons.assignment_ind_outlined,
      relatedTaskId: 't1',
      relatedEmployeeId: 'e3',
      relatedProjectId: 'p1',
      targetEmployeeId: null,
    ),
  ];

  List<ProjectModel> get projects => List.unmodifiable(_projects);
  List<EmployeeModel> get employees => List.unmodifiable(_employees);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<AdminUserModel> get adminUsers => List.unmodifiable(_adminUsers);
  List<NotificationItemModel> get notifications => List.unmodifiable(_notifications.where((n) => n.targetEmployeeId == null).toList());
  List<StudentSubmissionModel> get studentSubmissions => List.unmodifiable(_studentSubmissions);

  bool get hasUnreadNotifications => _notifications.any((n) => n.targetEmployeeId == null && !n.isRead);

  int get totalAdminUsers => _adminUsers.length;

  void addAdminUser(AdminUserModel admin) {
    _adminUsers.insert(0, admin);
    notifyListeners();
  }

  void toggleAdminStatus(String id) {
    final index = _adminUsers.indexWhere((a) => a.id == id);
    if (index != -1) {
      _adminUsers[index].isActive = !_adminUsers[index].isActive;
      notifyListeners();
    }
  }

  // Employee-specific queries & helpers
  EmployeeModel? getEmployeeByEmail(String email) {
    try {
      final query = email.trim().toLowerCase();
      return _employees.firstWhere((e) => e.email.trim().toLowerCase() == query);
    } catch (_) {
      return null;
    }
  }

  List<TaskModel> getTasksByEmployee(String employeeName) {
    return _tasks.where((t) => t.assignedEmployee.trim().toLowerCase() == employeeName.trim().toLowerCase()).toList();
  }

  List<ProjectModel> getProjectsByEmployee(String employeeName) {
    return _projects.where((p) => p.assignedEmployee != null && p.assignedEmployee!.trim().toLowerCase() == employeeName.trim().toLowerCase()).toList();
  }

  List<NotificationItemModel> getEmployeeNotifications(String employeeId) {
    return _notifications.where((n) => n.targetEmployeeId == employeeId).toList();
  }

  bool hasUnreadEmployeeNotifications(String employeeId) {
    return _notifications.any((n) => n.targetEmployeeId == employeeId && !n.isRead);
  }

  void markAllEmployeeNotificationsAsRead(String employeeId) {
    for (var n in _notifications) {
      if (n.targetEmployeeId == employeeId) {
        n.isRead = true;
      }
    }
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      if (n.targetEmployeeId == null) {
        n.isRead = true;
      }
    }
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void addNotification(NotificationItemModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void updateTaskStatus(String taskId, String newStatus, {String? workUpdateNote}) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final oldStatus = task.status;
      task.status = newStatus;
      if (workUpdateNote != null) {
        task.workUpdateNote = workUpdateNote;
      }

      final now = DateTime.now();
      final eventDt = '${now.day} ${_monthName(now.month)} ${now.year} • ${_formatTime(now)}';
      final emp = _employees.where((e) => e.employeeName.trim() == task.assignedEmployee.trim()).firstOrNull;
      final proj = _projects.where((p) => p.projectName == task.projectType).firstOrNull;

      // Notify Admin if employee submitted task for review
      if (newStatus == 'REVIEW') {
        _notifications.insert(0, NotificationItemModel(
          id: 'n_${now.millisecondsSinceEpoch}',
          type: 'task_submitted',
          employeeName: task.assignedEmployee,
          taskName: task.taskTitle,
          title: 'Task Submitted for Review',
          message: '${task.assignedEmployee} submitted "${task.taskTitle}" for review',
          subTitle: task.projectType,
          timestamp: 'Just now',
          eventDateTime: eventDt,
          previousStatus: oldStatus,
          newStatus: newStatus,
          isRead: false,
          icon: Icons.rate_review_rounded,
          relatedTaskId: task.id,
          relatedProjectId: proj?.id,
          relatedEmployeeId: emp?.id,
          targetEmployeeId: null, // Admin target
        ));
      }

      notifyListeners();
    }
  }

  void updateTaskWorkNote(String taskId, String note) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].workUpdateNote = note;
      notifyListeners();
    }
  }

  int get totalProjects => _projects.length;
  int get totalEmployees => _employees.length;
  int get totalTasks => _tasks.length;

  ProjectModel? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  EmployeeModel? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void addProject(ProjectModel project) {
    _projects.insert(0, project);
    final now = DateTime.now();
    final eventDt = '${now.day} ${_monthName(now.month)} ${now.year} • ${_formatTime(now)}';
    _notifications.insert(0, NotificationItemModel(
      id: 'n_${now.millisecondsSinceEpoch}',
      type: 'project_created',
      employeeName: 'Admin',
      taskName: project.projectName,
      title: 'Project Created',
      message: '${project.projectName} was created',
      subTitle: project.collegeName,
      timestamp: 'Just now',
      eventDateTime: eventDt,
      isRead: false,
      icon: Icons.create_new_folder_outlined,
      relatedProjectId: project.id,
      targetEmployeeId: null,
    ));
    notifyListeners();
  }

  void assignEmployeeToProject(String projectId, String employeeName) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      _projects[index].assignedEmployee = employeeName.trim();
      _projects[index].status = ProjectStatus.assigned;
      _projects[index].assignedDate = DateTime.now();
      
      final now = DateTime.now();
      final eventDt = '${now.day} ${_monthName(now.month)} ${now.year} • ${_formatTime(now)}';
      final emp = _employees.where((e) => e.employeeName.trim() == employeeName.trim()).firstOrNull;

      // Admin notification
      _notifications.insert(0, NotificationItemModel(
        id: 'n_admin_${now.millisecondsSinceEpoch}',
        type: 'task_assigned',
        employeeName: employeeName.trim(),
        taskName: _projects[index].projectName,
        title: 'Project Lead Assigned',
        message: '$employeeName assigned to ${_projects[index].projectName}',
        subTitle: _projects[index].projectName,
        timestamp: 'Just now',
        eventDateTime: eventDt,
        isRead: false,
        icon: Icons.person_add_alt_1_outlined,
        relatedProjectId: projectId,
        relatedEmployeeId: emp?.id,
        targetEmployeeId: null,
      ));

      // Employee-targeted notification
      if (emp != null) {
        _notifications.insert(0, NotificationItemModel(
          id: 'n_emp_${now.millisecondsSinceEpoch}',
          type: 'project_assigned',
          employeeName: employeeName.trim(),
          taskName: _projects[index].projectName,
          title: 'New Project Assigned',
          message: 'You have been assigned to project ${_projects[index].projectName}',
          subTitle: _projects[index].projectName,
          timestamp: 'Just now',
          eventDateTime: eventDt,
          isRead: false,
          icon: Icons.folder_shared_rounded,
          relatedProjectId: projectId,
          relatedEmployeeId: emp.id,
          targetEmployeeId: emp.id,
        ));
      }

      notifyListeners();
    }
  }

  void updateProjectStatus(String projectId, String newStatus) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final upperStatus = newStatus.toUpperCase();
      if (ProjectStatus.all.contains(upperStatus)) {
        _projects[index].status = upperStatus;
        notifyListeners();
      }
    }
  }

  void addEmployee(EmployeeModel employee) {
    _employees.insert(0, employee);
    final now = DateTime.now();
    final eventDt = '${now.day} ${_monthName(now.month)} ${now.year} • ${_formatTime(now)}';
    _notifications.insert(0, NotificationItemModel(
      id: 'n_${now.millisecondsSinceEpoch}',
      type: 'task_assigned',
      employeeName: employee.employeeName,
      taskName: 'N/A',
      title: 'New Employee Registered',
      message: '${employee.employeeName} (${employee.role}) joined the team',
      subTitle: employee.domain,
      timestamp: 'Just now',
      eventDateTime: eventDt,
      isRead: false,
      icon: Icons.person_outline_rounded,
      relatedEmployeeId: employee.id,
      targetEmployeeId: null,
    ));
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    final now = DateTime.now();
    final eventDt = '${now.day} ${_monthName(now.month)} ${now.year} • ${_formatTime(now)}';
    final proj = _projects.where((p) => p.projectName == task.projectType).firstOrNull;
    final emp = _employees.where((e) => e.employeeName.trim() == task.assignedEmployee.trim()).firstOrNull;

    // Admin notification
    _notifications.insert(0, NotificationItemModel(
      id: 'n_admin_${now.millisecondsSinceEpoch}',
      type: 'task_assigned',
      employeeName: task.assignedEmployee,
      taskName: task.taskTitle,
      title: 'Task Assigned',
      message: '${task.taskTitle} assigned to ${task.assignedEmployee}',
      subTitle: task.projectType,
      timestamp: 'Just now',
      eventDateTime: eventDt,
      isRead: false,
      icon: Icons.add_task_outlined,
      relatedTaskId: task.id,
      relatedProjectId: proj?.id,
      relatedEmployeeId: emp?.id,
      targetEmployeeId: null,
    ));

    // Employee notification
    if (emp != null) {
      _notifications.insert(0, NotificationItemModel(
        id: 'n_emp_${now.millisecondsSinceEpoch}',
        type: 'task_assigned',
        employeeName: task.assignedEmployee,
        taskName: task.taskTitle,
        title: 'New Task Assigned',
        message: 'You were assigned to "${task.taskTitle}"',
        subTitle: task.projectType,
        timestamp: 'Just now',
        eventDateTime: eventDt,
        isRead: false,
        icon: Icons.assignment_rounded,
        relatedTaskId: task.id,
        relatedProjectId: proj?.id,
        relatedEmployeeId: emp.id,
        targetEmployeeId: emp.id,
      ));
    }

    notifyListeners();
  }

  // ── Employee TO DO Methods ──────────────────────────────────────────────────

  List<EmployeeTodoModel> getTodosByProject(String projectId) =>
      _todos.where((t) => t.projectId == projectId).toList();

  List<EmployeeTodoModel> getTodosByEmployee(String employeeId) =>
      _todos.where((t) => t.employeeId == employeeId).toList();

  List<EmployeeTodoModel> getTodosByStudent(String studentId) =>
      _todos.where((t) => t.studentId == studentId).toList();

  List<EmployeeTodoModel> getSubmittedTodosByProject(String projectId) =>
      _todos
          .where((t) => t.projectId == projectId && t.status == 'SUBMITTED')
          .toList();

  void addEmployeeTodo(EmployeeTodoModel todo) {
    final project = getProjectById(todo.projectId);
    if (project?.status == ProjectStatus.completed) return;

    _todos.insert(0, todo);
    notifyListeners();
  }

  /// Update a PENDING TO DO — silently ignored if already SUBMITTED.
  void updateEmployeeTodo({
    required String id,
    required String title,
    required String description,
    String? studentName,
    String? note,
  }) {
    final matches = _todos.where((t) => t.id == id).toList();
    if (matches.isEmpty) return; // not found
    final todo = matches.first;
    if (todo.status != 'PENDING') return; // provider-level lock
    final project = getProjectById(todo.projectId);
    if (project?.status == ProjectStatus.completed) return;

    todo.title = title;
    todo.description = description;
    todo.studentName = studentName;
    todo.note = note;
    notifyListeners();
  }

  /// Submit a PENDING TO DO — auto-captures DateTime.now() as submittedAt.
  /// Silently ignored if TO DO is missing or already SUBMITTED.
  void submitEmployeeTodo(String id) {
    final matches = _todos.where((t) => t.id == id).toList();
    if (matches.isEmpty) return;
    final todo = matches.first;
    if (todo.status != 'PENDING') return; // provider-level guard
    final project = getProjectById(todo.projectId);
    if (project?.status == ProjectStatus.completed) return;

    todo.status = 'SUBMITTED';
    todo.submittedAt = DateTime.now();
    notifyListeners();
    evaluateProjectMilestones(todo.projectId);
  }

  // ── Student Submissions Methods ─────────────────────────────────────────────

  void addStudentSubmission(StudentSubmissionModel submission) {
    final project = getProjectById(submission.projectId);
    if (project?.status == ProjectStatus.completed) return;

    _studentSubmissions.insert(0, submission);
    notifyListeners();
    evaluateProjectMilestones(submission.projectId);
  }

  void updateStudentSubmission(StudentSubmissionModel submission) {
    final index = _studentSubmissions.indexWhere((s) => s.id == submission.id);
    if (index != -1) {
      final target = _studentSubmissions[index];
      if (target.status == 'SUBMITTED') return; // Strict lock
      final project = getProjectById(target.projectId);
      if (project?.status == ProjectStatus.completed) return;
      
      target.studentName = submission.studentName;
      target.registerNumber = submission.registerNumber;
      target.department = submission.department;
      target.college = submission.college;
      target.email = submission.email;
      target.phone = submission.phone;
      target.notes = submission.notes;
      target.documentName = submission.documentName;
      target.documentPath = submission.documentPath;
      target.documentType = submission.documentType;
      target.documentSize = submission.documentSize;
      target.isRequired = submission.isRequired;
      
      notifyListeners();
    }
  }

  void attachDocumentToSubmission(String id, String name, String path, String type, String size) {
    final index = _studentSubmissions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final target = _studentSubmissions[index];
      if (target.status == 'SUBMITTED') return; // Strict lock
      final project = getProjectById(target.projectId);
      if (project?.status == ProjectStatus.completed) return;
      
      target.documentName = name;
      target.documentPath = path;
      target.documentType = type;
      target.documentSize = size;
      
      notifyListeners();
    }
  }

  void removeDraftSubmissionDocument(String id) {
    final index = _studentSubmissions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final target = _studentSubmissions[index];
      if (target.status == 'SUBMITTED') return; // Strict lock
      final project = getProjectById(target.projectId);
      if (project?.status == ProjectStatus.completed) return;
      
      target.documentName = null;
      target.documentPath = null;
      target.documentType = null;
      target.documentSize = null;
      
      notifyListeners();
    }
  }

  void submitStudentSubmission(String id) {
    final index = _studentSubmissions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final sub = _studentSubmissions[index];
      if (sub.status == 'SUBMITTED') return; // Strict lock
      final project = getProjectById(sub.projectId);
      if (project?.status == ProjectStatus.completed) return;
      
      // Validation
      if (sub.studentName.trim().isEmpty ||
          sub.registerNumber.trim().isEmpty ||
          sub.department.trim().isEmpty ||
          sub.college.trim().isEmpty ||
          sub.documentName == null) {
        return;
      }
      
      sub.status = 'SUBMITTED';
      sub.submittedAt = DateTime.now();
      notifyListeners();
      evaluateProjectMilestones(sub.projectId);
    }
  }

  List<StudentSubmissionModel> getStudentSubmissionsByProject(String projectId) {
    return _studentSubmissions.where((s) => s.projectId == projectId).toList();
  }

  List<StudentSubmissionModel> getStudentSubmissionsByEmployee(String employeeId) {
    return _studentSubmissions.where((s) => s.employeeId == employeeId).toList();
  }

  List<StudentSubmissionModel> getSubmittedStudentSubmissionsByProject(String projectId) {
    return _studentSubmissions.where((s) => s.projectId == projectId && s.status == 'SUBMITTED').toList();
  }

  List<StudentSubmissionModel> getAllSubmittedStudentSubmissions() {
    return _studentSubmissions.where((s) => s.status == 'SUBMITTED').toList();
  }

  // ── Student Processes in-memory store ──────────────────────────────────────────
  final List<StudentProcessModel> _studentProcesses = [
    StudentProcessModel(
      id: 'sp1',
      projectId: 'p1',
      employeeId: 'e_demo',
      studentId: '2026CSE001',
      studentName: 'Aishwarya R',
      title: 'Initial Database Schema Design',
      description: 'Drafted the structure for core academic tables including tables for students, enrollment and course registration.',
      note: 'Need to refine indexes for query optimization.',
      status: 'SUBMITTED',
      isRequired: true,
      createdAt: DateTime(2026, 8, 20, 10, 0),
      submittedAt: DateTime(2026, 8, 20, 11, 30),
    ),
    StudentProcessModel(
      id: 'sp2',
      projectId: 'p1',
      employeeId: 'e_demo',
      studentId: '2026CSE001',
      studentName: 'Aishwarya R',
      title: 'Authentication Module Integration',
      description: 'Configuring custom router hooks for token-based employee login.',
      status: 'DRAFT',
      isRequired: true,
      createdAt: DateTime(2026, 8, 21, 9, 15),
    ),
  ];

  List<StudentProcessModel> get studentProcesses => List.unmodifiable(_studentProcesses);

  void addStudentProcess(StudentProcessModel process) {
    final project = getProjectById(process.projectId);
    if (project?.status == ProjectStatus.completed) return; // Project completed lock

    _studentProcesses.insert(0, process);
    notifyListeners();
    evaluateProjectMilestones(process.projectId);
  }

  void updateStudentProcess(StudentProcessModel process) {
    final index = _studentProcesses.indexWhere((p) => p.id == process.id);
    if (index != -1) {
      final p = _studentProcesses[index];
      if (p.status == 'SUBMITTED') return; // Immutable submission lock
      final project = getProjectById(p.projectId);
      if (project?.status == ProjectStatus.completed) return; // Project completed lock

      p.title = process.title;
      p.description = process.description;
      p.note = process.note;
      p.referenceDocumentName = process.referenceDocumentName;
      p.isRequired = process.isRequired;
      notifyListeners();
    }
  }

  void submitStudentProcess(String id) {
    final index = _studentProcesses.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _studentProcesses[index];
      if (p.status == 'SUBMITTED') return; // Immutable submission lock
      final project = getProjectById(p.projectId);
      if (project?.status == ProjectStatus.completed) return; // Project completed lock
      if (p.title.trim().isEmpty || p.description.trim().isEmpty) return;

      p.status = 'SUBMITTED';
      p.submittedAt = DateTime.now();
      notifyListeners();
      evaluateProjectMilestones(p.projectId);
    }
  }

  List<StudentProcessModel> getProcessesByProject(String projectId) {
    return _studentProcesses.where((p) => p.projectId == projectId).toList();
  }

  List<StudentProcessModel> getProcessesByStudent(String studentId) {
    return _studentProcesses.where((p) => p.studentId == studentId).toList();
  }

  List<StudentProcessModel> getProcessesByEmployee(String employeeId) {
    return _studentProcesses.where((p) => p.employeeId == employeeId).toList();
  }

  List<StudentProcessModel> getSubmittedProcessesByProject(String projectId) {
    return _studentProcesses.where((p) => p.projectId == projectId && p.status == 'SUBMITTED').toList();
  }

  List<StudentProcessModel> getAllSubmittedStudentProcesses() {
    return _studentProcesses.where((p) => p.status == 'SUBMITTED').toList();
  }

  // ── Central Timeline & Closure helper methods ───────────────────────────────

  String deriveProjectStatus(String timelineStage) {
    switch (timelineStage) {
      case 'Project Assigned':
      case 'Student Added':
        return ProjectStatus.assigned;
      case 'Initial Process':
      case 'Student Work':
        return ProjectStatus.inProgress;
      case 'Phase 1 Review':
        return ProjectStatus.phase1Review;
      case 'Rework':
        return ProjectStatus.rework;
      case 'Testing':
        return ProjectStatus.testing;
      case 'Project Closure':
        return ProjectStatus.closure;
      case 'Completed':
        return ProjectStatus.completed;
      default:
        return ProjectStatus.assigned;
    }
  }

  void setProjectTimelineStage(String projectId, String newStage) {
    final project = getProjectById(projectId);
    if (project == null) return;
    if (project.status == ProjectStatus.completed) return; // locked

    project.currentTimelineStage = newStage;
    project.status = deriveProjectStatus(newStage);
    if (newStage == 'Completed') {
      project.completedAt = DateTime.now();
    }
    notifyListeners();
  }

  void evaluateProjectMilestones(String projectId) {
    final project = getProjectById(projectId);
    if (project == null || project.status == ProjectStatus.completed) return;

    final currentStage = project.currentTimelineStage;
    final stages = [
      "Project Assigned",
      "Student Added",
      "Initial Process",
      "Student Work",
      "Phase 1 Review",
      "Rework",
      "Testing",
      "Project Closure",
      "Completed"
    ];

    int currentIndex = stages.indexOf(currentStage);
    if (currentIndex == -1) currentIndex = 0;

    int newIndex = currentIndex;

    // Condition 1: At least one student registry exists
    final submissions = getStudentSubmissionsByProject(projectId);
    if (submissions.isNotEmpty && newIndex < 1) {
      newIndex = 1; // Student Added
    }

    // Condition 2: At least one submitted process exists
    final submittedProcesses = getSubmittedProcessesByProject(projectId);
    if (submittedProcesses.isNotEmpty && newIndex < 2) {
      newIndex = 2; // Initial Process
    }

    // Condition 3: At least 2 submitted processes exist
    if (submittedProcesses.length >= 2 && newIndex < 3) {
      newIndex = 3; // Student Work
    }

    // Condition 4: At least 1 submitted student submission exists
    final submittedSubmissions = getSubmittedStudentSubmissionsByProject(projectId);
    if (submittedSubmissions.isNotEmpty && newIndex < 4) {
      newIndex = 4; // Phase 1 Review
    }

    // Auto-advance only if the index increased and is within the auto-advance range (<= 4, i.e. up to Phase 1 Review)
    if (newIndex > currentIndex && newIndex <= 4) {
      setProjectTimelineStage(projectId, stages[newIndex]);
    }
  }

  Map<String, dynamic> validateProjectClosure(String projectId) {
    final project = getProjectById(projectId);
    final List<String> incompleteItems = [];

    if (project == null) {
      return {
        'isValid': false,
        'incompleteItems': ['Project not found.']
      };
    }

    // 1. Required TO DOs: No required EmployeeTodoModel remains PENDING
    final projectTodos = _todos.where((t) => t.projectId == projectId).toList();
    for (var todo in projectTodos) {
      if (todo.isRequired && todo.status == 'PENDING') {
        incompleteItems.add('Required TO DO: "${todo.title}" is still pending.');
      }
    }

    // 2. Required Processes: No required StudentProcessModel remains DRAFT
    final projectProcesses = getProcessesByProject(projectId);
    for (var process in projectProcesses) {
      if (process.isRequired && process.status == 'DRAFT') {
        incompleteItems.add('Required Process: "${process.title}" is still a draft.');
      }
    }

    // 3. Required Student Submissions: No required StudentSubmissionModel remains DRAFT
    final projectSubmissions = getStudentSubmissionsByProject(projectId);
    for (var sub in projectSubmissions) {
      if (sub.isRequired && sub.status == 'DRAFT') {
        incompleteItems.add('Required Submission: Student "${sub.studentName}" is in draft.');
      }
    }

    // 4. Mandatory Milestones: Project must be in Project Closure stage
    final stages = [
      "Project Assigned",
      "Student Added",
      "Initial Process",
      "Student Work",
      "Phase 1 Review",
      "Rework",
      "Testing",
      "Project Closure",
      "Completed"
    ];
    int stageIndex = stages.indexOf(project.currentTimelineStage);
    if (stageIndex < 7) {
      incompleteItems.add('Project has not reached the "Project Closure" milestone.');
    }

    return {
      'isValid': incompleteItems.isEmpty,
      'incompleteItems': incompleteItems,
    };
  }

  void requestProjectClosure(String projectId) {
    final validation = validateProjectClosure(projectId);
    if (validation['isValid'] == true) {
      final project = getProjectById(projectId);
      if (project != null) {
        project.closureRequestedAt = DateTime.now();
        notifyListeners();
      }
    }
  }

  void confirmProjectClosure(String projectId) {
    final validation = validateProjectClosure(projectId);
    if (validation['isValid'] == true) {
      setProjectTimelineStage(projectId, 'Completed');
    }
  }

  // ── Private helpers for datetime formatting ────────────────────────────────

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month];
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
