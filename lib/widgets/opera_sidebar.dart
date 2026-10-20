import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';

class OperaSidebar extends StatelessWidget {
  final Function(String section) onSectionSelected;
  final String activeSection;

  const OperaSidebar({
    super.key,
    required this.onSectionSelected,
    required this.activeSection,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work_outline':
        return Icons.work_outline;
      case 'person_outline':
        return Icons.person_outline;
      case 'sports_esports_outlined':
        return Icons.sports_esports_outlined;
      default:
        return Icons.folder_open;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BrowserProvider>(context);

    return Container(
      width: 58,
      decoration: BoxDecoration(
        color: provider.isDarkMode ? const Color(0xFF181B20) : const Color(0xFFE3E5EB),
        border: Border(
          right: BorderSide(
            color: provider.isDarkMode ? const Color(0xFF2B2E38) : const Color(0xFFCCCCCC),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Opera Logo / Brand
          Tooltip(
            message: 'Opera Dreamwork',
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF1B2D), Color(0xFFA80010)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'O',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'sans-serif',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFF333642)),
          const SizedBox(height: 12),

          // Aria AI Assistant Button
          Tooltip(
            message: 'Aria AI Assistant',
            child: InkWell(
              onTap: () => provider.toggleAriaPanel(),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: provider.isAriaPanelOpen
                      ? const Color(0xFF7B2CBF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: provider.isAriaPanelOpen ? Colors.white : const Color(0xFFA0A5B5),
                  size: 22,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFF333642)),
          const SizedBox(height: 12),

          // Workspaces
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...provider.workspaces.map((workspace) {
                  final isSelected = provider.activeWorkspaceId == workspace.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Tooltip(
                      message: 'Workspace: ${workspace.name}',
                      child: InkWell(
                        onTap: () => provider.switchWorkspace(workspace.id),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (provider.isDarkMode
                                    ? const Color(0xFF2C313E)
                                    : const Color(0xFFC5C8D4))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(color: Colors.redAccent, width: 1.5)
                                : null,
                          ),
                          child: Icon(
                            _getIconData(workspace.iconName),
                            color: isSelected
                                ? Colors.redAccent
                                : (provider.isDarkMode
                                    ? const Color(0xFF9096A8)
                                    : const Color(0xFF555966)),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFF333642)),
                const SizedBox(height: 12),

                // Quick Navigation Shortcuts
                _buildSidebarItem(
                  context: context,
                  id: 'speed_dial',
                  icon: Icons.grid_view_rounded,
                  label: 'Speed Dial',
                  isSelected: activeSection == 'speed_dial',
                  onTap: () {
                    provider.addTab(url: 'opera://startpage');
                    onSectionSelected('speed_dial');
                  },
                ),
                _buildSidebarItem(
                  context: context,
                  id: 'bookmarks',
                  icon: Icons.bookmark_border_rounded,
                  label: 'Bookmarks',
                  isSelected: activeSection == 'bookmarks',
                  onTap: () => onSectionSelected('bookmarks'),
                ),
                _buildSidebarItem(
                  context: context,
                  id: 'history',
                  icon: Icons.history_rounded,
                  label: 'History',
                  isSelected: activeSection == 'history',
                  onTap: () => onSectionSelected('history'),
                ),
              ],
            ),
          ),

          // Bottom Settings / Theme Toggle
          Tooltip(
            message: 'Toggle Theme Mode',
            child: IconButton(
              icon: Icon(
                provider.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                color: const Color(0xFFA0A5B5),
                size: 20,
              ),
              onPressed: () => provider.toggleTheme(),
            ),
          ),
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFFA0A5B5),
                size: 20,
              ),
              onPressed: () => onSectionSelected('settings'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required BuildContext context,
    required String id,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final provider = Provider.of<BrowserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? (provider.isDarkMode
                      ? const Color(0xFF2C313E)
                      : const Color(0xFFC5C8D4))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.redAccent
                  : (provider.isDarkMode ? const Color(0xFF9096A8) : const Color(0xFF555966)),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
