import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/chat/chat_controller.dart';
import 'package:douce/features/user/chat/chat_model.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// WhatsApp-style soft pink doodle background painter
class WhatsAppDoodlePainter extends CustomPainter {
  const WhatsAppDoodlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6972).withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = const Color(0xFFFF6972).withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    // Draw distributed doodle icons across the background
    const double stepX = 80;
    const double stepY = 90;

    for (double y = 20; y < size.height; y += stepY) {
      for (double x = 15; x < size.width; x += stepX) {
        final int patternIndex = ((x / stepX).floor() + (y / stepY).floor()) % 6;
        final double cx = x + (patternIndex % 2 == 0 ? 10 : -10);
        final double cy = y;

        switch (patternIndex) {
          case 0:
            // Cute Heart
            final path = Path();
            path.moveTo(cx, cy + 4);
            path.cubicTo(cx - 7, cy - 6, cx - 14, cy + 3, cx, cy + 13);
            path.cubicTo(cx + 14, cy + 3, cx + 7, cy - 6, cx, cy + 4);
            canvas.drawPath(path, paint);
            break;
          case 1:
            // Star
            canvas.drawCircle(Offset(cx, cy), 3, fillPaint);
            canvas.drawLine(Offset(cx - 6, cy), Offset(cx + 6, cy), paint);
            canvas.drawLine(Offset(cx, cy - 6), Offset(cx, cy + 6), paint);
            break;
          case 2:
            // Baby Rattle / Cloud
            final cloudPath = Path();
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx - 4, cy), radius: 5));
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx + 4, cy), radius: 6));
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx, cy - 3), radius: 5));
            canvas.drawPath(cloudPath, paint);
            break;
          case 3:
            // Flower
            for (int i = 0; i < 4; i++) {
              final double dx = i == 0 ? -4 : (i == 1 ? 4 : 0);
              final double dy = i == 2 ? -4 : (i == 3 ? 4 : 0);
              canvas.drawCircle(Offset(cx + dx, cy + dy), 3, paint);
            }
            canvas.drawCircle(Offset(cx, cy), 2, fillPaint);
            break;
          case 4:
            // Sparkle
            canvas.drawLine(Offset(cx - 5, cy), Offset(cx + 5, cy), paint);
            canvas.drawLine(Offset(cx, cy - 5), Offset(cx, cy + 5), paint);
            canvas.drawCircle(Offset(cx, cy), 1.5, fillPaint);
            break;
          default:
            // Soft smile / arc
            final arcRect = Rect.fromCircle(center: Offset(cx, cy), radius: 6);
            canvas.drawArc(arcRect, 0.2, 2.7, false, paint);
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDoulaSender
              ? ColorDouce.douceBase.withValues(alpha: 0.4)
              : const Color(0xFF0F766E).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
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

  /// Membangun bubble chat gaya WhatsApp iOS dengan background pink & aksen spesifik
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
        : (chatController.namaUser.value.isNotEmpty ? chatController.namaUser.value : 'Bunda Nadia Salsabila');

    // Cek apakah pesan memiliki reply quote (contoh pesan diskusi)
    final bool hasReplyQuote = !isMe && message.message.toLowerCase().contains('kita bahas di rumah');

    if (isMe) {
      // ═══════════════════════════════════════════════════════════════════════
      // PENGIRIM (AKUN AKTIF / ANDA) -> SISI KANAN (PINK SOLID WHATSAPP STYLE)
      // ═══════════════════════════════════════════════════════════════════════
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 48),
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                decoration: BoxDecoration(
                  color: ColorDouce.douceBase,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4), // iOS WhatsApp tail
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorDouce.douceBase.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text pesan
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Waktu dan double centang (WhatsApp seen receipt)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.formattedTime.isNotEmpty ? message.formattedTime : '3.15 PM',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all_rounded,
                          size: 15,
                          color: Color(0xFF93C5FD), // Light blue double check
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // ═══════════════════════════════════════════════════════════════════════
      // LAWAN BICARA (CLIENT / MAZDA) -> SISI KIRI (PUTIH BERSIH WHATSAPP)
      // ═══════════════════════════════════════════════════════════════════════
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4), // iOS WhatsApp tail
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Jika ada reply box (seperti di screenshot contoh WhatsApp)
                    if (hasReplyQuote) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: const Border(
                            left: BorderSide(
                              color: Color(0xFF0D9488), // Teal quote accent
                              width: 3.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anda • Momsie P2MW',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'info red doors nya udah pesen kah @$senderName',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Isi teks pesan utama
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1E293B),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Waktu pesan diterima
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        message.formattedTime.isNotEmpty ? message.formattedTime : '7.28 PM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
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
      backgroundColor: const Color(0xFFFFF0F3), // Soft pastel pink base
      body: Stack(
        children: [
          // WhatsApp soft pink doodle pattern background
          Positioned.fill(
            child: CustomPaint(
              painter: const WhatsAppDoodlePainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ══════════════════════════════════════════════════════════════
                // APP BAR / HEADER GAYA WHATSAPP IOS
                // ══════════════════════════════════════════════════════════════
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    border: const Border(
                      bottom: BorderSide(
                        color: Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Tombol Back dengan badge ala iOS "< 222"
                      InkWell(
                        onTap: Get.back,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: ColorDouce.douceBase,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '222',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorDouce.douceBase,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Avatar Foto Profil Lawan Bicara
                      _buildAvatar(!isDoula, chatController),
                      const SizedBox(width: 10),

                      // Nama Kontak & Subtitle "ketuk untuk info kontak"
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                isDoula
                                    ? (chatController.namaUser.value.isNotEmpty ? chatController.namaUser.value : 'Bunda Pelanggan')
                                    : (chatController.namaDoula.value.isNotEmpty ? chatController.namaDoula.value : 'Anastasia Mawardi'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'ketuk untuk info kontak',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol Video Call (Khas WhatsApp)
                      IconButton(
                        onPressed: () {
                          Get.snackbar(
                            'Panggilan Video',
                            'Fitur konsultasi video live sedang diinisiasi...',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: AppSemanticColors.textDarkSecondary,
                          );
                        },
                        icon: const Icon(
                          Icons.videocam_outlined,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                        tooltip: 'Video Call',
                      ),

                      // Tombol Voice Call (Khas WhatsApp)
                      IconButton(
                        onPressed: () {
                          Get.snackbar(
                            'Panggilan Suara',
                            'Menghubungkan panggilan suara...',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: AppSemanticColors.textDarkSecondary,
                          );
                        },
                        icon: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF1E293B),
                          size: 21,
                        ),
                        tooltip: 'Voice Call',
                      ),
                    ],
                  ),
                ),

                // Baris Info Slot Jadwal Konsultasi (Jika ada)
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
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      color: Colors.white.withValues(alpha: 0.8),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 13, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            slotTanggal,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.schedule_rounded, size: 13, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '$slotJam - ${_addHour(slotJam)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: statusColor),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // ══════════════════════════════════════════════════════════════
                // STREAM DAFTAR PESAN
                // ══════════════════════════════════════════════════════════════
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

                // ══════════════════════════════════════════════════════════════
                // BOTTOM INPUT BAR (GAYA WHATSAPP IOS)
                // ══════════════════════════════════════════════════════════════
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    border: const Border(
                      top: BorderSide(
                        color: Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Tombol "+" Attachment (Foto, Dokumen, dsb.)
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.spaceAround,
                                children: [
                                  _buildAttachOption(Icons.image_outlined, 'Galeri', Colors.purple),
                                  _buildAttachOption(Icons.camera_alt_outlined, 'Kamera', Colors.pink),
                                  _buildAttachOption(Icons.insert_drive_file_outlined, 'Dokumen', Colors.indigo),
                                  _buildAttachOption(Icons.location_on_outlined, 'Lokasi', Colors.teal),
                                ],
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF64748B),
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Input Bar Pill-shaped dengan icon sticker di dalamnya
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: chatController.messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Tulis pesan...',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade400,
                                      fontSize: 14.5,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                              // Icon Stiker / Dokumen di dalam pill
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.sticky_note_2_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Tombol Kamera Cepat
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Kamera',
                            'Membuka kamera untuk mengirim foto...',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: AppSemanticColors.textDarkSecondary,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF64748B),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Tombol Bulat Pink (Microphone / Send ala WhatsApp)
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: chatController.messageController,
                        builder: (context, value, child) {
                          final hasText = value.text.trim().isNotEmpty;
                          return InkWell(
                            onTap: () {
                              if (hasText) {
                                chatController.sendMessage();
                              } else {
                                Get.snackbar(
                                  'Pesan Suara',
                                  'Tahan untuk merekam pesan suara...',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  colorText: AppSemanticColors.textDarkSecondary,
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: ColorDouce.douceBase,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorDouce.douceBase.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                hasText ? Icons.send_rounded : Icons.mic_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
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

  static Widget _buildAttachOption(IconData icon, String title, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
