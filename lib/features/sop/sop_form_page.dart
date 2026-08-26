import 'dart:io';
import 'package:douce/features/sop/sop_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_dropdown.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:douce/shared/widget/signature_pad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SopFormPage extends StatelessWidget {
  const SopFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SopController controller = Get.put(SopController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SOP Pendaftaran Mitra',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorDouce.douceBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              _buildStepIndicator(controller),
              const SizedBox(height: 24),

              // Step 1: Data Diri
              if (controller.currentStep.value == 0) ...[
                _buildStepTitle('Langkah 1: Data Diri'),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "Nama Lengkap",
                  iconImage: const Icon(Icons.person_outline),
                  isPassword: false,
                  controller: controller.nameController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "NIK (Nomor Induk Kependudukan)",
                  iconImage: const Icon(Icons.badge_outlined),
                  isPassword: false,
                  controller: controller.nikController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "No. HP / WhatsApp",
                  iconImage: const Icon(Icons.phone_outlined),
                  isPassword: false,
                  controller: controller.nohpController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "Kota / Provinsi",
                  iconImage: const Icon(Icons.location_city_outlined),
                  isPassword: false,
                  controller: controller.kotaProvinsiController,
                ),
                const SizedBox(height: 16),
                CustomDropDown(
                  items: ['Doula', 'Developer'],
                  selectedItem: controller.roleSelect,
                  onChanged: (value) => controller.roleSelect.value = value,
                ),
              ],

              // Step 2: Template Surat
              if (controller.currentStep.value == 1) ...[
                _buildStepTitle('Langkah 2: Persetujuan & Upload'),
                const SizedBox(height: 16),
                _buildSuratTemplate(),
                const SizedBox(height: 20),
                _buildCheckbox(
                  controller.agreeTerms,
                  'Saya menyatakan bahwa semua data yang saya isi adalah benar dan dapat dipertanggungjawabkan.',
                ),
                const SizedBox(height: 12),
                _buildCheckbox(
                  controller.agreeRules,
                  'Saya bersedia mengikuti aturan, kode etik, dan kebijakan yang berlaku di platform Momsie.',
                ),
                const SizedBox(height: 12),
                _buildCheckbox(
                  controller.agreeValidation,
                  'Saya memahami bahwa status keaktifan akun akan divalidasi terlebih dahulu oleh tim Momsie.',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Upload Foto KTP / Identitas',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildImageUpload(controller.ktpImage, 'KTP/Identitas', () => controller.pickKtpImage()),
                const SizedBox(height: 16),
                const Text(
                  'Upload Sertifikat Pelatihan (opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildImageUpload(
                  controller.sertifikatImage,
                  'Sertifikat',
                  () => controller.pickSertifikatImage(),
                ),
              ],

              // Step 3: Tanda Tangan
              if (controller.currentStep.value == 2) ...[
                _buildStepTitle('Langkah 3: Tanda Tangan Digital'),
                const SizedBox(height: 16),
                const Text(
                  'Silakan tanda tangani dokumen di bawah ini menggunakan jari atau stylus.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                SignaturePad(),
                const SizedBox(height: 24),
                _buildSubmitButton(controller),
              ],

              // Navigation Buttons (Step 0 & 1 only)
              if (controller.currentStep.value < 2) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.currentStep.value > 0)
                      OutlinedButton(
                        onPressed: () => controller.prevStep(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: ColorDouce.douceBase),
                        ),
                        child: const Text('Kembali'),
                      )
                    else
                      const Spacer(),
                    ElevatedButton(
                      onPressed: () => controller.nextStep(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        controller.currentStep.value == 1 ? 'Selanjutnya' : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepIndicator(SopController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++) ...[
          _stepCircle(i, controller.currentStep.value),
          if (i < 2)
            Container(
              width: 40,
              height: 2,
              color: i < controller.currentStep.value ? ColorDouce.douceBase : Colors.grey.shade300,
            ),
        ],
      ],
    );
  }

  Widget _stepCircle(int index, int current) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index <= current ? ColorDouce.douceBase : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: index <= current ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStepTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorDouce.douceBase,
      ),
    );
  }

  Widget _buildSuratTemplate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '''PERNYATAAN DAN PERSETUJUAN CALON MITRA / DOULA MOMSIE

Saya yang bertanda tangan di bawah ini:

Nama Lengkap    : [Diisi pada Langkah 1]
NIK             : [Diisi pada Langkah 1]
No. HP          : [Diisi pada Langkah 1]
Role            : [Diisi pada Langkah 1]

Dengan ini menyatakan dan berpendapat bahwa:

1. Saya bersedia menjadi mitra/doula resmi Momsie dan
   memberikan layanan sesuai dengan kompetensi dan
   etika profesi.

2. Saya memahami bahwa semua data yang saya sampaikan
   adalah benar dan dapat dipertanggungjawabkan.

3. Saya bersedia mengikuti aturan, kode etik, dan
   kebijakan yang berlaku di platform Momsie.

4. Saya memahami bahwa status keaktifan akun akan
   divalidasi terlebih dahulu oleh tim Momsie.

5. Saya setuju untuk menerima pembayaran melalui
   sistem transfer yang ditentukan oleh Momsie.

Demikian pernyataan ini saya buat dengan sadar dan
tanpa paksaan dari pihak manapun.

Tempat, Tanggal: ________________

(Tanda Tangan Digital di Langkah 3)''',
        style: TextStyle(fontSize: 12, height: 1.6, color: Colors.black87),
      ),
    );
  }

  Widget _buildCheckbox(RxBool checkbox, String text) {
    return Row(
      children: [
        Obx(() => Checkbox(
              value: checkbox.value,
              activeColor: ColorDouce.douceBase,
              onChanged: (val) => checkbox.value = val ?? false,
            )),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildImageUpload(Rx<String?> image, String label, VoidCallback onTap) {
    return Obx(() => InkWell(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: image.value != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(image.value!),
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined, size: 32, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text('$label (tap untuk upload)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
          ),
        ));
  }

  Widget _buildSubmitButton(SopController controller) {
    return ElevatedButton(
      onPressed: () => controller.submitSOP(),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorDouce.douceBase,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Kirim & Daftar',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
