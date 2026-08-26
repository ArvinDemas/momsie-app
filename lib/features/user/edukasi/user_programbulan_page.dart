import 'package:cached_network_image/cached_network_image.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/model/program_model.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:get/get.dart';

class UserProgramBulanPage extends StatelessWidget {
  const UserProgramBulanPage({super.key});

  static final List<Map<String, String>> _weekDetails = [
    {
      'title': 'Sesi Pernapasan & Relaksasi Diafragma',
      'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Sesi Kelenturan Otot Panggul & Pinggul',
      'image': 'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?w=500&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Sesi Penguatan Kaki & Otot Inti Hamil',
      'image': 'https://images.unsplash.com/photo-1599447421416-3414500d18a5?w=500&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Sesi Persiapan Persalinan & Yoga Restoratif',
      'image': 'https://images.unsplash.com/photo-1510894347713-fc3ed6fdf539?w=500&auto=format&fit=crop&q=80',
    },
  ];

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
              children: List.generate(month.weeks.length, (index) {
                final week = month.weeks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: bulanContainer(program, month, week, index),
                );
              }),
            )
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget bulanContainer(ProgramModel program, Month month, Week week, int index) {
    final detail = _weekDetails[index % _weekDetails.length];
    final String weekImage = (week.image.isNotEmpty && !week.image.contains('picsum') && !week.image.contains('flowers'))
        ? week.image
        : detail['image']!;
    final String weekSubtitle = detail['title']!;

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
                      const SizedBox(height: 4),
                      Text(
                        weekSubtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: weekImage,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 75,
                      height: 75,
                      color: Colors.pink.shade50,
                      child: Icon(Icons.self_improvement_rounded, size: 36, color: ColorDouce.douceBase),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
