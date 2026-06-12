import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:douce/shared/util/model/transaksi_model.dart';
import 'package:douce/shared/theme/color.dart';

class SalesLineChart extends StatelessWidget {
  final List<TransaksiModel> transactions;

  const SalesLineChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil 7 hari terakhir
    final now = DateTime.now();
    final DateFormat dayFormat = DateFormat('dd/MM');
    final List<DateTime> last7Days = List.generate(7, (index) {
      return now.subtract(Duration(days: 6 - index));
    });

    // 2. Kelompokkan nominal paid per hari
    final Map<String, double> revenuePerDay = {};
    for (var date in last7Days) {
      final key = dayFormat.format(date);
      revenuePerDay[key] = 0.0;
    }

    for (var tx in transactions) {
      if (tx.status == 'paid') {
        final key = dayFormat.format(tx.createdAt);
        if (revenuePerDay.containsKey(key)) {
          revenuePerDay[key] = revenuePerDay[key]! + tx.nominal.toDouble();
        }
      }
    }

    // 3. Konversi ke FlSpot
    final List<FlSpot> spots = [];
    double maxVal = 100000; // default min y axis limit
    for (int i = 0; i < last7Days.length; i++) {
      final key = dayFormat.format(last7Days[i]);
      final val = revenuePerDay[key] ?? 0.0;
      spots.add(FlSpot(i.toDouble(), val));
      if (val > maxVal) {
        maxVal = val;
      }
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
              'Tren Penjualan (7 Hari Terakhir)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < last7Days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                dayFormat.format(last7Days[idx]),
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
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: maxVal * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: ColorDouce.douceBase,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: ColorDouce.douceBase.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
