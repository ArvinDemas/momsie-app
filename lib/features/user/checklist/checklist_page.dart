import 'package:douce/features/user/checklist/checklist_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChecklistController c = Get.put(ChecklistController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Text(
                          'Hospital Bag Checklist',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                      Obx(() => TextButton.icon(
                            onPressed: c.totalDone > 0 ? c.resetAll : null,
                            icon: const Icon(Icons.restart_alt_rounded, size: 16),
                            label: const Text('Reset', style: TextStyle(fontSize: 12)),
                          )),
                    ],
                  ),
                ),

                // Progress Card
                Obx(() {
                  final pct = (c.progress * 100).toInt();
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorDouce.douceBase, ColorDouce.lightPink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColorDouce.douceBase.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress Packing',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${c.totalDone}/${c.totalItems} item ($pct%)',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: c.progress,
                            minHeight: 10,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        if (pct == 100)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '🎉 Semua item sudah di-pack!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                // Category Tabs
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: c.categories.map((cat) {
                          final isSelected = c.selectedCategory.value == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                c.categoryLabels[cat] ?? cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: ColorDouce.douceBase,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? ColorDouce.douceBase
                                      : Colors.grey[300]!,
                                ),
                              ),
                              onSelected: (_) => c.selectCategory(cat),
                            ),
                          );
                        }).toList(),
                      ),
                    )),

                const SizedBox(height: 12),

                // Checklist Items
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final filtered = c.filteredItems;
                    if (filtered.isEmpty) {
                      return const Center(child: Text('Tidak ada item.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final item = filtered[i];
                        return Obx(() {
                          // listen to items for reactivity
                          c.items.length;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: item.isDone
                                  ? ColorDouce.kindaRed.withValues(alpha: 0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              leading: GestureDetector(
                                onTap: () => c.toggleItem(item),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: item.isDone
                                        ? ColorDouce.douceBase
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: item.isDone
                                          ? ColorDouce.douceBase
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: item.isDone
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 18)
                                      : null,
                                ),
                              ),
                              title: Text(
                                item.detail,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'OpenSans',
                                  decoration: item.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: item.isDone
                                      ? Colors.grey[500]
                                      : Colors.black87,
                                ),
                              ),
                              onTap: () => c.toggleItem(item),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
