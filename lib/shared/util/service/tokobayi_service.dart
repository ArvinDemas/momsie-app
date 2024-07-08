import 'package:cloud_firestore/cloud_firestore.dart';

class TokoBayiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTokoBayi() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('tokobayi').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
