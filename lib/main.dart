import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/browser_provider.dart';
import 'widgets/opera_sidebar.dart';
import 'widgets/opera_top_bar.dart';
import 'widgets/aria_panel.dart';
import 'widgets/web_content_viewer.dart';

void main() {
  runApp(const OperaDreamworkApp());
}

class OperaDreamworkApp extends StatelessWidget {
  const OperaDreamworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrowserProvider(),
      child: Consumer<BrowserProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Opera Dreamwork Browser',
            debugShowCheckedModeBanner: false,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.redAccent,
              scaffoldBackgroundColor: const Color(0xFFF5F6F9),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.redAccent,
              scaffoldBackgroundColor: const Color(0xFF14171D),
            ),
            home: const MainBrowserScreen(),
          );
        },
      ),
    );
  }
}

class MainBrowserScreen extends StatefulWidget {
  const MainBrowserScreen({super.key});

  @override
  State<MainBrowserScreen> createState() => _MainBrowserScreenState();
}

class _MainBrowserScreenState extends State<MainBrowserScreen> {
  String _activeSection = 'speed_dial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Vertical Opera Sidebar
          OperaSidebar(
            activeSection: _activeSection,
            onSectionSelected: (section) {
              setState(() {
                _activeSection = section;
              });
            },
          ),

          // Aria AI Assistant Side Drawer (if opened)
          const AriaPanel(),

          // Main Content View (Top Bar + Web Content Viewer)
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar (Workspaces + Tabs + URL Bar + Shield/VPN)
                const OperaTopBar(),

                // Active Tab Content Viewer / Speed Dial / Section Manager
                Expanded(
                  child: WebContentViewer(
                    activeSection: _activeSection,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
