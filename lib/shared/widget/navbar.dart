import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    required this.onChangeIndex,
    required this.listItems,
    required this.selectedIndex,
    super.key,
  });

  final List<Map<String, dynamic>> listItems;
  final Function(int) onChangeIndex;
  final int selectedIndex;

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
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
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

          // Floating Center Momsie AI Bot Button (Elevated Circular Glow Button)
          Positioned(
            top: -18,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () => Get.toNamed('/ai-chat'),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B8B), Color(0xFFFF8E9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B8B).withOpacity(0.45),
                        blurRadius: 14,
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
              color: isSelected ? const Color(0xFFFF6B8B) : Colors.slate[400],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF6B8B) : Colors.slate[600],
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
      case 'kesehatan':
        return Icons.favorite_rounded;
      case 'edukasi':
        return Icons.menu_book_rounded;
      case 'akun':
        return Icons.person_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
