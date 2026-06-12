import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserProgramBulanPage extends StatelessWidget {
  const UserProgramBulanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Month month = Get.arguments['month'];
    final ProgramModel program = Get.arguments['program'];
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                Text(
                  "Bulan Ke - ${month.month}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: month.weeks
                  .map(
                    (week) => Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: bulanContainer(program, month, week),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget bulanContainer(ProgramModel program, Month month, Week week) {
    return InkWell(
      onTap: () => Get.toNamed('/user-program-minggu', arguments: {
        'week': week,
        'month': month,
        'program': program,
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorDouce.kindaRed,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Minggu Ke - ${week.week}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Pengenalan Yoga Prenetal",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Image.network(
                  program.image,
                  width: 75,
                  height: 75,
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 1,
              color: ColorDouce.douceBase,
              minHeight: 5,
            ),
          ],
        ),
      ),
    );
  }
}
