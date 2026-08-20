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
      assignedEmployee: null,
    ),
    ProjectModel(
      id: 'p2',
      projectName: 'AI Placement Predictor',
      projectDescription: 'Machine learning framework to analyze student career trends.',
      collegeName: 'NIT Trichy',
      domain: 'Artificial Intelligence',
      createdDate: '18 August 2026',
      assignedEmployee: 'Sarah Jenkins',
    ),
    ProjectModel(
      id: 'p3',
      projectName: 'IoT Lab Monitor',
      projectDescription: 'Real-time telemetry and equipment monitoring application.',
      collegeName: 'Anna University',
      domain: 'Internet of Things',
      createdDate: '15 August 2026',
      assignedEmployee: null,
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

  final List<EmployeeModel> _employees = [
    EmployeeModel(
      id: 'e1',
      employeeName: 'Sarah Jenkins',
      email: 'sarah.j@admintech.com',
      role: 'Lead Full Stack Dev',
      currentProject: 'Smart Campus Portal',
      currentTask: 'Database Schema Design',
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
      currentTask: 'OAuth Auth Module',
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
      currentTask: 'Book Reader View Integration',
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
      id: 't1',
      taskTitle: 'Database Schema Design',
      taskDescription: 'Define core tables for student enrollment and grades.',
      projectType: 'Web Development',
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
      projectType: 'Mobile App',
      taskType: 'UI/UX Design',
      assignedEmployee: 'Alex Rivera',
      createdDate: '16 August 2026',
      dueDate: 'Aug 22, 2026',
      status: 'TO DO',
    ),
    TaskModel(
      id: 't3',
      taskTitle: 'IoT Telemetry Protocol Test',
      taskDescription: 'Verify MQTT broker connections under high latency.',
      projectType: 'Internet of Things',
      taskType: 'Integration Test',
      assignedEmployee: 'Sarah Jenkins',
      createdDate: '18 August 2026',
      dueDate: 'Aug 28, 2026',
      status: 'TO DO',
    ),
    TaskModel(
      id: 't4',
      taskTitle: 'OAuth Auth Module Implementation',
      taskDescription: 'Setup secure token refresh and role based access control.',
      projectType: 'Web Development',
      taskType: 'Security & Auth',
      assignedEmployee: 'Priya Sharma',
      createdDate: '19 August 2026',
      dueDate: 'Sep 02, 2026',
      status: 'TO DO',
    ),
  ];

  final List<NotificationItemModel> _notifications = [
    NotificationItemModel(
      id: 'n1',
      type: 'WORK_SUBMITTED',
      employeeName: 'Priya Sharma',
      taskName: 'OAuth Auth Module Implementation',
      title: 'Work Submitted',
      message: 'Priya Sharma submitted \'OAuth Auth Module Implementation\' for review',
      timestamp: '5 minutes ago',
      isRead: false,
      icon: Icons.unarchive_rounded,
    ),
    NotificationItemModel(
      id: 'n2',
      type: 'TASK_STARTED',
      employeeName: 'Alex Rivera',
      taskName: 'Dashboard UI Wireframes',
      title: 'Task Started',
      message: 'Alex Rivera started working on \'Dashboard UI Wireframes\'',
      timestamp: '18 minutes ago',
      isRead: false,
      icon: Icons.play_circle_outline_rounded,
    ),
    NotificationItemModel(
      id: 'n3',
      type: 'NEW_COMMENT',
      employeeName: 'Sarah Jenkins',
      taskName: 'IoT Telemetry Protocol Test',
      title: 'New Comment',
      message: 'Sarah Jenkins commented on \'IoT Telemetry Protocol Test\'',
      timestamp: '42 minutes ago',
      isRead: false,
      icon: Icons.chat_bubble_outline_rounded,
    ),
    NotificationItemModel(
      id: 'n4',
      type: 'TASK_ACCEPTED',
      employeeName: 'Michael Chen',
      taskName: 'Database Schema Design',
      title: 'Task Accepted',
      message: 'Michael Chen accepted the task \'Database Schema Design\'',
      timestamp: '2 hours ago',
      isRead: true,
      icon: Icons.assignment_turned_in_outlined,
    ),
    NotificationItemModel(
      id: 'n5',
      type: 'ISSUE_REPORTED',
      employeeName: 'David Vance',
      taskName: 'API Latency Bottleneck',
      title: 'Issue Reported',
      message: 'David Vance reported an issue with \'API Latency Bottleneck\'',
      timestamp: '3 hours ago',
      isRead: true,
      icon: Icons.report_problem_outlined,
    ),
    NotificationItemModel(
      id: 'n6',
      type: 'TASK_COMPLETED',
      employeeName: 'Sarah Jenkins',
      taskName: 'Security Benchmark Protocol',
      title: 'Task Completed',
      message: 'Sarah Jenkins completed \'Security Benchmark Protocol\'',
      timestamp: '1 day ago',
      isRead: true,
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  List<ProjectModel> get projects => List.unmodifiable(_projects);
  List<EmployeeModel> get employees => List.unmodifiable(_employees);
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<NotificationItemModel> get notifications => List.unmodifiable(_notifications);
  bool get hasUnreadNotifications => _notifications.any((n) => !n.isRead);

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
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
    _notifications.insert(0, NotificationItemModel(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      type: 'PROJECT_CREATED',
      employeeName: 'Admin',
      taskName: project.projectName,
      title: 'New Project Created',
      message: '${project.projectName} (${project.collegeName})',
      timestamp: 'Just now',
      isRead: false,
      icon: Icons.create_new_folder_outlined,
    ));
    notifyListeners();
  }

  void assignEmployeeToProject(String projectId, String employeeName) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      _projects[index].assignedEmployee = employeeName.trim();
      _notifications.insert(0, NotificationItemModel(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        type: 'PROJECT_ASSIGNED',
        employeeName: employeeName.trim(),
        taskName: _projects[index].projectName,
        title: 'Project Lead Assigned',
        message: '$employeeName assigned to ${_projects[index].projectName}',
        timestamp: 'Just now',
        isRead: false,
        icon: Icons.person_add_alt_1_outlined,
      ));
      notifyListeners();
    }
  }

  void addEmployee(EmployeeModel employee) {
    _employees.insert(0, employee);
    _notifications.insert(0, NotificationItemModel(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      type: 'EMPLOYEE_ADDED',
      employeeName: employee.employeeName,
      taskName: 'N/A',
      title: 'New Employee Registered',
      message: '${employee.employeeName} (${employee.role})',
      timestamp: 'Just now',
      isRead: false,
      icon: Icons.person_outline_rounded,
    ));
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    _notifications.insert(0, NotificationItemModel(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      type: 'TASK_CREATED',
      employeeName: task.assignedEmployee,
      taskName: task.taskTitle,
      title: 'New Task Created',
      message: '${task.taskTitle} assigned to ${task.assignedEmployee}',
      timestamp: 'Just now',
      isRead: false,
      icon: Icons.add_task_outlined,
    ));
    notifyListeners();
  }
}
