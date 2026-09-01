import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cet_connect/main.dart';
import 'package:cet_connect/data/services/mock_data_service.dart';

void main() {
  setUp(() {
    MockDataService().resetToMockData();
  });

  testWidgets('S1 Landing screen renders CET branding and action buttons', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CETConnectApp());
    await tester.pumpAndSettle();

    // Verify S1 Elements
    expect(find.text('Welcome to CET'), findsOneWidget);
    expect(find.text('COLLEGE OF ENGINEERING TRIVANDRUM'), findsOneWidget);
    expect(find.text('Create New Account (Sign Up)'), findsOneWidget);
    expect(find.text('Already have an account? Sign In'), findsOneWidget);
    expect(find.text('Developer & Admin Console'), findsOneWidget);
  });

  testWidgets('Navigate from S1 to S2 Signup screen and validate fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CETConnectApp());
    await tester.pumpAndSettle();

    // Tap Sign up
    await tester.tap(find.text('Create New Account (Sign Up)'));
    await tester.pumpAndSettle();

    // Verify S2 Screen
    expect(find.text('Join the CET\nCommunity'), findsOneWidget);
    expect(find.text('STEP 1 OF 2 : CREDENTIALS'), findsOneWidget);
    expect(find.text('Continue to Profile Setup (S3)'), findsOneWidget);
  });

  testWidgets('Directly open S4 Discover and verify Students, Clubs, and Activity Tracker tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    MockDataService().loginAsDemo('student');

    await tester.pumpWidget(const CETConnectApp());
    await tester.pumpAndSettle();

    // Tap Sign In and choose Student Demo
    await tester.tap(find.text('Already have an account? Sign In'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Student Demo'));
    await tester.pumpAndSettle();

    // Verify S4 Discover Screen
    expect(find.text('CET Connect'), findsOneWidget);
    expect(find.text('Students'), findsOneWidget);
    expect(find.text('Clubs & Groups'), findsOneWidget);
    expect(find.text('Activity Tracker'), findsOneWidget);

    // Verify students list items exist in students tab
    expect(find.text('Ananya Nair'), findsOneWidget);

    // Switch to Clubs Tab
    await tester.tap(find.text('Clubs & Groups'));
    await tester.pumpAndSettle();

    expect(find.text('CodeCET'), findsOneWidget);
    expect(find.text('CET Robotics Club'), findsOneWidget);

    // Switch to Activity Tracker Tab
    await tester.tap(find.text('Activity Tracker'));
    await tester.pumpAndSettle();

    expect(find.text('Campus Schedule & Tracker'), findsOneWidget);
    expect(find.text('+ Plan Private Activity with Friends'), findsOneWidget);
  });

  testWidgets('Open Developer Admin Screen and verify statistics metrics', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CETConnectApp());
    await tester.pumpAndSettle();

    // Tap Developer Console
    await tester.tap(find.text('Developer & Admin Console'));
    await tester.pumpAndSettle();

    expect(find.text('Developer & Admin Console'), findsWidgets);
    expect(find.text('Total Users'), findsOneWidget);
    expect(find.text('Active Clubs'), findsOneWidget);
    expect(find.text('Workshops / Events'), findsOneWidget);
    expect(find.text('Registered Profiles Database'), findsOneWidget);
  });
}
