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
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      // Avatar
                      CircleAvatar(
                        backgroundColor: ColorDouce.douceBase,
                        radius: 18,
                        child: const Text('🌸',
                            style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Momsie AI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            Text(
                              'Asisten kehamilan personalmu',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // API Key button
                      Obx(() => IconButton(
                            tooltip: c.hasApiKey.value
                                ? 'API Key: ${c.apiKeyPreview.value}'
                                : 'Atur API Key',
                            icon: Icon(
                              c.hasApiKey.value
                                  ? Icons.vpn_key_rounded
                                  : Icons.vpn_key_outlined,
                              color: c.hasApiKey.value
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            onPressed: () =>
                                _showApiKeyDialog(context, c),
                          )),
                      // Clear history
                      IconButton(
                        tooltip: 'Hapus riwayat',
                        icon: const Icon(Icons.delete_sweep_outlined),
                        onPressed: () => Get.defaultDialog(
                          title: 'Hapus Riwayat?',
                          middleText:
                              'Semua pesan akan dihapus.',
                          textConfirm: 'Hapus',
                          textCancel: 'Batal',
                          buttonColor: Colors.red,
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

                // No API key banner
                Obx(() => !c.hasApiKey.value
                    ? GestureDetector(
                        onTap: () => _showApiKeyDialog(context, c),
                        child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.orange, size: 18),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Ketuk di sini untuk memasukkan Gemini API key '
                                  'agar chatbot aktif. API key gratis dari Google AI Studio.',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange),
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Colors.orange, size: 18),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),

                // Messages
                Expanded(
                  child: Obx(() {
                    _scrollToBottom();
                    return ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                        padding:
                            const EdgeInsets.only(left: 20, bottom: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: ColorDouce.douceBase,
                              radius: 14,
                              child: const Text('🌸',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.06),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Row(
                                children: List.generate(
                                  3,
                                  (i) => _DotAnimation(
                                      delay: i * 200),
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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Row(
                          children: [
                            '🤰 Tips trimester 1',
                            '🥗 Makanan ibu hamil',
                            '💊 Vitamin prenatal',
                            '😰 Mengatasi morning sickness',
                          ].map((s) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                label: Text(s,
                                    style:
                                        const TextStyle(fontSize: 11)),
                                onPressed: () {
                                  c.messageCtrl.text = s;
                                  c.sendMessage();
                                },
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: ts.primary.withValues(
                                        alpha: 0.3)),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : const SizedBox.shrink()),

                // Input bar
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
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
                          decoration: InputDecoration(
                            hintText:
                                'Tanya seputar kehamilan...',
                            hintStyle: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => GestureDetector(
                            onTap: c.isLoading.value
                                ? null
                                : c.sendMessage,
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.isLoading.value
                                    ? Colors.grey[300]
                                    : ts.primary,
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.vpn_key_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Gemini API Key', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dapatkan API key gratis di:\ngoogle.aistudio.com',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Obx(() => TextField(
                  controller: keyCtrl,
                  obscureText: obscure.value,
                  decoration: InputDecoration(
                    hintText: 'Masukkan API key...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => obscure.value = !obscure.value,
                    ),
                  ),
                )),
            if (c.hasApiKey.value) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  c.removeApiKey();
                  Get.back();
                },
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 16),
                label: const Text('Hapus API Key',
                    style:
                        TextStyle(color: Colors.red, fontSize: 12)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: Get.back,
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => c.saveApiKey(keyCtrl.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
  const _MessageBubble(
      {required this.msg, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == 'user';
    final timeStr =
        '${msg.time.hour.toString().padLeft(2, '0')}:'
        '${msg.time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: ColorDouce.douceBase,
              radius: 14,
              child:
                  const Text('🌸', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? themeColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUser ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timeStr,
                  style: const TextStyle(
                      fontSize: 9, color: Colors.grey),
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

class _DotAnimationState extends State<_DotAnimation>
    with SingleTickerProviderStateMixin {
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
              color: ColorDouce.douceBase.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
