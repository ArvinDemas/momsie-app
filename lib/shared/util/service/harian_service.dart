import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/harian_model.dart';

class HarianService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HarianModel>> getHarian() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('harian').get();

      return snapshot.docs
          .map((doc) => HarianModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
