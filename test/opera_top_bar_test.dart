import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dreamwork_browser/providers/browser_provider.dart';
import 'package:flutter_dreamwork_browser/widgets/opera_top_bar.dart';

void main() {
  testWidgets('OperaTopBar renders active tab, address bar, Shield, and VPN', (WidgetTester tester) async {
    final provider = BrowserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<BrowserProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(
            body: OperaTopBar(),
          ),
        ),
      ),
    );

    // Verify initial tab title
    expect(find.text('Speed Dial'), findsWidgets);

    // Verify address bar hint text
    expect(find.text('Search with Google or enter address'), findsOneWidget);

    // Verify Shield (Ad blocker) and VPN buttons exist
    expect(find.text('Shield'), findsOneWidget);
    expect(find.text('VPN'), findsOneWidget);
  });
}
