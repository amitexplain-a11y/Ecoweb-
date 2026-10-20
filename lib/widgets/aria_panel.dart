import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/browser_models.dart';
import '../providers/browser_provider.dart';

class AriaPanel extends StatefulWidget {
  const AriaPanel({super.key});

  @override
  State<AriaPanel> createState() => _AriaPanelState();
}

class _AriaPanelState extends State<AriaPanel> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BrowserProvider provider) {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    provider.sendAriaMessage(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BrowserProvider>(context);

    if (!provider.isAriaPanelOpen) return const SizedBox.shrink();

    final isDark = provider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF1E1A29) : const Color(0xFFF4EFFA);
    final cardBg = isDark ? const Color(0xFF2B2538) : const Color(0xFFFFFFFF);
    final userBubbleColor = const Color(0xFF7B2CBF);
    final ariaBubbleColor = isDark ? const Color(0xFF383049) : const Color(0xFFE8DEF8);

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(
            color: isDark ? const Color(0xFF3B334B) : const Color(0xFFD8CEEB),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF282236) : const Color(0xFFEADDFF),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF3B334B) : const Color(0xFFD8CEEB),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aria AI Assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Powered by Dreamwork AI',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: isDark ? Colors.white70 : Colors.black54,
                  onPressed: () => provider.toggleAriaPanel(),
                  tooltip: 'Close Aria Panel',
                ),
              ],
            ),
          ),

          // Quick Action Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickPrompt(provider, 'Summarize Page', 'Summarize this page'),
                  const SizedBox(width: 6),
                  _buildQuickPrompt(provider, 'Explain Code', 'Explain the code on this page'),
                  const SizedBox(width: 6),
                  _buildQuickPrompt(provider, 'Key Takeaways', 'Give me key takeaways'),
                ],
              ),
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: provider.ariaMessages.length,
              itemBuilder: (context, index) {
                final msg = provider.ariaMessages[index];
                final isUser = msg.sender == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 240),
                    decoration: BoxDecoration(
                      color: isUser ? userBubbleColor : ariaBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isUser ? 14 : 2),
                        bottomRight: Radius.circular(isUser ? 2 : 14),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: isUser
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(12),
            color: cardBg,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask Aria anything...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E1A29) : const Color(0xFFF0E8F8),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(provider),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _sendMessage(provider),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF7B2CBF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompt(BrowserProvider provider, String label, String prompt) {
    final isDark = provider.isDarkMode;
    return InkWell(
      onTap: () => provider.sendAriaMessage(prompt),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF332B40) : const Color(0xFFE8DEF8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF4A3F5E) : const Color(0xFFD0BCFF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFD0BCFF) : const Color(0xFF6750A4),
          ),
        ),
      ),
    );
  }
}
