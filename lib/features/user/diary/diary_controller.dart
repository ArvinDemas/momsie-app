import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DiaryController extends GetxController {
  final RxList<DiaryModel> entries = <DiaryModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  String get _uid => Get.find<UserController>().uid.value;
  CollectionReference get _col =>
      _firestore.collection('user').doc(_uid).collection('diary');

  @override
  void onInit() {
    super.onInit();
    _listenEntries();
  }

  void _listenEntries() {
    isLoading.value = true;
    _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      entries.value =
          snap.docs.map((d) => DiaryModel.fromFirestore(d)).toList();
      isLoading.value = false;
    });
  }

  // ── Form state (reused for add & edit) ──────────────────────────
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final RxString selectedMood = 'happy'.obs;
  final RxList<XFile> newPhotos = <XFile>[].obs; // pending picks
  final RxList<String> existingPhotoUrls = <String>[].obs; // from Firestore
  final RxInt editingWeek = 0.obs;

  void initForm({DiaryModel? entry, int defaultWeek = 20}) {
    titleCtrl.text = entry?.title ?? '';
    contentCtrl.text = entry?.content ?? '';
    selectedMood.value = entry?.mood ?? 'happy';
    newPhotos.clear();
    existingPhotoUrls.value = List.from(entry?.photoUrls ?? []);
    editingWeek.value = entry?.pregnancyWeek ?? defaultWeek;
  }

  void clearForm() {
    titleCtrl.clear();
    contentCtrl.clear();
    selectedMood.value = 'happy';
    newPhotos.clear();
    existingPhotoUrls.clear();
    editingWeek.value = 0;
  }

  Future<void> pickPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 75);
    if (picked.isNotEmpty) {
      // Max 4 total photos
      final total =
          existingPhotoUrls.length + newPhotos.length + picked.length;
      if (total > 4) {
        Get.snackbar('Batas Foto',
            'Maksimal 4 foto per entri. ${4 - existingPhotoUrls.length - newPhotos.length} slot tersisa.',
            snackPosition: SnackPosition.TOP);
        final allowed =
            4 - existingPhotoUrls.length - newPhotos.length;
        if (allowed > 0) newPhotos.addAll(picked.take(allowed));
      } else {
        newPhotos.addAll(picked);
      }
    }
  }

  Future<void> removeNewPhoto(int index) async =>
      newPhotos.removeAt(index);

  Future<void> removeExistingPhoto(String url) async {
    existingPhotoUrls.remove(url);
    // Delete from Storage
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }

  Future<List<String>> _uploadPhotos(List<XFile> photos) async {
    final urls = <String>[];
    for (final photo in photos) {
      final ref = _storage
          .ref('diary/$_uid/${DateTime.now().millisecondsSinceEpoch}_${photo.name}');
      await ref.putFile(File(photo.path));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> saveEntry({String? editId}) async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Judul kosong', 'Isi judul diary terlebih dahulu.',
          snackPosition: SnackPosition.TOP);
      return;
    }
    isSaving.value = true;
    try {
      final uploadedUrls = await _uploadPhotos(newPhotos);
      final allPhotos = [...existingPhotoUrls, ...uploadedUrls];

      final data = DiaryModel(
        id: editId ?? '',
        title: titleCtrl.text.trim(),
        content: contentCtrl.text.trim(),
        mood: selectedMood.value,
        pregnancyWeek: editingWeek.value,
        photoUrls: allPhotos,
        createdAt: DateTime.now(),
      ).toFirestore();

      if (editId != null) {
        await _col.doc(editId).update(data);
        Get.snackbar('Berhasil', 'Diary diperbarui!',
            snackPosition: SnackPosition.TOP);
      } else {
        await _col.add(data);
        Get.snackbar('Berhasil', 'Diary tersimpan!',
            snackPosition: SnackPosition.TOP);
      }
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi error: $e',
          snackPosition: SnackPosition.TOP);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteEntry(DiaryModel entry) async {
    // Delete photos from Storage
    for (final url in entry.photoUrls) {
      try {
        await _storage.refFromURL(url).delete();
      } catch (_) {}
    }
    await _col.doc(entry.id).delete();
    Get.snackbar('Dihapus', 'Entri diary dihapus.',
        snackPosition: SnackPosition.TOP);
  }
}
