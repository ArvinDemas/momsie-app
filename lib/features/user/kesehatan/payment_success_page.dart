import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Halaman Bukti Pembayaran Resmi (Receipt Page) setelah transaksi berhasil.
/// Tanpa auto-redirect timer agar pengguna dapat melihat/screenshot bukti pembayaran dengan tenang.
class PaymentSuccessPage extends StatefulWidget {
  final String transactionId;
  final String? bookingId;
  final int? nominal;
  final String? layanan;

  const PaymentSuccessPage({
    super.key,
    required this.transactionId,
    this.bookingId,
    this.nominal,
    this.layanan,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  void _navigateToDetail() {
    if (widget.bookingId != null && widget.bookingId!.isNotEmpty) {
      Get.offAllNamed(AppRoutes.bookingDetail, arguments: {'bookingId': widget.bookingId});
    } else {
      Get.offAllNamed(AppRoutes.userPesanan);
    }
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ColorDouce.douceBase),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Get.back();
            } else {
              _navigateToDetail();
            }
          },
        ),
        title: const Text(
          'Bukti Pembayaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppSemanticColors.textDark),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Success icon with animation
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 58,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppSemanticColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      'Transaksi Anda telah dikonfirmasi & diverifikasi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Transaction summary card (Wrapped Expanded to prevent 12px right overflow!)
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Resmi Header Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 14, color: Colors.green.shade700),
                            const SizedBox(width: 6),
                            Text(
                              'BUKTI PEMBAYARAN RESMI',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _infoRow('ID Transaksi', widget.transactionId),
                      if (widget.nominal != null)
                        _infoRow('Nominal', _formatRupiah(widget.nominal!)),
                      if (widget.layanan != null)
                        _infoRow('Layanan', widget.layanan!),
                      _infoRow('Status', 'Sudah Dibayar', isStatus: true),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Action buttons (Primary & Secondary)
              ElevatedButton(
                onPressed: _navigateToDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorDouce.douceBase,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lihat Detail Pesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.user),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: BorderSide(color: ColorDouce.douceBase),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    color: ColorDouce.douceBase,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Crash-proof info row with Expanded right text to prevent overflow
  Widget _infoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isStatus ? Colors.green.shade700 : AppSemanticColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
