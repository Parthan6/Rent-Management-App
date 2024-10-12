import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_app/main.dart'; // Make sure this points to your main app file.

void main() {
  testWidgets('Room details displayed test', (WidgetTester tester) async {
    // Build the Room Rent Manager app.
    await tester.pumpWidget(RentManagementApp());

    // Verify that a room list item is present (e.g., room 1).
    expect(find.text('1'), findsOneWidget);

    // Simulate tapping on the room 1 list item.
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify that the tenant details for room 1 are displayed.
    expect(find.text('Tenant Name: ********'), findsOneWidget);
    expect(find.text('Rent: ₹****'), findsOneWidget);
  });
}
