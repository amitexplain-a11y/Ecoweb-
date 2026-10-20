import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dreamwork_browser/providers/browser_provider.dart';
import 'package:flutter_dreamwork_browser/widgets/aria_panel.dart';

void main() {
  testWidgets('AriaPanel renders header, quick action chips, and chat input when open', (WidgetTester tester) async {
    final provider = BrowserProvider();
    provider.toggleAriaPanel(); // Open panel

    await tester.pumpWidget(
      ChangeNotifierProvider<BrowserProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(
            body: AriaPanel(),
          ),
        ),
      ),
    );

    // Verify Aria Header
    expect(find.text('Aria AI Assistant'), findsOneWidget);

    // Verify Quick Prompts
    expect(find.text('Summarize Page'), findsOneWidget);
    expect(find.text('Explain Code'), findsOneWidget);

    // Verify Input Field
    expect(find.text('Ask Aria anything...'), findsOneWidget);
  });
}
