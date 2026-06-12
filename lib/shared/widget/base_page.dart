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
  });

  final Widget childWidget;
  final bool isApotek;
  final bool isDoula;
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final double topPadding = showSearch ? 150.0 : 100.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated orb background
          const ThemedBackground(),
          // Main content + top bar
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: childWidget,
          ),
          Positioned(
            top: 0,
            child: isApotek
                ? const ApotikTopBar()
                : TopBar(
                    isDoula: isDoula,
                    showSearch: showSearch,
                    searchHint: searchHint,
                    onSearchChanged: onSearchChanged,
                    onSearchSubmitted: onSearchSubmitted,
                  ),
          ),
        ],
      ),
    );
  }
}
