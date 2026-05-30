import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/pesanan_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:get/get.dart';

class PesananService {
  /// Batch-fetch usernames dari koleksi 'user' (maks 30 per query).
  Future<Map<String, String>> _fetchUsernames(List<String> uids) async {
    return fetchUsernamesPublic(uids);
  }

  /// Public version — dapat dipakai oleh controller lain (misal: stream-based controller).
  Future<Map<String, String>> fetchUsernamesPublic(List<String> uids) async {
    final Map<String, String> usernames = {};
    if (uids.isEmpty) return usernames;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final List<String> uniqueUids = uids.toSet().toList();

    final List<List<String>> chunks = [];
    for (var i = 0; i < uniqueUids.length; i += 30) {
      chunks.add(uniqueUids.sublist(i, i + 30 > uniqueUids.length ? uniqueUids.length : i + 30));
    }

    for (var chunk in chunks) {
      final querySnapshot = await firestore
          .collection('user')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (var doc in querySnapshot.docs) {
        usernames[doc.id] = doc.data()['username'] ?? '';
      }
    }
    return usernames;
  }

  /// Batch-fetch nama doula dari koleksi 'mitra' (maks 30 per query).
  Future<Map<String, String>> fetchDolaNamePublic(List<String> uids) async {
    final Map<String, String> names = {};
    if (uids.isEmpty) return names;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final List<String> uniqueUids = uids.toSet().toList();

    final List<List<String>> chunks = [];
    for (var i = 0; i < uniqueUids.length; i += 30) {
      chunks.add(uniqueUids.sublist(i, i + 30 > uniqueUids.length ? uniqueUids.length : i + 30));
    }

    for (var chunk in chunks) {
      final querySnapshot = await firestore
          .collection('mitra')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (var doc in querySnapshot.docs) {
        names[doc.id] = doc.data()['name'] ?? '';
      }
    }
    return names;
  }

  Future<List<PesananModel>> getPesanan() async {
    try {
      final UserController userController = Get.find<UserController>();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot snapshot = await firestore
          .collection('booking')
          .where('user', isEqualTo: userController.uid.value)
          .get();

      final List<String> userIds =
          snapshot.docs.map((doc) => doc['user'] as String).toList();
      final Map<String, String> usernameMap = await _fetchUsernames(userIds);

      return snapshot.docs.map((doc) {
        final String uid = doc['user'] as String;
        return PesananModel.fromMap(
          doc.data() as Map<String, dynamic>,
          namaUser: usernameMap[uid] ?? '',
        );
      }).toList();
    } catch (e) {
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

      final List<String> userIds =
          snapshot.docs.map((doc) => doc['user'] as String).toList();
      final Map<String, String> usernameMap = await _fetchUsernames(userIds);

      return snapshot.docs.map((doc) {
        final String uid = doc['user'] as String;
        return PesananModel.fromMap(
          doc.data() as Map<String, dynamic>,
          namaUser: usernameMap[uid] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

class ActiveService {
  final PesananService _pesananService = PesananService();

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

      final List<String> userIds =
          snapshot.docs.map((doc) => doc['user'] as String).toList();
      final List<String> doulaIds =
          snapshot.docs.map((doc) => doc['doula'] as String).toList();

      final Map<String, String> usernameMap =
          await _pesananService.fetchUsernamesPublic(userIds);
      final Map<String, String> doulaNameMap =
          await _pesananService.fetchDolaNamePublic(doulaIds);

      return snapshot.docs.map((doc) {
        final String uid = doc['user'] as String;
        final String doulaId = doc['doula'] as String;
        return ActiveModel.fromMap(
          doc.data() as Map<String, dynamic>,
          namaUser: usernameMap[uid] ?? '',
          namaDoula: doulaNameMap[doulaId] ?? '',
        );
      }).toList();
    } catch (e) {
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

      final List<String> userIds =
          snapshot.docs.map((doc) => doc['user'] as String).toList();
      final List<String> doulaIds =
          snapshot.docs.map((doc) => doc['doula'] as String).toList();

      final Map<String, String> usernameMap =
          await _pesananService.fetchUsernamesPublic(userIds);
      final Map<String, String> doulaNameMap =
          await _pesananService.fetchDolaNamePublic(doulaIds);

      return snapshot.docs.map((doc) {
        final String uid = doc['user'] as String;
        final String doulaId = doc['doula'] as String;
        return ActiveModel.fromMap(
          doc.data() as Map<String, dynamic>,
          namaUser: usernameMap[uid] ?? '',
          namaDoula: doulaNameMap[doulaId] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
