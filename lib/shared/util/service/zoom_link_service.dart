import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ZoomLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'zoom_links';

  /// Ambil link Zoom untuk booking tertentu
  Future<String?> getZoomLink(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['linkUrl'] as String?;
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Get zoom link error: $e');
      return null;
    }
  }

  /// Stream zoom link untuk booking (real-time)
  Stream<String?> streamZoomLink(String bookingId) {
    return _firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .snapshots()
        .map((snap) =>
            snap.docs.isNotEmpty ? snap.docs.first.data()['linkUrl'] as String? : null);
  }

  /// Buat zoom link baru
  Future<void> createZoomLink({
    required String bookingId,
    required String doulaId,
    required String linkUrl,
    required String scheduledDate,
    required String scheduledTime,
    required String createdBy,
  }) async {
    try {
      final id = 'ZL-${DateTime.now().millisecondsSinceEpoch}';
      await _firestore.collection(_collection).doc(id).set({
        'id': id,
        'bookingId': bookingId,
        'doulaId': doulaId,
        'linkUrl': linkUrl,
        'scheduledDate': scheduledDate,
        'scheduledTime': scheduledTime,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Create zoom link error: $e');
      rethrow;
    }
  }

  /// Update zoom link
  Future<void> updateZoomLink(String bookingId, String linkUrl) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({'linkUrl': linkUrl});
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Update zoom link error: $e');
      rethrow;
    }
  }

  /// Hapus zoom link
  Future<void> deleteZoomLink(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Delete zoom link error: $e');
    }
  }

  /// Ambil semua zoom link untuk doula tertentu
  Stream<List<Map<String, dynamic>>> streamZoomLinksByDoula(String doulaId) {
    return _firestore
        .collection(_collection)
        .where('doulaId', isEqualTo: doulaId)
        .orderBy('scheduledDate')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
