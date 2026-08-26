import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/features/user/kesehatan/booking_doula_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDoulaPage extends StatelessWidget {
  const BookingDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingDoulaController controller = Get.isRegistered<BookingDoulaController>()
        ? Get.find<BookingDoulaController>()
        : Get.put(BookingDoulaController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: ListView(
                children: [
                  // App Bar Header
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: Get.back,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: ColorDouce.douceBase,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Pilih Jadwal & Layanan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selected Doula Banner
                  Obx(() {
                    final doula = controller.selectedDoula.value;
                    if (doula == null) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: doula.image,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                width: 52,
                                height: 52,
                                color: Colors.pink.shade50,
                                child: Icon(Icons.person, color: ColorDouce.douceBase),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doula.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doula.job,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Google Calendar Style Month Navigator Header
                  const Text(
                    "Pilih Tanggal Kunjungan",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    final monthText = controller.monthYearFormat.format(controller.focusedMonth.value);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left_rounded, color: ColorDouce.douceBase, size: 26),
                            onPressed: () => controller.changeMonth(-1),
                          ),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: controller.focusedMonth.value,
                                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                helpText: 'Pilih Bulan & Tahun Booking',
                              );
                              if (picked != null) {
                                controller.onDateSelected(picked);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month_rounded, size: 18, color: ColorDouce.douceBase),
                                const SizedBox(width: 6),
                                Text(
                                  monthText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right_rounded, color: ColorDouce.douceBase, size: 26),
                            onPressed: () => controller.changeMonth(1),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // View Mode Tabs (Bulanan / Mingguan)
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          _modeTab('Bulanan', 'bulanan', controller),
                          _modeTab('Mingguan', 'mingguan', controller),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 14),

                  // Dynamic Calendar Grid View
                  Obx(() {
                    if (controller.viewMode.value == 'mingguan') {
                      return _buildWeekView(controller);
                    }
                    return _buildMonthGridView(controller);
                  }),

                  const SizedBox(height: 24),

                  // Jam Kunjungan Section
                  Obx(() {
                    final displayDateStr = DateFormat('EEEE, dd MMMM yyyy').format(controller.selectedDate.value);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pilih Jam Kunjungan",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              displayDateStr,
                              style: TextStyle(fontSize: 12, color: ColorDouce.douceBase, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (controller.isLoadingSlots.value)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (controller.errorMessage.value.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: controller.availableSlots
                                .map((jam) => jamContainer(jam, controller))
                                .toList(),
                          ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // Jenis Layanan Section
                  const Text(
                    "Pilih Jenis Layanan",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(
                    () => Column(
                      children: [
                        layananContainer(
                          "Konsultasi Online via Chat",
                          "Konsultasi Sesi Tanya Jawab Online 1 Jam",
                          Icons.chat_rounded,
                          controller,
                          30000,
                        ),
                        const SizedBox(height: 10),
                        layananContainer(
                          "Kelas Online: Materi Prenatal",
                          "Materi Edukasi Interaktif Seputar Persalinan",
                          Icons.menu_book_rounded,
                          controller,
                          99000,
                        ),
                        const SizedBox(height: 10),
                        layananContainer(
                          "Kelas Online: Prenatal Yoga",
                          "Sesi Hatha Yoga Hamil Dibimbing Doula",
                          Icons.self_improvement_rounded,
                          controller,
                          75000,
                        ),
                        const SizedBox(height: 10),
                        layananContainer(
                          "Kelas Online: Bundling Edukasi & Yoga",
                          "Paket Hemat Materi Prenatal + Prenatal Yoga",
                          Icons.workspace_premium_rounded,
                          controller,
                          135000,
                        ),
                        const SizedBox(height: 10),
                        layananContainer(
                          "Full Journey Doula Care",
                          "Pendampingan Komprehensif Door-to-Door Persalinan",
                          Icons.verified_user_rounded,
                          controller,
                          3000000,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Alamat Input if Full Journey selected
                  Obx(() {
                    if (controller.selectedLayanan.value == "Full Journey Doula Care") {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Alamat Lengkap Kunjungan",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: (val) => controller.alamatUser.value = val,
                              decoration: InputDecoration(
                                hintText: "Masukkan alamat rumah lengkap Anda...",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  }),

                  // Next Step Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (controller.selectedTanggal.value.isEmpty ||
                          controller.selectedJam.value.isEmpty ||
                          controller.selectedLayanan.value.isEmpty) {
                        Get.snackbar(
                          "Pilih Kelengkapan Booking",
                          "Silakan pilih tanggal, jam kunjungan, dan jenis layanan terlebih dahulu.",
                          backgroundColor: ColorDouce.kindaRed,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.toNamed("/confirm-booking");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorDouce.douceBase,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Lanjutkan ke Konfirmasi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeTab(String label, String mode, BookingDoulaController controller) {
    final isSel = controller.viewMode.value == mode;
    return Expanded(
      child: InkWell(
        onTap: () => controller.viewMode.value = mode,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                color: isSel ? ColorDouce.douceBase : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Interactive Month Grid View (Google Calendar Style)
  Widget _buildMonthGridView(BookingDoulaController controller) {
    final monthDate = controller.focusedMonth.value;
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final leadingEmptyDays = firstDayOfMonth.weekday - 1; // Mon=1..Sun=7

    final List<String> dayHeaders = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayHeaders.map((h) {
              return Expanded(
                child: Center(
                  child: Text(
                    h,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: leadingEmptyDays + daysInMonth,
            itemBuilder: (_, index) {
              if (index < leadingEmptyDays) {
                return const SizedBox();
              }
              final dayNum = index - leadingEmptyDays + 1;
              final thisDate = DateTime(monthDate.year, monthDate.month, dayNum);
              final isSelected = controller.selectedDate.value.year == thisDate.year &&
                  controller.selectedDate.value.month == thisDate.month &&
                  controller.selectedDate.value.day == thisDate.day;

              return InkWell(
                onTap: () => controller.onDateSelected(thisDate),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorDouce.douceBase : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? ColorDouce.douceBase : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Horizontal Week Strip View
  Widget _buildWeekView(BookingDoulaController controller) {
    final selDate = controller.selectedDate.value;
    final monday = selDate.subtract(Duration(days: selDate.weekday - 1));
    final weekDates = List.generate(7, (i) => monday.add(Duration(days: i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = weekDates[i];
          final isSel = controller.selectedDate.value.year == date.year &&
              controller.selectedDate.value.month == date.month &&
              controller.selectedDate.value.day == date.day;

          return InkWell(
            onTap: () => controller.onDateSelected(date),
            child: Container(
              width: 65,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSel ? ColorDouce.douceBase : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSel ? ColorDouce.douceBase : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSel ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSel ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget jamContainer(String time, BookingDoulaController controller) {
    return InkWell(
      onTap: () => controller.setSelectedJam(time),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.selectedJam.value == time ? ColorDouce.douceBase : Colors.grey.shade300,
            width: controller.selectedJam.value == time ? 2 : 1,
          ),
          color: controller.selectedJam.value == time
              ? ColorDouce.douceBase.withValues(alpha: 0.1)
              : Colors.white,
        ),
        child: Text(
          time,
          style: TextStyle(
            color: controller.selectedJam.value == time ? ColorDouce.douceBase : const Color(0xFF0F172A),
            fontSize: 13,
            fontWeight: controller.selectedJam.value == time ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget layananContainer(
    String title,
    String subtitle,
    IconData icon,
    BookingDoulaController controller,
    int harga,
  ) {
    final isSelected = controller.selectedLayanan.value == title;
    return InkWell(
      onTap: () {
        controller.setSelectedLayanan(title);
        controller.setHarga(harga);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? ColorDouce.douceBase.withValues(alpha: 0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? ColorDouce.douceBase : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: isSelected ? ColorDouce.douceBase.withValues(alpha: 0.15) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? ColorDouce.douceBase : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? ColorDouce.douceBase : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Text(
              "Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: ColorDouce.douceBase,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? ColorDouce.douceBase : Colors.grey.shade400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
