import 'package:douce/features/user/ai_chat/ai_chat_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/theme_service.dart';
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B8B).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: Color(0xFFFF6B8B),
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
                                color: Color(0xFF0F172A),
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
                      // Key settings
                      Obx(() => IconButton(
                            tooltip: c.hasCustomApiKey.value
                                ? 'Custom Key: ${c.apiKeyPreview.value}'
                                : 'Pengaturan API Key',
                            icon: Icon(
                              Icons.key_rounded,
                              color: c.hasCustomApiKey.value
                                  ? const Color(0xFFFF6B8B)
                                  : Colors.grey,
                            ),
                            onPressed: () => _showApiKeyDialog(context, c),
                          )),
                      // Clear history
                      IconButton(
                        tooltip: 'Hapus riwayat',
                        icon: const Icon(Icons.delete_sweep_rounded),
                        onPressed: () => Get.defaultDialog(
                          title: 'Hapus Riwayat?',
                          middleText: 'Semua pesan akan dibersihkan dari layar.',
                          textConfirm: 'Hapus',
                          textCancel: 'Batal',
                          buttonColor: const Color(0xFFFF6B8B),
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            Get.back();
                            c.clearHistory();
                          },
                        ),
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

                // Messages List
                Expanded(
                  child: Obx(() {
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
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B8B).withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.smart_toy_rounded,
                                color: Color(0xFFFF6B8B),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Row(
                                children: List.generate(
                                  3,
                                  (i) => _DotAnimation(delay: i * 200),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                // Quick suggestion chips
                Obx(() => c.messages.length <= 1
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                          children: [
                            '🥑 Perkembangan janin minggu ini',
                            '🥗 Nutrisi penambah sel darah ibu hamil',
                            '💊 Panduan konsumsi Asam Folat & DHA',
                            '😰 Solusi mual morning sickness',
                          ].map((s) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                label: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                onPressed: () {
                                  c.messageCtrl.text = s;
                                  c.sendMessage();
                                },
                                backgroundColor: Colors.white,
                                side: BorderSide(color: ts.primary.withOpacity(0.3)),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : const SizedBox.shrink()),

                // Input bar
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: c.messageCtrl,
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => c.sendMessage(),
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tanyakan seputar kehamilan & Si Kecil...',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => GestureDetector(
                            onTap: c.isLoading.value ? null : c.sendMessage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.isLoading.value ? Colors.grey[300] : ColorDouce.douceBase,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
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

  void _showApiKeyDialog(BuildContext context, AiChatController c) {
    final keyCtrl = TextEditingController();
    final obscure = true.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.key_rounded, color: Color(0xFFFF6B8B)),
            SizedBox(width: 8),
            Text('Gemini / Custom API Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aplikasi menggunakan API Key default aktif. Anda dapat menggantinya dengan Kunci API Anda sendiri:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Obx(() => TextField(
                  controller: keyCtrl,
                  obscureText: obscure.value,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Tempel API key custom...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => obscure.value = !obscure.value,
                    ),
                  ),
                )),
            if (c.hasCustomApiKey.value) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  c.removeApiKey();
                  Get.back();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.blue, size: 16),
                label: const Text('Reset ke Key Default', style: TextStyle(color: Colors.blue, fontSize: 12)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => c.saveApiKey(keyCtrl.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final Color themeColor;
  const _MessageBubble({required this.msg, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == 'user';
    final timeStr = '${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B8B).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Color(0xFFFF6B8B),
                size: 16,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.76,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? ColorDouce.douceBase : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUser ? Colors.white : const Color(0xFF0F172A),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _DotAnimation extends StatefulWidget {
  final int delay;
  const _DotAnimation({required this.delay});

  @override
  State<_DotAnimation> createState() => _DotAnimationState();
}

class _DotAnimationState extends State<_DotAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Transform.translate(
          offset: Offset(0, _anim.value),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: ColorDouce.douceBase.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
