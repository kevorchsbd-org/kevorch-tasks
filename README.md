# Kevorch Tasks — Admin Panel

> **Platform:** Flutter (iOS · Android · Web · Desktop)
> **Role:** Admin-only internal management tool
> **Design System:** White · Black · Red `#DC2626` · Sora + DM Sans

---

## 📋 Table of Contents

1. [App Overview](#app-overview)
2. [Tech Stack](#tech-stack)
3. [Admin Workflow](#admin-workflow)
   - [1. Login](#1-login)
   - [2. Dashboard](#2-dashboard)
   - [3. Projects](#3-projects)
   - [4. Employees](#4-employees)
   - [5. Tasks](#5-tasks)
   - [6. Notifications](#6-notifications)
   - [7. Admin Monitoring](#7-admin-monitoring)
4. [Navigation Structure](#navigation-structure)
5. [Data Layer](#data-layer)
6. [Project Structure](#project-structure)

---

## App Overview

Kevorch Tasks is a **premium SaaS admin dashboard** for managing projects, employees, and tasks for college-based tech teams. The admin can create projects, register employees, assign tasks, track statuses, and receive real-time in-app notifications — all from a single unified panel.

---

## Tech Stack

| Area | Technology |
|---|---|
| Framework | Flutter 3.x |
| State Management | `ChangeNotifier` + `AnimatedBuilder` |
| Data | In-memory dummy data (`DummyDataProvider` singleton) |
| Typography | Sora (headings) · DM Sans (body) |
| Animations | Custom `FadeSlideTransition` · `ScaleTapWidget` · `AppPageRoute` |

---

## Admin Workflow

### 1. Login

**Screen:** `LoginScreen`

The admin enters credentials to access the dashboard.

| Field | Default Value |
|---|---|
| Email | `admin@kevorch.com` |
| Password | `admin123` |

**Flow:**
```
App Launch → Login Screen → Enter Credentials → Tap Login → Admin Dashboard
```

- Form validates email format and password
- 600ms simulated auth delay
- On success → navigates to `AdminNavigation` (bottom nav shell)

---

### 2. Dashboard

**Screen:** `DashboardScreen` · Tab index `0`

The home screen gives the admin an **Employee Overview** — all registered employees listed as compact cards.

**What's visible:**
- Admin profile avatar + `ADMIN` badge in header
- List of all employees with name, role, current project
- Tap any employee card → opens **Employee Details**

**Header actions:**
| Button | Action |
|---|---|
| 📊 Chart icon | Opens Admin Monitoring screen |
| 🔔 Bell icon | Opens Notification List |

---

### 3. Projects

**Screen:** `ProjectsScreen` · Tab index `1`

The admin manages all client college projects here.

#### 3a. View All Projects
- Total project count badge at top
- Search bar — filter by project name, college, domain, or assignee
- Each project card shows: name, college, domain, assigned employee (if any)

#### 3b. Create a Project
**Trigger:** `+ Create Project` FAB button

**Form fields:**
| Field | Required |
|---|---|
| Project Name | ✅ |
| Description | ✅ |
| College Name | ✅ |
| Domain | ✅ (typed or selected from suggestions) |
| Assign Employee (Lead) | Optional |

On submit:
- Project added to list
- Notification created: **"Project Created"**
- Success dialog shown

#### 3c. Project Details
**Trigger:** Tap any project card

**Displays:**
- Project name + domain badge
- Description
- College name
- Created date
- Assigned employee (with initials avatar)
- **"Assign Employee"** button if not yet assigned

#### 3d. Assign Employee to Project
**Trigger:** Tap `Assign Employee` on project details

- Dropdown of all registered employees
- On assign → updates project + creates notification: **"Project Lead Assigned"**

---

### 4. Employees

**Screen:** `EmployeesScreen` · Tab index `2`

The admin manages the team here.

#### 4a. View All Employees
- Search bar — filter by name, email, or role
- Each employee card shows: name, role, current project, work status badge

#### 4b. Add a New Employee
**Trigger:** `+ Add Employee` FAB button

**Form fields:**
| Field | Required |
|---|---|
| Employee Name | ✅ |
| Email | ✅ |
| Role / Designation | ✅ |

On submit:
- Employee added to list
- Notification created: **"New Employee Registered"**
- Success dialog shown

#### 4c. Employee Details
**Trigger:** Tap any employee card (from Employees tab or Dashboard)

**Three information sections:**

| Section | Fields |
|---|---|
| Employee Info | ID, Name, Email, Role |
| Current Work | Current Project, Current Task, Priority badge, Deadline, Status badge |
| Student Details | Student ID, Student Name, College, Domain, Project Title |

**Priority badges:** 🔴 HIGH · 🟡 MEDIUM · 🔵 LOW

**Status badges:** 🔵 In Progress · 🟣 Submitted · 🟢 Completed · 🟡 Pending

---

### 5. Tasks

**Screen:** `TasksScreen` · Tab index `3`

The admin creates and tracks all assigned tasks.

#### 5a. View All Tasks
- Search bar — filter by task title, project type, task type, or assigned employee
- Shows count: `All Assigned Tasks (N)`
- Each task card shows: title, type, assignee, due date, status

#### 5b. Create a Task
**Trigger:** `+ Create Task` FAB button

**Form fields:**
| Field | Required |
|---|---|
| Task Title | ✅ |
| Description | ✅ |
| Project Type | ✅ |
| Task Type | ✅ |
| Assign Employee | ✅ |
| Due Date | ✅ |

On submit:
- Task added to list with status `TO DO`
- Notification created: **"Task Assigned"**
- Success dialog shown

#### 5c. Task Details
**Trigger:** Tap any task card

**Four information sections:**

| Section | Fields |
|---|---|
| Task Information | Title, Description, Project Type, Task Type |
| Assignment Information | Assigned Employee (with avatar initials) |
| Date Information | Created Date, Due Date (highlighted red) |
| Status Information | Current status badge |

---

### 6. Notifications

**Bell icon** is available in every screen's header via `CustomAppBar`.

#### 6a. Notification Bell
- Shows **red dot badge** when unread notifications exist
- Tap → opens Notification List

#### 6b. Notification List
**Screen:** `NotificationsScreen`

- Staggered fade+slide animation on load
- `Mark all as read` button (top right, shown only when unread exist)
- Each notification card shows:
  - Type icon
  - Title
  - Short message
  - Project name (if linked)
  - Relative timestamp
  - Small red dot (unread indicator)

**Unread card:** subtle red-tinted background · bold font

**Read card:** plain white background · normal font

#### 6c. Notification Tap
Tapping a notification card:
1. **Marks it as read** immediately
2. **Updates unread badge** count
3. **Navigates** to Notification Details screen

#### 6d. Notification Details
**Screen:** `NotificationDetailsScreen`

**Summary Card** (top, red-tinted):
- Notification icon + title + message + project name + timestamp

**Details Card** (type-specific):

| Notification Type | Fields Shown |
|---|---|
| **Task Submitted** | Task · Project · Submitted By · Submitted At · Current Status |
| **Task Assigned** | Task · Project · Assigned To · Assigned Date · Due Date · Current Status |
| **Task Status Updated** | Task · Project · Employee · New Status · Updated At |
| **Project Created** | Project Name · Description · College · Domain · Created Date |

**Status badges:** colour-coded (green = completed, amber = in progress/review, grey = to do/pending)

**Action buttons:**
| Button | When Shown | Navigates To |
|---|---|---|
| `View Task` | Notification has a related task | Task Details screen |
| `View Project` | Notification has a related project | Project Details screen |

#### 6e. Notification Types Generated Automatically

| Action | Notification Created |
|---|---|
| Admin creates a project | Project Created |
| Admin assigns employee to project | Project Lead Assigned |
| Admin adds an employee | New Employee Registered |
| Admin creates a task | Task Assigned |

---

### 7. Admin Monitoring

**Screen:** `MonitoringScreen`
**Access:** Chart icon in Dashboard header

A real-time summary dashboard showing system health.

**System Health Card (dark):**
| Metric | Value |
|---|---|
| Active Nodes | 100% |
| Pending Tasks | Live count from data |
| Team Utilization | 88% |

**Monitoring Breakdown:**
| Tile | Info |
|---|---|
| Projects Overview | Total projects across N domains |
| Employees & Resources | Total registered team members |
| Tasks Tracking | Total tasks logged |
| Upcoming Due Dates | Next task deadline |

---

## Navigation Structure

```
LoginScreen
    └── AdminNavigation (Bottom Nav Shell)
            ├── [0] DashboardScreen
            │       └── EmployeeDetailsScreen
            │               └── (read-only employee profile)
            │
            ├── [1] ProjectsScreen
            │       ├── CreateProjectModal (bottom sheet)
            │       └── ProjectDetailsScreen
            │               └── AssignEmployeeModal
            │
            ├── [2] EmployeesScreen
            │       ├── AddEmployeeModal (bottom sheet)
            │       └── (employee card taps → EmployeeDetailsScreen)
            │
            └── [3] TasksScreen
                    ├── CreateTaskModal (bottom sheet)
                    └── TaskDetailsScreen

    [Header Bell — all tabs]
            └── NotificationsScreen
                    └── NotificationDetailsScreen
                            ├── TaskDetailsScreen  (View Task button)
                            └── ProjectDetailsScreen  (View Project button)

    [Dashboard Header]
            └── MonitoringScreen
```

---

## Data Layer

**File:** `lib/data/dummy_data.dart`

`DummyDataProvider` is a **singleton ChangeNotifier** — all screens listen to it via `AnimatedBuilder` and re-render on any data change.

### Seed Data Summary

| Entity | Count |
|---|---|
| Projects | 4 |
| Employees | 7 |
| Tasks | 4 |
| Notifications | 6 |

### Key Methods

| Method | Effect |
|---|---|
| `addProject(project)` | Adds project + creates "Project Created" notification |
| `assignEmployeeToProject(id, name)` | Updates project + creates "Project Lead Assigned" notification |
| `addEmployee(employee)` | Adds employee + creates "New Employee Registered" notification |
| `addTask(task)` | Adds task + creates "Task Assigned" notification |
| `markNotificationAsRead(id)` | Sets `isRead = true` + notifies listeners |
| `markAllNotificationsAsRead()` | Marks all read + notifies listeners |
| `getProjectById(id)` | Returns `ProjectModel?` |
| `getEmployeeById(id)` | Returns `EmployeeModel?` |
| `getTaskById(id)` | Returns `TaskModel?` |

### Notification Relational Fields

Each `NotificationItemModel` carries:

| Field | Purpose |
|---|---|
| `relatedTaskId` | Links to `TaskModel.id` |
| `relatedProjectId` | Links to `ProjectModel.id` |
| `relatedEmployeeId` | Links to `EmployeeModel.id` |
| `subTitle` | Project name shown in notification card |
| `eventDateTime` | Actual event timestamp (formatted) |
| `previousStatus` | Only for status-update notifications, when known |
| `newStatus` | Only for status-update notifications, when known |

---

## Project Structure

```
lib/
├── core/
│   ├── animations/
│   │   └── app_animations.dart       # FadeSlideTransition, ScaleTapWidget, AppPageRoute
│   └── theme/
│       ├── app_colors.dart           # Color tokens
│       ├── app_typography.dart       # Text styles (Sora + DM Sans)
│       └── app_theme.dart            # ThemeData
│
├── data/
│   ├── models.dart                   # ProjectModel, EmployeeModel, TaskModel, NotificationItemModel
│   └── dummy_data.dart               # DummyDataProvider singleton
│
├── navigation/
│   └── admin_navigation.dart         # Bottom nav shell (4 tabs)
│
├── screens/
│   ├── login/
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── projects/
│   │   ├── projects_screen.dart
│   │   ├── project_details_screen.dart
│   │   ├── create_project_modal.dart
│   │   └── assign_employee_modal.dart
│   ├── employees/
│   │   ├── employees_screen.dart
│   │   ├── employee_details_screen.dart
│   │   └── add_employee_modal.dart
│   ├── tasks/
│   │   ├── tasks_screen.dart
│   │   ├── task_details_screen.dart
│   │   └── create_task_modal.dart
│   ├── notifications/
│   │   ├── notifications_screen.dart
│   │   └── notification_details_screen.dart
│   └── monitoring/
│       └── monitoring_screen.dart
│
└── widgets/
    ├── custom_app_bar.dart           # Shared header with bell + monitoring icon
    ├── bottom_nav_bar.dart           # Custom bottom navigation bar
    ├── primary_button.dart           # Red CTA button
    ├── custom_text_field.dart        # Styled form input
    ├── project_card.dart             # Project list card
    ├── employee_card.dart            # Employee list card
    ├── task_card.dart                # Task list card
    ├── summary_card.dart             # Dashboard summary metrics
    ├── quick_action_card.dart        # Dashboard quick actions
    └── success_state_dialog.dart     # Post-submit success dialog
```

---

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on device / emulator
flutter run

# Analyze for issues
flutter analyze
```

**Default login credentials:**
```
Email:    admin@kevorch.com
Password: admin123
```

---

*Built with Flutter · Kevorch Admin Platform*
