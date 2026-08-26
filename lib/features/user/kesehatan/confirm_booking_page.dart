import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/mitra/profil/setup_pin_page.dart';
import 'package:douce/features/user/kesehatan/booking_doula_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:douce/shared/widget/payment_sheet.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({super.key});

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  int _remainingSeconds = 15 * 60; // 15 menit
  Timer? _countdownTimer;
  bool _isExpired = false;
  String? _transactionId;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isExpired = true;
          timer.cancel();
          _handleExpire();
        }
      });
    });
  }

  Future<void> _handleExpire() async {
    if (_transactionId != null) {
      await PaymentService().expireBooking(_transactionId!);
    }
    if (!mounted) return;
    Get.snackbar(
      'Waktu Habis',
      'Pembayaran batal karena melebihi 15 menit.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
    );
    Get.offAllNamed('/user');
  }

  String _formatCountdown(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BookingDoulaController controller =
        Get.find<BookingDoulaController>();
    final doula = controller.selectedDoula.value;

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: Get.back,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorDouce.douceBase,
                      ),
                    ),
                    const Text(
                      "Konfirmasi Booking",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 24),

                // Doula Info Card
                if (doula != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: doula.image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 64,
                              height: 64,
                              color: Colors.pink.shade50,
                              child: Icon(Icons.person, color: ColorDouce.douceBase),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doula.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                doula.job,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      doula.alamat,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Detail Waktu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jadwal Konsultasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Text(
                        "Ubah",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ColorDouce.douceBase,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: ColorDouce.douceBase, size: 28),
                      const SizedBox(width: 12),
                      Obx(
                        () => Text(
                          "${controller.selectedTanggal.value} ${controller.selectedDay.value}  |  ${controller.selectedJam.value}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Layanan Selected
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jenis Layanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Text(
                        "Ubah",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ColorDouce.douceBase,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services_rounded, color: ColorDouce.douceBase, size: 28),
                      const SizedBox(width: 12),
                      Obx(
                        () => Text(
                          controller.selectedLayanan.value,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Rincian Pembayaran
                const Text(
                  "Rincian Pembayaran",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => _buildCostRow(
                          controller.selectedLayanan.value,
                          "Rp ${controller.harga.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCostRow("Biaya Layanan Admin", "Rp 2.000"),
                      const Divider(height: 24),
                      Obx(
                        () => _buildCostRow(
                          "Total Pembayaran",
                          "Rp ${(controller.harga.value + 2000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                          isTotal: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Countdown Timer 15 Menit
                if (!_isExpired)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _remainingSeconds < 300
                          ? Colors.red.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _remainingSeconds < 300
                            ? Colors.red.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: _remainingSeconds < 300 ? Colors.red : Colors.orange,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _remainingSeconds < 300
                                ? 'Segera bayar! Waktu hampir habis'
                                : 'Bayar sebelum waktu habis',
                            style: TextStyle(
                              fontSize: 14,
                              color: _remainingSeconds < 300
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                        ),
                        Text(
                          _formatCountdown(_remainingSeconds),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE8985E),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Button Bayar & Booking (proteksi PIN/biometrik)
                if (!_isExpired)
                  InkWell(
                    onTap: () async {
                      final pinService = Get.find<PinAuthService>();
                      if (!pinService.hasPinSetup.value) {
                        final result = await Get.to(() => const SetupPinPage());
                        if (result != true) return;
                      }
                      final authenticated = await pinService.promptAuth(
                          reason: 'Verifikasi untuk melanjutkan pembayaran');
                      if (!authenticated) return;

                      final bookingModel = controller.toBookingModel();

                      // Simpan transactionId untuk auto-cancel jika time-out
                      _transactionId = 'BKG-${DateTime.now().millisecondsSinceEpoch}';

                      showPaymentSheet(
                        context,
                        jenisLayanan: 'doula',
                        deskripsi: 'Booking Doula – ${controller.selectedLayanan.value}',
                        nominal: bookingModel.totalBayar,
                        booking: bookingModel,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorDouce.douceBase.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Lanjut Ke Pembayaran",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_isExpired)
                  const Center(
                    child: Text(
                      'Waktu pembayaran telah habis. Silakan buat pesanan baru.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF0F172A) : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? ColorDouce.douceBase : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
