import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_project_management/main.dart';
import 'package:admin_project_management/navigation/admin_navigation.dart';

void main() {
  testWidgets('Renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AdminProjectManagementApp());
    await tester.pumpAndSettle();

    expect(find.text('Admin Login'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Quick Actions render cleanly on Mobile screen width (360px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: AdminNavigation()));
    await tester.pumpAndSettle();

    expect(find.text('Create Project'), findsAtLeastNWidgets(1));
    expect(find.text('Add Employee'), findsAtLeastNWidgets(1));
    expect(find.text('Create Task'), findsAtLeastNWidgets(1));
  });

  testWidgets('Project Details and Assign Employee workflow test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: AdminNavigation()));
    await tester.pumpAndSettle();

    // Tap the first project card ("Smart Campus Portal")
    final projectCard = find.text('Smart Campus Portal');
    expect(projectCard, findsAtLeastNWidgets(1));
    await tester.tap(projectCard.first);
    await tester.pumpAndSettle();

    // Verify Project Details screen opens with project info
    expect(find.text('Project Details'), findsOneWidget);
    expect(find.text('Project Information'), findsOneWidget);
    expect(find.text('Smart Campus Portal'), findsAtLeastNWidgets(1));
    expect(find.text('Assigned Employee'), findsOneWidget);

    // Tap Assign Employee button
    final assignButton = find.text('Assign Employee').last;
    await tester.tap(assignButton);
    await tester.pumpAndSettle();

    // Verify Assign Employee modal opens
    expect(find.text('Employee Name'), findsOneWidget);

    // Type employee name "Arun Kumar"
    final nameField = find.byType(TextFormField).last;
    await tester.enterText(nameField, 'Arun Kumar');
    await tester.pumpAndSettle();

    // Submit assignment
    final submitButton = find.text('Assign');
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);

    // Pump past the 600ms loading delay
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify Success Dialog
    expect(find.text('Employee Assigned'), findsOneWidget);
    final continueBtn = find.text('Continue');
    await tester.tap(continueBtn);
    await tester.pumpAndSettle();

    // Verify Project Details immediately reflects "Arun Kumar"
    expect(find.text('Arun Kumar'), findsAtLeastNWidgets(1));
  });
}
