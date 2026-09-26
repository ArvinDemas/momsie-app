import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/chat/chat_controller.dart';
import 'package:douce/features/user/chat/chat_model.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:douce/shared/theme/design_system.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static String _addHour(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return '$time +1j';
    final hour = int.tryParse(parts[0]) ?? 0;
    return '${(hour + 1).toString().padLeft(2, '0')}:${parts[1]}';
  }

  static Widget _buildAvatar(bool isDoulaSender, ChatController chatController) {
    final image = isDoulaSender ? chatController.imageDoula.value : chatController.imageUser.value;
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDoulaSender
              ? ColorDouce.douceBase.withValues(alpha: 0.35)
              : const Color(0xFF0F766E).withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: image.isNotEmpty && (image.startsWith('http://') || image.startsWith('https://'))
            ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Image.asset('assets/images/blank-profile.png', fit: BoxFit.cover),
              )
            : image.isNotEmpty && image.startsWith('assets/')
                ? Image.asset(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.asset('assets/images/blank-profile.png', fit: BoxFit.cover))
                : Image.asset('assets/images/blank-profile.png', fit: BoxFit.cover),
      ),
    );
  }

  static Widget _buildMessageItem(
    ChatModel message,
    ChatController chatController,
    String doula,
    String user,
    bool isDoulaView,
  ) {
    // isMe: True jika pesan ini dikirim oleh akun yang sedang aktif membuka halaman ini
    final bool isMe = message.sender == chatController.pengguna.value;
    final bool isSenderDoula = message.sender == doula;

    final String senderName = isSenderDoula
        ? (chatController.namaDoula.value.isNotEmpty ? chatController.namaDoula.value : 'Anastasia Mawardi')
        : (chatController.namaUser.value.isNotEmpty ? chatController.namaUser.value : 'Bunda Pelanggan');

    final String roleBadge = isSenderDoula ? 'Bidan & Doula' : 'Customer / Klien';

    if (isMe) {
      // ═══════════════════════════════════════════════════════════════════════
      // PENGIRIM (AKUN AKTIF SAAT INI) -> DI SEBELAH KANAN
      // ═══════════════════════════════════════════════════════════════════════
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 48),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorDouce.douceBase,
                      const Color(0xFFFF7B93),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorDouce.douceBase.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isDoulaView ? 'Anda (Mitra Doula)' : 'Anda (Bunda)',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, size: 11, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.formattedTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildAvatar(isSenderDoula, chatController),
          ],
        ),
      );
    } else {
      // ═══════════════════════════════════════════════════════════════════════
      // LAWAN BICARA (DITERIMA) -> DI SEBELAH KIRI
      // ═══════════════════════════════════════════════════════════════════════
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildAvatar(isSenderDoula, chatController),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            senderName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSenderDoula ? ColorDouce.douceBase : const Color(0xFF0F766E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: isSenderDoula ? const Color(0xFFFDF2F8) : const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSenderDoula ? const Color(0xFFFBCFE8) : const Color(0xFF99F6E4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            roleBadge,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isSenderDoula ? ColorDouce.douceBase : const Color(0xFF0F766E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1E293B),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.formattedTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String doula = Get.arguments['doula'] as String;
    final String user = Get.arguments['user'] as String;
    final bool isDoula = Get.arguments['isDoula'] as bool;
    final String? bookingId = Get.arguments['bookingId'] as String?;

    final ChatController chatController = Get.put(
      ChatController(doula: doula, user: user, isDoula: isDoula, bookingId: bookingId),
    );

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: Get.back,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ColorDouce.douceBase,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            Obx(
                              () => Text(
                                isDoula
                                    ? (chatController.namaUser.value.isNotEmpty ? chatController.namaUser.value : 'Bunda Pelanggan')
                                    : (chatController.namaDoula.value.isNotEmpty ? chatController.namaDoula.value : 'Anastasia Mawardi'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppSemanticColors.textDarkSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isDoula ? 'Klien / Pasien • Online' : 'Bidan & Certified Doula • Online',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const SizedBox(width: 34, height: 34),
                    ],
                  ),
                  Obx(
                    () {
                      if (chatController.slotIsOnDemand.value) {
                        return const SizedBox.shrink();
                      }
                      final slotTanggal = chatController.slotTanggal.value;
                      final slotJam = chatController.slotJam.value;
                      if (slotTanggal.isEmpty && slotJam.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                slotTanggal,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.schedule_rounded, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                '$slotJam - ${_addHour(slotJam)}',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                              ),
                              const Spacer(),
                              Obx(
                                () {
                                  final status = chatController.slotStatus.value;
                                  String statusText;
                                  Color statusColor;
                                  if (status == 'confirmed' || status == 'ongoing') {
                                    statusText = 'Sedang Berlangsung';
                                    statusColor = Colors.green;
                                  } else if (status == 'paid') {
                                    statusText = 'Segera Dimulai';
                                    statusColor = Colors.orange;
                                  } else {
                                    statusText = '';
                                    statusColor = Colors.grey;
                                  }
                                  if (statusText.isEmpty) return const SizedBox.shrink();
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: Obx(
                      () {
                        if (!chatController.chatAccessAllowed.value) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  chatController.accessMessage.value,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Kembali'),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: chatController.messages.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            final message = chatController.messages[index];
                            return _buildMessageItem(
                              message,
                              chatController,
                              doula,
                              user,
                              isDoula,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: chatController.messageController,
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan balasan...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          chatController.sendMessage();
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorDouce.douceBase,
                                const Color(0xFFFF7B93),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
