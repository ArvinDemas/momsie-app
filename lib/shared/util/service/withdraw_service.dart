import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/withdrawal_model.dart';

class WithdrawService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'withdrawals';

  /// Buat request withdraw baru
  Future<String> createWithdrawal({
    required String doulaUid,
    required String doulaName,
    required int nominal,
    required String bank,
    required String noRekening,
    required String atasNama,
  }) async {
    final docRef = _firestore.collection(_collection).doc();
    final withdrawal = WithdrawalModel(
      id: docRef.id,
      doulaUid: doulaUid,
      doulaName: doulaName,
      nominal: nominal,
      bank: bank,
      noRekening: noRekening,
      atasNama: atasNama,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await docRef.set(withdrawal.toMap());
    return docRef.id;
  }

  /// Update status withdraw
  Future<void> updateStatus(String withdrawalId, String status) async {
    await _firestore.collection(_collection).doc(withdrawalId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream semua withdraw untuk doula tertentu
  Stream<List<WithdrawalModel>> streamWithdrawalsByDoula(String doulaUid) {
    return _firestore
        .collection(_collection)
        .where('doulaUid', isEqualTo: doulaUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => WithdrawalModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  /// Stream semua withdraw (untuk admin)
  Stream<List<WithdrawalModel>> streamAllWithdrawals() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => WithdrawalModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }
}
