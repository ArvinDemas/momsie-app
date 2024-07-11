import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProgramMingguPage extends StatelessWidget {
  const UserProgramMingguPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgramModel program = Get.arguments['program'];
    final Week week = Get.arguments['week'];
    final Month month = Get.arguments['month'];

    return Scaffold(
      body: SafeArea(
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
                    Get.back(
                      result: {
                        "program": program,
                        "month": month,
                      },
                    );
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorDouce.douceBase,
                  ),
                ),
                Text(
                  "Minggu Ke - ${week.week}",
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
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Pengenalan Yoga Prenetal",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              runSpacing: 15,
              children: week.moves
                  .map(
                    (move) => gerakanContainer(program, month, week, move),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget gerakanContainer(ProgramModel program, Month month, Week week, Move move) {
    return InkWell(
      onTap: () => Get.toNamed("/user-detail-gerakan", arguments: {
        "program": program,
        "month": month,
        "week": week,
        "move": move,
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                move.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
