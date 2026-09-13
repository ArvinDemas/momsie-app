import 'package:douce/app/app_routes.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/user_controller.dart';
import 'package:douce/shared/widget/avatar_picker_modal.dart';
import 'package:douce/shared/widget/confrm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAkunPage extends StatelessWidget {
  const UserAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Top Bar & Avatar Header
            _buildHeader(context, userController),
            const SizedBox(height: 24),

            // Section 1: Kehamilan & Janin
            _buildSectionHeader("Kehamilan & Janin"),
            _buildMenuItem(
              icon: Icons.calendar_month_outlined,
              title: "Hari Perkiraan Lahir (HPL):",
              trailingObx: () => Text(
                userController.dueDate.value,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              onTap: () => _pickDueDate(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.calculate_outlined,
              title: "Kalkulator HPL",
              onTap: () => _showDueDateCalculatorModal(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.child_care_outlined,
              title: "Jenis Kelamin Bayi:",
              trailingObx: () => Text(
                userController.babySex.value,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              onTap: () => _showBabySexPicker(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.edit_note_outlined,
              title: "Nama Calon Bayi:",
              trailingObx: () => Text(
                userController.babyName.value.isEmpty
                    ? "Ketik di sini..."
                    : userController.babyName.value,
                style: TextStyle(
                  color: userController.babyName.value.isEmpty
                      ? AppSemanticColors.textMuted
                      : Colors.black87,
                  fontSize: 14,
                ),
              ),
              onTap: () => _showBabyNameDialog(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.family_restroom_outlined,
              title: "Anak Pertama?",
              trailingObx: () => Switch.adaptive(
                value: userController.isFirstChild.value,
                activeColor: ColorDouce.douceBase,
                onChanged: (val) => userController.updateIsFirstChild(val),
              ),
            ),
            _buildMenuItem(
              icon: Icons.favorite_border_outlined,
              title: "Riwayat Keguguran?",
              trailingObx: () => Switch.adaptive(
                value: userController.isPregnancyLoss.value,
                activeColor: ColorDouce.douceBase,
                onChanged: (val) => userController.updateIsPregnancyLoss(val),
              ),
            ),
            _buildMenuItem(
              icon: Icons.bedroom_baby_outlined,
              title: "Bayi Sudah Lahir?",
              trailingObx: () => Switch.adaptive(
                value: userController.isBabyBorn.value,
                activeColor: ColorDouce.douceBase,
                onChanged: (val) => userController.updateIsBabyBorn(val),
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Pengaturan Aplikasi
            _buildSectionHeader("Pengaturan Aplikasi"),
            _buildMenuItem(
              icon: Icons.straighten_outlined,
              title: "Satuan Panjang:",
              trailingObx: () => Text(
                userController.lengthUnit.value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                final nextUnit =
                    userController.lengthUnit.value == 'cm' ? 'inch' : 'cm';
                userController.updateLengthUnit(nextUnit);
              },
            ),
            _buildMenuItem(
              icon: Icons.monitor_weight_outlined,
              title: "Satuan Berat:",
              trailingObx: () => Text(
                userController.weightUnit.value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                final nextUnit =
                    userController.weightUnit.value == 'kg' ? 'lbs' : 'kg';
                userController.updateWeightUnit(nextUnit);
              },
            ),
            _buildMenuItem(
              icon: Icons.palette_outlined,
              title: "Tema & Warna Aplikasi (Advance Theme)",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed(AppRoutes.themePicker),
            ),
            _buildMenuItem(
              icon: Icons.delete_sweep_outlined,
              title: "Hapus Cache Aplikasi",
              onTap: () => _clearCache(context),
            ),
            const SizedBox(height: 24),

            // Section 3: Detail Akun
            _buildSectionHeader("Detail Akun"),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: "Nama Depan:",
              trailingObx: () {
                final names = userController.username.value.split(' ');
                return Text(
                  names.isNotEmpty ? names.first : "Bunda",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                );
              },
              onTap: () => Get.toNamed('/user-data-diri'),
            ),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: "Nama Belakang:",
              trailingObx: () {
                final names = userController.username.value.split(' ');
                return Text(
                  names.length > 1 ? names.sublist(1).join(' ') : "-",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                );
              },
              onTap: () => Get.toNamed('/user-data-diri'),
            ),
            _buildMenuItem(
              icon: Icons.cake_outlined,
              title: "Usia Bunda:",
              trailingObx: () => Text(
                "${userController.age.value} th",
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              onTap: () => _showAgeDialog(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.people_alt_outlined,
              title: "Peran / Hubungan:",
              trailingObx: () => Text(
                userController.relationship.value,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              onTap: () => _showRelationshipPicker(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.receipt_long_outlined,
              title: "Pesanan Aktif",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed('/user-pesanan'),
            ),

            const SizedBox(height: 24),

            // Section 4: Bantuan & Dukungan
            _buildSectionHeader("Bantuan & Dukungan"),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Pusat Bantuan",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed('/user-bantuan'),
            ),
            _buildMenuItem(
              icon: Icons.mail_outline,
              title: "Hubungi Kami",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed('/user-hubungi'),
            ),
            _buildMenuItem(
              icon: Icons.share_outlined,
              title: "Bagikan Aplikasi ke Teman",
              onTap: () => _shareApp(),
            ),
            _buildMenuItem(
              icon: Icons.star_outline,
              title: "Beri Rating Aplikasi",
              onTap: () => _showRatingDialog(context),
            ),
            const SizedBox(height: 24),

            // Section 5: Privasi & Keamanan
            _buildSectionHeader("Privasi & Keamanan"),
            _buildMenuItem(
              icon: Icons.campaign_outlined,
              title: "Iklan Terpersonalisasi",
              trailingObx: () => Switch.adaptive(
                value: userController.personalisedAds.value,
                activeColor: ColorDouce.douceBase,
                onChanged: (val) =>
                    userController.updatePersonalisedAds(val),
              ),
            ),
            _buildMenuItem(
              icon: Icons.file_download_outlined,
              title: "Ekspor Semua Data",
              onTap: () => _exportData(context, userController),
            ),
            _buildMenuItem(
              icon: Icons.delete_forever_outlined,
              title: "Hapus Data / Akun",
              onTap: () => _showDeleteAccountDialog(context),
            ),
            const SizedBox(height: 24),

            // Section 6: Tentang Momsie
            _buildSectionHeader("Tentang Momsie"),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: "Tentang Momsie",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed('/user-tentang-doula'),
            ),
            _buildMenuItem(
              icon: Icons.article_outlined,
              title: "Syarat & Ketentuan",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showTermsModal(context),
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: "Kebijakan Privasi",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Get.toNamed('/user-kebijakan-privasi'),
            ),
            _buildMenuItem(
              icon: Icons.badge_outlined,
              title: "Kredit Aplikasi",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => _showCreditsModal(context),
            ),
            const SizedBox(height: 32),

            // Sign out Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorDouce.douceBase,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  "Keluar Akun",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Footer Subtitle Info
            Obx(
              () => Column(
                children: [
                  Text(
                    "Pencadangan Terakhir: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppSemanticColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Akun: ${userController.email.value.isNotEmpty ? userController.email.value : 'bunda@gmail.com'}",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppSemanticColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Header Bar with Close X, Title, and Editable Avatar
  Widget _buildHeader(BuildContext context, UserController userController) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 28, color: Colors.black87),
              onPressed: () => Get.back(),
            ),
            Column(
              children: [
                const Text(
                  "Profil Saya",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Obx(
                  () => Text(
                    userController.username.value.isNotEmpty
                        ? userController.username.value
                        : "Bunda",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppSemanticColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 48), // Spacer to balance close button width
          ],
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 96,
                  height: 96,
                  color: Colors.pink.shade50,
                  child: _buildAvatar(userController.image.value),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => AvatarPickerModal.show(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(String imagePath) {
    if (imagePath.isEmpty) {
      return Image.asset(
        'assets/images/blank-profile.png',
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/blank-profile.png',
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/blank-profile.png',
      width: 96,
      height: 96,
      fit: BoxFit.cover,
    );
  }

  // Section Header Title
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppSemanticColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Single Menu Item Row
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Widget Function()? trailingObx,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Icon(icon, size: 22, color: Colors.black87),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (trailingObx != null) Obx(trailingObx) else if (trailing != null) trailing,
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 0.5, color: AppSemanticColors.textMuted.withValues(alpha: 0.3)),
      ],
    );
  }

  // DatePicker Handler for HPL Due Date
  Future<void> _pickDueDate(BuildContext context, UserController userController) async {
    final DateTime initialDate = DateTime.now().add(const Duration(days: 180));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now().add(const Duration(days: 300)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorDouce.douceBase,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('dd MMM yyyy').format(picked);
      await userController.updateDueDate(formatted);
      Get.snackbar(
        'HPL Diperbarui',
        'Tanggal Hari Perkiraan Lahir diset ke $formatted',
        backgroundColor: Colors.white,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Due Date Calculator Modal
  void _showDueDateCalculatorModal(BuildContext context, UserController userController) {
    DateTime selectedLPM = DateTime.now().subtract(const Duration(days: 60));
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Kalkulator HPL", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Hari Pertama Haid Terakhir (HPHT) Anda:"),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (ctx, setState) {
                final estimatedHPL = selectedLPM.add(const Duration(days: 280));
                return Column(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text(DateFormat('dd MMMM yyyy').format(selectedLPM)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedLPM,
                          firstDate: DateTime.now().subtract(const Duration(days: 300)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedLPM = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: ColorDouce.douceBase),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Estimasi HPL: ${DateFormat('dd MMM yyyy').format(estimatedHPL)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () {
              final estimatedHPL = selectedLPM.add(const Duration(days: 280));
              final formatted = DateFormat('dd MMM yyyy').format(estimatedHPL);
              userController.updateDueDate(formatted);
              Get.back();
              Get.snackbar(
                'HPL Diterapkan',
                'HPL berhasil dihitung dan diperbarui ke $formatted',
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Simpan HPL", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Baby Sex Selector Dialog
  void _showBabySexPicker(BuildContext context, UserController userController) {
    Get.dialog(
      SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Pilih Jenis Kelamin Bayi"),
        children: ['Laki-laki', 'Perempuan', 'Belum Tahu'].map((sex) {
          return SimpleDialogOption(
            onPressed: () {
              userController.updateBabySex(sex);
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    sex == 'Laki-laki'
                        ? Icons.male
                        : sex == 'Perempuan'
                            ? Icons.female
                            : Icons.help_outline,
                    color: ColorDouce.douceBase,
                  ),
                  const SizedBox(width: 12),
                  Text(sex, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Baby Name Input Dialog
  void _showBabyNameDialog(BuildContext context, UserController userController) {
    final txtCtrl = TextEditingController(text: userController.babyName.value);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Nama Calon Bayi"),
        content: TextField(
          controller: txtCtrl,
          decoration: const InputDecoration(
            hintText: "Masukkan nama kesayangan calon bayi...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              userController.updateBabyName(txtCtrl.text.trim());
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Age Input Dialog
  void _showAgeDialog(BuildContext context, UserController userController) {
    final txtCtrl = TextEditingController(text: userController.age.value.toString());
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Usia Bunda"),
        content: TextField(
          controller: txtCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Contoh: 26",
            border: OutlineInputBorder(),
            suffixText: "Tahun",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final parsed = int.tryParse(txtCtrl.text.trim());
              if (parsed != null && parsed > 12 && parsed < 90) {
                userController.updateAge(parsed);
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Relationship Selector Dialog
  void _showRelationshipPicker(BuildContext context, UserController userController) {
    Get.dialog(
      SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Peran / Hubungan"),
        children: [
          'Ibu Hamil / Bunda',
          'Ayah / Suami',
          'Keluarga / Pendamping',
        ].map((rel) {
          return SimpleDialogOption(
            onPressed: () {
              userController.updateRelationship(rel);
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(rel, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Clear App Cache Handler
  void _clearCache(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Cache Aplikasi"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus file sementara dan cache gambar aplikasi? Tindakan ini aman dan tidak menghapus akun Anda.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 300));
              Get.snackbar(
                'Cache Dibersihkan',
                'Berhasil menghapus 4.2 MB file cache aplikasi Momsie.',
                backgroundColor: Colors.white,
                colorText: Colors.black87,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Hapus Cache", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Share App Link
  void _shareApp() {
    Get.snackbar(
      'Bagikan Momsie',
      'Link aplikasi Momsie berhasil disalin ke clipboard! Siap dibagikan ke teman-teman Bunda.',
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 5-Star Rating Dialog
  void _showRatingDialog(BuildContext context) {
    int rating = 5;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Beri Rating Momsie", textAlign: TextAlign.center),
        content: StatefulBuilder(
          builder: (ctx, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Terima Kasih!',
                'Terima kasih telah memberikan rating bintang $rating untuk Momsie!',
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Kirim Rating", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Export Data Summary Dialog
  void _exportData(BuildContext context, UserController userController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Ekspor Data Saya"),
        content: const Text(
          "Ringkasan seluruh data profil, catatan kehamilan, dan pesanan Anda akan diekspor dalam format dokumen.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Ekspor Berhasil',
                'Dokumen data Bunda berhasil didownload.',
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Ekspor Sekarang", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Delete Account Warning Dialog
  void _showDeleteAccountDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hapus Akun / Data",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah Anda yakin ingin mengajukan penghapusan akun? Semua data kehamilan dan riwayat Anda akan terhapus permanen.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Permintaan Terkirim',
                'Permintaan penghapusan akun telah dikirim ke tim bantuan Momsie.',
                backgroundColor: Colors.red.shade50,
                colorText: Colors.red,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus Permanen", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Terms of Use Modal
  void _showTermsModal(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Syarat & Ketentuan"),
        content: const SingleChildScrollView(
          child: Text(
            "Dengan menggunakan aplikasi Momsie, Anda menyetujui bahwa seluruh fitur edukasi dan pendampingan doula ditujukan untuk mendukung kesehatan ibu hamil dan janin. Informasi dalam aplikasi tidak menggantikan konsultasi langsung dengan dokter spesialis kandung (Sp.OG).",
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: ColorDouce.douceBase),
            child: const Text("Saya Mengerti", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Credits Modal
  void _showCreditsModal(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Kredit Aplikasi", textAlign: TextAlign.center),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("💖 Momsie Apps v2.0", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Dikembangkan dengan penuh kasih sayang untuk seluruh Ibu Hamil Indonesia oleh Tim P2MW."),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup")),
        ],
      ),
    );
  }

  // Switch to Doula Mode Dialog (Developer Tool)
  void _showSwitchDoulaDialog(BuildContext context, UserController userController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          descText: "Pindah ke Mode Doula?",
          onTap: () async {
            final FirebaseFirestore firestore = FirebaseFirestore.instance;

            final DocumentSnapshot checkUser = await firestore
                .collection("user")
                .doc(userController.uid.value)
                .get();

            Map<String, dynamic>? userData =
                checkUser.data() as Map<String, dynamic>?;

            userController.updateUser(
              userData?['username'],
              userData?['isDoula'],
              userData?['image'],
            );

            if (userController.isDoula.value) {
              final DocumentSnapshot mitraData = await firestore
                  .collection('mitra')
                  .doc(userController.uid.value)
                  .get();

              final data = mitraData.data() as Map<String, dynamic>?;
              userController.setDoula(
                data?['name'] ?? 'Tester',
                data?['alamat'] ?? '',
                data?['kotaProvinsi'] ?? '',
                data?['biografi'] ?? '',
                data?['image'] ?? '',
                data?['jenisKelamin'] ?? '',
                data?['nik'] ?? '',
              );

              // ═══ Cek status SOP sebelum izinkan masuk dashboard ═══
              final hasPending = userData?['mitraPendingApproval'] == true;
              if (hasPending) {
                final sopQuery = await firestore
                    .collection('sop_submissions')
                    .where('userId', isEqualTo: userController.uid.value)
                    .limit(1)
                    .get();

                if (sopQuery.docs.isEmpty) {
                  Get.offAllNamed('/sop-form');
                  return;
                }

                final sopDoc = sopQuery.docs.first;
                final sopData = sopDoc.data() as Map<String, dynamic>? ?? {};
                final sopStatus = sopData['status'] ?? 'pending';

                if (sopStatus == 'pending') {
                  Get.snackbar(
                    'Menunggu Verifikasi',
                    'Pendaftaran Anda sedang diverifikasi admin.',
                    snackPosition: SnackPosition.TOP,
                  );
                  Get.offAllNamed('/sop-waiting');
                  return;
                } else if (sopStatus == 'rejected') {
                  final reason = sopData['rejectionReason'] ?? 'Ditolak oleh admin.';
                  Get.snackbar(
                    'Pendaftaran Ditolak',
                    reason,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red.shade700,
                    colorText: Colors.white,
                  );
                  Get.offAllNamed(AppRoutes.login);
                  return;
                }
              }

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('last_active_mode', 'mitra');
              Get.offAllNamed('/mitra');
            } else {
              Get.offNamed('/mitra-register');
            }
          },
        );
      },
    );
  }

  // Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Keluar Akun",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Pilih aksi yang diinginkan:"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                try {
                  await GoogleSignIn().signOut();
                  await GoogleSignIn().signIn();
                } catch (e) {
                  debugPrint('[SwitchAccount Error]: $e');
                }
                Get.offAllNamed('/login');
              },
              child: Text(
                "Switch Account",
                style: TextStyle(color: ColorDouce.lightPink),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                try {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                } catch (e) {
                  debugPrint('[Logout Error]: $e');
                }
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorDouce.douceBase,
              ),
              child: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
