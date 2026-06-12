import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:douce/shared/theme/color.dart';

class CategoryBarChart extends StatelessWidget {
  final List<TransaksiModel> transactions;

  const CategoryBarChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // 1. Inisialisasi kategori
    final Map<String, double> revenueByCat = {
      'doula': 0.0,
      'obat': 0.0,
      'tema': 0.0,
      'diary_premium': 0.0,
    };

    // 2. Akumulasi nominal paid per kategori
    for (var tx in transactions) {
      if (tx.status == 'paid') {
        final cat = tx.jenisLayanan.toLowerCase();
        if (revenueByCat.containsKey(cat)) {
          revenueByCat[cat] = revenueByCat[cat]! + tx.nominal.toDouble();
        }
      }
    }

    final categories = ['Doula', 'Obat', 'Tema', 'Diary'];
    final keys = ['doula', 'obat', 'tema', 'diary_premium'];
    final colors = [
      ColorDouce.douceBase,
      const Color(0xFF6C63FF),
      const Color(0xFFFFB74D),
      const Color(0xFF4CAF50),
    ];

    double maxVal = 100000;
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < keys.length; i++) {
      final val = revenueByCat[keys[i]] ?? 0.0;
      if (val > maxVal) {
        maxVal = val;
      }
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: colors[i],
              width: 18,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perbandingan Penjualan per Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                categories[idx],
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value >= 1000000) {
                            return Text('${(value / 1000000).toStringAsFixed(1)}jt',
                                style: const TextStyle(fontSize: 9, color: Colors.grey));
                          } else if (value >= 1000) {
                            return Text('${(value / 1000).toStringAsFixed(0)}rb',
                                style: const TextStyle(fontSize: 9, color: Colors.grey));
                          }
                          return Text(value.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 9, color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  maxY: maxVal * 1.2,
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
