import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/browser_models.dart';
import '../providers/browser_provider.dart';

class SpeedDialPage extends StatefulWidget {
  const SpeedDialPage({super.key});

  @override
  State<SpeedDialPage> createState() => _SpeedDialPageState();
}

class _SpeedDialPageState extends State<SpeedDialPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(BrowserProvider provider, String query) {
    if (query.trim().isEmpty) return;
    String targetUrl = query.trim();
    if (!targetUrl.startsWith('http://') &&
        !targetUrl.startsWith('https://')) {
      if (targetUrl.contains('.')) {
        targetUrl = 'https://$targetUrl';
      } else {
        targetUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(targetUrl)}';
      }
    }
    provider.updateActiveTabUrl(targetUrl);
  }

  void _showAddSpeedDialDialog(BuildContext context, BrowserProvider provider) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: provider.isDarkMode ? const Color(0xFF282C37) : Colors.white,
        title: Text(
          'Add Speed Dial Tile',
          style: TextStyle(color: provider.isDarkMode ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: provider.isDarkMode ? Colors.white : Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Flutter',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              style: TextStyle(color: provider.isDarkMode ? Colors.white : Colors.black87),
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'e.g. flutter.dev',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                String u = urlController.text.trim();
                if (!u.startsWith('http')) u = 'https://$u';
                provider.addSpeedDial(titleController.text.trim(), u);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<Color> _getWallpaperGradient(String wallpaper) {
    switch (wallpaper) {
      case 'cyberpunk':
        return [const Color(0xFF0F0C29), const Color(0xFF302B63), const Color(0xFF24243E)];
      case 'dark_space':
        return [const Color(0xFF000000), const Color(0xFF130F40)];
      case 'gradient_blue':
      default:
        return [const Color(0xFF141E30), const Color(0xFF243B55)];
    }
  }

  IconData _getIconForTitle(String icon) {
    switch (icon) {
      case 'search':
        return Icons.search;
      case 'code':
        return Icons.code;
      case 'play_circle':
        return Icons.play_circle_fill;
      case 'menu_book':
        return Icons.menu_book;
      case 'forum':
        return Icons.forum;
      case 'newspaper':
        return Icons.newspaper;
      default:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BrowserProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getWallpaperGradient(provider.activeWallpaper),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dreamwork Branding
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF1B2D), Color(0xFFA80010)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'OPERA DREAMWORK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Search Box
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Search the web or type a URL...',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (q) => _handleSearch(provider, q),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.redAccent),
                        onPressed: () => _handleSearch(provider, _searchController.text),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Wallpaper Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Wallpaper: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  _buildWallpaperOption(provider, 'gradient_blue', 'Blue Gradient'),
                  const SizedBox(width: 8),
                  _buildWallpaperOption(provider, 'cyberpunk', 'Cyberpunk'),
                  const SizedBox(width: 8),
                  _buildWallpaperOption(provider, 'dark_space', 'Dark Space'),
                ],
              ),

              const SizedBox(height: 32),

              // Speed Dial Grid
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ...provider.speedDials.map((tile) {
                      return _buildSpeedDialTile(context, provider, tile);
                    }).toList(),

                    // Add Tile Button
                    InkWell(
                      onTap: () => _showAddSpeedDialDialog(context, provider),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12, width: 1.5),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white70, size: 28),
                            SizedBox(height: 6),
                            Text(
                              'Add Site',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWallpaperOption(BrowserProvider provider, String id, String name) {
    final isSelected = provider.activeWallpaper == id;
    return GestureDetector(
      onTap: () => provider.setWallpaper(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedDialTile(BuildContext context, BrowserProvider provider, Bookmark tile) {
    return InkWell(
      onTap: () => provider.updateActiveTabUrl(tile.url),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForTitle(tile.icon),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tile.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
