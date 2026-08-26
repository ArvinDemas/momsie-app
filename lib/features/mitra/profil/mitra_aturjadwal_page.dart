import 'package:douce/features/mitra/profil/mitra_aturjadwal_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MitraAturJadwalPage extends StatelessWidget {
  const MitraAturJadwalPage({super.key});

  static const List<String> _allJams = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00',
  ];

  @override
  Widget build(BuildContext context) {
    final MitraAturJadwalController controller = Get.put(MitraAturJadwalController());

    return Scaffold(
      body: Stack(
        children: [
          const ThemedBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                const SizedBox(height: 10),

                // Clean Header (Without Baby Avatar Picture)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kelola Jadwal Kerja',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Atur jam ketersediaan booking fleksibel untuk client',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Google Calendar Style Month Navigator Header
                Obx(() {
                  final monthText = controller.monthYearFormat.format(controller.focusedMonth.value);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left_rounded, color: ColorDouce.douceBase, size: 28),
                          onPressed: () => controller.changeMonth(-1),
                        ),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: controller.focusedMonth.value,
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                              helpText: 'Pilih Bulan & Tahun Jadwal',
                            );
                            if (picked != null) {
                              controller.setFocusedDate(picked);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_rounded, size: 20, color: ColorDouce.douceBase),
                              const SizedBox(width: 8),
                              Text(
                                monthText,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right_rounded, color: ColorDouce.douceBase, size: 28),
                          onPressed: () => controller.changeMonth(1),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Mode Tampilan Switcher (Bulanan / Mingguan / Harian)
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _viewModeTab('Bulanan', 'bulanan', controller),
                        _viewModeTab('Mingguan', 'mingguan', controller),
                        _viewModeTab('Harian', 'harian', controller),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Main Dynamic View Content
                Obx(() {
                  switch (controller.viewMode.value) {
                    case 'mingguan':
                      return _buildWeekView(controller);
                    case 'harian':
                      return _buildDayView(controller);
                    case 'bulanan':
                    default:
                      return _buildMonthGridView(controller);
                  }
                }),

                const SizedBox(height: 24),

                // Time Slot Manager Card for Selected Date
                Obx(() {
                  final selDate = controller.selectedDate.value;
                  final storageTgl = controller.storageDate(selDate);
                  final displayTgl = controller.displayDate(selDate);
                  final activeSlots = controller.slotState[storageTgl] ?? [];

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayTgl,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${activeSlots.length} Jam Aktif Dipilih',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: activeSlots.isNotEmpty ? Colors.green.shade700 : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 24, thickness: 0.5),

                        // Quick Action Presets
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _presetChip('⚡ Normal (09-17)', () => controller.setPresetNormal(storageTgl)),
                              const SizedBox(width: 8),
                              _presetChip('🌙 Malam (18-21)', () => controller.setPresetNight(storageTgl)),
                              const SizedBox(width: 8),
                              _presetChip('✅ Semua Jam', () => controller.setPresetAllDay(storageTgl)),
                              const SizedBox(width: 8),
                              _presetChip('❌ Kosongkan', () => controller.clearDaySlots(storageTgl)),
                              const SizedBox(width: 8),
                              _presetChip('📋 Terapkan ke Kerja Bulanan', () => controller.applyToAllWorkdaysInMonth(storageTgl)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Interactive Hour Grid
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _allJams.map((jam) {
                            final isSelected = activeSlots.contains(jam);
                            return InkWell(
                              onTap: () => controller.toggleJam(storageTgl, jam),
                              borderRadius: BorderRadius.circular(10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? ColorDouce.douceBase : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? ColorDouce.douceBase : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  jam,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Save All Schedule Button
                ElevatedButton.icon(
                  onPressed: () => controller.saveAllSlots(),
                  icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                  label: const Text(
                    'Simpan Perubahan Jadwal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorDouce.douceBase,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewModeTab(String label, String mode, MitraAturJadwalController controller) {
    final isSel = controller.viewMode.value == mode;
    return Expanded(
      child: InkWell(
        onTap: () => controller.viewMode.value = mode,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                color: isSel ? ColorDouce.douceBase : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Full Month Interactive Calendar Grid (Google Calendar Style)
  Widget _buildMonthGridView(MitraAturJadwalController controller) {
    final monthDate = controller.focusedMonth.value;
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final leadingEmptyDays = firstDayOfMonth.weekday - 1; // Mon=1..Sun=7

    final List<String> dayHeaders = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day Name Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayHeaders.map((h) {
              return Expanded(
                child: Center(
                  child: Text(
                    h,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.95,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: leadingEmptyDays + daysInMonth,
            itemBuilder: (_, index) {
              if (index < leadingEmptyDays) {
                return const SizedBox();
              }
              final dayNum = index - leadingEmptyDays + 1;
              final thisDate = DateTime(monthDate.year, monthDate.month, dayNum);
              final dateStr = controller.storageDate(thisDate);
              final isSelected = controller.storageDate(controller.selectedDate.value) == dateStr;
              final slotCount = (controller.slotState[dateStr] ?? []).length;

              return InkWell(
                onTap: () => controller.setFocusedDate(thisDate),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorDouce.douceBase
                        : (slotCount > 0 ? Colors.pink.shade50 : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? ColorDouce.douceBase
                          : (slotCount > 0 ? Colors.pink.shade200 : Colors.grey.shade200),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected || slotCount > 0 ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (slotCount > 0 ? ColorDouce.douceBase : const Color(0xFF0F172A)),
                        ),
                      ),
                      if (slotCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withValues(alpha: 0.3) : ColorDouce.douceBase,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${slotCount}j',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Week View Horizontal Cards
  Widget _buildWeekView(MitraAturJadwalController controller) {
    final selDate = controller.selectedDate.value;
    final monday = selDate.subtract(Duration(days: selDate.weekday - 1));
    final weekDates = List.generate(7, (i) => monday.add(Duration(days: i)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = weekDates[i];
          final dateStr = controller.storageDate(date);
          final isSel = controller.storageDate(selDate) == dateStr;
          final slotCount = (controller.slotState[dateStr] ?? []).length;

          return InkWell(
            onTap: () => controller.setFocusedDate(date),
            child: Container(
              width: 72,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSel ? ColorDouce.douceBase : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSel ? ColorDouce.douceBase : Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSel ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSel ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  if (slotCount > 0)
                    Text(
                      '${slotCount} slot',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSel ? Colors.white : Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Day View Selector Card
  Widget _buildDayView(MitraAturJadwalController controller) {
    final selDate = controller.selectedDate.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => controller.setFocusedDate(selDate.subtract(const Duration(days: 1))),
        ),
        Text(
          controller.displayDate(selDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onPressed: () => controller.setFocusedDate(selDate.add(const Duration(days: 1))),
        ),
      ],
    );
  }

  Widget _presetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: ColorDouce.douceBase.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorDouce.douceBase.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: ColorDouce.douceBase,
          ),
        ),
      ),
    );
  }
}
