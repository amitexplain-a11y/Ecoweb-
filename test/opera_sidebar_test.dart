import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dreamwork_browser/providers/browser_provider.dart';
import 'package:flutter_dreamwork_browser/widgets/opera_sidebar.dart';

void main() {
  testWidgets('OperaSidebar renders logo, aria button, and workspaces', (WidgetTester tester) async {
    final provider = BrowserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<BrowserProvider>.value(
        value: provider,
        child: MaterialApp(
          home: Scaffold(
            body: OperaSidebar(
              activeSection: 'speed_dial',
              onSectionSelected: (section) {},
            ),
          ),
        ),
      ),
    );

    // Verify Opera 'O' logo rendering
    expect(find.text('O'), findsOneWidget);

    // Verify Aria icon button
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

    // Verify workspace icons exist
    expect(find.byIcon(Icons.work_outline), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.sports_esports_outlined), findsOneWidget);
  });
}
