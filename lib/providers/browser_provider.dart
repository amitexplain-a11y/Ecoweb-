import 'package:flutter/material.dart';
import '../models/browser_models.dart';

class BrowserProvider extends ChangeNotifier {
  // Workspaces
  final List<Workspace> _workspaces = [
    Workspace(id: 'default', name: 'Work', iconName: 'work_outline'),
    Workspace(id: 'personal', name: 'Personal', iconName: 'person_outline'),
    Workspace(id: 'gaming', name: 'Gaming', iconName: 'sports_esports_outlined'),
  ];
  String _activeWorkspaceId = 'default';

  // Tabs
  final List<TabInfo> _tabs = [];
  int _activeTabIndex = 0;

  // Bookmarks (Speed Dial & Favorites)
  final List<Bookmark> _speedDials = [
    Bookmark(id: '1', title: 'Google', url: 'https://www.google.com', icon: 'search'),
    Bookmark(id: '2', title: 'GitHub', url: 'https://github.com', icon: 'code'),
    Bookmark(id: '3', title: 'YouTube', url: 'https://www.youtube.com', icon: 'play_circle'),
    Bookmark(id: '4', title: 'Wikipedia', url: 'https://www.wikipedia.org', icon: 'menu_book'),
    Bookmark(id: '5', title: 'Reddit', url: 'https://www.reddit.com', icon: 'forum'),
    Bookmark(id: '6', title: 'Tech News', url: 'https://news.ycombinator.com', icon: 'newspaper'),
  ];
  final List<Bookmark> _bookmarks = [];

  // History
  final List<HistoryItem> _history = [];

  // Aria AI Chat
  final List<ChatMessage> _ariaMessages = [
    ChatMessage(
      id: '0',
      sender: 'aria',
      text: 'Hello! I am Aria, your Opera AI assistant powered by Dreamwork. How can I assist your browsing today?',
      timestamp: DateTime.now(),
    ),
  ];
  bool _isAriaPanelOpen = false;

  // Browser Settings & Toggles
  bool _isAdBlockerEnabled = true;
  bool _isVpnEnabled = false;
  bool _isDarkMode = true;
  String _activeWallpaper = 'gradient_blue'; // 'gradient_blue', 'cyberpunk', 'dark_space'

  BrowserProvider() {
    // Default initial tab
    addTab(url: 'opera://startpage', title: 'Speed Dial');
  }

  // Getters
  List<Workspace> get workspaces => _workspaces;
  String get activeWorkspaceId => _activeWorkspaceId;
  Workspace get activeWorkspace => _workspaces.firstWhere(
        (w) => w.id == _activeWorkspaceId,
        orElse: () => _workspaces.first,
      );

  List<TabInfo> get allTabs => _tabs;
  List<TabInfo> get currentWorkspaceTabs =>
      _tabs.where((t) => t.workspaceId == _activeWorkspaceId).toList();

  int get activeTabIndex => _activeTabIndex;
  TabInfo? get activeTab {
    final workspaceTabs = currentWorkspaceTabs;
    if (workspaceTabs.isEmpty) return null;
    if (_activeTabIndex >= workspaceTabs.length) {
      _activeTabIndex = workspaceTabs.length - 1;
    }
    return workspaceTabs[_activeTabIndex];
  }

  List<Bookmark> get speedDials => _speedDials;
  List<Bookmark> get bookmarks => _bookmarks;
  List<HistoryItem> get history => _history;
  List<ChatMessage> get ariaMessages => _ariaMessages;
  bool get isAriaPanelOpen => _isAriaPanelOpen;
  bool get isAdBlockerEnabled => _isAdBlockerEnabled;
  bool get isVpnEnabled => _isVpnEnabled;
  bool get isDarkMode => _isDarkMode;
  String get activeWallpaper => _activeWallpaper;

  // Workspace Actions
  void switchWorkspace(String workspaceId) {
    _activeWorkspaceId = workspaceId;
    _activeTabIndex = 0;
    if (currentWorkspaceTabs.isEmpty) {
      addTab(url: 'opera://startpage', title: 'Speed Dial');
    }
    notifyListeners();
  }

  // Tab Actions
  void addTab({required String url, String title = 'New Tab'}) {
    String finalTitle = title;
    if (url == 'opera://startpage') {
      finalTitle = 'Speed Dial';
    } else if (title == 'New Tab') {
      finalTitle = _extractTitleFromUrl(url);
    }

    final newTab = TabInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: finalTitle,
      url: url,
      workspaceId: _activeWorkspaceId,
    );
    _tabs.add(newTab);
    _activeTabIndex = currentWorkspaceTabs.length - 1;

    if (!newTab.isSpeedDial) {
      addToHistory(newTab.title, newTab.url);
    }
    notifyListeners();
  }

  void closeTab(String tabId) {
    final workspaceTabs = currentWorkspaceTabs;
    final indexToClose = workspaceTabs.indexWhere((t) => t.id == tabId);

    _tabs.removeWhere((t) => t.id == tabId);

    if (currentWorkspaceTabs.isEmpty) {
      addTab(url: 'opera://startpage', title: 'Speed Dial');
    } else if (indexToClose <= _activeTabIndex && _activeTabIndex > 0) {
      _activeTabIndex--;
    }
    notifyListeners();
  }

  void selectTab(int index) {
    if (index >= 0 && index < currentWorkspaceTabs.length) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void updateActiveTabUrl(String newUrl) {
    final tab = activeTab;
    if (tab == null) return;

    tab.url = newUrl;
    if (newUrl == 'opera://startpage') {
      tab.title = 'Speed Dial';
    } else {
      tab.title = _extractTitleFromUrl(newUrl);
      addToHistory(tab.title, tab.url);
    }
    notifyListeners();
  }

  void setTabLoading(String tabId, bool isLoading) {
    final tabIndex = _tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex != -1) {
      _tabs[tabIndex].isLoading = isLoading;
      notifyListeners();
    }
  }

  // History Actions
  void addToHistory(String title, String url) {
    if (url.isEmpty || url == 'opera://startpage') return;
    _history.insert(
      0,
      HistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        url: url,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  // Bookmarks & Speed Dial
  void addSpeedDial(String title, String url) {
    _speedDials.add(Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      url: url,
    ));
    notifyListeners();
  }

  void toggleBookmark(String title, String url) {
    final existingIndex = _bookmarks.indexWhere((b) => b.url == url);
    if (existingIndex != -1) {
      _bookmarks.removeAt(existingIndex);
    } else {
      _bookmarks.add(Bookmark(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        url: url,
      ));
    }
    notifyListeners();
  }

  bool isBookmarked(String url) {
    return _bookmarks.any((b) => b.url == url);
  }

  // Aria AI Panel
  void toggleAriaPanel() {
    _isAriaPanelOpen = !_isAriaPanelOpen;
    notifyListeners();
  }

  void sendAriaMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    );
    _ariaMessages.add(userMsg);
    notifyListeners();

    // Simulated Aria AI Smart Response
    Future.delayed(const Duration(milliseconds: 600), () {
      String response = _generateAriaResponse(text);
      _ariaMessages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: 'aria',
        text: response,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    });
  }

  // Feature Toggles
  void toggleAdBlocker() {
    _isAdBlockerEnabled = !_isAdBlockerEnabled;
    notifyListeners();
  }

  void toggleVpn() {
    _isVpnEnabled = !_isVpnEnabled;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setWallpaper(String wallpaper) {
    _activeWallpaper = wallpaper;
    notifyListeners();
  }

  String _extractTitleFromUrl(String rawUrl) {
    if (rawUrl.isEmpty) return 'New Tab';
    try {
      String formatted = rawUrl;
      if (!formatted.startsWith('http://') && !formatted.startsWith('https://')) {
        formatted = 'https://$formatted';
      }
      final uri = Uri.parse(formatted);
      return uri.host.isNotEmpty ? uri.host : rawUrl;
    } catch (_) {
      return rawUrl;
    }
  }

  String _generateAriaResponse(String query) {
    final lower = query.toLowerCase();
    if (lower.contains('summary') || lower.contains('summarize')) {
      return 'Here is a quick summary of the active webpage: Flutter Dreamwork is an Opera-style high performance web experience created with Flutter Dart.';
    } else if (lower.contains('wallpaper') || lower.contains('theme')) {
      return 'You can change your Speed Dial wallpaper and theme mode from the settings icon on the sidebar!';
    } else if (lower.contains('tab') || lower.contains('workspace')) {
      return 'Dreamwork allows you to create separate workspaces (Work, Personal, Gaming) to organize your active tabs efficiently.';
    } else {
      return 'I have analyzed "$query". Dreamwork AI Assistant can help you search, summarize content, or organize your tabs!';
    }
  }
}
