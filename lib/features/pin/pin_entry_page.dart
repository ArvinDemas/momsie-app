import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/features/mitra/profil/setup_pin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Halaman penuh untuk input PIN 6 digit.
/// Diganti dari PinInputDialog bottomSheet yang "gepeng".
class PinEntryPage extends StatefulWidget {
  /// Alasan verifikasi: 'pin_auth', 'withdraw', 'change_pin'
  final String reason;

  const PinEntryPage({super.key, this.reason = 'pin_auth'});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage>
    with SingleTickerProviderStateMixin {
  // Simpan digit sebagai list supaya setState langsung update dot visual
  final List<String> _digits = List.filled(6, '');
  final PinAuthService _pinService = Get.find<PinAuthService>();

  bool _isLoading = false;
  bool _error = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    final idx = _digits.indexWhere((d) => d.isEmpty);
    if (idx == -1) return; // sudah penuh
    setState(() => _digits[idx] = digit);
    // Auto-submit saat 6 digit terisi
    if (_digits.every((d) => d.isNotEmpty)) {
      Future.delayed(const Duration(milliseconds: 80), _verifyPin);
    }
  }

  void _onBackspace() {
    // Cari digit terakhir yang terisi dari belakang
    for (int i = 5; i >= 0; i--) {
      if (_digits[i].isNotEmpty) {
        setState(() => _digits[i] = '');
        break;
      }
    }
  }

  Future<void> _verifyPin() async {
    final pin = _digits.join();
    if (pin.length != 6) return;

    setState(() => _isLoading = true);
    try {
      final verified = await _pinService.verifyPin(pin);
      if (!mounted) return;

      if (verified) {
        Get.back(result: true);
      } else {
        setState(() => _error = true);
        _shakeController.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          setState(() {
            for (int i = 0; i < 6; i++) _digits[i] = '';
            _error = false;
          });
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: ColorDouce.douceBase),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 12),

              // Fingerprint icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.fingerprint,
                    size: 40, color: Color(0xFFDB2777)),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Masukkan PIN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppSemanticColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _getReasonText(),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // PIN Dots (6 dots)
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  if (_error) {
                    return Transform.translate(
                      offset: Offset(
                        _shakeAnimation.value * 10 - 5,
                        0,
                      ),
                      child: child,
                    );
                  }
                  return child!;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) => _PinDot(
                        filled: _digits[i].isNotEmpty,
                        error: _error && i == _enteredCount - 1,
                      )),
                ),
              ),
              if (_error) ...[
                const SizedBox(height: 8),
                const Text('PIN salah, coba lagi',
                    style: TextStyle(color: Colors.red, fontSize: 13)),
              ],

              const SizedBox(height: 24),

              // Loading indicator
              if (_isLoading)
                CircularProgressIndicator(color: ColorDouce.douceBase),

              // Numpad
              if (!_isLoading) ...[
                _PinNumpad(
                  onDigit: _onDigitPressed,
                  onBackspace: _onBackspace,
                  onForgotPin: _handleForgotPin,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleForgotPin() async {
    if (!mounted) return;

    final pinService = Get.find<PinAuthService>();
    final bioAvailable = pinService.isBiometricAvailable.value;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _ForgotPinBottomSheet(
        bioAvailable: bioAvailable,
        navigatorContext: sheetCtx,
      ),
    );

    if (result != true || !mounted) return;

    setState(() {
      for (int i = 0; i < 6; i++) _digits[i] = '';
      _error = false;
    });

    Get.snackbar(
      'PIN Baru Tersimpan',
      'PIN berhasil diubah, silakan gunakan PIN baru Anda',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  int get _enteredCount => _digits.where((d) => d.isNotEmpty).length;

  String _getReasonText() {
    switch (widget.reason) {
      case 'withdraw':
        return 'Verifikasi untuk penarikan dana';
      case 'change_pin':
        return 'Verifikasi untuk mengubah PIN';
      default:
        return 'Masukkan PIN 6 digit untuk melanjutkan';
    }
  }
}

// ── Sub-widgets ─────────────────────────────────────────────

class _PinDot extends StatelessWidget {
  final bool filled;
  final bool error;

  const _PinDot({required this.filled, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: error
            ? Colors.red.shade100
            : filled
                ? ColorDouce.douceBase
                : Colors.grey.shade100,
        border: Border.all(
          color: error
              ? Colors.red.shade300
              : filled
                  ? ColorDouce.douceBase
                  : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: filled
            ? Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}

class _PinNumpad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onForgotPin;

  const _PinNumpad({
    required this.onDigit,
    required this.onBackspace,
    this.onForgotPin,
  });

  @override
  Widget build(BuildContext context) {
    final digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'Lupa?', '0', '⌫'];
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
        if (d == 'Lupa?') {
          if (onForgotPin == null) return const SizedBox.shrink();
          return _LupaBtn(onPressed: onForgotPin!);
        }
        if (d.isEmpty) return const SizedBox.shrink();
        if (d == '⌫') {
          return _NumBtn(
            icon: Icons.backspace,
            onPressed: onBackspace,
          );
        }
        return _NumBtn(
          label: d,
          onPressed: () => onDigit(d),
        );
      },
    );
  }
}

class _LupaBtn extends StatelessWidget {
  final VoidCallback onPressed;
  const _LupaBtn({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Text(
            'Lupa?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppSemanticColors.textDarkSecondary,
            ),
          ),
        ),
      ),
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
              : Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppSemanticColors.textDarkSecondary,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ForgotPinBottomSheet extends StatefulWidget {
  final bool bioAvailable;
  final BuildContext navigatorContext;
  const _ForgotPinBottomSheet({required this.bioAvailable, required this.navigatorContext});

  @override
  State<_ForgotPinBottomSheet> createState() => _ForgotPinBottomSheetState();
}

class _ForgotPinBottomSheetState extends State<_ForgotPinBottomSheet> {
  final _passwordController = TextEditingController();
  final _pinService = Get.find<PinAuthService>();
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitPassword() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _error = 'Masukkan kata sandi akun Momsie');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      setState(() => _error = 'Tidak ada akun yang terdaftar');
      return;
    }

    setState(() { _isLoading = true; _error = null; });
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      if (!mounted) return;
      final result = await Get.to<bool>(() => SetupPinPage(isReset: true));
      if (result == true && mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(widget.navigatorContext).pop(true);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          msg = 'Kata sandi akun salah';
          break;
        case 'too-many-requests':
          msg = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        case 'user-not-found':
          msg = 'Akun tidak ditemukan';
          break;
        default:
          msg = 'Verifikasi gagal: ${e.message}';
      }
      setState(() { _error = msg; _isLoading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Terjadi kesalahan. Coba lagi.'; _isLoading = false; });
    }
  }

  Future<void> _submitBiometric() async {
    if (!widget.bioAvailable) return;
    setState(() { _isLoading = true; _error = null; });
    final success = await _pinService.authenticateBiometric();
    if (!mounted) return;
    if (success) {
      final result = await Get.to<bool>(() => SetupPinPage(isReset: true));
      if (result == true) {
        if (mounted) Navigator.of(context).pop(true);
      }
    } else {
      setState(() { _error = 'Verifikasi biometrik gagal'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verifikasi Lupa PIN',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan kata sandi akun Momsie untuk membuat PIN baru',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          if (widget.bioAvailable) ...[
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _submitBiometric,
              icon: const Icon(Icons.fingerprint, size: 20),
              label: const Text('Verifikasi dengan Sidik Jari'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: ColorDouce.douceBase),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Akun Momsie',
              hintText: 'Masukkan kata sandi',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitPassword(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorDouce.douceBase,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Lanjutkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: TextStyle(color: AppSemanticColors.textMuted)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
