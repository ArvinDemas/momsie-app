import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDoulaPage extends StatelessWidget {
  const BookingDoulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDouce.grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
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
                    "Booking",
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
                  Row(
                    children: [
                      Text("Maret 2024"),
                      Icon(Icons.arrow_left_rounded),
                      Icon(Icons.arrow_right_rounded),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  calendarContainer("Sen", "12", true),
                  calendarContainer("Sel", "13", false),
                  calendarContainer("Rab", "14", false),
                  calendarContainer("Kam", "15", false),
                  calendarContainer("Jum", "16", false),
                  calendarContainer("Sab", "17", false),
                ],
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
              Wrap(
                spacing: 10,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  jamContainer("09:00 AM", true, false),
                  jamContainer("10:00 AM", false, true),
                  jamContainer("11:00 AM", false, false),
                  jamContainer("12:00 PM", false, false),
                  jamContainer("01:00 PM", false, false),
                  jamContainer("02:00 PM", true, false),
                  jamContainer("03:00 PM", false, false),
                  jamContainer("04:00 PM", false, false),
                  jamContainer("05:00 PM", false, false),
                ],
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
              layananContainer(
                "Chat",
                "1 Jam",
                false,
                Icons.chat,
              ),
              const SizedBox(height: 20),
              layananContainer(
                "Panggilan Video",
                "1 Jam",
                true,
                Icons.video_call,
              ),
              const SizedBox(height: 20),
              layananContainer(
                "Panggilan Telepon",
                "1 Jam",
                false,
                Icons.phone,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Get.toNamed("/confirm-booking"),
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
    );
  }

  Widget jamContainer(String time, bool disabled, bool isActive) {
    return Opacity(
      opacity: disabled ? 0.2 : 1,
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
          color: isActive ? ColorDouce.lightPink : Colors.transparent,
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget calendarContainer(String day, String date, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? ColorDouce.douceBase : ColorDouce.kindaRed,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget layananContainer(
    String title,
    String subtitle,
    bool isActive,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: isActive
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
                "Rp 70.0000",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorDouce.douceBase,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isActive ? Icons.radio_button_checked : Icons.radio_button_off,
                color: ColorDouce.douceBase,
              )
            ],
          )
        ],
      ),
    );
  }
}
