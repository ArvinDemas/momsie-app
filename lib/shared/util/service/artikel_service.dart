import 'package:cloud_firestore/cloud_firestore.dart';

class ArtikelService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getArtikel() async {
    try {
      QuerySnapshot querySnapshot = await _firebase.collection('artikel').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
