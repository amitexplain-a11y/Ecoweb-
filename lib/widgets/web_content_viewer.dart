import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';
import 'speed_dial_page.dart';

class WebContentViewer extends StatefulWidget {
  final String activeSection;

  const WebContentViewer({
    super.key,
    required this.activeSection,
  });

  @override
  State<WebContentViewer> createState() => _WebContentViewerState();
}

class _WebContentViewerState extends State<WebContentViewer> {
  Widget _buildWebContentView(String tabId, String url) {
    return Container(
      color: const Color(0xFF12141A),
      child: Column(
        children: [
          // Simulated Website Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1A1D24),
            child: Row(
              children: [
                const Icon(Icons.language, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rendering: $url',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DREAMWORK ENGINE ACTIVE',
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.public,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Web Content Loaded via Dreamwork Engine',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      url,
                      style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                      label: const Text('Interact with Web View', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BrowserProvider>(context);

    // If active section is Bookmarks, History, or Settings
    if (widget.activeSection == 'bookmarks') {
      return _buildBookmarksSection(provider);
    } else if (widget.activeSection == 'history') {
      return _buildHistorySection(provider);
    } else if (widget.activeSection == 'settings') {
      return _buildSettingsSection(provider);
    }

    final activeTab = provider.activeTab;

    if (activeTab == null || activeTab.isSpeedDial) {
      return const SpeedDialPage();
    }

    return _buildWebContentView(activeTab.id, activeTab.url);
  }

  Widget _buildBookmarksSection(BrowserProvider provider) {
    final isDark = provider.isDarkMode;
    return Container(
      color: isDark ? const Color(0xFF14171D) : const Color(0xFFF5F6F9),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark_rounded, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                'Bookmarks Manager',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: provider.bookmarks.isEmpty
                ? Center(
                    child: Text(
                      'No bookmarks added yet. Click the star icon in the address bar to bookmark a page.',
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.bookmarks.length,
                    itemBuilder: (context, index) {
                      final b = provider.bookmarks[index];
                      return Card(
                        color: isDark ? const Color(0xFF222630) : Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(
                            b.title,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          ),
                          subtitle: Text(
                            b.url,
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => provider.toggleBookmark(b.title, b.url),
                          ),
                          onTap: () => provider.addTab(url: b.url, title: b.title),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BrowserProvider provider) {
    final isDark = provider.isDarkMode;
    return Container(
      color: isDark ? const Color(0xFF14171D) : const Color(0xFFF5F6F9),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                'Browsing History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              if (provider.history.isNotEmpty)
                TextButton.icon(
                  onPressed: () => provider.clearHistory(),
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  label: const Text('Clear History', style: TextStyle(color: Colors.redAccent)),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: provider.history.isEmpty
                ? Center(
                    child: Text(
                      'Browsing history is clear.',
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.history.length,
                    itemBuilder: (context, index) {
                      final item = provider.history[index];
                      return Card(
                        color: isDark ? const Color(0xFF222630) : Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.language, color: Colors.blue),
                          title: Text(
                            item.title,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          ),
                          subtitle: Text(
                            item.url,
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                          trailing: Text(
                            '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                          ),
                          onTap: () => provider.addTab(url: item.url, title: item.title),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BrowserProvider provider) {
    final isDark = provider.isDarkMode;
    return Container(
      color: isDark ? const Color(0xFF14171D) : const Color(0xFFF5F6F9),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_rounded, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                'Opera Dreamwork Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text('Ad & Tracker Blocker (Shield)', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            subtitle: Text('Block intrusive ads and tracking scripts across web pages', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
            value: provider.isAdBlockerEnabled,
            activeColor: Colors.blue,
            onChanged: (_) => provider.toggleAdBlocker(),
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Opera Free Built-in VPN', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            subtitle: Text('Encrypt browsing connection and protect online privacy', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
            value: provider.isVpnEnabled,
            activeColor: Colors.green,
            onChanged: (_) => provider.toggleVpn(),
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Dark Theme Mode', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
            subtitle: Text('Switch application UI theme', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
            value: provider.isDarkMode,
            activeColor: Colors.redAccent,
            onChanged: (_) => provider.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
