import 'dart:async';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:douce/shared/util/service/subscription_service.dart';
import 'package:flutter/material.dart';

class AdService {
  // Test Ad Unit IDs Resmi Google AdMob (Aman untuk Testing Tanpa Banned)
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5224354917';

  // Production Ad Unit IDs (Ganti dengan milik Anda dari Dashboard AdMob)
  static String liveBannerAdUnitId = '';
  static String liveInterstitialAdUnitId = '';
  static String liveRewardedAdUnitId = '';

  /// Tampilkan Modal Rewarded Ad (Sponsor 5 Detik) sebelum fitur premium (seperti Ekspor PDF / Panduan Yoga)
  static Future<bool> showRewardedAdDialog(
    BuildContext context, {
    required String title,
    required String description,
  }) async {
    if (SubscriptionService.to.isPremium.value ||
        SubscriptionService.to.isSubscribedUser()) {
      return true; // Bypass rewarded ad: user adalah pelanggan premium!
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _RewardedAdModal(
          title: title,
          description: description,
        );
      },
    );
    return result ?? false;
  }
}

class _RewardedAdModal extends StatefulWidget {
  final String title;
  final String description;

  const _RewardedAdModal({
    required this.title,
    required this.description,
  });

  @override
  State<_RewardedAdModal> createState() => _RewardedAdModalState();
}

class _RewardedAdModalState extends State<_RewardedAdModal> {
  bool _isPlayingAd = false;
  int _secondsLeft = 5;
  Timer? _timer;

  void _startAdView() {
    setState(() {
      _isPlayingAd = true;
      _secondsLeft = 5;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        Navigator.pop(context, true); // Return true (Iklan selesai ditonton)
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isPlayingAd) ...[
              // State 1: Penawaran Nonton Iklan
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: ColorDouce.lightPink.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: ColorDouce.douceBase,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppSemanticColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.ads_click_rounded, size: 16, color: Colors.amber.shade800),
                    const SizedBox(width: 6),
                    Text(
                      'Sponsor AdMob (5 Detik)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _startAdView,
                      icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 20),
                      label: const Text(
                        'Tonton Iklan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorDouce.douceBase,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // State 2: Iklan Sedang Pemutaran (Simulasi Rewarded Ad)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppSemanticColors.textDarkSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam_rounded, color: Colors.white54, size: 48),
                        const SizedBox(height: 8),
                        const Text(
                          'Sponsor Video AdMob',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Momsie App x Google AdMob',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Iklan: $_secondsLeft dtk',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Membuka PDF setelah iklan selesai...',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
