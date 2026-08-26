import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Halaman detail & tracking status pesanan doula.
class BookingDetailPage extends StatefulWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final PaymentService _paymentService = PaymentService();
  BookingModel? _booking;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _booking = BookingModel.fromMap(snapshot.data()!, id: snapshot.id);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Booking tidak ditemukan';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'ongoing':
        return Colors.orange;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Sudah Dibayar';
      case 'confirmed':
        return 'Dikonfirmasi Doula';
      case 'ongoing':
        return 'Sedang Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
      case 'expired':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.payment_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'ongoing':
        return Icons.play_circle_rounded;
      case 'completed':
        return Icons.celebration_rounded;
      case 'cancelled':
      case 'expired':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F5),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: ColorDouce.douceBase))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final b = _booking!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header dengan back button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: ColorDouce.douceBase,
                size: 24,
              ),
            ),
            const Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(height: 24),

        // Status Card
        Container(
          padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(b.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(b.status),
                  color: _getStatusColor(b.status),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusLabel(b.status),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${b.id}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: b.status),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Doula Info
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: b.doulaPhoto,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
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
                      b.doulaName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      b.doulaJob,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Detail Jadwal
        Container(
          padding: const EdgeInsets.all(16),
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
              const Text(
                'Jadwal Pendampingan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _detailRow(Icons.calendar_today, 'Tanggal', '${b.tanggal} (${b.day})'),
              const SizedBox(height: 8),
              _detailRow(Icons.access_time, 'Waktu', b.jam),
              const SizedBox(height: 8),
              _detailRow(Icons.medical_services, 'Layanan', b.layanan),
              if (b.alamat != null && b.alamat!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _detailRow(Icons.location_on, 'Alamat', b.alamat!),
              ],
              if (b.catatan != null && b.catatan!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _detailRow(Icons.note, 'Catatan', b.catatan!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Rincian Pembayaran
        Container(
          padding: const EdgeInsets.all(16),
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
              const Text(
                'Rincian Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _costRow('Harga Layanan', _formatRupiah(b.hargaLayanan)),
              const SizedBox(height: 8),
              _costRow('Biaya Admin', _formatRupiah(b.biayaAdmin)),
              const Divider(height: 24),
              _costRow(
                'Total Bayar',
                _formatRupiah(b.totalBayar),
                isTotal: true,
              ),
              const SizedBox(height: 12),
              _costRow('Platform Fee (15%)', _formatRupiah(b.platformFee)),
              const SizedBox(height: 8),
              _costRow('Pendapatan Doula (85%)', _formatRupiah(b.doulaEarnings)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Timestamps
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Waktu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _timeRow('Dibuat', _formatDate(b.createdAt)),
              if (b.paidAt != null) _timeRow('Dibayar', _formatDate(b.paidAt!)),
              if (b.confirmedAt != null) _timeRow('Dikonfirmasi', _formatDate(b.confirmedAt!)),
              if (b.completedAt != null) _timeRow('Selesai', _formatDate(b.completedAt!)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action buttons based on status
        if (['paid', 'confirmed', 'ongoing', 'completed'].contains(b.status)) ...[
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed('/payment-success', arguments: {
                'transactionId': b.transactionId.isNotEmpty ? b.transactionId : b.id,
                'bookingId': b.id,
                'nominal': b.totalBayar,
                'layanan': 'Booking ${b.doulaName.isNotEmpty ? b.doulaName : "Doula"} – ${b.layanan}',
              });
            },
            icon: const Icon(Icons.receipt_long_rounded, color: Colors.white),
            label: const Text(
              'Lihat Bukti Transaksi',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (b.status == 'paid' || b.status == 'confirmed') ...[
          OutlinedButton(
            onPressed: () => Get.toNamed('/chat-page', arguments: {
              'doula': null,
              'user': null,
              'isDoula': false,
            }),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: ColorDouce.douceBase),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Chat Doula',
              style: TextStyle(color: ColorDouce.douceBase, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ColorDouce.douceBase),
        const SizedBox(width: 10),
        Text('$label: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  Widget _costRow(String label, String value, {bool isTotal = false}) {
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

  Widget _timeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case 'paid':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'confirmed':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'ongoing':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'completed':
        bgColor = Colors.purple.shade50;
        textColor = Colors.purple.shade700;
        break;
      default:
        bgColor = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _shortLabel(status),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  String _shortLabel(String status) {
    switch (status) {
      case 'paid': return 'Lunas';
      case 'confirmed': return 'Dikonf';
      case 'ongoing': return 'Berjalan';
      case 'completed': return 'Selesai';
      default: return status;
    }
  }
}
