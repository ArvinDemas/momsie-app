import 'package:douce/features/mitra/pendapatan/mitra_pendapatan_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/model/withdrawal_model.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraPendapatanPage extends StatelessWidget {
  const MitraPendapatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraPendapatanController controller = Get.put(MitraPendapatanController());
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (controller.isAnastasiaUser && (controller.withdrawals.isEmpty || controller.completedBookings.length < 3)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.applyAnastasiaDemo();
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pendapatan & Dompet",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppSemanticColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Balance Card
                Obx(() {
                  final saldo = controller.saldoTersedia.value;
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorDouce.douceBase, ColorDouce.douceBase.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ColorDouce.douceBase.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saldo Tersedia",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(saldo),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: saldo > 0 ? () => controller.showWithdrawDialog() : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_horiz_rounded, color: ColorDouce.douceBase, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Tarik Dana",
                                  style: TextStyle(
                                    color: ColorDouce.douceBase,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Stats Row
                Obx(() {
                  final totalPendapatan = controller.totalPendapatan.value;
                  return Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: "Total Pendapatan",
                          value: currencyFormat.format(totalPendapatan),
                          icon: Icons.trending_up_rounded,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: "Menunggu Withdraw",
                          value: currencyFormat.format(controller.saldoTersedia.value),
                          icon: Icons.pending_rounded,
                          color: Colors.amber[700]!,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 24),

                // Withdrawals History
                const Text(
                  "Riwayat Penarikan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.withdrawals.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              "Belum ada penarikan dana",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: controller.withdrawals.map((w) {
                      return _WithdrawalCard(withdrawal: w, currencyFormat: currencyFormat);
                    }).toList(),
                  );
                }),

                const SizedBox(height: 24),

                // Earnings History (Completed Bookings)
                const Text(
                  "Riwayat Pekerjaan Selesai",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.completedBookings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          "Belum ada pekerjaan selesai",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: controller.completedBookings.map((b) {
                      return _BookingCard(booking: b, currencyFormat: currencyFormat);
                    }).toList(),
                  );
                }),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  final WithdrawalModel withdrawal;
  final NumberFormat currencyFormat;

  const _WithdrawalCard({required this.withdrawal, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    final bool isPending = withdrawal.status == 'pending';
    final bool isDone = withdrawal.status == 'done';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPending ? Colors.amber.shade200 : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDone ? Colors.green.shade50 : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDone ? Icons.check_circle : Icons.hourglass_empty,
              color: isDone ? Colors.green : Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tarik ${currencyFormat.format(withdrawal.nominal)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text("${withdrawal.bank} •••${withdrawal.noRekening.substring(0 < withdrawal.noRekening.length - 4 ? withdrawal.noRekening.length - 4 : 0)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(
            isPending ? "Menunggu" : "Selesai",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPending ? Colors.amber[700] : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic booking;
  final NumberFormat currencyFormat;

  const _BookingCard({required this.booking, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.layanan ?? 'Booking', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text("${booking.tanggal} ${booking.day ?? ''} • ${booking.jam ?? ''}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(
            "+${currencyFormat.format(booking.doulaEarnings ?? 0)}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
