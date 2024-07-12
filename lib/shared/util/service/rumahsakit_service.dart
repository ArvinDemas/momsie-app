import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/rumahsakit_model.dart';

class RumahSakitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RumahSakitModel>> getRumahSakit() async {
    try {
      List<RumahSakitModel> listRumahSakit = [];

      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('rumahsakit').get();
      snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
        final Map<String, dynamic> data = e.data();
        listRumahSakit.add(RumahSakitModel(
          nama: data['nama'],
          latitude: double.parse(data['latitude']),
          longitude: double.parse(data['longitude']),
          alamat: data['alamat'],
          layanan: data['layanan'],
          rating: data['rating'],
          image: data['image'],
        ));
      }).toList();

      return listRumahSakit;
    } catch (e) {
      return [];
    }
  }
}
