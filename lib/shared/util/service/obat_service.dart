import 'package:cloud_firestore/cloud_firestore.dart';

class ObatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getObat() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('obat').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }
}