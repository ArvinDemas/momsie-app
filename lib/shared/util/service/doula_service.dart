import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/doula_model.dart';

class DoulaService {
  Future<List<DoulaModel>> getDoula() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> doulaSnapshot =
          await firestore.collection('mitra').get();
      return doulaSnapshot.docs.map((doc) {
        return DoulaModel(
          uid: doc.id,
          image: doc['image'],
          name: doc['name'],
          job: doc['pekerjaan'],
          alamat: doc['alamat'],
          jenisKelamin: doc['jenisKelamin'],
          biografi: doc['biografi'],
          rating: doc['rating'].toString(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
