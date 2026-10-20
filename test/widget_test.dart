import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dreamwork_browser/main.dart';

void main() {
  testWidgets('MainBrowserScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OperaDreamworkApp());

    // Verify main components render on initial launch
    expect(find.text('OPERA DREAMWORK'), findsOneWidget);
    expect(find.text('Shield'), findsOneWidget);
    expect(find.text('VPN'), findsOneWidget);
  });
}
