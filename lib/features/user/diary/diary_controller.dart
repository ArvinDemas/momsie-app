import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/util/model/diary_model.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  StreamSubscription? _entriesSubscription;

  void _listenEntries() {
    isLoading.value = true;
    _entriesSubscription = _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) async {
          final rawEntries = snap.docs.map((d) => DiaryModel.fromFirestore(d)).toList();
          final resolvedEntries = await _resolvePhotoPaths(rawEntries);
          entries.value = resolvedEntries;
          isLoading.value = false;
        }, onError: (e) {
          debugPrint('Diary entries stream error: $e');
          isLoading.value = false;
        });
  }

  /// Resolves any broken local file paths to local diary_photos folder
  Future<List<DiaryModel>> _resolvePhotoPaths(List<DiaryModel> rawList) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final diaryDir = Directory('${appDir.path}/diary_photos');
      final hasDir = await diaryDir.exists();

      return rawList.map((entry) {
        if (entry.photoUrls.isEmpty) return entry;

        final fixedUrls = entry.photoUrls.map((url) {
          if (url.startsWith('http://') || url.startsWith('https://')) {
            return url;
          }
          final f = File(url);
          if (f.existsSync()) return url;

          if (hasDir) {
            final fileName = url.split('/').last;
            final candidate = File('${diaryDir.path}/$fileName');
            if (candidate.existsSync()) {
              return candidate.path;
            }
          }
          return url;
        }).toList();

        return entry.copyWith(photoUrls: fixedUrls);
      }).toList();
    } catch (_) {
      return rawList;
    }
  }

  // ── Form state (reused for add & edit) ──────────────────────────
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final weekTextCtrl = TextEditingController();
  final RxString selectedMood = 'happy'.obs;
  final RxList<XFile> newPhotos = <XFile>[].obs; // pending picks
  final RxList<String> existingPhotoUrls = <String>[].obs; // from Firestore
  final RxInt editingWeek = 20.obs;
  final RxBool isBabyBorn = false.obs;
  final RxString babyAgeUnit = 'bulan'.obs; // 'bulan' or 'tahun'

  int get maxAge {
    if (!isBabyBorn.value) return 42;
    return babyAgeUnit.value == 'tahun' ? 2 : 24;
  }

  int get minAge => 1;

  int get safeEditingWeek {
    return editingWeek.value.clamp(minAge, maxAge);
  }

  void initForm({DiaryModel? entry, int defaultWeek = 20}) {
    titleCtrl.text = entry?.title ?? '';
    contentCtrl.text = entry?.content ?? '';
    selectedMood.value = entry?.mood ?? 'happy';
    newPhotos.clear();
    existingPhotoUrls.value = List.from(entry?.photoUrls ?? []);
    
    if (entry != null) {
      // ── EDIT EXISTING ENTRY ──
      isBabyBorn.value = entry.isBabyBorn;
      babyAgeUnit.value = entry.babyAgeUnit;
      final val = entry.pregnancyWeek.clamp(minAge, maxAge);
      editingWeek.value = val;
      weekTextCtrl.text = val.toString();
    } else {
      // ── NEW ENTRY: Remember last saved entry's category & age! ──
      final latest = entries.isNotEmpty ? entries.first : null;
      if (latest != null) {
        isBabyBorn.value = latest.isBabyBorn;
        babyAgeUnit.value = latest.babyAgeUnit;
        final val = latest.pregnancyWeek.clamp(minAge, maxAge);
        editingWeek.value = val;
        weekTextCtrl.text = val.toString();
      } else {
        isBabyBorn.value = false;
        babyAgeUnit.value = 'bulan';
        editingWeek.value = defaultWeek;
        weekTextCtrl.text = defaultWeek.toString();
      }
    }
  }

  void clearForm() {
    titleCtrl.clear();
    contentCtrl.clear();
    weekTextCtrl.clear();
    selectedMood.value = 'happy';
    newPhotos.clear();
    existingPhotoUrls.clear();

    final latest = entries.isNotEmpty ? entries.first : null;
    if (latest != null) {
      isBabyBorn.value = latest.isBabyBorn;
      babyAgeUnit.value = latest.babyAgeUnit;
      final val = latest.pregnancyWeek.clamp(minAge, maxAge);
      editingWeek.value = val;
      weekTextCtrl.text = val.toString();
    } else {
      isBabyBorn.value = false;
      babyAgeUnit.value = 'bulan';
      editingWeek.value = 20;
      weekTextCtrl.text = '20';
    }
  }

  void updateMode(bool babyBorn) {
    isBabyBorn.value = babyBorn;
    if (babyBorn && editingWeek.value > 24 && babyAgeUnit.value == 'bulan') {
      editingWeek.value = 24;
    }
    final clamped = editingWeek.value.clamp(minAge, maxAge);
    editingWeek.value = clamped;
    weekTextCtrl.text = clamped.toString();
  }

  void updateUnit(String unit) {
    babyAgeUnit.value = unit;
    final clamped = editingWeek.value.clamp(minAge, maxAge);
    editingWeek.value = clamped;
    weekTextCtrl.text = clamped.toString();
  }

  void setWeekValue(int val) {
    final clamped = val.clamp(minAge, maxAge);
    editingWeek.value = clamped;
    weekTextCtrl.text = clamped.toString();
  }

  void incrementAge() {
    setWeekValue(editingWeek.value + 1);
  }

  void decrementAge() {
    setWeekValue(editingWeek.value - 1);
  }

  void onWeekTextChanged(String text) {
    if (text.trim().isEmpty) return;
    final parsed = int.tryParse(text.trim());
    if (parsed != null) {
      if (parsed > maxAge) {
        editingWeek.value = maxAge;
        weekTextCtrl.text = maxAge.toString();
        weekTextCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: weekTextCtrl.text.length),
        );
      } else if (parsed < minAge) {
        editingWeek.value = minAge;
      } else {
        editingWeek.value = parsed;
      }
    }
  }

  Future<void> pickPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isNotEmpty) {
      final total = existingPhotoUrls.length + newPhotos.length + picked.length;
      if (total > 4) {
        Get.snackbar(
          'Batas Foto',
          'Maksimal 4 foto per entri diary.',
          snackPosition: SnackPosition.TOP,
        );
        final allowed = 4 - existingPhotoUrls.length - newPhotos.length;
        if (allowed > 0) newPhotos.addAll(picked.take(allowed));
      } else {
        newPhotos.addAll(picked);
      }
    }
  }

  Future<void> removeNewPhoto(int index) async => newPhotos.removeAt(index);

  Future<void> removeExistingPhoto(String url) async {
    existingPhotoUrls.remove(url);
    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        await _storage.refFromURL(url).delete();
      } else {
        final file = File(url);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error deleting photo: $e');
    }
  }

  Future<List<String>> _uploadPhotos(List<XFile> photos) async {
    final urls = <String>[];
    final appDir = await getApplicationDocumentsDirectory();
    final diaryDir = Directory('${appDir.path}/diary_photos');
    if (!await diaryDir.exists()) {
      await diaryDir.create(recursive: true);
    }

    for (final photo in photos) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${photo.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}';
      final localFile = File(photo.path);

      final targetPath = '${diaryDir.path}/$fileName';
      File savedLocalFile;
      try {
        savedLocalFile = await localFile.copy(targetPath);
      } catch (_) {
        savedLocalFile = localFile;
      }

      try {
        final ref = _storage.ref().child('users').child(_uid).child('diary').child(fileName);
        final uploadTask = await ref.putFile(savedLocalFile);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        urls.add(downloadUrl);
      } catch (e) {
        debugPrint('Firebase storage upload fallback to local path: $e');
        urls.add(savedLocalFile.path);
      }
    }
    return urls;
  }

  Future<void> saveEntry({String? editId}) async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Judul Kosong',
        'Isi judul diary terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Strict Clamping Check before saving
    final rawInput = int.tryParse(weekTextCtrl.text.trim()) ?? editingWeek.value;
    final validWeek = rawInput.clamp(minAge, maxAge);
    editingWeek.value = validWeek;
    weekTextCtrl.text = validWeek.toString();

    isSaving.value = true;
    try {
      final uploadedUrls = await _uploadPhotos(newPhotos);
      final allPhotos = [...existingPhotoUrls, ...uploadedUrls];

      final data = DiaryModel(
        id: editId ?? '',
        title: titleCtrl.text.trim(),
        content: contentCtrl.text.trim(),
        mood: selectedMood.value,
        pregnancyWeek: validWeek,
        isBabyBorn: isBabyBorn.value,
        babyAgeUnit: babyAgeUnit.value,
        photoUrls: allPhotos,
        createdAt: DateTime.now(),
      ).toFirestore();

      if (editId != null) {
        await _col.doc(editId).update(data);
      } else {
        await _col.add(data);
      }

      final isEditing = editId != null;
      clearForm();

      // 1. Pop back safely to the previous screen (DiaryListPage)
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        Get.offNamed(AppRoutes.diary);
      }

      // 2. Show notification snackbar on the Diary List page
      Get.snackbar(
        'Berhasil Tersimpan',
        isEditing
            ? 'Catatan diary berhasil diperbarui!'
            : 'Catatan diary kehamilan berhasil tersimpan!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat menyimpan: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    _entriesSubscription?.cancel();
    titleCtrl.dispose();
    contentCtrl.dispose();
    weekTextCtrl.dispose();
    super.onClose();
  }

  Future<void> deleteEntry(DiaryModel entry) async {
    for (final url in entry.photoUrls) {
      try {
        if (url.startsWith('http://') || url.startsWith('https://')) {
          await _storage.refFromURL(url).delete();
        } else {
          final file = File(url);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (e) {
        debugPrint('Error deleting photo file: $e');
      }
    }
    await _col.doc(entry.id).delete();
    Get.snackbar(
      'Dihapus',
      'Catatan diary berhasil dihapus.',
      snackPosition: SnackPosition.TOP,
    );
  }
}
