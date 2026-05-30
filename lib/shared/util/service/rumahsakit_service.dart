import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';

class RumahSakitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RumahSakitModel>> getRumahSakit() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('rumahsakit').get();
      return snapshot.docs
          .map((doc) => RumahSakitModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
