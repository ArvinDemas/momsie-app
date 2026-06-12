import 'package:douce/features/user/kesehatan/booking_doula_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDoulaPage extends StatelessWidget {
  const BookingDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingDoulaController controller =
        Get.isRegistered<BookingDoulaController>()
            ? Get.find<BookingDoulaController>()
            : Get.put(BookingDoulaController());
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  const Text(
                    "Booking Doula",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Tanggal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.dates
                      .map(
                        (date) => calendarContainer(
                          DateFormat('E').format(date),
                          date.day.toString(),
                          controller,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pilih Jam",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    jamContainer("09:00 AM", controller),
                    jamContainer("10:00 AM", controller),
                    jamContainer("11:00 AM", controller),
                    jamContainer("12:00 PM", controller),
                    jamContainer("01:00 PM", controller),
                    jamContainer("02:00 PM", controller),
                    jamContainer("03:00 PM", controller),
                    jamContainer("04:00 PM", controller),
                    jamContainer("05:00 PM", controller),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pilih Layanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Column(
                  children: [
                    layananContainer(
                      "Chat",
                      "1 Jam",
                      Icons.chat,
                      controller,
                      30000,
                    ),
                    const SizedBox(height: 20),
                    layananContainer(
                      "Call / Video Call",
                      "1 Jam",
                      Icons.video_call,
                      controller,
                      50000,
                    ),
                    const SizedBox(height: 20),
                    layananContainer(
                      "Kunjungan",
                      "1 Jam",
                      Icons.home,
                      controller,
                      75000,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (controller.selectedDay.value.isEmpty ||
                      controller.selectedJam.value.isEmpty ||
                      controller.selectedTanggal.value.isEmpty ||
                      controller.selectedLayanan.value.isEmpty) {
                    Get.snackbar(
                      "Peringatan",
                      "Pastikan semua data terisi",
                      backgroundColor: ColorDouce.kindaRed,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.toNamed("/confirm-booking");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorDouce.douceBase,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Selanjutnya",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }

  Widget jamContainer(String time, BookingDoulaController controller) {
    return InkWell(
      onTap: () => controller.setSelectedJam(time),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorDouce.douceBase,
          ),
          color: controller.selectedJam.value == time
              ? ColorDouce.lightPink
              : Colors.transparent,
        ),
        child: Text(
          time,
          style: TextStyle(
            color: controller.selectedJam.value == time
                ? Colors.white
                : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget calendarContainer(
    String day,
    String date,
    BookingDoulaController controller,
  ) {
    return InkWell(
      onTap: () {
        controller.selectedTanggal.value = date;
        controller.selectedDay.value = day;
      },
      child: Container(
        decoration: BoxDecoration(
          color: date == controller.selectedTanggal.value
              ? ColorDouce.douceBase
              : ColorDouce.kindaRed,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 14,
                color: date == controller.selectedTanggal.value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 18,
                color: controller.selectedTanggal.value == date
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
    return InkWell(
      onTap: () {
        controller.setSelectedLayanan(title);
        controller.setHarga(harga);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          color: Colors.white,
          border: controller.selectedLayanan.value == title
              ? Border.all(
                  color: ColorDouce.douceBase,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: ColorDouce.douceBase,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Rp $harga",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorDouce.douceBase,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  controller.selectedLayanan.value == title
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: ColorDouce.douceBase,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
