import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/chat/chat_controller.dart';
import 'package:douce/features/user/chat/chat_model.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Doodle Painter: white translucent pattern on pink bg ──────────────────────
class WhatsAppDoodlePainter extends CustomPainter {
  const WhatsAppDoodlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    const double stepX = 80.0;
    const double stepY = 90.0;

    for (double y = 20; y < size.height; y += stepY) {
      for (double x = 15; x < size.width; x += stepX) {
        final int patternIndex = ((x / stepX).floor() + (y / stepY).floor()) % 6;
        final double cx = x + (patternIndex % 2 == 0 ? 10 : -10);
        final double cy = y;

        switch (patternIndex) {
          case 0: // Heart
            final path = Path();
            path.moveTo(cx, cy + 4);
            path.cubicTo(cx - 7, cy - 6, cx - 14, cy + 3, cx, cy + 13);
            path.cubicTo(cx + 14, cy + 3, cx + 7, cy - 6, cx, cy + 4);
            canvas.drawPath(path, paint);
            break;
          case 1: // Star
            canvas.drawCircle(Offset(cx, cy), 3, fillPaint);
            canvas.drawLine(Offset(cx - 6, cy), Offset(cx + 6, cy), paint);
            canvas.drawLine(Offset(cx, cy - 6), Offset(cx, cy + 6), paint);
            break;
          case 2: // Cloud / Rattle
            final cloudPath = Path();
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx - 4, cy), radius: 5));
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx + 4, cy), radius: 6));
            cloudPath.addOval(Rect.fromCircle(center: Offset(cx, cy - 3), radius: 5));
            canvas.drawPath(cloudPath, paint);
            break;
          case 3: // Flower
            for (int i = 0; i < 4; i++) {
              final double dx = i == 0 ? -4 : (i == 1 ? 4 : 0);
              final double dy = i == 2 ? -4 : (i == 3 ? 4 : 0);
              canvas.drawCircle(Offset(cx + dx, cy + dy), 3, paint);
            }
            canvas.drawCircle(Offset(cx, cy), 2, fillPaint);
            break;
          case 4: // Sparkle
            canvas.drawLine(Offset(cx - 5, cy), Offset(cx + 5, cy), paint);
            canvas.drawLine(Offset(cx, cy - 5), Offset(cx, cy + 5), paint);
            canvas.drawCircle(Offset(cx, cy), 1.5, fillPaint);
            break;
          default: // Smile arc
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

// ─── Bubble tail clipper ────────────────────────────────────────────────────────
/// Tail pada pojok kanan-bawah (pengirim / pink bubble)
class RightTailClipper extends CustomClipper<Path> {
  const RightTailClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final tailStartX = size.width - 24.0;
    final tailBaseY = size.height - 12.0;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Cut out the tail triangle from bottom-right
    path.addPolygon([
      Offset(tailStartX, tailBaseY),
      Offset(tailStartX + 6, tailBaseY + 8),
      Offset(size.width, tailBaseY),
    ], true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Tail pada pojok kiri-bawah (penerima / white bubble)
class LeftTailClipper extends CustomClipper<Path> {
  const LeftTailClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final tailEndX = 24.0;
    final tailBaseY = size.height - 12.0;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Cut out the tail triangle from bottom-left
    path.addPolygon([
      Offset(tailEndX, tailBaseY),
      Offset(tailEndX - 6, tailBaseY + 8),
      Offset(0, tailBaseY),
    ], true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ─── Avatar widget ─────────────────────────────────────────────────────────────
Widget _buildAvatar(bool isDoulaSender, ChatController controller) {
  return Obx(() {
    var image = isDoulaSender ? controller.imageDoula.value : controller.imageUser.value;
    if (isDoulaSender &&
        (image.isEmpty ||
            image.contains('blank-profile') ||
            image.contains('doula_dewi.png'))) {
      image = 'assets/images/dewi_riana.jpg';
    }

    Widget imgWidget;
    if (image.isNotEmpty && (image.startsWith('http://') || image.startsWith('https://'))) {
      imgWidget = CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          isDoulaSender ? 'assets/images/dewi_riana.jpg' : 'assets/images/blank-profile.png',
          fit: BoxFit.cover,
        ),
      );
    } else {
      final assetPath = image.isNotEmpty && image.startsWith('assets/') && !image.contains('doula_dewi.png')
          ? image
          : (isDoulaSender ? 'assets/images/dewi_riana.jpg' : 'assets/images/blank-profile.png');
      imgWidget = Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          isDoulaSender ? 'assets/images/dewi_riana.jpg' : 'assets/images/blank-profile.png',
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorDouce.douceBase.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imgWidget,
      ),
    );
  });
}

// ─── Message bubble ────────────────────────────────────────────────────────────
Widget _buildMessageItem(
  ChatModel message,
  ChatController controller,
  String doula,
  String user,
  bool isDoulaView,
) {
  final bool isMe = message.sender == controller.pengguna.value;
  final bool hasReplyQuote = message.replyQuote != null && message.replyQuote!.isNotEmpty;
  final bool hasMedia = _hasMediaContent(message.message);

  if (isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Flexible(
            child: ClipPath(
              clipper: const RightTailClipper(),
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.lg),
                decoration: BoxDecoration(color: ColorDouce.douceBase),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasReplyQuote) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: const Border(
                            left: BorderSide(color: AppSemanticColors.softTeal, width: 3.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Anda • Momsie P2MW',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.softTeal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message.replyQuote!,
                              style: TextStyle(fontSize: 11.5, color: AppSemanticColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (hasMedia)
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.sm)),
                        child: Image.asset('assets/images/blank-profile.png', fit: BoxFit.cover, width: 200),
                      ),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.formattedTime.isNotEmpty ? message.formattedTime : '3.15 PM',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.80),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        const Icon(Icons.done_all_rounded, size: 15, color: Color(0xFF93C5FD)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: ClipPath(
              clipper: const LeftTailClipper(),
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.lg),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasReplyQuote) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: const Border(
                            left: BorderSide(color: AppSemanticColors.softTeal, width: 3.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Anda • Momsie P2MW',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppSemanticColors.softTeal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message.replyQuote!,
                              style: TextStyle(fontSize: 11.5, color: AppSemanticColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (hasMedia)
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.sm)),
                        child: Image.asset('assets/images/blank-profile.png', fit: BoxFit.cover, width: 200),
                      ),
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: AppSemanticColors.textDark,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        message.formattedTime.isNotEmpty ? message.formattedTime : '7.28 PM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppSemanticColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

bool _hasMediaContent(String message) {
  return message.contains(RegExp(r'\.(png|jpg|jpeg|gif|mp4|mov)(\?|$|\s)', caseSensitive: false));
}

// ─── Attachment options (bottom sheet) ─────────────────────────────────────────
Widget _buildAttachOption(IconData icon, String title, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 26,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color, size: 26),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ],
  );
}

// ─── Main Page ─────────────────────────────────────────────────────────────────
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static String _addHour(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return '$time +1j';
    final hour = int.tryParse(parts[0]) ?? 0;
    return '${(hour + 1).toString().padLeft(2, '0')}:${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    String doula = Get.arguments != null && Get.arguments['doula'] != null
        ? Get.arguments['doula'] as String
        : 'doula_dewi';
    String user = Get.arguments != null && Get.arguments['user'] != null
        ? Get.arguments['user'] as String
        : 'user_arvin';
    final bool isDoula = Get.arguments != null && Get.arguments['isDoula'] != null
        ? Get.arguments['isDoula'] as bool
        : false;
    final String? bookingId = Get.arguments != null ? Get.arguments['bookingId'] as String? : null;

    if (!isDoula) {
      if (doula.isEmpty ||
          doula == user ||
          doula == 'doula_id_1' ||
          doula.toLowerCase().contains('arvin') ||
          doula.toLowerCase().contains('adnar')) {
        doula = 'doula_dewi';
      }
    }

    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }

    final ChatController chatController = Get.put(
      ChatController(doula: doula, user: user, isDoula: isDoula, bookingId: bookingId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F3),
      body: Stack(
        children: [
          // Doodle background — white translucent on pink
          Positioned.fill(
            child: CustomPaint(painter: const WhatsAppDoodlePainter()),
          ),

          SafeArea(
            child: Column(
              children: [
                // ─── Header ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  color: Colors.white.withValues(alpha: 0.95),
                  child: Row(
                    children: [
                      // Tombol back: cukup panah saja tanpa teks
                      InkWell(
                        onTap: Get.back,
                        borderRadius: AppRadius.roundedFull,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: ColorDouce.douceBase,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Avatar: Doula jika dipandang user, atau User jika dipandang doula
                      _buildAvatar(!isDoula, chatController),
                      const SizedBox(width: AppSpacing.sm),

                      // Contact info: Selalu nama Doula yang dihubungi jika !isDoula
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () {
                                if (isDoula) {
                                  final name = chatController.namaUser.value.trim();
                                  return Text(
                                    name.isNotEmpty ? name : 'Bunda Pelanggan',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppSemanticColors.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }

                                String displayName = chatController.namaDoula.value.trim();
                                if (displayName.isEmpty ||
                                    displayName.toLowerCase().contains('arvin') ||
                                    displayName.toLowerCase().contains('demas') ||
                                    displayName.toLowerCase().contains('adnar') ||
                                    displayName == 'Mitra Doula' ||
                                    displayName == 'Bunda Pelanggan') {
                                  displayName = 'Doula Dewi Sartika, S.Keb';
                                }
                                return Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppSemanticColors.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                            const SizedBox(height: 1),
                            Text(
                              isDoula ? 'Pasien / Pelanggan Konsultasi' : 'Mitra Doula & Bidan Bersertifikasi',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppSemanticColors.textMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Video call
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Panggilan Video',
                            'Fitur konsultasi video live sedang diinisiasi...',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: AppSemanticColors.textDarkSecondary,
                          );
                        },
                        borderRadius: AppRadius.roundedFull,
                        child: const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: Icon(Icons.videocam_outlined, color: AppSemanticColors.textDark, size: 24),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),

                      // Voice call
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            'Panggilan Suara',
                            'Menghubungkan panggilan suara...',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: AppSemanticColors.textDarkSecondary,
                          );
                        },
                        borderRadius: AppRadius.roundedFull,
                        child: const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: Icon(Icons.phone_outlined, color: AppSemanticColors.textDark, size: 21),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Slot info banner ──────────────────────────────
                Obx(
                  () {
                    if (chatController.slotIsOnDemand.value) return const SizedBox.shrink();
                    final slotTanggal = chatController.slotTanggal.value;
                    final slotJam = chatController.slotJam.value;
                    if (slotTanggal.isEmpty && slotJam.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      color: Colors.white.withValues(alpha: 0.8),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 13, color: AppSemanticColors.textMuted),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(slotTanggal, style: TextStyle(fontSize: 12, color: AppSemanticColors.textDarkSecondary)),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(Icons.schedule_rounded, size: 13, color: AppSemanticColors.textMuted),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            '$slotJam - ${_addHour(slotJam)}',
                            style: TextStyle(fontSize: 12, color: AppSemanticColors.textDarkSecondary),
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
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
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

                // ─── Message list ──────────────────────────────────
                Expanded(
                  child: Obx(
                    () {
                      if (!chatController.chatAccessAllowed.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 64, color: AppSemanticColors.textMuted),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                chatController.accessMessage.value,
                                style: TextStyle(fontSize: 16, color: AppSemanticColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.lg),
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
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          return _buildMessageItem(
                            chatController.messages[index],
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

                // ─── Bottom input bar ──────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.xs, AppSpacing.xs, AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
                  ),
                  child: Row(
                    children: [
                      // + Attachment button
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                              ),
                              child: Wrap(
                                spacing: AppSpacing.lg,
                                runSpacing: AppSpacing.lg,
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
                        borderRadius: AppRadius.roundedLg,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: Icon(Icons.add, color: AppSemanticColors.textSecondary, size: 26),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),

                      // Input pill — keyboard-icon on right
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.roundedFull,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                                      color: AppSemanticColors.textMuted,
                                      fontSize: 14.5,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.sm,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: AppSpacing.xs),
                                child: Icon(Icons.chat_bubble_outline, color: AppSemanticColors.textMuted, size: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Camera button (round pink outline)
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
                        borderRadius: AppRadius.roundedFull,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Icon(Icons.camera_alt_outlined, color: AppSemanticColors.textSecondary, size: 24),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Mic / Send button — pink circle with tap animation
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
                            borderRadius: AppRadius.roundedFull,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 1.0, end: 0.92),
                              duration: AppAnimation.fast,
                              curve: AppAnimation.defaultCurve,
                              builder: (context, scale, inner) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: ColorDouce.douceBase,
                                      shape: BoxShape.circle,
                                      boxShadow: AppElevation.softColor(ColorDouce.douceBase),
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
}
