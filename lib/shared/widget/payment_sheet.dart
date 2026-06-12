import 'dart:async';
import 'dart:io';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/service/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ═══════════════════════════════════════════════════════════
// Entry point: panggil dari mana saja untuk memulai pembayaran
// ═══════════════════════════════════════════════════════════
Future<void> showPaymentSheet(
  BuildContext context, {
  required String jenisLayanan,
  required String deskripsi,
  required int nominal,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PaymentSheet(
      jenisLayanan: jenisLayanan,
      deskripsi: deskripsi,
      nominal: nominal,
    ),
  );
}

// ═══════════════════════════════════════════════════════════
// Step 1 — Pilih Metode Pembayaran
// ═══════════════════════════════════════════════════════════
class PaymentSheet extends StatefulWidget {
  final String jenisLayanan;
  final String deskripsi;
  final int nominal;

  const PaymentSheet({
    super.key,
    required this.jenisLayanan,
    required this.deskripsi,
    required this.nominal,
  });

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  String? _selectedMethod;
  bool _isLoading = false;

  final _methods = [
    {'id': 'transfer_bca', 'label': 'Transfer BCA', 'icon': Icons.account_balance},
    {'id': 'transfer_mandiri', 'label': 'Transfer Mandiri', 'icon': Icons.account_balance_wallet},
    {'id': 'qris', 'label': 'QRIS', 'icon': Icons.qr_code_2},
    {'id': 'gopay', 'label': 'GoPay', 'icon': Icons.payments_outlined},
    {'id': 'dana', 'label': 'DANA', 'icon': Icons.wallet},
  ];

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  Future<void> _proceed() async {
    if (_selectedMethod == null) return;
    setState(() => _isLoading = true);

    try {
      final txId = await PaymentService().createTransaction(
        jenisLayanan: widget.jenisLayanan,
        deskripsi: widget.deskripsi,
        nominal: widget.nominal,
        metodePembayaran: _selectedMethod!,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      final ctx = context;
      final method = _selectedMethod!;
      final nominal = widget.nominal;
      final deskripsi = widget.deskripsi;

      // Navigasi ke Step 2
      Navigator.pop(ctx);
      if (!ctx.mounted) return;
      await showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PaymentInstructionSheet(
          transactionId: txId,
          metodePembayaran: method,
          nominal: nominal,
          deskripsi: deskripsi,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return _SheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHeader(title: 'Pilih Metode Pembayaran'),
          // Demo label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.orange.shade700),
                const SizedBox(width: 6),
                Text(
                  'Demo Mode – Simulasi Pembayaran',
                  style: TextStyle(fontSize: 11, color: Colors.orange.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Ringkasan pesanan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.deskripsi,
                      style: const TextStyle(fontSize: 14)),
                ),
                Text(
                  _formatRupiah(widget.nominal),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorDouce.douceBase,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Metode Bayar',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ..._methods.map((m) => _MethodTile(
                id: m['id'] as String,
                label: m['label'] as String,
                icon: m['icon'] as IconData,
                selected: _selectedMethod == m['id'],
                onTap: () => setState(() => _selectedMethod = m['id'] as String),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMethod == null ? null : _proceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Lanjutkan Pembayaran',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 2 — Instruksi Pembayaran + Timer
// ═══════════════════════════════════════════════════════════
class PaymentInstructionSheet extends StatefulWidget {
  final String transactionId;
  final String metodePembayaran;
  final int nominal;
  final String deskripsi;

  const PaymentInstructionSheet({
    super.key,
    required this.transactionId,
    required this.metodePembayaran,
    required this.nominal,
    required this.deskripsi,
  });

  @override
  State<PaymentInstructionSheet> createState() =>
      _PaymentInstructionSheetState();
}

class _PaymentInstructionSheetState extends State<PaymentInstructionSheet> {
  // Countdown 24 jam
  late Duration _remaining;
  Timer? _timer;

  final _bankInfo = {
    'transfer_bca': {'bank': 'BCA', 'rekening': '1234567890', 'atas_nama': 'PT Momsie Indonesia'},
    'transfer_mandiri': {'bank': 'Mandiri', 'rekening': '0987654321', 'atas_nama': 'PT Momsie Indonesia'},
    'gopay': {'bank': 'GoPay', 'rekening': '081234567890', 'atas_nama': 'Momsie App'},
    'dana': {'bank': 'DANA', 'rekening': '081234567890', 'atas_nama': 'Momsie App'},
    'qris': {'bank': 'QRIS', 'rekening': '', 'atas_nama': ''},
  };

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  void initState() {
    super.initState();
    _remaining = const Duration(hours: 24);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdownStr {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final info = _bankInfo[widget.metodePembayaran]!;
    final isQris = widget.metodePembayaran == 'qris';

    return _SheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHeader(title: 'Instruksi Pembayaran'),
          // Timer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selesaikan dalam',
                    style: TextStyle(fontSize: 13, color: Colors.red)),
                Text(_countdownStr,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Nominal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Bayar', style: TextStyle(color: Colors.black54)),
              Text(_formatRupiah(widget.nominal),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorDouce.douceBase)),
            ],
          ),
          const Divider(height: 24),
          if (!isQris) ...[
            _InfoRow('Bank / Dompet', info['bank']!),
            const SizedBox(height: 8),
            _InfoRowCopy('Nomor Rekening', info['rekening']!),
            const SizedBox(height: 8),
            _InfoRow('Atas Nama', info['atas_nama']!),
          ] else ...[
            const Center(
              child: Text('Scan QR Code di bawah ini',
                  style: TextStyle(color: Colors.black54)),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2, size: 160, color: Colors.black87),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text('ID Transaksi: ${widget.transactionId}',
              style:
                  const TextStyle(fontSize: 11, color: Colors.black38)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => PaymentUploadSheet(
                    transactionId: widget.transactionId,
                    nominal: widget.nominal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Saya Sudah Transfer',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 3 — Upload Bukti Pembayaran
// ═══════════════════════════════════════════════════════════
class PaymentUploadSheet extends StatefulWidget {
  final String transactionId;
  final int nominal;

  const PaymentUploadSheet({
    super.key,
    required this.transactionId,
    required this.nominal,
  });

  @override
  State<PaymentUploadSheet> createState() => _PaymentUploadSheetState();
}

class _PaymentUploadSheetState extends State<PaymentUploadSheet> {
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _confirm() async {
    setState(() => _isUploading = true);
    try {
      if (_image != null) {
        await PaymentService().uploadBukti(_image!, widget.transactionId);
      }
      // Simulasi auto-verify 10 detik (fire & forget)
      PaymentService().simulateVerification(widget.transactionId);

      if (!mounted) return;
      Navigator.pop(context);

      // Step 4: Success
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PaymentSuccessSheet(transactionId: widget.transactionId),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHeader(title: 'Upload Bukti Transfer'),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Tap untuk pilih foto bukti transfer',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text('*Opsional — bisa skip jika tidak ada bukti',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUploading ? null : _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Konfirmasi Pembayaran',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 4 — Sukses
// ═══════════════════════════════════════════════════════════
class PaymentSuccessSheet extends StatelessWidget {
  final String transactionId;

  const PaymentSuccessSheet({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return _SheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          ),
          const SizedBox(height: 20),
          const Text('Pembayaran Dikonfirmasi!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Transaksi Anda sedang diverifikasi.\nBiasanya selesai dalam beberapa saat.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(transactionId,
                style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          const Text('Simpan nomor transaksi di atas',
              style: TextStyle(fontSize: 11, color: Colors.black38)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Selesai',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Helper Widgets
// ═══════════════════════════════════════════════════════════

class _SheetContainer extends StatelessWidget {
  final Widget child;
  const _SheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child,
        ],
      ),
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
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.id,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? ColorDouce.douceBase.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? ColorDouce.douceBase : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? ColorDouce.douceBase : Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? ColorDouce.douceBase : Colors.black87,
                )),
            const Spacer(),
            if (selected)
              Icon(Icons.check_circle, color: ColorDouce.douceBase, size: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}

class _InfoRowCopy extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRowCopy(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nomor disalin!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Row(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(width: 6),
              const Icon(Icons.copy, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
