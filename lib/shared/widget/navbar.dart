import 'dart:ui';
import 'package:douce/app/app_routes.dart';
import 'package:douce/shared/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    required this.onChangeIndex,
    required this.listItems,
    required this.selectedIndex,
    this.isMitra = false,
    super.key,
  });

  final List<Map<String, dynamic>> listItems;
  final Function(int) onChangeIndex;
  final int selectedIndex;
  final bool isMitra;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Single-Layer Liquid Glass Container (Frosted Glass)
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: AppElevation.level3,
                ),
                child: isMitra
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: listItems
                            .map((item) => navbarItem(item, context))
                            .toList(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Item 0 & 1 (Beranda & Kesehatan)
                          navbarItem(listItems[0], context),
                          navbarItem(listItems[1], context),
                          
                          // Spacer untuk Floating Center AI Bot Button
                          const SizedBox(width: 48),

                          // Item 2 & 3 (Edukasi & Akun)
                          navbarItem(listItems[2], context),
                          navbarItem(listItems[3], context),
                        ],
                      ),
              ),
            ),
          ),

          // Floating Center Momsie AI Bot Button (Only for User Mode)
          if (!isMitra)
            Positioned(
              top: -18,
              left: 0,
              right: 0,
              child: Center(
                child: _GeminiAIFloatingButton(
                  onTap: () => Get.toNamed(AppRoutes.aiChat),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget navbarItem(Map<String, dynamic> item, BuildContext context) {
    final String label = item['label'] as String;
    final int index = item['count'] as int;
    final bool isSelected = selectedIndex == index;

    final IconData iconData = _getIconForLabel(label);

    return InkWell(
      onTap: () => onChangeIndex(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: isSelected ? 24 : 22,
              color: isSelected ? const Color(0xFFF43F5E) : Colors.grey[400],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFF43F5E) : AppSemanticColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'beranda':
        return Icons.home_rounded;
      case 'pekerjaan':
        return Icons.work_rounded;
      case 'jadwal':
        return Icons.edit_calendar_rounded;
      case 'pendapatan':
        return Icons.account_balance_wallet_rounded;
      case 'status':
        return Icons.toggle_on_rounded;
      case 'kesehatan':
      case 'doula':
        return Icons.favorite_rounded;
      case 'edukasi':
        return Icons.menu_book_rounded;
      case 'eksplor':
        return Icons.explore_rounded;
      case 'akun':
        return Icons.person_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}

/// Dynamic Gemini AI Floating Button with Animated Fluid Gradient
class _GeminiAIFloatingButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GeminiAIFloatingButton({required this.onTap});

  @override
  State<_GeminiAIFloatingButton> createState() => _GeminiAIFloatingButtonState();
}

class _GeminiAIFloatingButtonState extends State<_GeminiAIFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;
        return InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFBE185D), // Deep Rose
                  Color(0xFFF472B6), // Soft Pink
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
