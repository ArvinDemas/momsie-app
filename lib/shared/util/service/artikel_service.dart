import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/data/dummy_data.dart';
import 'package:douce/shared/util/model/artikel_model.dart';

class ArtikelService {
  Future<List<ArtikelModel>> getArtikel() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('artikels')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final cloudList = snapshot.docs
            .map((doc) => ArtikelModel.fromMap(doc.data()))
            .toList();

        final combined = <ArtikelModel>[...cloudList];
        for (var d in DummyData.artikels) {
          if (!combined.any((e) => e.title.toLowerCase() == d.title.toLowerCase())) {
            combined.add(d);
          }
        }
        return combined;
      }
    } catch (e) {
      // Fallback jika offline
    }
    return DummyData.artikels;
  }
}
