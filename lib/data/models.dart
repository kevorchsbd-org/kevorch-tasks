import 'package:flutter/material.dart';

class ProjectStatus {
  static const String assigned = 'ASSIGNED';
  static const String inProgress = 'IN PROGRESS';
  static const String phase1Review = 'PHASE 1 REVIEW';
  static const String rework = 'REWORK';
  static const String testing = 'TESTING';
  static const String closure = 'CLOSURE';
  static const String completed = 'COMPLETED';

  static const List<String> all = [
    assigned,
    inProgress,
    phase1Review,
    rework,
    testing,
    closure,
    completed,
  ];

  static String getLabel(String status) {
    switch (status.toUpperCase()) {
      case assigned: return 'Assigned';
      case inProgress: return 'In Progress';
      case phase1Review: return 'Phase 1 Review';
      case rework: return 'Rework';
      case testing: return 'Testing';
      case closure: return 'Closure';
      case completed: return 'Completed';
      default: return status;
    }
  }
}

class ProjectModel {
  final String id;
  final String projectName;
  final String projectDescription;
  final String collegeName;
  final String domain;
  final String createdDate;
  String? assignedEmployee;
  String status;
  DateTime? assignedDate;
  DateTime? completedAt;
  String currentTimelineStage;
  DateTime? closureRequestedAt;

  ProjectModel({
    required this.id,
    required this.projectName,
    required this.projectDescription,
    required this.collegeName,
    required this.domain,
    required this.createdDate,
    this.assignedEmployee,
    this.status = ProjectStatus.assigned,
    this.assignedDate,
    this.completedAt,
    this.currentTimelineStage = 'Project Assigned',
    this.closureRequestedAt,
  });

  bool get isAssigned => assignedEmployee != null && assignedEmployee!.trim().isNotEmpty;

  String get assignedInitials {
    if (!isAssigned) return 'NA';
    final parts = assignedEmployee!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'EM';
  }
}

class EmployeeModel {
  final String id;
  final String employeeName;
  final String email;
  final String role;
  final String currentProject;
  final String currentTask;
  final String priority;
  final String deadline;
  final String status;
  final String studentId;
  final String studentName;
  final String college;
  final String domain;
  final String projectTitle;
  final String? avatarUrl;

  EmployeeModel({
    required this.id,
    required this.employeeName,
    required this.email,
    required this.role,
    this.currentProject = 'Smart Campus Portal',
    this.currentTask = 'Database Schema Design',
    this.priority = 'High',
    this.deadline = 'Aug 28, 2026',
    this.status = 'In Progress',
    this.studentId = 'STU-101',
    this.studentName = 'Kavitha R',
    this.college = 'IIT Madras',
    this.domain = 'Web Development',
    this.projectTitle = 'Smart Campus Portal',
    this.avatarUrl,
  });

  String get initials {
    final parts = employeeName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'EM';
  }
}

class TaskModel {
  final String id;
  final String taskTitle;
  final String taskDescription;
  final String projectType;
  final String taskType;
  final String assignedEmployee;
  final String createdDate;
  final String dueDate;
  String status;
  String? workUpdateNote;

  TaskModel({
    required this.id,
    required this.taskTitle,
    required this.taskDescription,
    required this.projectType,
    required this.taskType,
    required this.assignedEmployee,
    required this.createdDate,
    required this.dueDate,
    this.status = 'TO DO',
    this.workUpdateNote,
  });
}

class NotificationItemModel {
  final String id;
  final String type;
  final String employeeName;
  final String taskName;
  final String title;
  final String message;
  final String timestamp;
  bool isRead;
  final IconData icon;

  // Relational IDs — link to TaskModel, ProjectModel, EmployeeModel
  final String? relatedTaskId;
  final String? relatedProjectId;
  final String? relatedEmployeeId;
  final String? targetEmployeeId; // null = Admin notification, set = target employee notification

  // Short contextual subtitle (e.g. project name) shown on list card
  final String? subTitle;

  // Optional event-specific fields — only populate when real data exists
  final String? eventDateTime;   // e.g. "21 Aug 2026 • 10:18 AM"
  final String? previousStatus;  // Only for task_status_updated, when known
  final String? newStatus;       // Only for task_status_updated, when known

  NotificationItemModel({
    required this.id,
    required this.type,
    required this.employeeName,
    required this.taskName,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.icon = Icons.notifications_none_rounded,
    this.relatedTaskId,
    this.relatedProjectId,
    this.relatedEmployeeId,
    this.targetEmployeeId,
    this.subTitle,
    this.eventDateTime,
    this.previousStatus,
    this.newStatus,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Employee TO DO Model
// ─────────────────────────────────────────────────────────────────────────────

class EmployeeTodoModel {
  final String id;
  final String projectId;
  final String employeeId;
  final String? studentId;

  // Mutable while PENDING only (provider enforces lock after SUBMITTED)
  String? studentName;
  String title;
  String description;
  String? note;
  String status; // "PENDING" | "SUBMITTED"
  bool isRequired;

  // Immutable creation timestamp
  final DateTime createdAt;

  // Auto-set once at submission — never manually editable
  DateTime? submittedAt;

  EmployeeTodoModel({
    required this.id,
    required this.projectId,
    required this.employeeId,
    this.studentId,
    this.studentName,
    required this.title,
    required this.description,
    this.note,
    this.status = 'PENDING',
    this.isRequired = true,
    required this.createdAt,
    this.submittedAt,
  });

  bool get isPending => status == 'PENDING';
  bool get isSubmitted => status == 'SUBMITTED';

  /// Formatted created date: "21 Aug 2026"
  String get createdDateStr {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${createdAt.day} ${months[createdAt.month]} ${createdAt.year}';
  }

  /// Formatted created time: "04:10 PM"
  String get createdTimeStr => _formatTime(createdAt);

  /// Formatted submitted date: "21 Aug 2026"
  String? get submittedDateStr {
    if (submittedAt == null) return null;
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${submittedAt!.day} ${months[submittedAt!.month]} ${submittedAt!.year}';
  }

  /// Formatted submitted time: "04:22 PM"
  String? get submittedTimeStr {
    if (submittedAt == null) return null;
    return _formatTime(submittedAt!);
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String role; // "SUPER ADMIN" or "ADMIN"
  final String accessScope;
  final String createdDate;
  bool isActive;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accessScope,
    required this.createdDate,
    this.isActive = true,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'AD';
  }
}

class StudentSubmissionModel {
  final String id;
  final String projectId;
  final String employeeId;
  String studentName;
  String registerNumber;
  String department;
  String college;
  String? email;
  String? phone;
  String? notes;
  String? documentName;
  String? documentPath;
  String? documentType;
  String? documentSize;
  String status; // "DRAFT" | "SUBMITTED"
  bool isRequired;
  final DateTime createdAt;
  DateTime? submittedAt;

  StudentSubmissionModel({
    required this.id,
    required this.projectId,
    required this.employeeId,
    required this.studentName,
    required this.registerNumber,
    required this.department,
    required this.college,
    this.email,
    this.phone,
    this.notes,
    this.documentName,
    this.documentPath,
    this.documentType,
    this.documentSize,
    this.status = 'DRAFT',
    this.isRequired = true,
    required this.createdAt,
    this.submittedAt,
  });
}

class StudentProcessModel {
  final String id;
  final String projectId;
  final String employeeId;
  final String? studentId;
  final String studentName;
  String title;
  String description;
  String? note;
  String? referenceDocumentName;
  String status; // "DRAFT" | "SUBMITTED"
  bool isRequired;
  final DateTime createdAt;
  DateTime? submittedAt;

  StudentProcessModel({
    required this.id,
    required this.projectId,
    required this.employeeId,
    this.studentId,
    required this.studentName,
    required this.title,
    required this.description,
    this.note,
    this.referenceDocumentName,
    this.status = 'DRAFT',
    this.isRequired = true,
    required this.createdAt,
    this.submittedAt,
  });
}

