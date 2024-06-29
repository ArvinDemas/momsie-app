import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';

class MitraPekerjaanPage extends StatelessWidget {
  const MitraPekerjaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        const TopBar(),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Maret 2024",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Juni 2024",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.calendar_month_outlined)
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  calendarContainer("Sen", "21", false),
                  calendarContainer("Sel", "22", false),
                  calendarContainer("Rab", "23", true),
                  calendarContainer("Kam", "24", false),
                  calendarContainer("Jum", "25", false),
                ],
              ),
              const SizedBox(height: 25),
              jobContainer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget calendarContainer(String day, String date, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? ColorDouce.douceBase : ColorDouce.kindaRed,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 24,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget jobContainer() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.video_call,
                size: 60,
                color: ColorDouce.douceBase,
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Panggilan Video",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Al Ikhsan Akbar Fatahillah",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 0.5,
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Column(),
              Column(),
            ],
          )
        ],
      ),
    );
  }
}
