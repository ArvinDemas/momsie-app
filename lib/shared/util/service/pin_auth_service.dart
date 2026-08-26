import 'package:douce/features/pin/pin_entry_page.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';

class PinAuthService extends GetxController {
  static const _pinKey = 'user_pin_hash';
  static const _pinMigrationDoneKey = 'pin_hash_migrated';
  static const _biometricKey = 'user_biometric_enabled';
  static const _isSetupKey = 'pin_is_setup';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  final RxBool isBiometricAvailable = false.obs;
  final RxBool hasPinSetup = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    try {
      final available = await _localAuth.isDeviceSupported();
      final biometricSupported = await _localAuth.canCheckBiometrics;
      isBiometricAvailable.value = available && biometricSupported;

      final setup = await _storage.read(key: _isSetupKey);
      hasPinSetup.value = setup == '1';
    } catch (e) {
      debugPrint('PIN init error: $e');
    }
  }

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<bool> setupPin(String pin) async {
    if (pin.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(pin)) return false;

    try {
      await _storage.write(key: _pinKey, value: _hashPin(pin));
      await _storage.write(key: _isSetupKey, value: '1');
      hasPinSetup.value = true;
      return true;
    } catch (e) {
      debugPrint('SetPin error: $e');
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricKey, value: enabled ? '1' : '0');
  }

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _biometricKey);
    return val == '1';
  }

  /// Verifikasi PIN 6 digit
  Future<bool> verifyPin(String pin) async {
    if (pin.length != 6) return false;
    final stored = await _storage.read(key: _pinKey);
    if (stored == null) return false;

    // Migration: jika nilai masih plain 6-digit PIN, re-hash
    if (!stored.contains('-') && stored.length == 6) {
      await _storage.write(key: _pinKey, value: _hashPin(stored));
      await _storage.write(key: _pinMigrationDoneKey, value: '1');
      return true;
    }

    return stored == _hashPin(pin);
  }

  Future<bool> authenticateBiometric() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      if (!canAuth) return false;

      final success = await _localAuth.authenticate(
        localizedReason:
            'Scan sidik jari atau gunakan Face ID untuk konfirmasi',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return success ?? false;
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }

  /// Prompt autentikasi: biometrik dulu, fallback ke halaman PIN penuh
  Future<bool> promptAuth({String reason = ''}) async {
    final bioEnabled = await isBiometricEnabled();
    if (bioEnabled && isBiometricAvailable.value) {
      final bioSuccess = await authenticateBiometric();
      if (bioSuccess) return true;
    }

    // BUKAN bottomSheet — gunakan Full Page
    final result = await Get.to<bool>(() => PinEntryPage(reason: reason));
    return result ?? false;
  }

  /// OLD method untuk backward compatibility — tetap fungsional tapi deprecated
  Future<bool?> showPinDialog({String reason = ''}) async {
    final result = await Get.to<bool>(() => PinEntryPage(reason: reason));
    return result;
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    final validOld = await verifyPin(oldPin);
    if (!validOld) return false;
    if (newPin.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(newPin)) {
      return false;
    }

    await _storage.write(key: _pinKey, value: _hashPin(newPin));
    return true;
  }

  Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _isSetupKey);
    await _storage.delete(key: _biometricKey);
    hasPinSetup.value = false;
  }
}
