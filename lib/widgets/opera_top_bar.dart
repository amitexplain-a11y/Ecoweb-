import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/browser_provider.dart';

class OperaTopBar extends StatefulWidget {
  const OperaTopBar({super.key});

  @override
  State<OperaTopBar> createState() => _OperaTopBarState();
}

class _OperaTopBarState extends State<OperaTopBar> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _submitUrl(BrowserProvider provider, String text) {
    if (text.trim().isEmpty) return;
    String finalUrl = text.trim();
    if (!finalUrl.startsWith('http://') &&
        !finalUrl.startsWith('https://') &&
        !finalUrl.startsWith('opera://')) {
      if (finalUrl.contains('.')) {
        finalUrl = 'https://$finalUrl';
      } else {
        // Search query
        finalUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(finalUrl)}';
      }
    }
    provider.updateActiveTabUrl(finalUrl);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BrowserProvider>(context);
    final activeTab = provider.activeTab;

    if (activeTab != null && _urlController.text != activeTab.url) {
      _urlController.text = activeTab.isSpeedDial ? '' : activeTab.url;
    }

    final isDark = provider.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E222B) : const Color(0xFFEDEEF2);
    final addressBg = isDark ? const Color(0xFF282C37) : const Color(0xFFFFFFFF);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          // Row 1: Tab Bar
          SizedBox(
            height: 38,
            child: Row(
              children: [
                // Workspace Label Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        _getWorkspaceIcon(provider.activeWorkspace.iconName),
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        provider.activeWorkspace.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFB0B5C0) : const Color(0xFF555966),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1, indent: 8, endIndent: 8, color: Colors.grey),

                // Tabs list
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.currentWorkspaceTabs.length,
                    itemBuilder: (context, index) {
                      final tab = provider.currentWorkspaceTabs[index];
                      final isSelected = index == provider.activeTabIndex;

                      return GestureDetector(
                        onTap: () => provider.selectTab(index),
                        child: Container(
                          width: 180,
                          margin: const EdgeInsets.only(top: 4, right: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF282C37) : const Color(0xFFFFFFFF))
                                : (isDark ? const Color(0xFF181B20) : const Color(0xFFE0E2E8)),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            border: isSelected
                                ? Border.all(
                                    color: Colors.redAccent.withOpacity(0.8),
                                    width: 1.5,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                tab.isSpeedDial ? Icons.grid_view_rounded : Icons.language,
                                size: 14,
                                color: isSelected ? Colors.redAccent : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tab.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? textColor : Colors.grey,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => provider.closeTab(tab.id),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: isSelected ? textColor : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add Tab Button
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  color: isDark ? const Color(0xFFA0A5B5) : const Color(0xFF555966),
                  onPressed: () => provider.addTab(url: 'opera://startpage'),
                  tooltip: 'New Tab',
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          // Row 2: Navigation & Address Bar
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 18),
                  color: isDark ? const Color(0xFFA0A5B5) : const Color(0xFF555966),
                  onPressed: () {},
                  tooltip: 'Back',
                ),
                // Forward Button
                IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  color: isDark ? const Color(0xFFA0A5B5) : const Color(0xFF555966),
                  onPressed: () {},
                  tooltip: 'Forward',
                ),
                // Refresh Button
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  color: isDark ? const Color(0xFFA0A5B5) : const Color(0xFF555966),
                  onPressed: () {},
                  tooltip: 'Reload Page',
                ),

                const SizedBox(width: 8),

                // URL Address Bar
                Expanded(
                  child: Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: addressBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? const Color(0xFF383C4A) : const Color(0xFFCCCCCC),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        // Security Lock / Speed dial icon
                        Icon(
                          activeTab?.isSpeedDial == true ? Icons.grid_view : Icons.lock_outline,
                          size: 16,
                          color: activeTab?.isSpeedDial == true ? Colors.redAccent : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: TextStyle(fontSize: 13, color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Search with Google or enter address',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: isDark ? const Color(0xFF707585) : const Color(0xFF999999),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onSubmitted: (text) => _submitUrl(provider, text),
                          ),
                        ),
                        // Bookmark icon toggle
                        if (activeTab != null && !activeTab.isSpeedDial)
                          IconButton(
                            icon: Icon(
                              provider.isBookmarked(activeTab.url)
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 18,
                              color: provider.isBookmarked(activeTab.url)
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              provider.toggleBookmark(
                                activeTab.title,
                                activeTab.url,
                              );
                            },
                            tooltip: 'Bookmark Page',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Ad Blocker Toggle Indicator
                Tooltip(
                  message: provider.isAdBlockerEnabled
                      ? 'Ad Blocker: Enabled'
                      : 'Ad Blocker: Disabled',
                  child: InkWell(
                    onTap: () => provider.toggleAdBlocker(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: provider.isAdBlockerEnabled
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: provider.isAdBlockerEnabled ? Colors.blue : Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield,
                            size: 14,
                            color: provider.isAdBlockerEnabled ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Shield',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: provider.isAdBlockerEnabled ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // VPN Indicator
                Tooltip(
                  message: provider.isVpnEnabled ? 'VPN: Active' : 'VPN: Inactive',
                  child: InkWell(
                    onTap: () => provider.toggleVpn(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: provider.isVpnEnabled
                            ? Colors.green.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: provider.isVpnEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.vpn_key,
                            size: 14,
                            color: provider.isVpnEnabled ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'VPN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: provider.isVpnEnabled ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWorkspaceIcon(String name) {
    switch (name) {
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
}
