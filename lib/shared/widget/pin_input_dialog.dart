import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/service/pin_auth_service.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget dialog input PIN 6 digit
class PinInputDialog extends StatefulWidget {
  final String reason;
  const PinInputDialog({required this.reason, super.key});

  @override
  State<PinInputDialog> createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<PinInputDialog> {
  final List<String> _entered = [];
  bool _error = false;
  bool _isLoading = false;
  final PinAuthService _pinService = Get.find<PinAuthService>();

  Future<void> _onDigitPress(String digit) async {
    if (_entered.length >= 6 || _isLoading) return;
    setState(() => _entered.add(digit));

    if (_entered.length == 6) {
      setState(() => _isLoading = true);
      final success = await _pinService.verifyPin(_entered.join());
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _isLoading = false;
        _error = !success;
        if (success) _entered.clear();
      });

      if (success) {
        Get.back(result: true);
      } else {
        // Shake animation feedback
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() => _entered.clear());
        });
      }
    }
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() => _entered.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.fingerprint, size: 32, color: Color(0xFFDB2777)),
          ),
          const SizedBox(height: 16),

          Text(
            widget.reason.isNotEmpty ? widget.reason : 'Verifikasi PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppSemanticColors.textDarkSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text('Masukkan PIN 6 digit untuk melanjutkan', style: TextStyle(fontSize: 13, color: Colors.grey)),

          // PIN Dots
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              final filled = i < _entered.length;
              final error = _error && i == _entered.length - 1;
              return Container(
                width: 40, height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: error ? Colors.red.shade100 : filled ? ColorDouce.douceBase : Colors.grey.shade100,
                ),
                child: Center(
                  child: filled
                      ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                      : null,
                ),
              );
            }),
          ),
          if (_error) const SizedBox(height: 8),
          if (_error) Text('PIN salah, coba lagi', style: TextStyle(color: Colors.red, fontSize: 12)),

          const SizedBox(height: 24),
          if (_isLoading) SizedBox(
            width: 24, height: 24,
            child: CircularProgressIndicator(color: ColorDouce.douceBase),
          ),

          // Numpad
          if (!_isLoading) ...[
            Numpad(onPress: _onDigitPress, onDelete: _onDelete),
          ],
        ],
      ),
    );
  }
}

class Numpad extends StatelessWidget {
  final void Function(String) onPress;
  final void Function() onDelete;
  const Numpad({required this.onPress, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1','2','3','4','5','6','7','8','9'].map((d) => Expanded(child: _numBtn(d))).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(child: SizedBox.shrink()),
            Expanded(child: _numBtn('0')),
            Expanded(child: _delBtn()),
          ],
        ),
      ],
    );
  }

  Widget _numBtn(String label) {
    final VoidCallback? onTap = label.isEmpty ? null : () => onPress(label);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }

  Widget _delBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onDelete,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.backspace, size: 26, color: Colors.grey),
        ),
      ),
    );
  }
}
