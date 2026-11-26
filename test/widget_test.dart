import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aec_app/app/app.dart';

void main() {
  testWidgets('AE Connect Employee flow: Login -> Home -> New Visit -> Profile -> Sign out', (WidgetTester tester) async {
    await tester.pumpWidget(const AecApp());
    await tester.pumpAndSettle();

    // 1. Verify Login Portal & 3-Role selector
    expect(find.text('Employee sign in'), findsOneWidget);
    expect(find.text('Employee'), findsOneWidget);
    expect(find.text('Manager / Admin'), findsOneWidget);
    expect(find.text('Warehouse'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);

    // 2. Click Send OTP
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    // 3. Verify OTP Screen & Click Verify
    expect(find.text('Enter verification code'), findsOneWidget);
    expect(find.text('Verify & continue'), findsOneWidget);

    await tester.tap(find.text('Verify & continue'));
    await tester.pumpAndSettle();

    // 4. Verify Home Dashboard (Sales overview)
    expect(find.text('Sales overview'), findsOneWidget);
    expect(find.text('Hello, John.'), findsOneWidget);
    expect(find.text('Open leads'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);

    // 5. Tap "Log a visit" button from Hero Banner
    expect(find.text('Log a visit'), findsOneWidget);
    await tester.tap(find.text('Log a visit'));
    await tester.pumpAndSettle();

    // 6. Verify New visit form exact prototype match
    expect(find.text('New visit'), findsWidgets);
    expect(find.text('Choose your customer, contact and purpose before checking in.'), findsOneWidget);
    expect(find.text('Technical Discussion'), findsOneWidget);
    expect(find.text('Demo'), findsOneWidget);

    // 7. Click BackButton in AppBar to return to Home
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 7b. Navigate to Tasks tab
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    // Verify Tasks screen components matching prototype exactly
    expect(find.text('Due today'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Add task'), findsOneWidget);
    expect(find.text('Call Acme about the fiber proposal'), findsOneWidget);
    expect(find.text('Schedule Bright Infra site visit'), findsOneWidget);

    // Tap Add task to open TaskFormScreen
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    // Verify New task form
    expect(find.text('New task'), findsOneWidget);
    expect(find.text('Set the customer, assignee and due date.'), findsOneWidget);
    expect(find.text('Task title *'), findsOneWidget);
    expect(find.text('Related lead / customer *'), findsOneWidget);
    expect(find.text('Save task'), findsOneWidget);

    // Tap Cancel to return to Tasks screen
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 8. Tap Profile Avatar icon in Header
    await tester.tap(find.byKey(const Key('header_profile_button')));
    await tester.pumpAndSettle();

    // 9. Verify Profile Screen & Red Sign out Button
    expect(find.text('My profile'), findsWidgets);
    expect(find.text('Requests & updates'), findsOneWidget);

    // Scroll to Sign out button and click it
    await tester.scrollUntilVisible(find.text('Sign out'), 200);
    await tester.pumpAndSettle();
    expect(find.text('Sign out'), findsOneWidget);

    // 10. Click Sign out
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    // 11. Verify immediately returned to Login Screen!
    expect(find.text('Employee sign in'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
