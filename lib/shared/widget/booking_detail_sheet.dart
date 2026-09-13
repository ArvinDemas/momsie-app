import 'package:douce/features/mitra/pekerjaan/mitra_pekerjaan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailSheet extends StatelessWidget {
  final BookingModel booking;
  final MitraPekerjaanController? controller;

  const BookingDetailSheet({
    super.key,
    required this.booking,
    this.controller,
  });

  static void show(BuildContext context, BookingModel booking, {MitraPekerjaanController? controller}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BookingDetailSheet(booking: booking, controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,###', 'id_ID');
    final statusLabel = _statusLabel(booking.status);
    final statusColor = _statusColor(booking.status);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.medical_information_outlined,
                    size: 36,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.layanan,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppSemanticColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),

            // Section 1: Pemesan & Informasi Lokasi
            _DetailSection(
              title: 'Informasi Client & Pemesan',
              children: [
                _DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Nama Client',
                  value: booking.namaUser.isNotEmpty ? booking.namaUser : 'Client Momsie',
                  isBold: true,
                ),
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Tanggal Pelayanan',
                  value: '${booking.tanggal} (${booking.day})',
                ),
                _DetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Waktu / Jam',
                  value: booking.jam,
                ),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Alamat Pelayanan',
                  value: (booking.alamat != null && booking.alamat!.isNotEmpty)
                      ? booking.alamat!
                      : 'Alamat sesuai lokasi pengguna',
                ),
                if (booking.catatan != null && booking.catatan!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.sticky_note_2_outlined,
                    label: 'Catatan Khusus',
                    value: booking.catatan!,
                  ),
              ],
            ),

            const SizedBox(height: 18),

            // Section 2: Rincian Honor Doula (Hanya Pendapatan Doula)
            _DetailSection(
              title: 'Honor Pekerjaan',
              children: [
                _DetailRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Pendapatan Doula',
                  value: 'Rp ${fmt.format(booking.doulaEarnings > 0 ? booking.doulaEarnings : (booking.hargaLayanan * 0.85).round())}',
                  isBold: true,
                  valueColor: Colors.green.shade700,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Section 3: Transaksi Info
            _DetailSection(
              title: 'Info Transaksi',
              children: [
                _DetailRow(
                  icon: Icons.tag_rounded,
                  label: 'ID Transaksi',
                  value: booking.transactionId.isNotEmpty ? booking.transactionId : booking.id,
                ),
                _DetailRow(
                  icon: Icons.shield_outlined,
                  label: 'Status Pembayaran',
                  value: booking.status == 'pending' ? 'Belum Bayar' : 'Lunas (Escrow Security)',
                  valueColor: booking.status == 'pending' ? Colors.orange : Colors.green.shade700,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            if (controller != null) ...[
              if (booking.status == 'paid' || booking.status == 'pending')
                _ActionButton(
                  label: 'Klaim Pekerjaan Ini',
                  icon: Icons.assignment_turned_in_outlined,
                  color: ColorDouce.douceBase,
                  onTap: () {
                    Navigator.pop(context);
                    controller!.klaimPekerjaan(booking);
                  },
                ),
              if (booking.status == 'confirmed')
                _ActionButton(
                  label: 'Mulai Kerja Sekarang',
                  icon: Icons.play_arrow_rounded,
                  color: Colors.orange.shade700,
                  onTap: () {
                    Navigator.pop(context);
                    controller!.startJob(booking);
                  },
                ),
              if (booking.status == 'ongoing')
                _ActionButton(
                  label: 'Check Out (Selesaikan Pekerjaan)',
                  icon: Icons.check_circle_outline,
                  color: Colors.green.shade700,
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => ConfirmDialog(
                        descText: 'Apakah Anda yakin telah selesai memberikan pelayanan?',
                        onTap: () => controller!.checkOut(booking),
                      ),
                    );
                  },
                ),
            ],

            // Close button if no controller or completed
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Tutup Detail',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'paid':
        return 'Siap Diklaim';
      case 'confirmed':
        return 'Sudah Diklaim';
      case 'ongoing':
        return 'Sedang Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green.shade700;
      case 'ongoing':
        return Colors.orange.shade700;
      case 'confirmed':
        return ColorDouce.douceBase;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppSemanticColors.textDarkSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children
                .expand((w) => [w, const Divider(height: 14, thickness: 0.4)])
                .take(children.length * 2 - 1)
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? AppSemanticColors.textDarkSecondary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
