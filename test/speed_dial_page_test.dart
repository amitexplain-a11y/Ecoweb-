import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dreamwork_browser/providers/browser_provider.dart';
import 'package:flutter_dreamwork_browser/widgets/speed_dial_page.dart';

void main() {
  testWidgets('SpeedDialPage renders branding, search, and speed dial tiles', (WidgetTester tester) async {
    final provider = BrowserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<BrowserProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(
            body: SpeedDialPage(),
          ),
        ),
      ),
    );

    // Verify Dreamwork Brand text
    expect(find.text('OPERA DREAMWORK'), findsOneWidget);

    // Verify Search hint
    expect(find.text('Search the web or type a URL...'), findsOneWidget);

    // Verify speed dial tiles
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('Add Site'), findsOneWidget);
  });
}
