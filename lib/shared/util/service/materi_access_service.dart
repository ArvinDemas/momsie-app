import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// T-023: Service untuk mengelola akses materi on-demand
/// (materi_online, paket_bundling) setelah pembayaran dikonfirmasi.
class MateriAccessService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'materi_access';

  Future<T> _retry<T>(Future<T> Function() fn, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await fn();
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1 << i));
      }
    }
    return await fn();
  }

  static String docId(String userId, String layanan) => '${userId}_$layanan';

  /// Grant akses untuk user pada layanan on-demand tertentu (idempotent)
  Future<void> grantAccess({
    required String userId,
    required String bookingId,
    required String layanan,
  }) async {
    try {
      await _retry(() => _firestore.collection(_collection)
          .doc(docId(userId, layanan))
          .set({
        'userId': userId,
        'layanan': layanan,
        'bookingId': bookingId,
        'grantedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)));
    } catch (e) {
      if (kDebugMode) debugPrint('Grant access error: $e');
      rethrow;
    }
  }

  /// Cek apakah user memiliki akses ke layanan tertentu
  Future<bool> hasAccess(String userId, String layanan) async {
    try {
      final doc = await _retry(() => _firestore
          .collection(_collection)
          .doc(docId(userId, layanan))
          .get());
      return doc.exists;
    } catch (e) {
      if (kDebugMode) debugPrint('Has access error: $e');
      return false;
    }
  }

  /// Stream status akses (real-time, untuk UI gating)
  Stream<bool> streamAccess(String userId, String layanan) {
    return _firestore
        .collection(_collection)
        .doc(docId(userId, layanan))
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Ambil daftar layanan yang sudah di-akses/dibeli user
  Future<List<String>> getAccessedList(String userId) async {
    try {
      final snapshot = await _retry(() => _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get());
      return snapshot.docs.map((doc) => doc['layanan'] as String).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('Get accessed list error: $e');
      return [];
    }
  }

  /// Hapus akses (dipakai saat refund / cancel confirmed booking)
  Future<void> revokeAccess({
    required String userId,
    required String layanan,
  }) async {
    try {
      await _retry(() => _firestore
          .collection(_collection)
          .doc(docId(userId, layanan))
          .delete());
    } catch (e) {
      if (kDebugMode) debugPrint('Revoke access error: $e');
      rethrow;
    }
  }
}
