import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String projectName;
  final String projectDescription;
  final String collegeName;
  final String domain;
  final String createdDate;
  String? assignedEmployee;

  ProjectModel({
    required this.id,
    required this.projectName,
    required this.projectDescription,
    required this.collegeName,
    required this.domain,
    required this.createdDate,
    this.assignedEmployee,
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
  final String status;

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
  });
}

