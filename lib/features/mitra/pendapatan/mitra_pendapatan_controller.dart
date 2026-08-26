import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/booking_model.dart';
import 'package:douce/shared/util/model/withdrawal_model.dart';
import 'package:douce/features/mitra/profil/setup_pin_page.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/shared/util/service/withdraw_service.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraPendapatanController extends GetxController {
  final WithdrawService _withdrawService = WithdrawService();
  late final UserController _userController;
  late final PinAuthService _pinService;
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Saldo
  final RxInt saldoTersedia = 0.obs;
  final RxInt totalPendapatan = 0.obs;

  // Withdrawals
  final RxList<WithdrawalModel> withdrawals = <WithdrawalModel>[].obs;

  // Completed bookings (untuk riwayat)
  final RxList<BookingModel> completedBookings = <BookingModel>[].obs;

  StreamSubscription? _saldoSubscription;
  StreamSubscription? _withdrawalSubscription;
  StreamSubscription? _bookingSubscription;

  @override
  void onInit() {
    super.onInit();
    _userController = Get.find<UserController>();
    _pinService = Get.find<PinAuthService>();
    _listenSaldo();
    _listenWithdrawals();
    _listenCompletedBookings();
  }

  /// Listen saldo dari dokumen mitra
  void _listenSaldo() {
    _saldoSubscription = FirebaseFirestore.instance
        .collection('mitra')
        .doc(_userController.uid.value)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;
          final data = doc.data()!;
          saldoTersedia.value = (data['saldo_tersedia'] ?? data['saldo_escrow'] ?? data['saldo'] ?? 0) as int;
          totalPendapatan.value = (data['totalPendapatan'] ?? 0) as int;
        }, onError: (e) {
          debugPrint('Saldo stream error: $e');
        });
  }

  /// Listen withdrawals untuk doula ini
  void _listenWithdrawals() {
    _withdrawalSubscription = _withdrawService.streamWithdrawalsByDoula(_userController.uid.value).listen((list) {
      withdrawals.value = list;
    }, onError: (e) {
      debugPrint('Withdrawals stream error: $e');
    });
  }

  /// Listen completed bookings
  void _listenCompletedBookings() {
    _bookingSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .where('doulaUid', isEqualTo: _userController.uid.value)
        .where('status', isEqualTo: 'completed')
        .orderBy('completedAt', descending: true)
        .limit(10)
        .snapshots()
        .listen((snapshot) {
          completedBookings.value = snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), id: doc.id))
              .toList();
        }, onError: (e) {
          debugPrint('Completed bookings stream error: $e');
        });
  }

  /// Show withdraw dialog (dengan proteksi PIN/biometrik)
  Future<void> showWithdrawDialog() async {
    final pinService = Get.find<PinAuthService>();
    if (!pinService.hasPinSetup.value) {
      // Belum setup PIN → arahkan ke halaman setup
      final result = await Get.to(() => const SetupPinPage());
      if (result != true) return;
    }
    // Proteksi: verifikasi PIN/biometrik sebelum buka dialog withdraw
    final authenticated = await pinService.promptAuth(reason: 'Verifikasi untuk penarikan dana');
    if (!authenticated) return;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WithdrawSheet(controller: this),
    );
  }

  @override
  void onClose() {
    _saldoSubscription?.cancel();
    _withdrawalSubscription?.cancel();
    _bookingSubscription?.cancel();
    super.onClose();
  }

  /// Submit withdraw request (dengan proteksi PIN/biometrik)
  Future<void> submitWithdraw({
    required int nominal,
    required String bank,
    required String noRekening,
    required String atasNama,
  }) async {
    // Proteksi: verifikasi PIN/biometrik sebelum submit withdraw
    if (!await _pinService.promptAuth(reason: 'Verifikasi untuk penarikan dana sebesar Rp ${currencyFormat.format(nominal)}')) {
      if (Get.context != null && Get.context!.mounted) Get.back();
      return;
    }
    try {
      final uid = _userController.uid.value;
      final doulaRef = FirebaseFirestore.instance.collection('mitra').doc(uid);

      // Gunakan transaksi atomik agar saldo dan withdrawal tidak bisa race condition
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final mitraSnap = await tx.get(doulaRef);
        if (!mitraSnap.exists) throw Exception('Data mitra tidak ditemukan');

        final currentBalance = (mitraSnap.data()!['saldo_tersedia'] ??
            mitraSnap.data()!['saldo_escrow'] ??
            mitraSnap.data()!['saldo'] ?? 0) as int;

        if (currentBalance < nominal) {
          throw Exception('Saldo tidak mencukupi untuk penarikan sebesar Rp ${currencyFormat.format(nominal)}');
        }

        // Buat dokumen withdraw baru di dalam transaksi
        final withdrawalRef = FirebaseFirestore.instance.collection('withdrawals').doc();
        final withdrawal = WithdrawalModel(
          id: withdrawalRef.id,
          doulaUid: uid,
          doulaName: _userController.doulaUsername.value,
          nominal: nominal,
          bank: bank,
          noRekening: noRekening,
          atasNama: atasNama,
          status: 'pending',
          createdAt: DateTime.now(),
        );
        tx.set(withdrawalRef, withdrawal.toMap());

        // Kurangi saldo secara atomik
        tx.update(doulaRef, {
          'saldo_tersedia': FieldValue.increment(-nominal),
        });
      });
      if (Get.context != null && Get.context!.mounted) {
        Get.back();
        Get.snackbar('Berhasil', 'Permintaan penarikan dana dikirim');
      }
    } catch (e) {
      String msg = 'Terjadi kesalahan. Silakan coba lagi.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            msg = 'Password terlalu lemah (minimal 6 karakter)';
            break;
          case 'email-already-in-use':
            msg = 'Email sudah terdaftar';
            break;
          case 'invalid-email':
            msg = 'Format email tidak valid';
            break;
          default:
            msg = 'Terjadi kesalahan. Silakan coba lagi.';
        }
      }
      if (Get.context != null && Get.context!.mounted) {
        Get.snackbar('Error', msg);
      }
    }
  }
}

class _WithdrawSheet extends StatefulWidget {
  final MitraPendapatanController controller;
  const _WithdrawSheet({required this.controller});

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  final _bankController = TextEditingController();
  final _noRekController = TextEditingController();
  final _atasNamaController = TextEditingController();

  String? _selectedBank;
  final List<String> _banks = ['BCA', 'Mandiri', 'BRI', 'BNI', 'GoPay', 'DANA', 'OVO'];

  @override
  void dispose() {
    _nominalController.dispose();
    _bankController.dispose();
    _noRekController.dispose();
    _atasNamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetContainer(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(title: 'Tarik Dana'),
            const SizedBox(height: 16),

            // Nominal
            Text('Nominal Penarikan', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan nominal',
                prefixText: 'Rp ',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Nominal wajib diisi';
                final n = int.tryParse(v.replaceAll('.', ''));
                if (n == null) return 'Format tidak valid';
                if (n < 50000) return 'Minimal Rp 50.000';
                final saldo = widget.controller.saldoTersedia.value;
                if (n > saldo) return 'Saldo tidak cukup';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  'Saldo tersedia: Rp ${widget.controller.currencyFormat.format(widget.controller.saldoTersedia.value)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                )),
            const SizedBox(height: 16),

            // Bank
            Text('Bank / E-Wallet', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _selectedBank = v),
              validator: (v) => v == null ? 'Pilih bank' : null,
            ),
            const SizedBox(height: 16),

            // No Rekening
            Text('Nomor Rekening', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noRekController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 1234567890',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Atas Nama
            Text('Atas Nama', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _atasNamaController,
              decoration: InputDecoration(
                hintText: 'Nama sesuai rekening',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorDouce.douceBase,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Kirim Permintaan', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final nominal = int.tryParse(_nominalController.text.replaceAll('.', ''));
      if (nominal == null) return;
      await widget.controller.submitWithdraw(
        nominal: nominal,
        bank: _selectedBank!,
        noRekening: _noRekController.text.trim(),
        atasNama: _atasNamaController.text.trim(),
      );
    }
  }
}

class _SheetContainer extends StatelessWidget {
  final Widget child;
  const _SheetContainer({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: child,
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
