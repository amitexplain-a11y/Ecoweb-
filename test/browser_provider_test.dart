import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dreamwork_browser/providers/browser_provider.dart';

void main() {
  group('BrowserProvider Unit Tests', () {
    late BrowserProvider provider;

    setUp(() {
      provider = BrowserProvider();
    });

    test('Initial state has default tab and workspaces', () {
      expect(provider.workspaces.length, 3);
      expect(provider.allTabs.length, 1);
      expect(provider.activeTab?.title, 'Speed Dial');
      expect(provider.activeWorkspaceId, 'default');
    });

    test('Adding and switching tabs works correctly', () {
      provider.addTab(url: 'https://flutter.dev', title: 'Flutter');
      expect(provider.currentWorkspaceTabs.length, 2);
      expect(provider.activeTab?.url, 'https://flutter.dev');

      provider.selectTab(0);
      expect(provider.activeTab?.title, 'Speed Dial');
    });

    test('Workspace switching filters tabs', () {
      provider.addTab(url: 'https://flutter.dev');
      expect(provider.currentWorkspaceTabs.length, 2);

      provider.switchWorkspace('personal');
      expect(provider.activeWorkspaceId, 'personal');
      expect(provider.currentWorkspaceTabs.length, 1); // auto created startpage
      expect(provider.activeTab?.isSpeedDial, isTrue);
    });

    test('Bookmarks toggle state properly', () {
      const url = 'https://example.com';
      expect(provider.isBookmarked(url), isFalse);

      provider.toggleBookmark('Example', url);
      expect(provider.isBookmarked(url), isTrue);

      provider.toggleBookmark('Example', url);
      expect(provider.isBookmarked(url), isFalse);
    });

    test('Aria chat messages append user input', () {
      final initialCount = provider.ariaMessages.length;
      provider.sendAriaMessage('Test prompt');
      expect(provider.ariaMessages.length, initialCount + 1);
      expect(provider.ariaMessages.last.text, 'Test prompt');
    });
  });
}
