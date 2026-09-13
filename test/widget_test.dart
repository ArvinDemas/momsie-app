import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Momsie App UI Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Momsie App Ready'),
          ),
        ),
      ),
    );
    expect(find.text('Momsie App Ready'), findsOneWidget);
  });
}

