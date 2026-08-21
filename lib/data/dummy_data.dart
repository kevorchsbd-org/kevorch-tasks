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
    ),
    ProjectModel(
      id: 'p2',
      projectName: 'AI Placement Predictor',
      projectDescription: 'Machine learning framework to analyze student career trends.',
      collegeName: 'NIT Trichy',
      domain: 'Artificial Intelligence',
      createdDate: '18 August 2026',
      assignedEmployee: 'Employee',
    ),
    ProjectModel(
      id: 'p3',
      projectName: 'IoT Lab Monitor',
      projectDescription: 'Real-time telemetry and equipment monitoring application.',
      collegeName: 'Anna University',
      domain: 'Internet of Things',
      createdDate: '15 August 2026',
      assignedEmployee: 'Michael Chen',
    ),
    ProjectModel(
      id: 'p4',
      projectName: 'E-Library Mobile App',
      projectDescription: 'Digital book reader and journal catalog for students.',
      collegeName: 'BITS Pilani',
      domain: 'Mobile App',
      createdDate: '10 August 2026',
      assignedEmployee: 'Alex Rivera',
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
    todo.status = 'SUBMITTED';
    todo.submittedAt = DateTime.now();
    notifyListeners();
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
