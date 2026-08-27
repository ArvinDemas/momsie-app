import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarPickerModal extends StatelessWidget {
  const AvatarPickerModal({super.key});

  static const List<Map<String, String>> avatars = [
    {
      'title': 'Bunda Hamil 3D',
      'asset': 'assets/images/avatar_3d_1.png',
    },
    {
      'title': 'Bayi Lucu 3D',
      'asset': 'assets/images/avatar_3d_2.png',
    },
    {
      'title': 'Bidan & Doula 3D',
      'asset': 'assets/images/avatar_3d_3.png',
    },
    {
      'title': 'Avatar Classic',
      'asset': 'assets/images/blank-profile.png',
    },
  ];

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AvatarPickerModal(),
    );
  }

  Future<void> _selectAvatar(String path) async {
    final UserController userController = Get.find<UserController>();
    userController.image.value = path;
    userController.doulaImage.value = path;

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', path);
    await prefs.setString('doula_image', path);

    // Simpan ke Firestore
    final uid = userController.uid.value;
    if (uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set({'image': path}, SetOptions(merge: true));
        await FirebaseFirestore.instance
            .collection('mitra')
            .doc(uid)
            .set({'image': path}, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Avatar picker save error: $e');
      }
    }

    Get.back(); // Tutup modal
    Get.snackbar(
      'Foto Profil Diperbarui',
      'Foto profil berhasil dipasang!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        await _selectAvatar(image.path);
      }
    } catch (e) {
      debugPrint('Error pickFromGallery: $e');
      Get.snackbar(
        'Akses Galeri',
        'Gagal mengambil foto. Mohon izinkan akses media/galeri di HP Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black87,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pilih Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih dari avatar 3D favorit Bunda atau unggah foto dari galeri HP:',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

          // Upload from Gallery Button
          InkWell(
            onTap: _pickFromGallery,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: ColorDouce.douceBase.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorDouce.douceBase,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    color: ColorDouce.douceBase,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Pilih dari Galeri / File HP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Grid Avatar Choices
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final String path = avatar['asset']!;
              return Obx(() {
                final bool isSelected = userController.image.value == path;
                return InkWell(
                  onTap: () => _selectAvatar(path),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorDouce.douceBase.withValues(alpha: 0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? ColorDouce.douceBase
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            path,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.pink.shade50,
                              child: Icon(Icons.person,
                                  color: ColorDouce.douceBase),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          avatar['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? ColorDouce.douceBase
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
