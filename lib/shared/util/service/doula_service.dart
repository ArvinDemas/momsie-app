import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/doula_model.dart';

class DoulaService {
  Future<List<DoulaModel>> getDoula() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> doulaSnapshot =
          await firestore.collection('mitra').get();
      return doulaSnapshot.docs
          .map((doc) => DoulaModel.fromMap(doc.data(), uid: doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
