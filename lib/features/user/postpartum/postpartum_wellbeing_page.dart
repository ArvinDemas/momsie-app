import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/util/service/subscription_service.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostpartumWellbeingPage extends StatefulWidget {
  const PostpartumWellbeingPage({super.key});

  @override
  State<PostpartumWellbeingPage> createState() => _PostpartumWellbeingPageState();
}

class _PostpartumWellbeingPageState extends State<PostpartumWellbeingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SubscriptionService.to.showPaywall(
          context: context,
          featureName: 'Postpartum Wellbeing',
          canDismissToAccess: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Postpartum Wellbeing',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Pemulihan Fisik & Kesehatan Emosional Ibu',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B8B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.workspace_premium_rounded, size: 14, color: Color(0xFFFF6B8B)),
                            SizedBox(width: 4),
                            Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B8B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header Hero Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEC4899).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat atas Kelahiran Buah Hati!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Fokus pada pemulihan diri, nutrisi ASI, dan ketenangan jiwa selama masa nifas.',
                                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Feature Cards Grid
                      const Text(
                        'Modul Pemulihan Pasca Melahirkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildModuleCard(
                        icon: Icons.fitness_center_rounded,
                        color: const Color(0xFF06B6D4),
                        title: 'Senam Nifas & Pemulihan Otot Panggul',
                        desc: 'Panduan gerakan aman mempercepat pemulihan rahim & otot panggul (Kegel).',
                      ),
                      _buildModuleCard(
                        icon: Icons.psychology_rounded,
                        color: const Color(0xFFA855F7),
                        title: 'Pencegahan Baby Blues & Mood Tracker',
                        desc: 'Edukasi mengelola emosi, kelelahan, dan dukungan psikologis dari keluarga.',
                      ),
                      _buildModuleCard(
                        icon: Icons.water_drop_rounded,
                        color: const Color(0xFF10B981),
                        title: 'Panduan Laktasi & Pijat Oksitosin',
                        desc: 'Teknik melembutkan payudara, posisi pelekatan bayi, & makanan pelancar ASI.',
                      ),
                      _buildModuleCard(
                        icon: Icons.medical_information_rounded,
                        color: const Color(0xFFF59E0B),
                        title: 'Perawatan Perineum & Jahitan C-Section',
                        desc: 'Langkah kebersihan pencegahan infeksi luka melahirkan normal & operasi Caesar.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
