import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/theme/colors.dart';

import '../../../domain/entities/categorie_stats.dart';

class CategoriePieChart extends StatefulWidget {
  final List<CategorieStats> categorieStats;

  CategoriePieChart({
    super.key,
    required this.categorieStats,
  });

  @override
  State<StatefulWidget> createState() => CategoriePieChartState();
}

class CategoriePieChartState extends State<CategoriePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(widget.categorieStats),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<CategorieStats> categorieStats) {
    return List.generate(categorieStats.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 13.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      return PieChartSectionData(
        color: pieChartColors[i % pieChartColors.length].withOpacity(0.75),
        value: categorieStats[i].percentage,
        title: '${categorieStats[i].percentage.toStringAsFixed(1)}% ${categorieStats[i].categorie}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}
