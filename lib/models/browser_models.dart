class TabInfo {
  final String id;
  String title;
  String url;
  String faviconUrl;
  bool isLoading;
  final String workspaceId;

  TabInfo({
    required this.id,
    required this.title,
    required this.url,
    this.faviconUrl = '',
    this.isLoading = false,
    this.workspaceId = 'default',
  });

  bool get isSpeedDial => url == 'opera://startpage' || url.isEmpty;
}

class Bookmark {
  final String id;
  final String title;
  final String url;
  final String icon;

  Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.icon = 'public',
  });
}

class HistoryItem {
  final String id;
  final String title;
  final String url;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.title,
    required this.url,
    required this.timestamp,
  });
}

class Workspace {
  final String id;
  final String name;
  final String iconName;

  Workspace({
    required this.id,
    required this.name,
    required this.iconName,
  });
}

class ChatMessage {
  final String id;
  final String sender; // 'user' or 'aria'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}
