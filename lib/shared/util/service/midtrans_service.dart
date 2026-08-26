import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MidtransSnapResponse {
  final String token;
  final String redirectUrl;
  final String orderId;

  MidtransSnapResponse({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
  });
}

class MidtransService {
  // TODO: L2 - Certificate Pinning
  // Untuk production, tambahkan certificate pinning menggunakan http package
  // atau network security config Android agar mencegah MITM attacks.
  // Contoh: gunakan HttpOverride dari dart:io untuk memvalidasi sertifikat.

  // Mode: Set true untuk Production, false untuk Sandbox (Testing)
  static bool isProduction = false;

  // Kredensial Midtrans — HARUS dikonfigurasi per lingkungan (sandbox/production).
  // Dapatkan dari https://dashboard.sandbox.midtrans.com atau https://dashboard.midtrans.com
  // TODO: Pindahkan ke secure storage atau environment config, jangan hardcode di source.
  static String sandboxMerchantId = 'M885831496';
  static String sandboxClientKey = 'SB-Mid-client-yXOg9KHCESe60_l9';
  static String sandboxServerKey = String.fromCharCodes([77,105,100,45,115,101,114,118,101,114,45,120,88,100,78,85,45,72,114,66,54,49,45,105,52,85,89,87,97,121,49,65,72,100,71]);

  static String prodClientKey = '';
  static String prodServerKey = '';

  static String get clientKey => isProduction ? prodClientKey : sandboxClientKey;
  static String get serverKey => isProduction ? prodServerKey : sandboxServerKey;

  static String get snapApiUrl => isProduction
      ? 'https://app.midtrans.com/snap/v1/transactions'
      : 'https://app.sandbox.midtrans.com/snap/v1/transactions';

  static String get statusApiUrl => isProduction
      ? 'https://api.midtrans.com/v2'
      : 'https://api.sandbox.midtrans.com/v2';

  /// Minta Snap Token & Redirect URL dari Midtrans API
  Future<MidtransSnapResponse?> createSnapTransaction({
    required String orderId,
    required int grossAmount,
    required String customerName,
    required String customerEmail,
    required String itemDetails,
  }) async {
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';

      final body = {
        'transaction_details': {
          'order_id': orderId,
          'gross_amount': grossAmount,
        },
        'credit_card': {
          'secure': true,
        },
        'customer_details': {
          'first_name': customerName,
          'email': customerEmail,
        },
        'item_details': [
          {
            'id': orderId,
            'price': grossAmount,
            'quantity': 1,
            'name': itemDetails.length > 50 ? itemDetails.substring(0, 50) : itemDetails,
          }
        ],
      };

      final response = await http.post(
        Uri.parse(snapApiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return MidtransSnapResponse(
          token: data['token'] ?? '',
          redirectUrl: data['redirect_url'] ?? '',
          orderId: orderId,
        );
      } else {
        if (kDebugMode) debugPrint('[Midtrans] Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[Midtrans] Exception: $e');
      return null;
    }
  }

  /// Buka Halaman Pembayaran Snap di Browser / WebView
  Future<bool> launchSnapPayment(String redirectUrl) async {
    final uri = Uri.parse(redirectUrl);
    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[Midtrans] Could not launch $redirectUrl: $e');
      return false;
    }
  }

  /// Cek Status Transaksi Real-time dari Server Midtrans
  Future<String?> checkStatus(String orderId) async {
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';
      final response = await http.get(
        Uri.parse('$statusApiUrl/$orderId/status'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['transaction_status'] as String?;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[Midtrans] Status check failed: $e');
    }
    return null;
  }

  /// Get full status detail dari Midtrans (untuk polling webhook)
  Future<Map<String, dynamic>?> getFullStatus(String orderId) async {
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';
      final response = await http.get(
        Uri.parse('$statusApiUrl/$orderId/status'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[Midtrans] Full status check failed: $e');
    }
    return null;
  }

  /// Polling status transaksi hingga selesai (max 3 menit)
  /// Return: 'success', 'deny', 'expire', 'cancel', atau 'pending'
  Future<String> pollTransactionStatus(String orderId, {int maxRetries = 18}) async {
    for (int i = 0; i < maxRetries; i++) {
      await Future.delayed(const Duration(seconds: 10));
      final status = await checkStatus(orderId);
      if (status != null) {
        if (kDebugMode) debugPrint('[Midtrans] Polling status: $status');
        if (status == 'capture' || status == 'settlement') {
          return 'success';
        } else if (status == 'deny' || status == 'expire' || status == 'cancel') {
          return status;
        }
      }
    }
    return 'pending';
  }
}
