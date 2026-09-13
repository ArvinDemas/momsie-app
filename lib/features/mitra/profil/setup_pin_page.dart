import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Halaman setup PIN pertama kali — tampilan sama dengan PinEntryPage
class SetupPinPage extends StatefulWidget {
  final bool isReset;
  const SetupPinPage({super.key, this.isReset = false});
  @override
  State<SetupPinPage> createState() => _SetupPinPageState();
}

class _SetupPinPageState extends State<SetupPinPage> {
  final PinAuthService _pinService = Get.find<PinAuthService>();
  // Langkah 1: buat pin, Langkah 2: konfirmasi pin
  final List<String> _step1 = List.filled(6, '');
  final List<String> _step2 = List.filled(6, '');
  bool _error = false;
  int _step = 1; // 1 = input, 2 = konfirmasi
  bool _isLoading = false;

  void _onDigit(String d) {
    final list = _step == 1 ? _step1 : _step2;
    final idx = list.indexWhere((x) => x.isEmpty);
    if (idx == -1) return;
    setState(() => list[idx] = d);
    if (list.every((x) => x.isNotEmpty)) {
      if (_step == 1) {
        // lanjut ke langkah konfirmasi setelah delay
        setState(() => _isLoading = true);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          setState(() { _isLoading = false; _step = 2; });
        });
      } else {
        // verifikasi konfirmasi
        if (list.join() == _step1.join()) {
          setState(() => _isLoading = true);
          _pinService.setupPin(list.join()).then((success) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            if (success) Get.back(result: true);
            else {
              setState(() => _error = true);
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!mounted) return;
                setState(() { _error = false; _step2.fillRange(0, 6, ''); });
              });
            }
          });
        } else {
          setState(() => _error = true);
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            setState(() { _error = false; _step2.fillRange(0, 6, ''); });
          });
        }
      }
    }
  }

  void _onDelete() {
    final list = _step == 1 ? _step1 : _step2;
    for (int i = 5; i >= 0; i--) {
      if (list[i].isNotEmpty) {
        setState(() => list[i] = '');
        break;
      }
    }
  }

  int get _enteredCount => _step == 1 ? _step1.where((d) => d.isNotEmpty).length : _step2.where((d) => d.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.fingerprint, size: 40, color: Color(0xFFDB2777)),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                _step == 1
                    ? (widget.isReset ? 'Buat PIN Baru' : 'Buat PIN Transaksi')
                    : (widget.isReset ? 'Konfirmasi PIN Baru' : 'Konfirmasi PIN'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _step == 1
                    ? (widget.isReset ? 'PIN baru akan menggantikan PIN lama Anda' : 'PIN 6 digit diperlukan untuk transaksi & penarikan dana')
                    : 'Masukkan kembali PIN yang sama',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) => _PinDot(
                      filled: (_step == 1 ? _step1 : _step2)[i].isNotEmpty,
                      error: _error && i == _enteredCount - 1,
                    )),
              ),
              if (_error) ...[
                const SizedBox(height: 8),
                const Text('PIN tidak cocok, coba lagi', style: TextStyle(color: Colors.red, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              // Loading
              if (_isLoading) CircularProgressIndicator(color: ColorDouce.douceBase),
              // Numpad
              if (!_isLoading) ...[
                _PinNumpad(onDigit: _onDigit, onBackspace: _onDelete),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets (sama dengan PinEntryPage) ───────────────────────

class _PinDot extends StatelessWidget {
  final bool filled;
  final bool error;
  const _PinDot({required this.filled, this.error = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44, margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: error ? Colors.red.shade100 : filled ? ColorDouce.douceBase : Colors.grey.shade100,
        border: Border.all(
          color: error ? Colors.red.shade300 : filled ? ColorDouce.douceBase : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: filled
            ? Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))
            : null,
      ),
    );
  }
}

class _PinNumpad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  const _PinNumpad({required this.onDigit, required this.onBackspace});
  @override
  Widget build(BuildContext context) {
    final digits = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: digits.length,
      itemBuilder: (context, idx) {
        final d = digits[idx];
        if (d.isEmpty) return const SizedBox.shrink();
        if (d == '⌫') {
          return _NumBtn(icon: Icons.backspace, onPressed: onBackspace);
        }
        return _NumBtn(label: d, onPressed: () => onDigit(d));
      },
    );
  }
}

class _NumBtn extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  const _NumBtn({this.label, this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: icon != null
              ? Icon(icon, size: 28, color: AppSemanticColors.textDarkSecondary)
              : Text(label!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppSemanticColors.textDarkSecondary)),
        ),
      ),
    );
  }
}
