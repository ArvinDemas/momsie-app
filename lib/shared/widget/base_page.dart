import 'package:douce/shared/widget/themed_background.dart';
import 'package:douce/shared/widget/apotek_topbar.dart';
import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.childWidget,
    this.isApotek = false,
    this.isDoula = false,
    this.showSearch = true,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onAvatarTap,
  });

  final Widget childWidget;
  final bool isApotek;
  final bool isDoula;
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding = statusBarHeight + (showSearch ? 144.0 : 85.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated orb background
          const ThemedBackground(),
          // Main content + top bar with safe spacing
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: childWidget,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: isApotek
                ? const ApotikTopBar()
                : TopBar(
                    isDoula: isDoula,
                    showSearch: showSearch,
                    searchHint: searchHint,
                    onSearchChanged: onSearchChanged,
                    onSearchSubmitted: onSearchSubmitted,
                    onAvatarTap: onAvatarTap,
                  ),
          ),
        ],
      ),
    );
  }
}
