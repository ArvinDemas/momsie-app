import 'package:flutter/material.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/widget/payment_sheet.dart';

class PaywallModal extends StatelessWidget {
  final String featureName;
  final bool canDismissToAccess;
  final VoidCallback onUnlocked;

  const PaywallModal({
    super.key,
    required this.featureName,
    required this.canDismissToAccess,
    required this.onUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),

                // ══════════ Illustrative Decorative Graphic Header ══════════
                Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF1F2), Color(0xFFFEE2E2), Color(0xFFEFF6FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Grid Cards Mockup
                      Positioned(
                        left: 20,
                        top: 20,
                        child: _buildTileCard(
                          color: const Color(0xFF06B6D4),
                          icon: Icons.chat_rounded,
                          isLocked: true,
                          rotation: -0.1,
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 15,
                        child: _buildTileCard(
                          color: const Color(0xFFA855F7),
                          icon: Icons.article_rounded,
                          isLocked: true,
                          rotation: 0.08,
                        ),
                      ),
                      Positioned(
                        left: 90,
                        bottom: 15,
                        child: _buildTileCard(
                          color: const Color(0xFFF97316),
                          icon: Icons.spa_rounded,
                          isLocked: true,
                          rotation: -0.05,
                        ),
                      ),
                      Positioned(
                        right: 100,
                        bottom: 10,
                        child: _buildTileCard(
                          color: const Color(0xFFEC4899),
                          icon: Icons.picture_as_pdf_rounded,
                          isLocked: true,
                          rotation: 0.12,
                        ),
                      ),

                      // Center Crown Badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B8B), Color(0xFFF43F5E)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B8B).withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ══════════ Headline & Subtitle ══════════
                const Text(
                  'Akses Seluruh Fitur Premium',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppSemanticColors.textDarkSecondary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Buka seluruh fitur & alat perencanaan kehamilan eksklusif dengan 1 kali pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppSemanticColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // ══════════ Feature List ══════════
                _buildFeatureRow('AI Chatbot Unlimited Chat 24/7'),
                _buildFeatureRow('Bebas Iklan (No Ads)'),
                _buildFeatureRow('Birth Plan (Rencana Persalinan)'),
                _buildFeatureRow('Postpartum Wellbeing (Pemulihan Nifas)'),
                _buildFeatureRow('Eksport Diary Jurnal Kehamilan ke PDF'),

                const SizedBox(height: 28),

                // ══════════ CTA Unlock Button ══════════
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showPaymentSheet(
                        context,
                        jenisLayanan: 'subscription',
                        deskripsi: 'Momsie Premium Annual Subscription',
                        nominal: 121500,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B8B),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFFFF6B8B).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: const Text(
                      'Buka Akses Rp 119.000 / Tahun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ══════════ Top Left Close (X) Button ══════════
          Positioned(
            left: 16,
            top: 16,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppSemanticColors.textDarkSecondary,
                  size: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileCard({
    required Color color,
    required IconData icon,
    required bool isLocked,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            if (isLocked)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_rounded, size: 10, color: color),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppSemanticColors.textDarkSecondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
