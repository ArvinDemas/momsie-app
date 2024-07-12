import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/obat_model.dart';
import 'package:douce/shared/util/model/tokobayi_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ObatModel>> searchObat(String query) async {
    try {
      final List<ObatModel> obatList = <ObatModel>[];

      final QuerySnapshot<Map<String, dynamic>> obatSnapshot = await _firestore
          .collection('obat')
          .where('nama', isGreaterThanOrEqualTo: query)
          .where('nama', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(4)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> obat
          in obatSnapshot.docs) {
        obatList.add(ObatModel.fromJson(obat.data()));
      }

      return obatList;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<List<TokoBayiModel>> searchTokoBayi(String query) async {
    try {
      final List<TokoBayiModel> tokoBayiList = <TokoBayiModel>[];

      final QuerySnapshot<Map<String, dynamic>> tokoBayiSnapshot =
          await _firestore
              .collection('tokobayi')
              .where('nama', isGreaterThanOrEqualTo: query)
              .where('nama', isLessThanOrEqualTo: '$query\uf8ff')
              .limit(4)
              .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> tokoBayi
          in tokoBayiSnapshot.docs) {
        tokoBayiList.add(TokoBayiModel.fromJson(tokoBayi.data()));
      }

      return tokoBayiList;
    } catch (e) {
      // print(e);
      return [];
    }
  }
}
