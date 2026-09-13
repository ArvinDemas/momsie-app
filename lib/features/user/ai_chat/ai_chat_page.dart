import 'package:douce/features/user/ai_chat/ai_chat_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/theme_service.dart';
import 'package:douce/shared/util/service/subscription_service.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SubscriptionService.to.showPaywall(
          context: context,
          featureName: 'AI Chatbot Unlimited',
          canDismissToAccess: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showHistoryModal(BuildContext context, AiChatController c) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history_rounded, color: Color(0xFFFF6B8B)),
                    SizedBox(width: 8),
                    Text(
                      'Riwayat Percakapan AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: Obx(() {
                if (c.sessions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Belum ada riwayat percakapan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: c.sessions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final session = c.sessions[i];
                    final isSelected = session.id == c.currentSessionId.value;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? const Color(0xFFFF6B8B).withOpacity(0.2)
                            : Colors.grey.shade100,
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: isSelected ? const Color(0xFFFF6B8B) : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? const Color(0xFFFF6B8B) : AppSemanticColors.textDark,
                        ),
                      ),
                      subtitle: Text(
                        '${session.messages.length} pesan • ${_formatDate(session.createdAt)}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                        onPressed: () => Get.defaultDialog(
                          title: 'Hapus Percakapan?',
                          middleText: 'Sesi percakapan ini akan dihapus permanen.',
                          textConfirm: 'Hapus',
                          textCancel: 'Batal',
                          buttonColor: Colors.red,
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            Get.back();
                            c.deleteSession(session.id);
                          },
                        ),
                      ),
                      onTap: () {
                        c.switchSession(session);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                c.createNewChat();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Mulai Chat Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Gemini AI Style Welcoming Canvas (Sparkle Icon + Centered Headline + Quick Suggestion Chips)
  Widget _buildGeminiWelcomingCanvas(BuildContext context, AiChatController c) {
    final List<Map<String, String>> suggestionChips = [
      {
        'title': 'Pertanda Awal Persalinan',
        'prompt': 'Apa saja tanda-tanda awal persalinan yang perlu diperhatikan?',
        'icon': 'Icons.medical_services_rounded',
      },
      {
        'title': 'Yoga Trimester 3',
        'prompt': 'Apa saja gerakan yoga yang aman dan bermanfaat untuk trimester 3?',
        'icon': 'Icons.sports_yoga_rounded',
      },
      {
        'title': 'Nutrisi Cegah Anemia',
        'prompt': 'Makanan dan nutrisi apa saja yang ampuh mencegah anemia saat hamil?',
        'icon': 'Icons.eco_rounded',
      },
      {
        'title': 'Tas Bersalin ke RS',
        'prompt': 'Apa saja daftar barang wajib di dalam Hospital Bag untuk persalinan?',
        'icon': 'Icons.backpack_rounded',
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // 1. Glowing Robot Logo (Consistent Momsie AI Icon)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [const Color(0xFFBE185D), const Color(0xFFF472B6), const Color(0xFFFFD1DC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: AppElevation.softColor(const Color(0xFFBE185D)),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Large Centered Welcoming Headline (Exact Gemini Style)
          const Text(
            "Halo Bunda, apa yang ingin\nAnda tanyakan hari ini?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppSemanticColors.textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tanyakan seputar nutrisi, kesehatan janin, persalinan & laktasi 24/7",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppSemanticColors.textSecondary,
            ),
          ),

          const SizedBox(height: 36),

          // 3. Suggestion Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: suggestionChips.map((chip) {
              return InkWell(
                onTap: () {
                  c.messageCtrl.text = chip['prompt']!;
                  c.sendMessage();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: AppElevation.level1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(chip['icon']!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(
                        chip['title']!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppSemanticColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AiChatController c = Get.put(AiChatController());
    final ThemeService ts = Get.find<ThemeService>();

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // AppBar Header
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: AppElevation.level1,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      // Avatar Gemini AI
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBE185D).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: const Color(0xFFBE185D),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Momsie AI Assistant',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.textDark,
                              ),
                            ),
                            Text(
                              'Spesialis Kehamilan & Laktasi 24/7',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Button Tambah Chat Baru (+)
                      IconButton(
                        tooltip: 'Tambah Chat Baru',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ColorDouce.douceBase.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded, color: Color(0xFFFF6B8B), size: 20),
                        ),
                        onPressed: () => c.createNewChat(),
                      ),

                      // Button Menu Riwayat Chat
                      IconButton(
                        tooltip: 'Riwayat Chat',
                        icon: Icon(Icons.history_rounded, color: AppSemanticColors.textSecondary),
                        onPressed: () => _showHistoryModal(context, c),
                      ),
                    ],
                  ),
                ),

                // Medical Disclaimer Sub-header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  color: const Color(0xFF0284C7).withOpacity(0.08),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: Color(0xFF0284C7)),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Edukasi medis terverifikasi Kemenkes/WHO. Bukan pengganti diagnosis dokter.',
                          style: TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                // Messages List OR Gemini Welcoming Canvas
                Expanded(
                  child: Obx(() {
                    if (c.showWelcomingCanvas) {
                      return _buildGeminiWelcomingCanvas(context, c);
                    }
                    _scrollToBottom();
                    return ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      itemCount: c.messages.length,
                      itemBuilder: (_, i) {
                        final msg = c.messages[i];
                        return _MessageBubble(
                          msg: msg,
                          themeColor: ts.primary,
                        );
                      },
                    );
                  }),
                ),

                // Typing indicator
                Obx(() => c.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppElevation.level1,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B8B)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Momsie AI sedang berpikir...',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                // Input Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    boxShadow: AppElevation.level1,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: c.messageCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Tanyakan sesuatu tentang kehamilan...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF6B8B),
                                width: 1.5,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => c.sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: c.isLoading.value ? null : c.sendMessage,
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: c.isLoading.value
                                      ? Colors.grey.shade300
                                      : ColorDouce.douceBase,
                                  shape: BoxShape.circle,
                                  boxShadow: c.isLoading.value
                                      ? []
                                      : AppElevation.softColor(ColorDouce.douceBase),
                                ),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )),
                    ],
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

class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final Color themeColor;

  const _MessageBubble({
    required this.msg,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == 'user';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFBE185D).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: const Color(0xFFBE185D),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? ColorDouce.douceBase : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: isUser
                    ? []
                    : AppElevation.level1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormattedText(msg.text, isUser),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isUser ? Colors.white.withOpacity(0.7) : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: ColorDouce.douceBase.withOpacity(0.2),
              child: Icon(
                Icons.person_rounded,
                color: ColorDouce.douceBase,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormattedText(String rawText, bool isUser) {
    final baseStyle = TextStyle(
      fontSize: 14,
      height: 1.45,
      color: isUser ? Colors.white : AppSemanticColors.textDark,
    );

    // Replace list bullet asterisks at the beginning of lines
    String cleaned = rawText.replaceAll(RegExp(r'^\*\s+', multiLine: true), '• ');

    if (!cleaned.contains('*')) {
      return SelectableText(cleaned, style: baseStyle);
    }

    final spans = <TextSpan>[];
    final regExp = RegExp(r'(\*\*.*?\*\*|\*.*?\*|[^\*]+)');
    final matches = regExp.allMatches(cleaned);

    for (final match in matches) {
      final str = match.group(0) ?? '';
      if (str.isEmpty) continue;

      if (str.startsWith('**') && str.endsWith('**') && str.length > 4) {
        final content = str.substring(2, str.length - 2);
        spans.add(
          TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isUser ? Colors.white : const Color(0xFF0284C7),
            ),
          ),
        );
      } else if (str.startsWith('*') && str.endsWith('*') && str.length > 2) {
        final content = str.substring(1, str.length - 1);
        spans.add(
          TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        final cleanStr = str.replaceAll('*', '');
        spans.add(TextSpan(text: cleanStr, style: baseStyle));
      }
    }

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }
}
