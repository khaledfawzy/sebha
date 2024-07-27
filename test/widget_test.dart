import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sebha/main.dart';

// ignore: depend_on_referenced_packages
//import 'package:seha/main.dart'; // Updated package name

void main() {
  testWidgets('Counter increments and rotates Sebha', (WidgetTester tester) async {
    await tester.pumpWidget(const SebhaApp());

    // Verify initial state
    expect(find.text('Counter: 0'), findsOneWidget);
    expect(find.text('Rounds: 0'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify the updated state
    expect(find.text('Counter: 1'), findsOneWidget);
    expect(find.text('Rounds: 0'), findsOneWidget);
  });
}
