import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class PesananService {
  Future<List<PesananModel>> getPesanan() async {
    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot snapshot = await firestore
          .collection('booking')
          .where('user', isEqualTo: userController.uid.value)
          .get();

      List<PesananModel> pesanan = [];
      List<Future> futures = [];

      for (var doc in snapshot.docs) {
        futures.add(
          () async {
            String namaUser = '';

            var userDoc =
                await firestore.collection('user').doc(doc['user']).get();
            namaUser = userDoc.data()?['username'] ?? '';

            return PesananModel(
              id: doc['id'],
              pemesan: doc['user'],
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: namaUser,
            );
          }(),
        );
      }

      await Future.wait(futures).then((List<dynamic> results) {
        pesanan.addAll(results.cast<PesananModel>());
      });

      return pesanan;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<List<PesananModel>> getPekerjaan(bool isDoula) async {
    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot snapshot = isDoula
          ? await firestore.collection('pekerjaan').get()
          : await firestore
              .collection('pekerjaan')
              .where('user', isEqualTo: userController.uid.value)
              .get();

      List<PesananModel> pesanan = [];
      List<Future> futures = [];

      for (var doc in snapshot.docs) {
        futures.add(
          () async {
            String namaUser = '';

            var userDoc =
                await firestore.collection('user').doc(doc['user']).get();
            namaUser = userDoc.data()?['username'] ?? '';

            return PesananModel(
              id: doc['id'],
              pemesan: doc['user'],
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: namaUser,
            );
          }(),
        );
      }

      await Future.wait(futures).then((List<dynamic> results) {
        pesanan.addAll(results.cast<PesananModel>());
      });

      return pesanan;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

class ActiveService {
  Future<List<ActiveModel>> getActive(bool isDoula) async {
    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot snapshot = isDoula
          ? await firestore
              .collection('active')
              .where('doula', isEqualTo: userController.uid.value)
              .get()
          : await firestore
              .collection('active')
              .where('user', isEqualTo: userController.uid.value)
              .get();

      List<ActiveModel> pesanan = [];
      List<Future> futures = [];

      for (var doc in snapshot.docs) {
        futures.add(
          () async {
            String namaUser = '';
            String namaDoula = '';

            var userDoc =
                await firestore.collection('user').doc(doc['user']).get();
            namaUser = userDoc.data()?['username'] ?? '';

            var doulaDoc =
                await firestore.collection('mitra').doc(doc['doula']).get();
            namaDoula = doulaDoc.data()?['name'] ?? '';

            return ActiveModel(
              id: doc['id'],
              pemesan: doc['user'],
              doula: doc['doula'],
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: namaUser,
              namaDoula: namaDoula,
            );
          }(),
        );
      }

      await Future.wait(futures).then((List<dynamic> results) {
        pesanan.addAll(results.cast<ActiveModel>());
      });

      return pesanan;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ActiveModel>> getRiwayat(bool isDoula) async {
    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot snapshot = isDoula
          ? await firestore
              .collection('riwayat')
              .where('doula', isEqualTo: userController.uid.value)
              .get()
          : await firestore
              .collection('riwayat')
              .where('user', isEqualTo: userController.uid.value)
              .get();

      List<ActiveModel> pesanan = [];
      List<Future> futures = [];

      for (var doc in snapshot.docs) {
        futures.add(
          () async {
            String namaUser = '';
            String namaDoula = '';

            var userDoc =
                await firestore.collection('user').doc(doc['user']).get();
            namaUser = userDoc.data()?['username'] ?? '';

            var doulaDoc =
                await firestore.collection('mitra').doc(doc['doula']).get();
            namaDoula = doulaDoc.data()?['name'] ?? '';

            return ActiveModel(
              id: doc['id'],
              pemesan: doc['user'],
              doula: doc['doula'],
              tanggal: doc['tanggal'],
              day: doc['day'],
              jam: doc['jam'],
              layanan: doc['layanan'],
              harga: doc['harga'].toString(),
              namaUser: namaUser,
              namaDoula: namaDoula,
            );
          }(),
        );
      }

      await Future.wait(futures).then((List<dynamic> results) {
        pesanan.addAll(results.cast<ActiveModel>());
      });

      return pesanan;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
